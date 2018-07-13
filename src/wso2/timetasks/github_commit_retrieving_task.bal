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

import wso2/dao;
import wso2/github3;
import ballerina/task;
import ballerina/config;
import ballerina/time;
import ballerina/runtime;
import ballerina/log;
import wso2/model;

endpoint github3:Client githubClient {
    accessToken: config:getAsString(GITHUB_ACCESS_TOKEN),
    clientConfig:{}
};


int currentTimeMills = 61000;

public function githubCommitRetrievingAppointment () {
    worker githubCommitsRetrievingWorker {
        log:printInfo("Starting Github commit information retrirevig task appointment");

        (function() returns error?) onTriggerFunction =  retrieveGithubCommit;
        (function(error )) onErrorFunction = loggedGithubCommitProcessError;

        task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction,
            config:getAsString(COMMIT_DATA_PROCESS_CRON));
        appointment.schedule();
    }
}

function retrieveGithubCommit() returns (error?) {

    log:printInfo("Start retrieving github commit information");

    time:Time time = time:currentTime();
    int startTime = time:currentTime().time;
    int searchRequestCount = 0;

    model:GithubCommitInfo[] githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    int lastFileId = dao:getLastFileId();

    while (lengthof githubCommitInfoList > 0) {
        model:FileInfo[] fileInfoList = [];
        model:CommitFileInfo[] commitFileList = [];

        foreach githubCommtInfo in githubCommitInfoList {
            github3:GitHubRepository[] response = [];
            github3:GitHubRepository[] repo = [];

            log:printTrace("Start searching commit");

            if ("PUBLIC" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient -> searchRepositoryViaCommit(githubCommtInfo.GITHUB_SHA_ID);

                match resp{
                    github3:GitHubRepository[] gitRepos => {
                        response = gitRepos;
                        repo = response.filter((github3:GitHubRepository repository) => boolean {
                                return repository.owner.contains(WSO2);
                            });
                    }
                    github3:GitHubError err => {
                        log:printErrorCause("Error ocurred while calling Github commit searching API for public repository", err);
                    }
                    error err => {
                        log:printErrorCause("Error ocurred while searching Github commit for public repository", err);
                    }
                }

                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                    match resp1{
                        github3:GitHubRepository[] gitRepos => {
                            response = gitRepos;
                            repo = response.filter((github3:GitHubRepository repository) => boolean {
                                    return repository.owner.contains(WSO2);
                                });
                        }
                        github3:GitHubError err => {
                            log:printErrorCause("Error ocurred while calling Github PR API for public repository", err);
                        }
                        error err => {
                            log:printErrorCause("Error ocurred while searching Github PR for public repository", err);
                        }
                    }
                }
            } else if ("SUPPORT" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                match resp{
                    github3:GitHubRepository[] gitRepos => {
                        response = gitRepos;
                        repo = response.filter((github3:GitHubRepository repository) => boolean {
                                return repository.owner.contains(WSO2);
                            });
                    }
                    github3:GitHubError err => {
                        log:printErrorCause("Error ocurred while calling Github PR API for support repository", err);
                    }
                    error err => {
                        log:printErrorCause("Error ocurred while searching Github PR for support repository", err);
                    }
                }

                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                    match resp1{
                        github3:GitHubRepository[] gitRepos => {
                            response = gitRepos;
                            repo = response.filter((github3:GitHubRepository repository) => boolean {
                                    return repository.owner.contains(WSO2);
                                });
                        }
                        github3:GitHubError err => {
                            log:printErrorCause("Error ocurred while calling Github commit searching API for support repository", err);
                        }
                        error err => {
                            log:printErrorCause("Error ocurred while searching Github commit for support repository", err);
                        }
                    }
                }
            }

            log:printTrace("Start requesting Github commit information");

            if (lengthof repo > 0) {
                var resp = githubClient -> getCommitChanges(repo[0].name, repo[0].owner, githubCommtInfo.GITHUB_SHA_ID);
                github3:GitHubCommitChanges response1;
                match resp {
                    github3:GitHubCommitChanges commitChanges => {
                        response1 = commitChanges;
                    }
                    github3:GitHubError err => {
                        log:printErrorCause("Error ocurred while calling Github commit information retreiving API", err);
                    }
                    error err => {
                        log:printErrorCause("Error ocurred while retrieving Github commit", err);
                    }
                }

                if (response1 != null) {
                    githubCommtInfo.TOTAL_CHANGES = response1.gitCommitStat.total;
                    githubCommtInfo.ADDITIONS = response1.gitCommitStat.additions;
                    githubCommtInfo.DELETIONS = response1.gitCommitStat.deletions;

                    string repositoryName = repo[0].owner + "/" + repo[0].name;

                    foreach githubfile in response1.gitCommitFiles {
                        var fileVar = dao:getFileInfo(githubfile.filename, repositoryName);

                        model:FileInfo file;
                        match fileVar {
                            model:FileInfo fileTemp => {
                                file = fileTemp;
                            }
                            () => {
                                foreach fileInfo in fileInfoList {
                                    if (fileInfo.FILE_NAME == githubfile.filename && fileInfo.REPOSITORY_NAME == repositoryName) {
                                        fileVar = fileInfo;
                                        break;
                                    }
                                }
                                match fileVar {
                                    model:FileInfo fileTemp => {
                                        file = fileTemp;
                                    }
                                    () => {
                                        lastFileId = lastFileId + 1;
                                        file = {ID:lastFileId, FILE_NAME:githubfile.filename, REPOSITORY_NAME: repositoryName};
                                        fileInfoList[lengthof fileInfoList] = file;
                                    }

                                }
                            }
                        }

                        model:CommitFileInfo commitFile = {};
                        commitFile.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommtInfo.GITHUB_SHA_ID;
                        commitFile.FILE_INFO_ID = file.ID;
                        commitFile.TOTAL_CHANGES = githubfile.totalChanges;
                        commitFile.ADDITIONS = githubfile.additions;
                        commitFile.DELETIONS = githubfile.deletions;

                        commitFileList[lengthof commitFileList] = commitFile;
                    }
                }
            }

            githubCommtInfo.IS_UPDATED = true;
            if (searchRequestCount >= 28) {
                log:printTrace("Waiting Process complete 1 min."); // todo change log level
                currentTimeMills = 61000 - (time:currentTime().time - startTime);

                runtime:sleepCurrentWorker(currentTimeMills);
                startTime = time:currentTime().time;
                searchRequestCount = 0;
            }
        }

        int[] res = dao:insertFileInfo(fileInfoList);
        res = dao:updateGithubCommitInfo(githubCommitInfoList);
        res = dao:insertGithubCommitFileInfo(commitFileList);
        githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    }

    return null;
}

function loggedGithubCommitProcessError(error e) {
    log:printErrorCause("Error occured while processing Github commit information", e);
}
