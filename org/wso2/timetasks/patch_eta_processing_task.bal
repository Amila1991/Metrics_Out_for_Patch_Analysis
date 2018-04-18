package org.wso2.timetasks;

import ballerina.task;
import ballerina.log;
import ballerina.math;
import org.wso2.model;
import org.wso2.dao;
import ballerina.io;


//int app1Count;
//string app1Tid;

const string NA = "N/A";
Regex REGEX = {pattern:"^[a-fA-F0-9]{40}$"};

function main (string[] args) {
    patchETAProcessingAppointment ();
    githubCommitRetrievingAppointment();

}

function patchETAProcessingAppointment () {
    worker patchETAProcessingWorker {
        log:printInfo("------- Scheduling Appointments ----------------");

        function () returns (error) onTriggerFunction;
        function (error e) onErrorFunction;

        onTriggerFunction = processPatchETA;
        onErrorFunction = loggedError;
        var apptid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction,
                                              "0 35 * * * ?");
    }
}

function processPatchETA() returns (error) {
    model:PatchInfo[] patchInfoList = [];
    model:GithubCommitInfo[] githubCommitInfoList = [];

    foreach patchETA in dao:getPatchETARecords(dao:getLastPatchInfoId()) {
        boolean has_pub_git_id = false;
        model:PatchInfo patchInfo = {};

        patchInfo.ID = patchETA.ID;
        patchInfo.PATCH_NAME = patchETA.PATCH_NAME;
        patchInfoList[lengthof patchInfoList] = patchInfo;

        if (patchETA.SVN_GIT_PUBLIC != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_PUBLIC)) {
            string[] git_sha_ids = patchETA.SVN_GIT_PUBLIC.split(",");

            foreach id in git_sha_ids {
                var idbool, _ = id.trim().matchesWithRegex(REGEX);
                has_pub_git_id = idbool ? idbool : has_pub_git_id;
                if (idbool) {
                    model:GithubCommitInfo githubCommitInfo = {};
                    githubCommitInfo.PATCH_INFO_ID = patchETA.ID;
                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "PUBLIC";
                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
                }
            }
        }

        if (!has_pub_git_id && patchETA.SVN_GIT_SUPPORT != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_SUPPORT)) {
            string[] git_sha_ids = patchETA.SVN_GIT_SUPPORT.split(",");

            foreach id in git_sha_ids {
                var idbool, _ = id.trim().matchesWithRegex(REGEX);
                if (idbool) {
                    model:GithubCommitInfo githubCommitInfo = {};
                    githubCommitInfo.PATCH_INFO_ID = patchETA.ID;
                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "SUPPORT";
                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
                }
            }
        }
    }


    int[] res = dao:insertPatchInfo(patchInfoList);
    int [] dbinsertFailedPatchIds = [];

    res = dao:insertGithubCommitInfo(githubCommitInfoList);
    if (false) {
        error e = {message:"Cleanup error"};
    }
    return null;
}

function loggedError(error e) {
    io:println(e);
    log:printErrorCause("[ERROR] cleanup failed", e);
}
