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
import ballerina/log;
import ballerina/config;

endpoint http:Client jacocoEndpoint {
    url: config:getAsString("testCoverage.service.url"),
    secureSocket: {
        keyStore: {
            path: config:getAsString("testCoverage.keyStore.path"),
            password: config:getAsString("testCoverage.keyStore.password")
        },
        trustStore: {
            path: config:getAsString("testCoverage.trustStore.path"),
            password: config:getAsString("testCoverage.trustStore.password")
        }
    }
    ,
    auth: {
        scheme: http:BASIC_AUTH,
        username: config:getAsString("testCoverage.service.user"),
        password: config:getAsString("testCoverage.service.password")
    },
    timeoutMillis: config:getAsInt("testCoverage.service.timeout")
};

public function getClassesTestCoverage(ClassTestCoverageRequestPayload[] classesList)
                    returns ClassTestCoverageResponsePayload[] {

    http:Request request = new;
    string requestPath = "/product-coverage-service/source-file-report";
    log:printInfo("Requesting url from jacoco service " + requestPath + ".");
    json jsonObject = check <json>classesList;
    json payload = { sourceFileJsons: jsonObject };
    request.setJsonPayload(payload);
    var jacoResponse = jacocoEndpoint->post(untaint requestPath, request);

    ClassTestCoverageResponsePayload[] toReturn;
    match jacoResponse {
        http:Response jacocoRes => {
            match jacocoRes.getJsonPayload() {
                json load => {
                    var jsonItems = check <json[]>load;
                    foreach item in jsonItems {
                        var responseItem = <ClassTestCoverageResponsePayload>item;
                        match responseItem {
                            ClassTestCoverageResponsePayload fileCoverage => {
                                toReturn[lengthof toReturn] = fileCoverage;
                            }
                            error err => {
                                log:printError(err.message, err = err);
                            }
                        }

                    }
                }
                error err => {
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => {
            log:printError(err.message, err = err);
        }
    }
    return toReturn;
}

public function getClassesSourceAsString(ClassTestCoverageRequestPayload classPayload) returns string {

    http:Request request = new;
    string requestPath = "/product-coverage-service/getSourceFile";
    log:printInfo("Requesting url from jacoco service " + requestPath + ".");

    json jsonObject = check <json>classPayload;
    request.setJsonPayload(jsonObject);
    var jacoResponse = jacocoEndpoint->post(untaint requestPath, request);

    string toReturn;
    match jacoResponse {
        http:Response jacocoRes => {
            match jacocoRes.getPayloadAsString() {
                string load => {
                    toReturn = load;
                }
                error err => {
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => {
            log:printError(err.message, err = err);
        }
    }
    return toReturn;
}