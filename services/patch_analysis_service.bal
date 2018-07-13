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
import dao;
import model;
import testcoverage;

@final public http:CorsConfig SERVICES_CORS_PARAMS = {
    allowOrigins:["*"],
    allowCredentials:false,
    allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
    exposeHeaders:["X-CUSTOM-HEADER"],
    maxAge:84900
};

documentation {Attributes associated with the service endpoint is defined here.}
endpoint http:Listener patchMetricsEP {
    port:9090
};


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/repository",
    cors: SERVICES_CORS_PARAMS
}
service<http:Service> repositoryService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }

    getRepositories(endpoint conn, http:Request req) {

        log:printInfo("Retrieving repositories information");

        http:Response res = new;
        var result = dao:getRepositories(parseQueryParam(req.getQueryParams()));

        match result {
            model:Repository[] repositoryList => {
                log:printDebug("Repositories information were retrieved");
                json jsonResponse = check <json>repositoryList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving repositories information failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/product/{product}"
    }

    getRepositoriesByProduct(endpoint conn, http:Request req, string product) {

        log:printInfo("Retrieving repositories information by product with product name : " + product);

        http:Response res = new;
        var result = dao:getRepositoriesbyProduct(untaint product, parseQueryParam(req.getQueryParams()));

        match result {
            model:Repository[] repositoryList => {
                log:printDebug("Repositories information were retrieved by product");
                json jsonResponse = check <json>repositoryList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving repositories information by product failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }
}


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/product",
    cors: SERVICES_CORS_PARAMS
}
service<http:Service> productService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getProducts(endpoint conn, http:Request req) {

        log:printInfo("Retrieving products information");

        http:Response res = new;
        var result = dao:getProducts(parseQueryParam(req.getQueryParams()));

        match result {
            model:Product[] productList => {
                log:printDebug("products information were retrieved");
                json jsonResponse = check <json>productList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving products information failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }
}


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/patch",
    cors: SERVICES_CORS_PARAMS
}
service<http:Service> patcheSrvice bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getPatches(endpoint conn, http:Request req) {

        log:printInfo("Retrieving patches information");

        http:Response res = new;
        var result = dao:getPatches(parseQueryParam(req.getQueryParams()));

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving patches information failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/product/{product}"
    }
    getPatchesByProduct(endpoint conn, http:Request req, string product) {

        log:printInfo("Retrieving patches information by product");

        http:Response res = new;
        var result = dao:getPatchesbyProduct(product, parseQueryParam(req.getQueryParams()));

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved by product");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving patches information by product failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/repository/{org}/{repo}"
    }
    getPatchesByRepository(endpoint conn, http:Request req, string org, string repo) {

        log:printInfo("Retrieving patches information by repository");

        string repository = org + "/" + repo;

        http:Response res = new;
        var result = dao:getPatchesbyRepository(repository, parseQueryParam(req.getQueryParams()));

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved by repository");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving patches information by repository failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}"
    }
    getPatchById(endpoint conn, http:Request req, int id) {

        log:printInfo("Retrieving patch information using given id");

        http:Response res = new;
        var result = dao:getPatchesbyId(id);

        match result {
            model:Patch patch => {
                log:printDebug("patch information was retrieved");
                json jsonResponse = check <json>patch;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving patch information failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }
        _ = conn -> respond(res);
    }
}


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/file",
    cors: SERVICES_CORS_PARAMS
}
service<http:Service> fileService bind patchMetricsEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/repository/{org}/{repo}"
    }
    getFileInfoWithStatsByRepositoryList(endpoint conn, http:Request req, string org, string repo) {

        string repository = org + "/" + repo;

        log:printInfo("Retrieving files information with statistics by repository with repository name : " + repository);

        http:Response res = new;
        var result = dao:getFileInfoWithStatsbyRepository(repository, parseQueryParam(req.getQueryParams()));

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("files information with statistics were retrieved by repository");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving files information with statistics by repository failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/patch/{id}/"
    }
    getFileInfoWithStatsByPatchList(endpoint conn, http:Request req, int id) {

        log:printInfo("Retrieving files information with statistics by patch with patch id : " + id);

        http:Response res = new;
        var result = dao:getFileInfoWithStatsbyPatch(id, parseQueryParam(req.getQueryParams()));

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("files information with statistics were retrieved by patch");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving files information with statistics by patch failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/mostModifiedJavaClasses/"
    }
    getMostModifiedJavaClassesList(endpoint conn, http:Request req) {

        log:printInfo("Retrieving most updated java classes with statistics");

        http:Response res = new;
        var result = dao:getMostModifiedJavaClasses(parseQueryParam(req.getQueryParams()));

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("Most updated java classes with statistics were retrieved by patch");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving most updated java classes with statistics by patch failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}"
    }
    getMostModifiedJavaClass(endpoint conn, http:Request req, int id) {

        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        log:printInfo("Retrieving java class with statistics with id : " + id + " & period from " + startDate + " to " + endDate);

        http:Response res = new;
        var result = dao:getJavaClassWithDateRange(id, startDate, endDate);

        match result {
            model:FileInfoWithStats file => {
                log:printDebug("java class with statistics was retrieved");
                json jsonResponse = check <json>file;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving java class with statistics failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}/allPatches"
    }
    getJavaClass(endpoint conn, http:Request req, int id) {

        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        log:printInfo("Retrieving java class with statistics with id : " + id + " & period from " + startDate + " to " + endDate + " (For patches)");

        http:Response res = new;
        var result = dao:getJavaClass(id, startDate, endDate);
            match result {
                model:FileInfoWithStats file => {
                log:printDebug("java class with statistics was retrieved");
                json jsonResponse = check <json>file;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving java class with statistics failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}/issues"
    }
    getJavaClassIssues(endpoint conn, http:Request req, int id) {

        log:printInfo("Retrieving issues in given java class with file id : " + id);

        http:Response res = new;
        var result = dao:getJavaClassIssuesFromDB(id, parseQueryParam(req.getQueryParams()));

        match result {
            model:Issue[] issues => {
                log:printDebug("Issues were retrieved");
                json jsonResponse = check <json>issues;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printError("Retrieving issues in given java class failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}/source"
    }
    getJavaFileSource(endpoint conn, http:Request req, int id) {

        log:printInfo("Retrieving given java class source with file id : " + id);

        http:Response res = new;
        var result = getFileSource(id);

        match result {
            string source => {
                res.setTextPayload(source);
            }
            error err => {
                log:printError("Retrieving java class source failed", err = err);
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        _ = conn -> respond(res);
    }


}

function getFileSource(int id) returns string|error {

    var result = dao:getFileInfoById(id);

    match result {
        model:FileInfo file => {
            testcoverage:ClassTestCoverageRequestPayload payload = {};

            if (file.FILE_NAME.contains(".java")) {
                string[] splitedFileName = file.FILE_NAME.split("/");
                string[] splitedRepoName = file.REPOSITORY_NAME.split("/");

                payload.fileId = <string>file.ID;
                payload.className = splitedFileName[lengthof splitedFileName - 1];
                payload.packageName = generatePackageName(splitedFileName);
                payload.componentName = splitedRepoName[1];
                payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
            }
            string returnTo = testcoverage:getClassesSourceAsString(payload);

            return returnTo;
        }
        error err => {
            log:printError("Retrieving java class failed", err = err);
            return err;
        }
    }
}

function parseQueryParam(map<string> queryParam) returns model:RequestQueryParam {
    model:RequestQueryParam params;
    params.pageIndex  = <int>(<string>untaint queryParam.pageIndex) but {error => 1};
    params.pageSize = <int>(<string>untaint queryParam.pageSize)  but {error => 25};
    params.sortDir = <int>(<string>untaint queryParam.sortDir)  but {error => 0};

    params.sortColumn = <string>untaint queryParam.sortColumn;
    params.startDate = <string>untaint queryParam.startDate;
    params.endDate = <string>untaint queryParam.endDate;

    return  params;
}
