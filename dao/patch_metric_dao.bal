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

import ballerina/sql;
import ballerina/mysql;
import ballerina/config;
import ballerina/log;
import model as model;

endpoint mysql:Client patchMetricDB {
    host: config:getAsString(PATCH_METRICS_DB_HOST),
    port: config:getAsInt(PATCH_METRICS_DB_PORT),
    name: config:getAsString(PATCH_METRICS_DB_NAME),
    username: config:getAsString(PATCH_METRICS_DB_USER),
    password: config:getAsString(PATCH_METRICS_DB_PASSWORD),
    poolOptions: {maximumPoolSize: config:getAsInt(PATCH_METRICS_DB_MAX_POOL_SIZE)},
    dbOptions: {useSSL: false}
};

documentation {Insert list of patch information entries.
        P{{patchInfoList}} Array of patch information
        returns Array of int which represent record inserting status.
}
public function insertPatchInfo(model:PatchInfo[] patchInfoList) returns int[] {

    log:printDebug("Inserting patch information");

    int[] res = [];
    foreach i, patchInfo in patchInfoList {
        log:printTrace("Inserting patch information with patch info id : " + patchInfo.ID);

        sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: patchInfo.ID };
        sql:Parameter patchNameParam = { sqlType: sql:TYPE_VARCHAR, value: patchInfo.PATCH_NAME };
        sql:Parameter clientParam = { sqlType: sql:TYPE_VARCHAR, value: patchInfo.CLIENT };
        sql:Parameter supportJIRAParam = { sqlType: sql:TYPE_VARCHAR, value: patchInfo.SUPPORT_JIRA };
        sql:Parameter reportDateParam = { sqlType: sql:TYPE_DATE, value: patchInfo.REPORT_DATE };
        sql:Parameter productComIdParam = { sqlType: sql:TYPE_INTEGER, value: patchInfo.PRODUCT_COMPONENT_ID };

        var rst = patchMetricDB->update(PATCH_METRICS_INSERT_PATCH_INFO, idParam, patchNameParam, clientParam,
            supportJIRAParam, reportDateParam, productComIdParam);
        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting patch information with patch info id : " + patchInfo.ID,
                    err = err);
            }
        }
    }

    return res;
}

documentation {Insert list of Github commit information entries.
        P{{githubCommitInfoList}} Array of commit information
        returns Array of int which represent record inserting status.
}
public function insertGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList) returns int[] {

    log:printDebug("Inserting github commit information");

    int[] res = [];
    foreach i, githubCommitInfo in githubCommitInfoList {
        log:printTrace("Inserting github commit information with github id : " + githubCommitInfo.GITHUB_SHA_ID);

        sql:Parameter githubSHAIdParam = { sqlType: sql:TYPE_VARCHAR, value: githubCommitInfo.GITHUB_SHA_ID };
        sql:Parameter githubSHAIdRepoTypeParam = { sqlType: sql:TYPE_VARCHAR, value: githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE };
        sql:Parameter totalChangesParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.TOTAL_CHANGES };
        sql:Parameter additionsParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.ADDITIONS };
        sql:Parameter deletionsParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.DELETIONS };
        sql:Parameter isUpdatedParam = { sqlType: sql:TYPE_TINYINT, value: <int>githubCommitInfo.IS_UPDATED };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_GITHUB_COMMIT_INFO, githubSHAIdParam,
            githubSHAIdRepoTypeParam, totalChangesParam, additionsParam, deletionsParam, isUpdatedParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting github commit information with github id : " +
                        githubCommitInfo.GITHUB_SHA_ID, err = err);
            }
        }
    }

    return res;
}

documentation {Insert list of patch related commit entries.
        P{{patchCommitInfoList}} Array of patch related commit
        returns Array of int which represent record inserting status.
}
public function insertPatchCommitInfo(model:PatchCommitInfo[] patchCommitInfoList) returns int[] {

    log:printDebug("Inserting patch related commit");

    int[] res = [];

    foreach i, patchCommitInfo in patchCommitInfoList {
        log:printTrace("Inserting patch related commit with patch id : " + patchCommitInfo.PATCH_INFO_ID);

        sql:Parameter githubSHAIdParam = { sqlType: sql:TYPE_VARCHAR, value: patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID };
        sql:Parameter patchIdParam = { sqlType: sql:TYPE_INTEGER, value: patchCommitInfo.PATCH_INFO_ID };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_PATCH_COMMIT_INFO, githubSHAIdParam, patchIdParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting patch related commit with patch id : " +
                        patchCommitInfo.PATCH_INFO_ID, err = err);
            }
        }

    }

    return res;
}

documentation {Insert list of file changes entries.
        P{{commitFileInfoList}} Array of file changes
        returns Array of int which represent record inserting status.
}
public function insertGithubCommitFileInfo(model:CommitFileInfo[] commitFileInfoList) returns int[] {

    log:printDebug("Inserting file changes");

    int[] res = [];

    foreach i, commitFileInfo in commitFileInfoList {
        log:printTrace("Inserting file changes with file id : " + commitFileInfo.FILE_INFO_ID +
                " & github commit id : " + commitFileInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID);

        sql:Parameter githubCommitSHAIdParam = { sqlType: sql:TYPE_VARCHAR, value: commitFileInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID };
        sql:Parameter fileSHAIdParam = { sqlType: sql:TYPE_INTEGER, value: commitFileInfo.FILE_INFO_ID };
        sql:Parameter totalChangesParam = { sqlType: sql:TYPE_INTEGER, value: commitFileInfo.TOTAL_CHANGES };
        sql:Parameter additionsParam = { sqlType: sql:TYPE_INTEGER, value: commitFileInfo.ADDITIONS };
        sql:Parameter deletionsParam = { sqlType: sql:TYPE_INTEGER, value: commitFileInfo.DELETIONS };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_FILE_CHANGES, githubCommitSHAIdParam, fileSHAIdParam,
            totalChangesParam, additionsParam, deletionsParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting file changes with file id : " +
                        commitFileInfo.FILE_INFO_ID + " & github commit id : " + commitFileInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID, err = err);
            }
        }
    }

    return res;
}

documentation {Update github commits to complete github commit information
        P{{githubCommitInfoList}} Array of commit information
        returns Array of int which represent record inserting status.
}
public function updateGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList) returns int[] {

    log:printDebug("Updating github commits to complete github information");

    int[] res = [];

    foreach i, githubCommitInfo in githubCommitInfoList {
        log:printTrace("Updating github commits with github id : " + githubCommitInfo.GITHUB_SHA_ID);

        sql:Parameter totalChangesParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.TOTAL_CHANGES };
        sql:Parameter additionsParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.ADDITIONS };
        sql:Parameter deletionsParam = { sqlType: sql:TYPE_INTEGER, value: githubCommitInfo.DELETIONS };
        sql:Parameter isUpdatedParam = { sqlType: sql:TYPE_TINYINT, value: <int>githubCommitInfo.IS_UPDATED };
        sql:Parameter githubSHAIdParam = { sqlType: sql:TYPE_VARCHAR, value: githubCommitInfo.GITHUB_SHA_ID };

        var rst = patchMetricDB -> update(PATCH_METRICS_UPDATE_GITHUB_COMMIT_INFO, totalChangesParam, additionsParam,
            deletionsParam, isUpdatedParam, githubSHAIdParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while updating github commit to complete github information with github id : "
                        + githubCommitInfo.GITHUB_SHA_ID, err = err);
            }
        }
    }

    return res;
}

documentation {Insert file information
        P{{fileInfoList}} Array of file information
        returns Array of int which represent record inserting status.
}
public function insertFileInfo(model:FileInfo[] fileInfoList) returns int[] {

    log:printDebug("Inserting file information");

    int[] res = [];

    foreach i, file in fileInfoList {
        log:printTrace("Inserting file information with file id : " + file.ID);

        sql:Parameter fileIdParam = { sqlType: sql:TYPE_INTEGER, value: file.ID };
        sql:Parameter fileNameParam = { sqlType: sql:TYPE_VARCHAR, value: file.FILE_NAME };
        sql:Parameter repositoryParam = { sqlType: sql:TYPE_VARCHAR, value: file.REPOSITORY_NAME };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_FILE_INFO, fileIdParam, fileNameParam, repositoryParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting file information with file id : " + file.ID, err = err);
            }
        }
    }

    return res;
}

documentation {Insert file statistics including test coverage
        P{{fileStatsList}} Array of file statistics
        returns Array of int which represent record inserting status.
}
public function insertFileStats(model:FileStats[] fileStatsList) returns int[] {

    log:printDebug("Inserting file statistics");

    int[] res = [];
    foreach i, fileStats in fileStatsList {
        log:printTrace("Inserting file statistics with file id : " + fileStats.FILE_INFO_ID);

        sql:Parameter fileIdParam = { sqlType: sql:TYPE_INTEGER, value: fileStats.FILE_INFO_ID };
        sql:Parameter updatedDateParam = { sqlType: sql:TYPE_DATE, value: fileStats.UPDATED_DATE };
        sql:Parameter coveredLinesParam = { sqlType: sql:TYPE_INTEGER, value: fileStats.TEST_COVERED_LINES };
        sql:Parameter missedLinesParam = { sqlType: sql:TYPE_INTEGER, value: fileStats.TEST_MISSED_LINES };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_FILE_STATS, fileIdParam, updatedDateParam,
            coveredLinesParam, missedLinesParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting file statistics with file id : " +
                        fileStats.FILE_INFO_ID, err = err);
            }
        }
    }

    return res;
}

documentation {Insert file issues which given by finbugs
        P{{issueList}} Array of issue
        returns Array of int which represent record inserting status.
}
public function insertFileIssues(model:Issue[] issueList) returns int[] {

    log:printDebug("Inserting files issues");

    int[] res = [];
    foreach i, issue in issueList {
        log:printTrace("Inserting files issue with file id : " + issue.FILE_STATS_FILE_INFO_ID);

        sql:Parameter IdParam = { sqlType: sql:TYPE_INTEGER, value: issue.ID };
        sql:Parameter fileIdParam = { sqlType: sql:TYPE_INTEGER, value: issue.FILE_STATS_FILE_INFO_ID };
        sql:Parameter lineParam = { sqlType: sql:TYPE_VARCHAR, value: issue.LINE };
        sql:Parameter descriptionParam = { sqlType: sql:TYPE_VARCHAR, value: issue.DESCRIPTION };
        sql:Parameter errorCodeParam = { sqlType: sql:TYPE_VARCHAR, value: issue.ERROR_CODE };

        var rst = patchMetricDB -> update(PATCH_METRICS_INSERT_ISSUES, IdParam, fileIdParam, lineParam,
            descriptionParam, errorCodeParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printError("Error occured while inserting files issues with file id : " +
                        issue.FILE_STATS_FILE_INFO_ID, err = err);
            }
        }

    }

    return res;
}

documentation {clear file issues table. Remove all entries in issues table
        returns Int which represent clear process success or not.
}
public function clearFileIssues() returns int {

    log:printDebug("Removing files issues");

    var rst = patchMetricDB -> update(PATCH_METRICS_DELETE_ISSUES);

    int res;
    match rst {
        int status => {
            res = status;
        }
        error err => {
            log:printError("Error occured while Removing file issues", err = err);
        }
    }

    return res;
}

documentation {Retrieve last patch information entry id.
        returns Int which represent last patch information entry id.
}
public function getLastPatchInfoId() returns int {

    log:printDebug("Retrieving last patch info id");

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_LAST_PATCH_ID, model:PatchInfo);

    match dtReturned {
        table patchtable => {
            if (patchtable.hasNext()) {
                var rs = check <model:PatchInfo>patchtable.getNext();
                patchtable.close();
                return rs.ID;
            }
        }
        error err => {
            log:printError("Error occured while retrieving last patch info id", err = err);
        }
    }

    return 0;
}

documentation {Retrieve incompleted commits.
        returns Array of GithubCommitInfo object.
}
public function getIncompleteGithubCommitInfo() returns model:GithubCommitInfo[] {

    log:printDebug("Retrieving incompleted Github commit information");

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_INCOMPLETED_COMMITS, model:GithubCommitInfo);

    model:GithubCommitInfo[] githubCommitInfoList = [];
    match dtReturned {
        table commitTable => {
            while (commitTable.hasNext()) {
                var rs = check <model:GithubCommitInfo>commitTable.getNext();
                githubCommitInfoList[lengthof githubCommitInfoList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving incompleted Github commit information", err = err);
        }
    }

    return githubCommitInfoList;
}

documentation {Retrieve file information using file name and repository.
        P{{filename}} File name
        P{{repository}} Repository
        returns If found File information according to the given parameters, then return FileInfo object other wise return null.
}
public function getFileInfo(string filename, string repository) returns (model:FileInfo?) {

    log:printDebug("Retrieving file information by filename : " + filename + " & repository : " + repository);

    sql:Parameter fileNameParam = { sqlType: sql:TYPE_VARCHAR, value: filename };
    sql:Parameter repositoryParam = { sqlType: sql:TYPE_VARCHAR, value: repository };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_FILES_INFO, model:FileInfo, fileNameParam, repositoryParam);

    match dtReturned {
        table fileTable => {
            if (fileTable.hasNext()) {
                var rs = check <model:FileInfo>fileTable.getNext();
                fileTable.close();
                return rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving file information by filename : " +
                    filename + " & repository : " + repository, err = err);
        }
    }

    return;
}

documentation {Get product component id according to the given product name.
        P{{productName}} Product name
        returns Int which represent product component id.
}
public function getProductCompId(string productName) returns int {
    log:printDebug("Retrieving product component id by prodyct name : " + productName);

    sql:Parameter productNameParam = { sqlType: sql:TYPE_VARCHAR, value: productName };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_PRODUCT_COMPONENT_ID, model:ProductComponent, productNameParam);

    match dtReturned {
        table productTable => {
            if (productTable.hasNext()) {
                var rs = check <model:ProductComponent>productTable.getNext();
                productTable.close();
                return rs.ID;
            }
        }
        error err => {
            log:printError("Error occured while retrieving last patch info id by prodyct name : " + productName, err = err);
        }
    }

    return 0;
}

documentation {Retrieve commit information using given commit SHA id.
        P{{id}} Github commit id
        returns If found commit information according to the given id, then return GithubCommitInfo object otherwise return null
}
public function getCommitInfo(string id) returns (model:GithubCommitInfo?) {

    log:printDebug("Retrieving commit information by id : " + id);

    sql:Parameter idParam = { sqlType: sql:TYPE_VARCHAR, value: id };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_COMMIT_INFO, model:GithubCommitInfo, idParam);

    match dtReturned {
        table commitTable => {
            if (commitTable.hasNext()) {
                var rs = check <model:GithubCommitInfo>commitTable.getNext();
                commitTable.close();
                return rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving commit information by id : " + id, err = err);
        }
    }

    return;
}

documentation {Get last file entry id
        returns int which represent last file entry id.
}
public function getLastFileId() returns int {

    log:printDebug("Retrieving entered last file id");

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_LAST_FILE_ID, model:FileInfo);

    match dtReturned {
        table fileTable => {
            if (fileTable.hasNext()) {
                var rs = check <model:FileInfo>fileTable.getNext();
                fileTable.close();
                return rs.ID;
            }
        }
        error err => {
            log:printError("Error occured while retrieving entered last file id", err = err);
        }
    }

    return 0;
}

documentation {GET java classes information using file id and file last updated date before given date. Retrieve record limit is 100.
        P{{id}} File id
        P{{updatedDate}} Date which is used check last updated date
        returns Array of FileInfo object.
}
public function getJavaFileInfo(int id, string updatedDate) returns model:FileInfo[] {

    log:printDebug("Retrieving java class information by id : " + id);

    sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: id };
    sql:Parameter updatedDateParam = { sqlType: sql:TYPE_DATE, value: updatedDate };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_JAVA_FILE_INFO, model:FileInfo, idParam, updatedDateParam);

    model:FileInfo[] fileInfoList;
    match dtReturned {
        table fileTable => {
            while (fileTable.hasNext()) {
                var rs = check <model:FileInfo>fileTable.getNext();
                fileInfoList[lengthof fileInfoList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving java class information by id : " + id, err = err);
        }
    }

    return fileInfoList;
}

documentation {GET file inofrmation by file id
        P{{id}} File id
        returns FileInfo object.
}
public function getFileInfoById(int id) returns model:FileInfo|error {

    log:printDebug("Retrieving java class information by id : " + id);

    sql:Parameter idParam = { sqlType: sql:TYPE_VARCHAR, value: id };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_FILE_INFO, model:FileInfo, idParam);

    model:FileInfo fileInfo;
    match dtReturned {
        table fileTable => {
            if (fileTable.hasNext()) {
                var rs = check <model:FileInfo>fileTable.getNext();
                fileTable.close();
                fileInfo = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving entered last file id", err = err);
            return err;
        }
    }

    return fileInfo;
}

documentation {Retrieve all repositries with pagination according to the given time period
        P{{requestParams}} request query parameters
        returns Array of Repository object. If occur error then return Error.
}
public function getRepositories(model:RequestQueryParam requestParams) returns model:Repository[]|error {

    log:printDebug("Retrieving repositories with page no : " + requestParams.pageIndex);

    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_REPOSITORIES +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Repository, periodStartDateParam, periodEndDateParam,
        periodStartDateParam, periodEndDateParam);

    model:Repository[] repositoryList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Repository>dt.getNext();
                repositoryList[lengthof repositoryList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving repository list ", err = err);
            return err;
        }
    }

    return repositoryList;
}

documentation {Retrieve repositries with pagination according to the given product and time period
        P{{productName}} Product Name
        P{{requestParams}} request query parameters
        returns Array of Repository object. If occur error then return Error.
}
public function getRepositoriesbyProduct(string productName, model:RequestQueryParam requestParams) returns model:
            Repository[]|error {

    log:printDebug("Retrieving repositories by product with product name : " + productName + "  page no : " +
            requestParams.pageIndex);

    sql:Parameter productNameParam = { sqlType: sql:TYPE_VARCHAR, value: productName };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_REPOSITORIES_BY_PRODUCT +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Repository, productNameParam, periodStartDateParam,
        periodEndDateParam, productNameParam, periodStartDateParam, periodEndDateParam);

    model:Repository[] repositoryList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Repository>dt.getNext();
                repositoryList[lengthof repositoryList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving repository list by product", err = err);
            return err;
        }
    }

    return repositoryList;
}

documentation {Retrieve all products with pagination according to the given time period
        P{{requestParams}} request query parameters
        returns Array of Product object. If occur error then return Error.
}
public function getProducts(model:RequestQueryParam requestParams) returns model:Product[]|error {

    log:printDebug("Retrieving products with page no : " + requestParams.pageIndex);

    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_PRODUCTS +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.
            pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Product, periodStartDateParam, periodEndDateParam,
        periodStartDateParam, periodEndDateParam);

    model:Product[] productList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Product>dt.getNext();
                productList[lengthof productList] = rs;
            }
        }
        error err => {
            log:printError("Error ocuured while retrieving products", err = err);
            return err;
        }
    }

    return productList;
}

documentation {Retrieve all complete patches with pagination according to the given time period
        P{{requestParams}} request query parameters
        returns Array of Patch object. If occur error then return Error.
}
public function getPatches(model:RequestQueryParam requestParams) returns model:Patch[]|error {

    log:printDebug("Retrieving patches with page no : " + requestParams.pageIndex);

    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_PATCHES +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir,requestParams. pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch, periodStartDateParam, periodEndDateParam);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            return patchList;
        }
        error err => {
            log:printError("Error occured while retrieving patches list", err = err);
            return err;
        }
    }
}

documentation {Retrieve completed patches with pagination according to the given product and time period
        P{{productName}} Product Name
        P{{requestParams}} request query parameters
        returns Array of Patch object. If occur error then return Error.
}
public function getPatchesbyProduct(string productName, model:RequestQueryParam requestParams) returns model:Patch[]|error {

    log:printDebug("Retrieving patches by product with product : " + productName + " page no : " + requestParams.pageIndex);

    sql:Parameter productNameParam = { sqlType: sql:TYPE_VARCHAR, value: productName };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_PATCHES_BY_PRODUCT +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch, productNameParam, periodStartDateParam, periodEndDateParam);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            return patchList;
        }
        error err => {
            log:printError("Error occured while retrieving patches list by product", err = err);
            return err;
        }
    }
}

documentation {Retrieve completed patches with pagination according to the given repository and time period
        P{{repositoryName}} Repositroy Name
        P{{requestParams}} request query parameters
        returns Array of Patch object. If occur error then return Error.
}
public function getPatchesbyRepository(string repositoryName, model:RequestQueryParam requestParams) returns model:Patch[]|error {

    log:printDebug("Retrieving patches by repository with repository : " + repositoryName + " page no : " + requestParams.pageIndex);

    sql:Parameter repositoryNameParam = { sqlType: sql:TYPE_VARCHAR, value: repositoryName };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_PATCHES_BY_REPOSITORY +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch, repositoryNameParam, periodStartDateParam, periodEndDateParam);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            return patchList;
        }
        error err => {
            log:printError("Error occured while retrieving patches list by repository", err = err);
            return err;
        }
    }
}

documentation {Retrieve completed patche according to the given patch id
        P{{id}} Patch id
        returns Patch object. If occur error then return Error.
}
public function getPatchesbyId(int id) returns model:Patch|error {

    log:printDebug("Retrieving patch by id with id : " + id);

    sql:Parameter repositoryNameParam = { sqlType: sql:TYPE_VARCHAR, value: id };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_PATCH, model:Patch, repositoryNameParam);

    model:Patch patch;

    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patch = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving patch list by id", err = err);
            return err;
        }
    }
    return patch;
}

documentation {Retrieve file statistics with pagination according to the given repository and time period
        P{{repositoryName}} Repositroy Name
        P{{requestParams}} request query parameters
        returns Array of FileInfoWithStats object. If occur error then return Error.
}
public function getFileInfoWithStatsbyRepository(string repositoryName, model:RequestQueryParam requestParams) returns model:
            FileInfoWithStats[]|error {

    log:printDebug("Retrieving files information with statistics by reposiotry with repository : " + repositoryName +
            " page no : " + requestParams.pageIndex);

    sql:Parameter repositoryNameParam = { sqlType: sql:TYPE_VARCHAR, value: repositoryName };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_FILE_STATS_BY_REPOSITORY_INCLUDE_INTERNAL_PATCHES +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, repositoryNameParam, periodStartDateParam,
        periodEndDateParam);

    model:FileInfoWithStats[] fileList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                fileList[lengthof fileList] = rs;
            }
            return fileList;
        }
        error err => {
            log:printError("Error occured while retrieving files information with stattics by reposiotry", err = err);
            return err;
        }
    }
}

documentation {Retrieve file statistics with pagination according to the given patch and time period
        P{{id}} Patch id
        P{{requestParams}} request query parameters
        returns Array of FileInfoWithStats object. If occur error then return Error.
}
public function getFileInfoWithStatsbyPatch(int id, model:RequestQueryParam requestParams) returns model:FileInfoWithStats[]|error {

    log:printDebug("Retrieving files information with statistics by patch with patch id : " + id + " page no : " +
            requestParams.pageIndex);

    sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: id };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_FILE_STATS_BY_PATCH +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, idParam, periodStartDateParam,
        periodEndDateParam);

    model:FileInfoWithStats[] fileList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                fileList[lengthof fileList] = rs;
            }
            return fileList;
        }
        error err => {
            log:printError("Error occured while retrieving files information with statistics by patch", err = err);
            return err;
        }
    }
}

documentation {Retrieve most updated java classes information with statistics according to the time period
        P{{requestParams}} request query parameters
        returns Array of FileInfoWithStats object. If occur error then return Error.
}
public function getMostModifiedJavaClasses(model:RequestQueryParam requestParams) returns model:FileInfoWithStats[]|error {

    log:printDebug("Retrieving most modified java classes with statistics with page no : " + requestParams.pageIndex);

    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: requestParams.endDate };

    string dbQuery = PATCH_METRICS_GET_MOST_UPDATED_JAVA_CLASSES_INCLUDE_INTERNAL_PATCHES
        + generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, periodStartDateParam, periodEndDateParam,
        periodStartDateParam, periodEndDateParam);

    model:FileInfoWithStats[] fileInfoWithStatsList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                fileInfoWithStatsList[lengthof fileInfoWithStatsList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving most modified java classes with statistics", err = err);
            return err;
        }
    }

    return fileInfoWithStatsList;
}

documentation {Retrieve java class information with statistics according to file id and time period
        P{{id}} Java class's file id
        P{{startDate}} Time period start date
        P{{endDate}} Time period end date
        returns FileInfoWithStats object. If occur error then return Error.
}
public function getJavaClassWithDateRange(int id, string startDate, string endDate)
                    returns model:FileInfoWithStats|error {

    log:printDebug("Retrieving java class with file id : " + id + " & time period");

    sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: id };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: endDate };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_JAVA_CLASS_WITH_TIME_PERIOD_INCLUDE_INTERNAL_PATCHES,
        model:FileInfoWithStats, idParam,
        periodStartDateParam, periodEndDateParam);

    model:FileInfoWithStats javaClass;
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                javaClass = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving java class with statistics using id and time period", err =
                err);
            return err;
        }
    }

    return javaClass;
}

documentation {Retrieve java class information with statistics according to file id and time period
        P{{id}} Java class's file id
        P{{startDate}} Time period start date
        P{{endDate}} Time period end date
        returns FileInfoWithStats object. If occur error then return Error.
}
public function getJavaClass(int id, string startDate, string endDate) returns model:FileInfoWithStats|error {

    log:printDebug("Retrieving java class with file id : " + id);

    sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: id };
    sql:Parameter periodStartDateParam = { sqlType: sql:TYPE_DATE, value: startDate };
    sql:Parameter periodEndDateParam = { sqlType: sql:TYPE_DATE, value: endDate };

    var dtReturned = patchMetricDB -> select(PATCH_METRICS_GET_JAVA_CLASS, model:FileInfoWithStats, idParam,
        periodStartDateParam, periodEndDateParam);

    model:FileInfoWithStats javaClass;
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                javaClass = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving java class with statistics using id", err = err);
            return err;
        }
    }

    return javaClass;
}

documentation {Retrieve file issues. These issues are givrn by findbugs.
        P{{fileId}} Java class file id
        P{{requestParams}} request query parameters
        returns Array of Issue object. If occur error then return Error.
}
public function getJavaClassIssuesFromDB(int fileId, model:RequestQueryParam requestParams)
                    returns model:Issue[]|error {

    log:printDebug("Retrieving issues in java class with file id : " + fileId);

    sql:Parameter idParam = { sqlType: sql:TYPE_INTEGER, value: fileId };

    string dbQuery = PATCH_METRICS_GET_FILE_ISSUES +
        generatePaginationQuery(requestParams.sortColumn, requestParams.sortDir, requestParams.pageIndex, requestParams.pageSize);

    var dtReturned = patchMetricDB -> select(dbQuery, model:Issue, idParam);

    model:Issue[] issueList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Issue>dt.getNext();
                issueList[lengthof issueList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving issues in java class", err = err);
            return err;
        }
    }

    return issueList;
}


function generatePaginationQuery(string sortColumn, int sortDir, int pageIndex, int pageSize) returns string {
    return
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " +
        ((pageIndex - 1) * pageSize);
}
