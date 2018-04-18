package org.wso2.timetasks;

import org.wso2.dao;
import org.wso2.connectors.github3;
import ballerina.task;
import ballerina.io;
import ballerina.config;
import ballerina.time;
import ballerina.runtime;
import org.wso2.model;


const string WSO2 = "wso2";
const string accessToken = config:getGlobalValue("github.access_token");

int i = 0;

github3:ClientConnector githubConnector = create github3:ClientConnector(accessToken);

int currentTimeMills = 60000;

//function main(string[] args) {
//   // githubCommitRetrievingAppointment();
//}

function githubCommitRetrievingAppointment () {
    worker githubCommitsRetrievingWorker {
        log:printInfo("------- Scheduling Appointments ----------------");

        function () returns (error) onTriggerFunction;
        function (error e) onErrorFunction;

        onTriggerFunction = retrieveGithubCommit;
        onErrorFunction = loggedError;
        var apptid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction,
                                                 "20 35 * * * ?");
    }
}

function retrieveGithubCommit() returns (error) {
    endpoint<github3:ClientConnector> githubConnection {
        githubConnector;
    }

    time:Time time = time:currentTime();
    int startTime = time:currentTime().time;
    int searchRequestCount = 0;

    model:FileInfo[] fileInfoList = [];
    model:CommitFileInfo[] commitFileList = [];

    model:GithubCommitInfo[] githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    int lastFileId = dao:getLastFileId();
io:println("enter : " + lengthof githubCommitInfoList + " , " + lastFileId);
    while (lengthof githubCommitInfoList > 0) {
        foreach githubCommtInfo in githubCommitInfoList {

            github3:GitHubRepository[] response = [];
            github3:GitHubError e;

            io:println(githubCommtInfo);
            if ("PUBLIC" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                response, e = githubConnection.searchRepositoryViaCommit(githubCommtInfo.GITHUB_SHA_ID);
                io:print("response double check 1 : ");
                io:println(response);
                if (lengthof response == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    response, e = githubConnection.searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);
                }
            } else if ("SUPPORT" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                response, e = githubConnection.searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);
                io:print("response double check 1 : ");
                io:println(response);
                if (lengthof response == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    response, e = githubConnection.searchRepositoryViaCommit(githubCommtInfo.GITHUB_SHA_ID);
                }
            }

            io:print("responsessss : ");
            io:println(response);

            github3:GitHubRepository[] repo = response.filter(
                function (github3:GitHubRepository repository)(boolean){
                    io:println(repository);
                    return repository.owner.contains("wso2");
                 });

            io:println(repo);
            i = i + 1;
            io:println(i);
            if (lengthof repo > 0) {
               var response1, e1 = githubConnection.getCommitChanges( repo[0].name, repo[0].owner, githubCommtInfo.GITHUB_SHA_ID);
                if (e1 != null) {
                    io:print("Error ");
                    io:println( e1);
                } else {
                    githubCommtInfo.TOTAL_CHANGES = response1.gitCommitStat.total;
                    githubCommtInfo.ADDITIONS = response1.gitCommitStat.additions;
                    githubCommtInfo.DELETIONS = response1.gitCommitStat.deletions;

                    foreach githubfile in response1.gitCommitFiles {
                        model:FileInfo file = dao:getFileInfo(githubfile.filename);
                        io:println(file);
                        if(file == null) {
                            foreach fileInfo in fileInfoList {
                                if (fileInfo.FILE_NAME == githubfile.filename) {
                                    file = fileInfo;
                                    break;
                                }
                            }
                            if(file == null) {
                                file = {ID:(lastFileId + 1) + lengthof fileInfoList, FILE_NAME:githubfile. filename};
                                fileInfoList[lengthof fileInfoList] = file;
                            }
                        }
                        model:CommitFileInfo commitFile = {};
                        commitFile.GITHUB_COMMIT_INFO_PATCH_INFO_ID = githubCommtInfo.PATCH_INFO_ID;
                        commitFile.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = githubCommtInfo.GITHUB_SHA_ID;
                        commitFile.FILE_INFO_ID = file.ID;
                        commitFile.TOTAL_CHANGES = githubfile.totalChanges;
                        commitFile.ADDITIONS = githubfile.additions;
                        commitFile.DELETIONS = githubfile.deletions;

                        commitFileList[lengthof commitFileList] = commitFile;
                    }


                    io:println("===========================================================================");
                    io:println(response1);
                    io:println("===========================================================================");
                }
            }
            io:println("search count" + searchRequestCount);
            githubCommtInfo.IS_UPDATED = true;
            if (searchRequestCount >= 29) {
                currentTimeMills = 60000 - (time:currentTime().time - startTime);
                io:print("cuurent milles ");
                io:println(currentTimeMills);

                runtime:sleepCurrentWorker(currentTimeMills);
                startTime = time:currentTime().time;
                searchRequestCount = 0;
            }

        }

        io:println(githubCommitInfoList);
        io:println(fileInfoList);
        io:println(commitFileList);

        int[] res = dao:insertFileInfo(fileInfoList);
        res = dao:updateGithubCommitInfo(githubCommitInfoList);
        res = dao:insertGithubCommitFileInfo(commitFileList);
        githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    }


    io:println("skdkdskdkdsds");
              if (false) {
    error e = {message:"Cleanup error"};
    }
    return null;
}



function loggedError1(error e) {
    io:println(e);
    log:printErrorCause("[ERROR] cleanup failed", e);
}
