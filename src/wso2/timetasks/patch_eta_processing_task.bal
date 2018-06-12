package wso2.timetasks;

import ballerina/task;
import ballerina/log;
import ballerina/math;
import ballerina/io;
import wso2/model;
import wso2/dao;


//int app1Count;
//string app1Tid;

@final string NA = "N/A";
@final Regex REGEX = {pattern:"^[a-fA-F0-9]{40}$"};

function main (string[] args) {
    patchETAProcessingAppointment ();
   // githubCommitRetrievingAppointment();

}

public function patchETAProcessingAppointment () {
        log:printInfo("------- Scheduling Appointments 1 ----------------");


        (function() returns error?) onTriggerFunction =  processPatchETA;
        (function(error )) onErrorFunction = loggedError;

        task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction, "0 * * * * ?");
        _= appointment.schedule();
}

public function processPatchETA() returns error? {
    io:println("start process Patch ETA");
    model:PatchInfo[] patchInfoList = [];
    model:GithubCommitInfo[] githubCommitInfoList = [];
    model:PatchCommitInfo[] patchCommitInfoList = [];

    foreach patchETA in dao:getPatchETARecords(dao:getLastPatchInfoId()) {
        boolean has_pub_git_id = false;
        model:PatchInfo patchInfo = {};

        patchInfo.ID = patchETA.ID;
        patchInfo.PATCH_NAME = patchETA.PATCH_NAME;
        patchInfo.CLIENT = patchETA.CLIENT;
        patchInfo.SUPPORT_JIRA = patchETA.SUPPORT_JIRA;
        patchInfo.PRODUCT_COMPONENT_ID = dao:getProductCompId(patchETA.PRODUCT_NAME);
        patchInfo.REPORT_DATE = patchETA.REPORT_DATE;

        patchInfoList[lengthof patchInfoList] = patchInfo;

        if (patchETA.SVN_GIT_PUBLIC != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_PUBLIC)) {
            string[] git_sha_ids = patchETA.SVN_GIT_PUBLIC.split(",");

            io:println(patchETA.ID + " :  ");
            io:println(git_sha_ids);

            foreach id in git_sha_ids {
                var checkMatches = id.trim().matchesWithRegex(REGEX);
                boolean idbool;
                match checkMatches {
                    boolean matched => {
                        idbool= matched;
                    }
                    error err => {
                        io:println(" " + err.message);
                    }
                }
                has_pub_git_id = idbool ? idbool : has_pub_git_id;
                if (idbool) {
                    model:GithubCommitInfo githubCommitInfo;
                    var commit = dao:getCommitInfo(id.trim());
                    match commit {
                        model:GithubCommitInfo commitInfo => {
                            githubCommitInfo = commitInfo;
                        }
                        () => {
                            foreach commitInfo in githubCommitInfoList {
                                if (commitInfo.GITHUB_SHA_ID == id.trim()) {
                                    commit = commitInfo;
                                    break;
                                }
                            }
                            match commit {
                                model:GithubCommitInfo commitInfo => {
                                    githubCommitInfo = commitInfo;
                                }
                                () => {
                                    githubCommitInfo = {};
                                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
                                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "PUBLIC";
                                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
                                }
                            }
                        }
                    }
                    //model:GithubCommitInfo githubCommitInfo = {};
                    //githubCommitInfo.PATCH_INFO_ID = patchETA.ID;
                    //githubCommitInfo.GITHUB_SHA_ID = id.trim();
                    //githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "PUBLIC";
                    //githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
                    model:PatchCommitInfo? exsistingPatchCommit = ();

                    foreach patchCommit in patchCommitInfoList {
                        if (patchCommit.PATCH_INFO_ID == patchInfo.ID && patchCommit.GITHUB_COMMIT_INFO_GITHUB_SHA_ID == githubCommitInfo.GITHUB_SHA_ID) {
                            exsistingPatchCommit = patchCommit;
                            break;
                        }
                    }

                    match exsistingPatchCommit {
                        model:PatchCommitInfo patchCommit => {
                        }
                        () => {
                            model:PatchCommitInfo patchCommitInfo = {};
                            patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommitInfo.GITHUB_SHA_ID;
                            patchCommitInfo.PATCH_INFO_ID = patchInfo.ID;
                            patchCommitInfoList[lengthof patchCommitInfoList] = patchCommitInfo;
                        }
                    }
                    //if (lengthof exsistingPatchCommits == 0) {
                    //    model:PatchCommitInfo patchCommitInfo = {};
                    //    patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommitInfo.GITHUB_SHA_ID;
                    //    patchCommitInfo.PATCH_INFO_ID = patchInfo.ID;
                    //    patchCommitInfoList[lengthof patchCommitInfoList] = patchCommitInfo;
                    //}
                }
            }
        }

        if (!has_pub_git_id && patchETA.SVN_GIT_SUPPORT != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_SUPPORT)) {
            string[] git_sha_ids = patchETA.SVN_GIT_SUPPORT.split(",");

io:println(patchETA.ID + " :  ");
            io:println(git_sha_ids);

            foreach id in git_sha_ids {
                var checkMatches = id.trim().matchesWithRegex(REGEX);
                boolean idbool;
                match checkMatches {
                    boolean matched => {
                        idbool= matched;
                    }
                    error err => {
                        io:println(" " + err.message);
                    }
                }
                if (idbool) {
                    model:GithubCommitInfo githubCommitInfo;
                    var commit = dao:getCommitInfo(id.trim());
                    match commit {
                        model:GithubCommitInfo commitInfo => {
                            githubCommitInfo = commitInfo;
                        }
                        () => {
                            foreach commitInfo in githubCommitInfoList {
                                if (commitInfo.GITHUB_SHA_ID == id.trim()) {
                                    commit = commitInfo;
                                    break;
                                }
                            }
                            match commit {
                                model:GithubCommitInfo commitInfo => {
                                    githubCommitInfo = commitInfo;
                                }
                                () => {
                                    githubCommitInfo = {};
                                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
                                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "SUPPORT";
                                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
                                }
                            }
                        }
                    }

                    model:PatchCommitInfo? exsistingPatchCommit = ();

                    foreach patchCommit in patchCommitInfoList {
                        if (patchCommit.PATCH_INFO_ID == patchInfo.ID && patchCommit.GITHUB_COMMIT_INFO_GITHUB_SHA_ID == githubCommitInfo.GITHUB_SHA_ID) {
                            exsistingPatchCommit = patchCommit;
                            break;
                        }
                    }

                    match exsistingPatchCommit {
                        model:PatchCommitInfo patchCommit => {
                        }
                        () => {
                            model:PatchCommitInfo patchCommitInfo = {};
                            patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommitInfo.GITHUB_SHA_ID;
                            patchCommitInfo.PATCH_INFO_ID = patchInfo.ID;
                            patchCommitInfoList[lengthof patchCommitInfoList] = patchCommitInfo;
                        }
                    }
                }
            }
        }
    }


    int[] res = dao:insertPatchInfo(untaint patchInfoList);
    int [] dbinsertFailedPatchIds = [];
io:println(githubCommitInfoList);
    io:println("+++++++++++++++++++++++++++++++++++++++++++++++");
    io:println(patchCommitInfoList);
    res = dao:insertGithubCommitInfo(untaint githubCommitInfoList);

    res = dao:insertPatchCommitInfo(untaint patchCommitInfoList);
    if (false) {
        error e = {message:"Cleanup error"};
    }
    return null;
}

function loggedError(error e) {
    io:println(e);
    log:printErrorCause("[ERROR] cleanup failed", e);
}


