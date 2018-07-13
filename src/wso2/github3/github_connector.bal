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

import ballerina/mime;

documentation {Struct to define the Github connector for Rest API v3}
public type GithubConnector object {
    public {
        string accessToken;
        http:Client clientEndpoint = new;
    }

    documentation {Search repositories info throu github commit.
        P{{id}} The commit SHA id
        returns array of GitHubRepository objects if successful else Error occured during HTTP client invocation.}
    public function searchRepositoryViaCommit (string id) returns GitHubRepository[] | error;

    documentation {Search repositories info using given github pull request.
        P{{id}} The pull request id
        returns array of GitHubRepository objects if successful else Error occured during HTTP client invocation.}
    public function searchRepositoryViaPR (string id) returns GitHubRepository[] | error;

    documentation {Retrieve commit using given commit id, repository name and repository owner.
        P{{repo}} The repository name
        P{{owner}} repository owner
        P{{id}} The commit SHA id
        returns GitHubCommitChanges object if successful else Error occured during HTTP client invocation.}
    public function getCommitChanges (string repo, string owner, string id) returns GitHubCommitChanges | error;
};

public function GithubConnector::searchRepositoryViaCommit (string id) returns GitHubRepository[] | GitHubError {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    http:Request request;
    GitHubError  githubError= {};

    string serviceUrl = GITHUB_COMMIT_SERACH_ENDPOINT; //"/search/commits";
    string queryParams = HASH_QUERY_PARAM + id; //"q=hash:"

    request.setHeader(AUTHORIZATION_HEADER, BEARER_TOKEN + self.accessToken);
    request.setHeader(ACCEPT_HEADER, APPLICATION_VND_GITHUB_CLOAK_PREVIEW);

    serviceUrl = serviceUrl + "?" + queryParams;

    var httpResponse = clientEndpoint -> get(serviceUrl, request);

    var response = validateResponse(httpResponse);

    match response {
        GitHubError err => {
            return err;
        }
        json jsonResponse => {
            return jsonTotGitRepositories(jsonResponse);
        }
    }
}

public function GithubConnector::searchRepositoryViaPR (string id) returns GitHubRepository[] | GitHubError {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    http:Request request = new;
    GitHubError githubError= {};

    string serviceUrl = GITHUB_PR_SERACH_ENDPOINT; //"/search/issues";
    string queryParams = "q=" + id;

    request.setHeader(AUTHORIZATION_HEADER, BEARER_TOKEN + self.accessToken);
    request.setHeader(ACCEPT_HEADER, APPLICATION_VND_GITHUB_CLOAK_PREVIEW);

    serviceUrl = serviceUrl + "?" + queryParams;

    var httpResponse = clientEndpoint -> get(serviceUrl, request);
    var response = validateResponse(httpResponse);

    match response {
        GitHubError err => {
            return err;
        }
        json jsonResponse => {
            return jsonTotGitRepositoriesWithExtraction(jsonResponse);
        }
    }
}

public function GithubConnector::getCommitChanges (string repo, string owner, string id) returns GitHubCommitChanges | GitHubError {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    http:Request request = new;
    GitHubError githubError= {};

    string serviceUrl = "/repos";
    string pathParams = "/" + owner + "/" + repo + "/commits/" + id;

    request.setHeader(AUTHORIZATION_HEADER, BEARER_TOKEN + self.accessToken);
    request.setHeader(ACCEPT_HEADER, APPLICATION_VND_GITHUB_CLOAK_PREVIEW);

    serviceUrl = serviceUrl + pathParams;
    var httpResponse = clientEndpoint -> get(serviceUrl, request);
    var response = validateResponse(httpResponse);

    match response {
        GitHubError err => {
            return err;
        }
        json jsonResponse => {
            return jsonToCommitChanges(jsonResponse);
        }
    }
}
