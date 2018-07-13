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

function validateResponse(http:Response|error httpResponse) returns json | GitHubError {
    match httpResponse {
        http:Response response => {
            if (response.statusCode < 200|| response.statusCode >= 300) {
                GitHubError githubError = {message:response.reasonPhrase, statusCode:response.statusCode};
                return githubError;
            }
            var GithubJSONResponse = response.getJsonPayload();
            match GithubJSONResponse {
                error err => {
                    GitHubError githubError = {message:err.message, cause: err.cause};
                    return githubError;
                }
                json jsonResponse => {
                    return jsonResponse;
                }
            }
        }
        error err => {
            GitHubError githubError = {message:err.message, cause: err.cause};
            return githubError;
        }
    }
}
