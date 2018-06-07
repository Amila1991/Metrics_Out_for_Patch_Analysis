package wso2.github3;

import ballerina/io;


function jsonTotGitRepositories(json jsonResponse) returns (GitHubRepository[])  {
    GitHubRepository[] repositories = [];
    var jsonItems = check <json[]> jsonResponse.items;
    foreach i, item in jsonItems {
        if(item.repository != null) {
            GitHubRepository repository = {};
            repository.name  = item.repository.name.toString() ?: "";
            repository.owner = item.repository.owner.login.toString() ?: "";
            repositories[i] = repository;
        }
    }
    return repositories;
}


function jsonTotGitRepositoriesWithExtraction(json jsonResponse) returns (GitHubRepository[]) {
    GitHubRepository[] repositories = [];
    var jsonItems = check <json[]> jsonResponse.items;
    foreach i, item in jsonItems{
        GitHubRepository repository = {};
        string repo_url= item.repository_url.toString() ?: "";
        string[] splitted_url = repo_url.split("/");
        if (lengthof splitted_url == 6) {
            repository.name = splitted_url[lengthof splitted_url - 1];
            repository.owner = splitted_url[lengthof splitted_url - 2];

            if (!isContainRepo(repositories, repository)) {
                repositories[lengthof repositories] = repository;
            }
        }
    }
    return repositories;
}


function jsonToCommitChanges(json jsonResponse) returns (GitHubCommitChanges) {
    GitHubCommitChanges commitChanges = {};
    commitChanges.gitCommitStat = check <GitHubCommitStat>jsonResponse.stats;
    commitChanges.gitCommitFiles = [];
    var jsonFiles = check <json[]> jsonResponse.files;
    foreach i, file in jsonFiles {
        GitHubFileChanges fileChanges = {};
        fileChanges.sha = file.sha.toString() ?: "";
        fileChanges.filename = file.filename.toString() ?: "";
        fileChanges.totalChanges = check <int> (file.changes.toString() ?: "");
        fileChanges.additions = check <int> (file.additions.toString() ?: "");
        fileChanges.deletions = check <int> (file.deletions.toString() ?: "");
        commitChanges.gitCommitFiles[i] = fileChanges;
    }

    return commitChanges;
}