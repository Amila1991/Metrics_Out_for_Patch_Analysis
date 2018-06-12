//package org.wso2.services;
//
//import org.wso2.connectors.github3;
//import ballerina.io;
//import org.wso2.dao;
//import ballerina.config;
//import org.wso2.model;
//
//const string accessToken = config:getGlobalValue("github.access_token");
//const string NA = "N/A";
//Regex REGEX = {pattern:"^[a-fA-F0-9]{40}$"};
//
//github3:ClientConnector githubConnector = create github3:ClientConnector(accessToken);
//
//
//public function processPatchPRInfo(int index) {
//    endpoint<github3:ClientConnector> githubConnection {
//        githubConnector;
//    }
//
//    while (true) {
//              var res= dao:getLastPatchInfoId();
//    }
//
//  //  table patchtable = dao:getPatchETARecords(dao:getLastPatchInfoId());
//    //var ree = dao:getLastPatchInfoId();
//
//    string [] public_pr_commit_id = [];
//    string [] support_pr_commit_id = [];
//
//    model:PatchInfo[] patchInfoList = [];
//    model:GithubCommitInfo[] githubCommitInfoList = [];
//
//  //  io:println(patchtable.hasNext());
//
//    foreach patchETA in dao:getPatchETARecords(dao:getLastPatchInfoId()) {
//    //while (patchtable.hasNext()) {
//    //    var rs, _ = (model:PatchETA)patchtable.getNext();
//        boolean has_pub_git_id = false;
//        model:PatchInfo patchInfo = {};
//
//        patchInfo.ID = patchETA.ID;
//        patchInfo.PATCH_NAME = patchETA.PATCH_NAME;
//        patchInfoList[lengthof patchInfoList] = patchInfo;
//
//        if (patchETA.SVN_GIT_PUBLIC != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_PUBLIC)) {
//            string[] git_sha_ids = patchETA.SVN_GIT_PUBLIC.split(",");
//
//            foreach id in git_sha_ids {
//                var idbool, _ = id.trim().matchesWithRegex(REGEX);
//                has_pub_git_id = idbool ? idbool : has_pub_git_id;
//                if (idbool) {
//                    model:GithubCommitInfo githubCommitInfo = {};
//                    public_pr_commit_id[lengthof public_pr_commit_id] = id.trim();
//                    githubCommitInfo.PATCH_INFO_ID = patchETA.ID;
//                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
//                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "PUBLIC";
//                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
//                }
//            }
//
//        }
//
//        if (!has_pub_git_id && patchETA.SVN_GIT_SUPPORT != null && !NA.equalsIgnoreCase(patchETA.SVN_GIT_SUPPORT)) {
//            string[] git_sha_ids = patchETA.SVN_GIT_SUPPORT.split(",");
//
//            foreach id in git_sha_ids {
//                var idbool, _ = id.trim().matchesWithRegex(REGEX);
//                if (idbool) {
//                   support_pr_commit_id[lengthof support_pr_commit_id] = id.trim();
//                    model:GithubCommitInfo githubCommitInfo = {};
//                    public_pr_commit_id[lengthof public_pr_commit_id] = id.trim();
//                    githubCommitInfo.PATCH_INFO_ID = patchETA.ID;
//                    githubCommitInfo.GITHUB_SHA_ID = id.trim();
//                    githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE = "SUPPORT";
//                    githubCommitInfoList[lengthof githubCommitInfoList] = githubCommitInfo;
//                }
//            }
//        }
//
//
//       // res =
//
//    }
//
//    var res = dao:insertPatchInfo(patchInfoList);
//    foreach i in res {
//        io:print(i);
//    }
//    io:println("\n");
//    //foreach id in public_pr_commit_id {
//    //    io:println(id);
//    //    var response, e = githubConnection.searchRepositoryViaCommit(id);
//    //    io:println(response);
//    //    io:println(e);
//    //
//    //    if (lengthof response == 0) {
//    //        response, e = githubConnection.searchRepositoryViaPR(id);
//    //    }
//    //
//    //    github3:GitHubRepository[] repo = response.filter(
//    //        function (github3:GitHubRepository repository)(boolean){
//    //            io:println(repository);
//    //            return repository.owner.contains("wso2");
//    //        });
//    //
//    //    io:println(repo);
//    //    if (lengthof repo > 0) {
//    //       var response1, e1 = githubConnection.getCommitChanges( repo[0].name, repo[0].owner, id);
//    //       if (e1 != null) {
//    //        io:print("Error ");
//    //        io:println( e1);
//    //       } else {
//    //        io:println("===========================================================================");
//    //        io:println( response1);
//    //        io:println("===========================================================================");
//    //       }
//    //    }
//    //}
//}