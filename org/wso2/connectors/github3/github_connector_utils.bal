package org.wso2.connectors.github3;

//import ballerina.time;
//import ballerina.util;
import ballerina.net.http;
import ballerina.file;
//import ballerina.net.uri;
//import ballerina.security.crypto;
import ballerina.io;

string timeStamp;
string nonceString;




function constructRequestHeaders(http:OutRequest request, string accessToken, string acceptParam) {
    request.setHeader("Authorization", "Bearer " + accessToken);
    request.setHeader("Accept", acceptParam);
}

function extractGitRepositories(json jsonResponse)(GitHubRepository[])  {
io:print("github search commit result : ");
io:println(jsonResponse);
    GitHubRepository[] repositories = [];
    foreach item in jsonResponse.items{
        GitHubRepository repository = {};
        repository.name, _ = (string)item.repository.name;
        repository.owner, _ = (string)item.repository.owner.login;
        repositories[lengthof repositories] = repository;
        io:println(item.repository.name);
    }
    return repositories;
}

function extractGitRepositoriesFromPR(json jsonResponse)(GitHubRepository[])  {
 io:print("github search PR result : ");
io:println(jsonResponse);
    GitHubRepository[] repositories = [];
    foreach item in jsonResponse.items{
        GitHubRepository repository = {};
        var repo_url, _ = (string)item.repository_url;
        string[] splitted_url = repo_url.split("/");
        repository.name = splitted_url[lengthof splitted_url - 1];
        repository.owner = splitted_url[lengthof splitted_url - 2];

        io:println(isContainRepo(repositories, repository));

        if (!isContainRepo(repositories, repository)) {
            repositories[lengthof repositories] = repository;
        }
      //  io:println(item.repository.name);
    }
    return repositories;
}


function extractCommitChanges(json jsonResponse)(GitHubCommitChanges) {
    io:print("github commit changes result : ");
    io:println(jsonResponse);
    GitHubCommitChanges commitChanges = {};
    commitChanges.gitCommitStat, _ = <GitHubCommitStat>jsonResponse.stats;
    commitChanges.gitCommitFiles = [];
    foreach file in jsonResponse.files{
        GitHubFileChanges fileChanges = {};
        fileChanges.sha, _ = (string)file.sha;
        fileChanges.filename, _ = (string)file.filename;
        fileChanges.totalChanges, _ = (int)file.changes;
        fileChanges.additions, _ = (int)file.additions;
        fileChanges.deletions, _ = (int)file.deletions;
        commitChanges.gitCommitFiles[lengthof commitChanges.gitCommitFiles] = fileChanges;
    }

    return commitChanges;
}


function isContainRepo(GitHubRepository[] repositories,GitHubRepository repository)(boolean) {
    foreach repo in repositories{
        if (repo.name == repository.name && repo.owner == repository.owner) {
            return true;
        }
    }
    return false;
}

//           string sha;
//string filename;
//int totalChanges;
//int additions;
//int deletions;

           //"sha": "922581873efc9348a294ee76b7ba9233bc2be722",
           //"filename": "esb/org.wso2.developerstudio.eclipse.gmf.esb.diagram/src/org/wso2/developerstudio/eclipse/gmf/esb/diagram/custom/deserializer/APIDeserializer.java",
           //"status": "modified",
           //"additions": 22,
           //"deletions": 22,
           //"changes": 44,
           //"blob_url": "https://github.