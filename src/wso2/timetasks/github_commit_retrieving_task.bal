package wso2.timetasks;

import wso2/dao;
import wso2/github3;
import ballerina/task;
import ballerina/io;
import ballerina/config;
import ballerina/time;
import ballerina/runtime;
import ballerina/log;
import wso2/model;


@final string WSO2 = "wso2";
@final string accessToken = config:getAsString("github.access_token");

endpoint github3:Client githubClient {
    accessToken: "9eb5e0a3ec30e09d1ddfadb9071fd31930e5da29",
    clientConfig:{}
};

int i = 0;
int currentTimeMills = 60000;

public function githubCommitRetrievingAppointment () {
    worker githubCommitsRetrievingWorker {
        log:printInfo("------- Scheduling Appointments 2 ----------------");

        //function () returns (error) onTriggerFunction;
        //function (error e) onErrorFunction;
        //
        //onTriggerFunction = retrieveGithubCommit;
        //onErrorFunction = loggedError;

        (function() returns error?) onTriggerFunction =  retrieveGithubCommit;
        (function(error )) onErrorFunction = loggedError;

        task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction, "40 19 * * * ?");
        appointment.schedule();
    }
}

function retrieveGithubCommit() returns (error?) {

    log:printDebug("Start retrieving girhub commit information");
  //  io:println("start retrieving girhub commit information");

    time:Time time = time:currentTime();
    int startTime = time:currentTime().time;
    int searchRequestCount = 0;

    model:GithubCommitInfo[] githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    int lastFileId = dao:getLastFileId();
    //io:println("enter : " + lengthof githubCommitInfoList + " , " + lastFileId);

    while (lengthof githubCommitInfoList > 0) {

        model:FileInfo[] fileInfoList = [];
        model:CommitFileInfo[] commitFileList = [];

        foreach githubCommtInfo in githubCommitInfoList {

            github3:GitHubRepository[] response = [];
            github3:GitHubRepository[] repo = [];

      //      io:println(githubCommtInfo);
            if ("PUBLIC" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient -> searchRepositoryViaCommit(githubCommtInfo.GITHUB_SHA_ID);
                //response = check <github3:GitHubRepository[]> resp;

                match resp{
                    github3:GitHubRepository[] gitRepos => {
                        response = gitRepos;
                        repo = response.filter((github3:GitHubRepository repository) => boolean {
                                //             io:println(repository);
                                return repository.owner.contains("wso2");
                            });
                    }
                    github3:GitHubError err => {
                        io:print("Commit Search Error 1 ID : " + githubCommtInfo.GITHUB_SHA_ID + "  ");
                        io:println(err);
                    }
                    error err => {
                        io:println(" " + err.message);
                    }
                }

          //      io:print("response double check 1 : ");
            //    io:println(response);
                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);
                    //response= check <github3:GitHubRepository[]> resp;
                    match resp1{
                        github3:GitHubRepository[] gitRepos => {
                            response = gitRepos;
                            repo = response.filter((github3:GitHubRepository repository) => boolean {
                                    //             io:println(repository);
                                    return repository.owner.contains("wso2");
                                });
                        }
                        github3:GitHubError err => {
                            io:print("PR Search Error 1 ID : " + githubCommtInfo.GITHUB_SHA_ID + "  ");
                            io:println(err);
                        }
                        error err => {
                            io:println(" " + err.message);
                        }
                    }
                }
            } else if ("SUPPORT" == githubCommtInfo.GITHUB_SHA_ID_REPO_TYPE) {
                searchRequestCount = searchRequestCount + 1;
                var resp = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);
                //response = check <github3:GitHubRepository[]> resp;
                match resp{
                    github3:GitHubRepository[] gitRepos => {
                        response = gitRepos;
                        repo = response.filter((github3:GitHubRepository repository) => boolean {
                                //             io:println(repository);
                                return repository.owner.contains("wso2");
                            });
                    }
                    github3:GitHubError err => {
                        io:print("PR Search Error 2 ID : " + githubCommtInfo.GITHUB_SHA_ID + "  ");
                        io:println(err);
                    }
                    error err => {
                        io:println(" " + err.message);
                    }
                }
              //  io:print("response double check 1 : ");
                //io:println(response);
                if (lengthof repo == 0) {
                    searchRequestCount = searchRequestCount + 1;
                    var resp1 = githubClient -> searchRepositoryViaPR(githubCommtInfo.GITHUB_SHA_ID);
                    //response = check <github3:GitHubRepository[]> resp;
                    match resp1{
                        github3:GitHubRepository[] gitRepos => {
                            response = gitRepos;
                            repo = response.filter((github3:GitHubRepository repository) => boolean {
                                    //             io:println(repository);
                                    return repository.owner.contains("wso2");
                                });
                        }
                        github3:GitHubError err => {
                            io:print("Commit Search Error 2 ID : " + githubCommtInfo.GITHUB_SHA_ID + "  ");
                            io:println(err);
                        }
                        error err => {
                            io:println(" " + err.message);
                        }
                    }
                }
            }

            if (lengthof repo == 0) {
                io:println(response);
            }

   //         io:print("responsessss : ");
     //       io:println(response);

       //     github3:GitHubRepository[] repo = response.filter((github3:GitHubRepository repository) => boolean {
       ////             io:println(repository);
       //             return repository.owner.contains("wso2");
       //     });

         //   io:println(repo);
           // i = i + 1;
            //io:println(i);
            if (lengthof repo > 0) {
                var resp = githubClient -> getCommitChanges(repo[0].name, repo[0].owner, githubCommtInfo.GITHUB_SHA_ID);
                github3:GitHubCommitChanges response1;
                match resp {
                    github3:GitHubCommitChanges commitChanges => {
                        response1 = commitChanges;
                    }
                    github3:GitHubError err => {
                        io:print("Retrieve Commit Error ID : " + githubCommtInfo.GITHUB_SHA_ID + "  ");
                        io:println(err);
                    }
                    error err => {
                        io:println(" " + err.message);
                    }
                }

                if (response1.gitCommitStat.total == 0) {
                    io:println(githubCommtInfo.GITHUB_SHA_ID);
                    io:println(repo);
                    io:println(response);
                }

                if (response1 != null) {
                    githubCommtInfo.TOTAL_CHANGES = response1.gitCommitStat.total;
                    githubCommtInfo.ADDITIONS = response1.gitCommitStat.additions;
                    githubCommtInfo.DELETIONS = response1.gitCommitStat.deletions;

                    string repositoryName = repo[0].owner + "/" + repo[0].name;

                    foreach githubfile in response1.gitCommitFiles {
                        var fileVar = dao:getFileInfo(githubfile.filename, repositoryName);
             //           io:println(fileVar);
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
                                        //io:println("file index : " + ((lastFileId + 1) + lengthof fileInfoList) + "   , " + lastFileId);
               //                         io:println("file index : " + lastFileId);
                                        //file = {ID:(lastFileId + 1) + lengthof fileInfoList, FILE_NAME:githubfile.filename, REPOSITORY_NAME: repo[0].name};
                                        file = {ID:lastFileId, FILE_NAME:githubfile.filename, REPOSITORY_NAME: repositoryName};
                 ///                       io:println("file index 2 : " + file.ID);
                                        fileInfoList[lengthof fileInfoList] = file;
                                    }

                                }
                                //if(file == null) {
                                //    file = {ID:(lastFileId + 1) + lengthof fileInfoList, FILE_NAME:githubfile. filename};
                                //    fileInfoList[lengthof fileInfoList] = file;
                                //}
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


                    //io:println("===========================================================================");
                    //io:println(response1);
                    //io:println("===========================================================================");
                }
            }
            io:println("search count" + searchRequestCount);
            githubCommtInfo.IS_UPDATED = true;
            if (searchRequestCount >= 28) {
                currentTimeMills = 61000 - (time:currentTime().time - startTime);
            //    io:print("cuurent milles ");
              //  io:println(currentTimeMills);

                runtime:sleepCurrentWorker(currentTimeMills);
                startTime = time:currentTime().time;
                searchRequestCount = 0;
            }

        }

        io:println(githubCommitInfoList);
        io:println("=======================================");
        io:println(fileInfoList);
        io:println("=======================================");
        io:println(commitFileList);

        int[] res = dao:insertFileInfo(fileInfoList);
        res = dao:updateGithubCommitInfo(githubCommitInfoList);
        res = dao:insertGithubCommitFileInfo(commitFileList);
        githubCommitInfoList = dao:getIncompleteGithubCommitInfo();
    }


    if (false) {
        error e = {message:"Cleanup error"};
    }
    return null;
}



function loggedError1(error e) {
    io:println(e);
    log:printErrorCause("[ERROR] cleanup failed", e);
}
