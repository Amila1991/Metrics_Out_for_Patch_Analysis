package wso2.github3;

import ballerina/io;
import ballerina/mime;



documentation {Struct to define the Github connector for Rest API v3}
public type GithubConnector object {
    public {
        string accessToken;
        http:Client clientEndpoint = new;
    }

    documentation {Search repositories info throu github commit.
        P{{id}} The commit SHA ID
        returns array of GitHubRepository objects if successful else Error occured during HTTP client invocation.}
    public function searchRepositoryViaCommit (string id) returns GitHubRepository[] | error;

    documentation {Search repositories info using given github pull request.
        P{{id}} The pull request ID
        returns array of GitHubRepository objects if successful else Error occured during HTTP client invocation.}
    public function searchRepositoryViaPR (string id) returns GitHubRepository[] | error;

    documentation {Retrieve commit using given commit ID, repository name and repository owner.
        P{{repo}} The repository name
        P{{owner}} repository owner
        P{{id}} The commit SHA ID
        returns GitHubCommitChanges object if successful else Error occured during HTTP client invocation.}
    public function getCommitChanges (string repo, string owner, string id) returns GitHubCommitChanges | error;
};




public function GithubConnector::searchRepositoryViaCommit (string id) returns GitHubRepository[] | GitHubError {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    http:Request request;
    GitHubError  githubError= {};

    string serviceUrl = "/search/commits";
    string queryParams = "q=hash:" + id;

    request.setHeader("Authorization", "Bearer " + self.accessToken);
    request.setHeader("Accept", "application/vnd.github.cloak-preview");

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

    string serviceUrl = "/search/issues";
    string queryParams = "q=" + id;

    request.setHeader("Authorization", "Bearer " + self.accessToken);
    request.setHeader("Accept", "application/vnd.github.cloak-preview");

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

    request.setHeader("Authorization", "Bearer " + self.accessToken);
    request.setHeader("Accept", "application/vnd.github.cloak-preview");

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
