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

import dao;
import github3 as github;
import ballerina/task;
import ballerina/config;
import ballerina/time;
import ballerina/runtime;
import ballerina/log;
import model;

endpoint github:Client githubClient {
    accessToken: config:getAsString(GITHUB_ACCESS_TOKEN),
    clientConfig: {}
};

int currentTimeMills = 61000;
string[] wso2RepostoryOnwers = [];

public function githubCommitRetrievingAppointment() { //todo function names
    worker githubCommitsRetrievingWorker {
        log:printInfo("Starting Github commit information retrirevig task appointment");

        (function() returns error?) onTriggerFunction = retrieveGithubCommit;
        (function(error)) onErrorFunction = loggedGithubCommitProcessError;

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
            github:GitHubRepository[] response = [];
            github:GitHubRepository[] repo = [];

            log:printTrace("Start searching commit");

            if ("PUBLIC" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient->searchRepositoryViaCommit(githubCommtInfo.GITHUB_SHA_ID);

                match resp {
                    github:GitHubRepository[] gitRepos => {
                       // response = gitRepos;
                        //repo = response.filter((github:GitHubRepository repository) => boolean {
                        //        return repository.owner.contains(WSO2);
                        //    });
                        repo = validateWSO2RepositoryOnwer(gitRepos);
                    }
                    github:GitHubError err => {
                        log:printError("Error ocurred while calling Github commit searching API for public repository",
                            err = err);
                    }
                    error err => {
                        log:printError("Error ocurred while searching Github commit for public repository", err = err);
                    }
                }

                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient->searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                    match resp1 {
                        github:GitHubRepository[] gitRepos => {
                            //response = gitRepos;
                            //repo = response.filter((github:GitHubRepository repository) => boolean {
                            //        return repository.owner.contains(WSO2);
                            //    });
                            repo = validateWSO2RepositoryOnwer(gitRepos);
                        }
                        github:GitHubError err => {
                            log:printError("Error ocurred while calling Github PR API for public repository", err = err)
                            ;
                        }
                        error err => {
                            log:printError("Error ocurred while searching Github PR for public repository", err = err);
                        }
                    }
                }
            } else if ("SUPPORT" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient->searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                match resp {
                    github:GitHubRepository[] gitRepos => {
                        //response = gitRepos;
                        //repo = response.filter((github:GitHubRepository repository) => boolean {
                        //        return repository.owner.contains(WSO2);
                        //    });
                        repo = validateWSO2RepositoryOnwer(gitRepos);
                    }
                    github:GitHubError err => {
                        log:printError("Error ocurred while calling Github PR API for support repository", err = err);
                    }
                    error err => {
                        log:printError("Error ocurred while searching Github PR for support repository", err = err);
                    }
                }

                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient->searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);

                    match resp1 {
                        github:GitHubRepository[] gitRepos => {
                            //response = gitRepos;
                            //repo = response.filter((github:GitHubRepository repository) => boolean {
                            //        return repository.owner.contains(WSO2);
                            //    });
                            repo = validateWSO2RepositoryOnwer(gitRepos);
                        }
                        github:GitHubError err => {
                            log:printError(
                                "Error ocurred while calling Github commit searching API for support repository", err =
                                err);
                        }
                        error err => {
                            log:printError("Error ocurred while searching Github commit for support repository", err =
                                err);
                        }
                    }
                }
            }

            log:printTrace("Start requesting Github commit information");

            if (lengthof repo > 0) {
                var resp = githubClient->getCommitChanges(repo[0].name, repo[0].owner, githubCommtInfo.GITHUB_SHA_ID);
                github:GitHubCommitChanges response1;
                match resp {
                    github:GitHubCommitChanges commitChanges => {
                        response1 = commitChanges;
                    }
                    github:GitHubError err => {
                        log:printError("Error ocurred while calling Github commit information retreiving API", err = err
                        );
                    }
                    error err => {
                        log:printError("Error ocurred while retrieving Github commit", err = err);
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
                                    if (fileInfo.FILE_NAME == githubfile.filename && fileInfo.REPOSITORY_NAME ==
                                    repositoryName) {
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
                                        file = { ID: lastFileId, FILE_NAME: githubfile.filename, REPOSITORY_NAME:
                                        repositoryName };
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
                log:printDebug("Waiting Process complete 1 min.");
                // todo change log level
                currentTimeMills = 61000 - (time:currentTime().time - startTime);

                runtime:sleep(currentTimeMills);
                startTime = time:currentTime().time;
                searchRequestCount = 0;
            }
        }

        int[] res = dao:insertFileInfo(fileInfoList);
        res = dao:updateGithubCommitInfo(githubCommitInfoList);
        res = dao:insertGithubCommitFileInfo(commitFileList);
        githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    }
    log:printInfo("Ended retrieving github commit information");

    return null;
}

function loggedGithubCommitProcessError(error e) {
    log:printError("Error occured while processing Github commit information", err = e);
}

function repositoryOnwers() returns string[] {
    return config:getAsString(WSO2_REPOSITORY_OWNERS).split(",");
}


function validateWSO2RepositoryOnwer(github:GitHubRepository[] gitRepos) returns github:GitHubRepository[] {
    github:GitHubRepository[] returnRepos = [];
    if (lengthof wso2RepostoryOnwers == 0) {
        wso2RepostoryOnwers = config:getAsString(WSO2_REPOSITORY_OWNERS).split(",");
    }

    foreach repo in gitRepos {
        foreach onwer in wso2RepostoryOnwers {
            if (repo.owner.equalsIgnoreCase(onwer)) {
                returnRepos[lengthof returnRepos] = repo;
                break;
            }
        }
    }
    return returnRepos;
}
