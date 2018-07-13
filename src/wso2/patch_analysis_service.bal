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
import wso2/dao;
import wso2/model;
import wso2/testcoverage;
import wso2/services;

documentation {Attributes associated with the service endpoint is defined here.}
endpoint http:Listener patchMetricsEP {
    port:9090
};


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/repository",
    cors: services:SERVICES_CORS_PARAMS
}
service<http:Service> repositoryService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }

    getRepositories(endpoint conn, http:Request req) {
        log:printInfo("Retrieving repositories information");

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

// default values
        int pageIndex = 1;
        int pageSize = 25;
        int sortDir = 0;

        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printErrorCause("Error occured while casting page index", err);
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printErrorCause("Error occured while casting page size", err);
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printErrorCause("Error occured while casting sort direction", err);
            }
        }

        http:Response res = new;
        var result = dao:getRepositories(sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:Repository[] repositoryList => {
                log:printDebug("Repositories information were retrieved");
                json jsonResponse = check <json>repositoryList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving repositories information failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 25;
        int sortDir = 0;

        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getRepositoriesbyProduct(untaint product, sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:Repository[] repositoryList => {
                log:printDebug("Repositories information were retrieved by product");
                json jsonResponse = check <json>repositoryList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving repositories information by product failed", err);
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
    cors: services:SERVICES_CORS_PARAMS
}
service<http:Service> productService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }

    getProducts(endpoint conn, http:Request req) {

        log:printInfo("Retrieving products information");

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getProducts(sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:Product[] productList => {
                log:printDebug("products information were retrieved");
                json jsonResponse = check <json>productList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving products information failed", err);
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
    cors: services:SERVICES_CORS_PARAMS
}
service<http:Service> patcheSrvice bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getPatches(endpoint conn, http:Request req) {

        log:printInfo("Retrieving patches information");

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getPatches(sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving patches information failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getPatchesbyProduct(product, sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved by product");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving patches information by product failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getPatchesbyRepository(repository, sortColumn, sortDir, pageIndex, pageSize, startDate,endDate);

        match result {
            model:Patch[] patchList => {
                log:printDebug("patches information were retrieved by repository");
                json jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving patches information by repository failed", err);
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
                log:printErrorCause("Retrieving patch information failed", err);
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
    cors: services:SERVICES_CORS_PARAMS
}
service<http:Service> fileService bind patchMetricsEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/repository/{org}/{repo}"
    }
    getFileInfoWithStatsByRepositoryList(endpoint conn, http:Request req, string org, string repo) {

        string repository = org + "/" + repo;

        log:printInfo("Retrieving files information with statistics by repository with repository name : " + repository);

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getFileInfoWithStatsbyRepository(repository, sortColumn, sortDir, pageIndex, pageSize,
            startDate, endDate);

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("files information with statistics were retrieved by repository");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving files information with statistics by repository failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getFileInfoWithStatsbyPatch(id, sortColumn, sortDir, pageIndex, pageSize, startDate, endDate);

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("files information with statistics were retrieved by patch");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving files information with statistics by patch failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        string startDate = <string>untaint req.getQueryParams().startDate;
        string endDate = <string>untaint req.getQueryParams().endDate;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getMostModifiedJavaClasses(startDate, endDate, sortColumn, sortDir, pageIndex, pageSize);

        match result {
            model:FileInfoWithStats[] fileList => {
                log:printDebug("Most updated java classes with statistics were retrieved by patch");
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving most updated java classes with statistics by patch failed", err);
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
                log:printErrorCause("Retrieving java class with statistics failed", err);
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
                log:printErrorCause("Retrieving java class with statistics failed", err);
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

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;

        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                pageIndex = index;
            }
            error err => {
                log:printWarn("Error occured while casting page index");
            }
        }

        match pageSizeStr {
            int size => {
                pageSize = size;
            }
            error err => {
                log:printWarn("Error occured while casting page size");
            }
        }

        match sortDirStr {
            int dir => {
                sortDir = dir;
            }
            error err => {
                log:printWarn("Error occured while casting sort direction");
            }
        }

        http:Response res = new;
        var result = dao:getJavaClassIssuesFromDB(id, sortColumn, sortDir, pageIndex, pageSize);

        match result {
            model:Issue[] issues => {
                log:printDebug("Issues were retrieved");
                json jsonResponse = check <json>issues;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                log:printErrorCause("Retrieving issues in given java class failed", err);
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
                res.setStringPayload(source);
            }
            error err => {
                log:printErrorCause("Retrieving java class source failed", err);
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
                payload.packageName = services:generatePackageName(splitedFileName);
                payload.componentName = splitedRepoName[1];
                payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
            }
            string returnTo = testcoverage:getClassesSourceAsString(payload);

            return returnTo;
        }
        error err => {
            log:printErrorCause("Retrieving java class failed", err);
            return err;
        }
    }
}
