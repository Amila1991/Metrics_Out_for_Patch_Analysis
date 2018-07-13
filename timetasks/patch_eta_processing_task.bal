//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/task;
import ballerina/log;
import ballerina/math;
import ballerina/config;
import model;
import dao;

@final string NA = "N/A";
@final string REGEX = "^[a-fA-F0-9]{40}$";

public function patchETAProcessingAppointment() { //todo schdule?
    log:printInfo("Starting patch infromation retrieving process task appointment");


    (function() returns error?) onTriggerFunction = processPatchETA;
    (function(error)) onErrorFunction = loggedpatchETAProcessError;

    task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction,
        config:getAsString(PMT_DATA_PROCESS_CRON));
    _ = appointment.schedule();
}

//todo documentation
public function processPatchETA() returns error? { // todo function name?
    log:printInfo("Starting patch information from PMT database");

    model:PatchInfo[] patchInfoList = [];
    model:GithubCommitInfo[] githubCommitInfoList = [];
    model:PatchCommitInfo[] patchCommitInfoList = [];

    foreach patchETA in dao:getPatchETARecords(dao:getLastPatchInfoId()) {
        log:printTrace("Start processing patch with patch id : " + patchETA.ID);

        boolean hasPublicGitId = false;
        model:PatchInfo patchInfo = {};

        patchInfo.ID = patchETA.ID;
        patchInfo.PATCH_NAME = patchETA.PATCH_NAME;
        patchInfo.CLIENT = patchETA.CLIENT;
        patchInfo.SUPPORT_JIRA = patchETA.SUPPORT_JIRA;
        patchInfo.PRODUCT_COMPONENT_ID = dao:getProductCompId(patchETA.PRODUCT_NAME);
        patchInfo.REPORT_DATE = patchETA.REPORT_DATE;

        patchInfoList[lengthof patchInfoList] = patchInfo;

        match patchETA.SVN_GIT_PUBLIC {
            string svnGitPublic => {
                if (!NA.equalsIgnoreCase(svnGitPublic)) {
                    log:printTrace("Splitting  public Github commit SHA id with patch id : " + patchETA.ID);

                    string[] gitSHAIds = svnGitPublic.split(",");

                    foreach id in gitSHAIds {
                        var checkMatches = id.trim().matches(REGEX);
                        boolean idbool = false;
                        match checkMatches {
                            boolean matched => {
                                idbool = matched;
                            }
                            error err => {
                                log:printWarn("Found invalid Github commit SHA id : " + id.trim());
                            }
                        }

                        hasPublicGitId = idbool;
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

                            model:PatchCommitInfo? exsistingPatchCommit = ();

                            foreach patchCommit in patchCommitInfoList {
                                if (patchCommit.PATCH_INFO_ID == patchInfo.ID && patchCommit.
                                    GITHUB_COMMIT_INFO_GITHUB_SHA_ID == githubCommitInfo.GITHUB_SHA_ID) {
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
            () => {
                hasPublicGitId = false;
            }
        }

        if (!hasPublicGitId) {
            match patchETA.SVN_GIT_SUPPORT {
                string svnGitSupport => {
                    if (!NA.equalsIgnoreCase(svnGitSupport)) {
                        log:printTrace("Splitting  support Github commit SHA id with patch id : " + patchETA.ID);

                        string[] gitSHAIds = svnGitSupport.split(",");

                        foreach id in gitSHAIds {
                            var checkMatches = id.trim().matches(REGEX);
                            boolean idbool;
                            match checkMatches {
                                boolean matched => {
                                    idbool = matched;
                                }
                                error err => {
                                    log:printWarn("Found invalid Github commit SHA id : " + id.trim());
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
                                    if (patchCommit.PATCH_INFO_ID == patchInfo.ID && patchCommit.
                                        GITHUB_COMMIT_INFO_GITHUB_SHA_ID == githubCommitInfo.GITHUB_SHA_ID) {
                                        exsistingPatchCommit = patchCommit;
                                        break;
                                    }
                                }

                                match exsistingPatchCommit {
                                    model:PatchCommitInfo patchCommit => {
                                    }
                                    () => {
                                        model:PatchCommitInfo patchCommitInfo = {};
                                        patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommitInfo.
                                        GITHUB_SHA_ID;
                                        patchCommitInfo.PATCH_INFO_ID = patchInfo.ID;
                                        patchCommitInfoList[lengthof patchCommitInfoList] = patchCommitInfo;
                                    }
                                }
                            }
                        }
                    }
                }
                () => {
                    log:printWarn("Valid Github Commit SHHA id not found with patch, patch id : " + patchETA.ID);
                }
            }
        }
    }


    int[] res = dao:insertPatchInfo(untaint patchInfoList);
    res = dao:insertGithubCommitInfo(untaint githubCommitInfoList);
    res = dao:insertPatchCommitInfo(untaint patchCommitInfoList);

    log:printInfo("Ended patch infromation retrieving process task appointment");

    return null;
}

function loggedpatchETAProcessError(error e) {
    log:printError("Error occured while processing patch infromation", err = e);
}


