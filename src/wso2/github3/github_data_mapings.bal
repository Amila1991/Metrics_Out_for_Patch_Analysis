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

package wso2.github3;

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