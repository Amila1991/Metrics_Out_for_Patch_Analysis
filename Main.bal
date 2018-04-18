import ballerina.io;
import org.wso2.connectors.github3;
import ballerina.config;
import org.wso2.services;
import org.wso2.dao;
import org.wso2.model;

const string accessToken = config:getGlobalValue("github.access_token");

public function main (string[] args) {
    //services:processPatchPRInfo(0);
    var res= dao:getIncompleteGithubCommitInfo();
    io:println(res);
    //string ss = (string)model:GithubRepoType.SUPPORT
  //  io:println("Hello, World!"); c24c4fb396da701c619eb374bcd2b55bfe5c2cba
//    endpoint<github3:ClientConnector> githubConnector {
//        create github3:ClientConnector(accessToken);
//    }
//
//io:println(accessToken);
//
//    string shaId = "cd19639d1adf73f42947e2a24519c37620e4a06a";
//    var response, e = githubConnector.searchRepositoryViaPR(shaId);
//    io:println(response);
//    //io:println(e);
//
//
//    github3:GitHubRepository[] repo = response.filter(function (github3:GitHubRepository repository)(boolean){
//            io:println(repository);
//            return repository.owner.contains("wso2");
//        });
//
//    io:println(repo);
//    var response1, e1 = githubConnector.getCommitChanges(repo[0].name, repo[0].owner, shaId);
//    io:println(response1);
}
