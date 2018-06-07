package wso2.github3;

import ballerina/http;
import ballerina/io;

function isContainRepo(GitHubRepository[] repositories,GitHubRepository repository) returns (boolean) {
    foreach repo in repositories{
        if (repo.name == repository.name && repo.owner == repository.owner) {
            return true;
        }
    }
    return false;
}



function validateResponse(http:Response | http:HttpConnectorError httpResponse) returns json | GitHubError {
    match httpResponse {
        http:HttpConnectorError err => {
            GitHubError githubError = {message:err.message, statusCode:err.statusCode, cause: err.cause};
            return githubError;
        }
        http:Response response => {
            if (response.statusCode < 200|| response.statusCode >= 300) {
                GitHubError githubError = {message:response.reasonPhrase, statusCode:response.statusCode};
                return githubError;
            }
            var GithubJSONResponse = response.getJsonPayload();
            match GithubJSONResponse {
                http:PayloadError err => {
                    GitHubError githubError = {message:err.message, cause: err.cause};
                    return githubError;
                }
                json jsonResponse => {
                    return jsonResponse;
                }
            }
        }
    }
}
