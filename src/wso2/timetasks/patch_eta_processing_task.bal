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

package wso2.timetasks;

import ballerina/task;
import ballerina/log;
import ballerina/math;
import ballerina/config;
import wso2/model;
import wso2/dao;

@final string NA = "N/A";
@final Regex REGEX = {pattern:"^[a-fA-F0-9]{40}$"};

public function patchETAProcessingAppointment () {
        log:printInfo("Starting patch infromation retrieving process task appointment");


        (function() returns error?) onTriggerFunction =  processPatchETA;
        (function(error )) onErrorFunction = loggedpatchETAProcessError;

        task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction,
            config:getAsString(PMT_DATA_PROCESS_CRON));
        _= appointment.schedule();
}

public function processPatchETA() returns error? {
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

        if (patchETA.SVN_GIT_PUBLIC != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_PUBLIC)) {
            log:printTrace("Splitting  public Github commit SHA id with patch id : " + patchETA.ID);

            string[] gitSHAIds = patchETA.SVN_GIT_PUBLIC.split(",");

            foreach id in gitSHAIds {
                var checkMatches = id.trim().matchesWithRegex(REGEX);
                boolean idbool = false;
                match checkMatches {
                    boolean matched => {
                        idbool= matched;
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

        if (!hasPublicGitId && patchETA.SVN_GIT_SUPPORT != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_SUPPORT)) {
            log:printTrace("Splitting  support Github commit SHA id with patch id : " + patchETA.ID);

            string[] gitSHAIds = patchETA.SVN_GIT_SUPPORT.split(",");

            foreach id in gitSHAIds {
                var checkMatches = id.trim().matchesWithRegex(REGEX);
                boolean idbool;
                match checkMatches {
                    boolean matched => {
                        idbool= matched;
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
    res = dao:insertGithubCommitInfo(untaint githubCommitInfoList);
    res = dao:insertPatchCommitInfo(untaint patchCommitInfoList);

    log:printInfo("Ended patch infromation retrieving process task appointment");

    return null;
}

function loggedpatchETAProcessError(error e) {
    log:printErrorCause("Error occured while processing patch infromation", e);
}


