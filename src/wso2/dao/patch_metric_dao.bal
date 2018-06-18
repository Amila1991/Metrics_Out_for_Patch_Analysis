package wso2.dao;

import ballerina/sql;
import ballerina/mysql;
import ballerina/io;
import ballerina/config;
import ballerina/log;
import wso2/model;

endpoint mysql:Client patchMetricDB {
    host:"localhost",
    port:3306,
    name:"patch_metrics_db2",
    username:"root",
    password:"password123",
    poolOptions:{maximumPoolSize:5},
    dbOptions:{useSSL:false}
};


@final string[] exculdeFiles = config:getAsString("exclude.files").split(",");

// Insert list of patch information enteries in to database.
public function insertPatchInfo(model:PatchInfo[] patchInfoList) returns int[] {

    log:printDebug("Inserting patch info entry list");

    int[] res = [];
    foreach i, patchInfo in patchInfoList {
        log:printTrace("Inserting patch info entry with patch info id : " + patchInfo.ID);

        sql:Parameter idParam = (sql:TYPE_INTEGER, patchInfo.ID);
        sql:Parameter patchNameParam = (sql:TYPE_VARCHAR, patchInfo.PATCH_NAME);
        sql:Parameter clientParam = (sql:TYPE_VARCHAR, patchInfo.CLIENT);
        sql:Parameter supportJIRAParam = (sql:TYPE_VARCHAR, patchInfo.SUPPORT_JIRA);
        sql:Parameter reportDateParam = (sql:TYPE_DATE, patchInfo.REPORT_DATE);
        sql:Parameter productComIdParam = (sql:TYPE_INTEGER, patchInfo.PRODUCT_COMPONENT_ID);
        var rst = patchMetricDB -> update(
                                       "INSERT INTO PATCH_INFO (ID,PATCH_NAME,CLIENT,SUPPORT_JIRA,REPORT_DATE,PRODUCT_COMPONENT_ID) VALUES (?,?,?,?,?,?)",
                                       idParam, patchNameParam, clientParam, supportJIRAParam, reportDateParam, productComIdParam);
        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printErrorCause("Error occured while inserting patch info entry with patch info id : " + patchInfo.ID, err);
            }
        }
    }

    return res;
}

public function insertGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList) returns int[] {

    log:printDebug("Inserting github commit info entry list");

    int[] res = [];
    foreach i, githubCommitInfo in githubCommitInfoList {
        log:printTrace("Inserting github commit info entry with github id : " + githubCommitInfo.GITHUB_SHA_ID);

        sql:Parameter githubSHAIdParam = (sql:TYPE_VARCHAR, githubCommitInfo.GITHUB_SHA_ID);
        sql:Parameter githubSHAIdRepoTypeParam = (sql:TYPE_VARCHAR, githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE);
        sql:Parameter totalChangesParam = (sql:TYPE_INTEGER, githubCommitInfo.TOTAL_CHANGES);
        sql:Parameter additionsParam = (sql:TYPE_INTEGER, githubCommitInfo.ADDITIONS);
        sql:Parameter deletionsParam = (sql:TYPE_INTEGER, githubCommitInfo.DELETIONS);
        sql:Parameter isUpdatedParam = (sql:TYPE_TINYINT, <int>githubCommitInfo.IS_UPDATED);
        var rst = patchMetricDB ->
        update("INSERT INTO GITHUB_COMMIT_INFO (GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED) VALUES (?,?,?,?,?,?)",
            githubSHAIdParam, githubSHAIdRepoTypeParam, totalChangesParam, additionsParam, deletionsParam, isUpdatedParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printErrorCause("Error occured while inserting github commit info entry with github id : " + githubCommitInfo.GITHUB_SHA_ID, err);
            }
        }

    }

    return res;
}

public function insertPatchCommitInfo(model:PatchCommitInfo[] patchCommitInfoList) returns int[] {
    int[] res = [];

    foreach i, patchCommitInfo in patchCommitInfoList {
        sql:Parameter githubSHAIdParam = (sql:TYPE_VARCHAR, patchCommitInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID);
        sql:Parameter patchIdParam = (sql:TYPE_INTEGER, patchCommitInfo.PATCH_INFO_ID);
        var rst = patchMetricDB -> update("INSERT INTO PATCH_RELATED_COMMITS (GITHUB_COMMIT_INFO_GITHUB_SHA_ID,PATCH_INFO_ID) VALUES (?,?)",
            githubSHAIdParam, patchIdParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                io:println("Patch Commit info insertion failed:" + err.message);
            }
        }

    }

    return res;
}


public function insertGithubCommitFileInfo(model:CommitFileInfo[] commitFileInfoList) returns int[] {
    int[] res = [];

    foreach i, commitFileInfo in commitFileInfoList {
        sql:Parameter githubCommitSHAIdParam = (sql:TYPE_VARCHAR, commitFileInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID);
        sql:Parameter fileSHAIdParam = (sql:TYPE_INTEGER, commitFileInfo.FILE_INFO_ID);
        sql:Parameter totalChangesParam = (sql:TYPE_INTEGER, commitFileInfo.TOTAL_CHANGES);
        sql:Parameter additionsParam = (sql:TYPE_INTEGER, commitFileInfo.ADDITIONS);
        sql:Parameter deletionsParam = (sql:TYPE_INTEGER, commitFileInfo.DELETIONS);
        var rst = patchMetricDB ->
        update("INSERT INTO FILE_CHANGES (GITHUB_COMMIT_INFO_GITHUB_SHA_ID,FILE_INFO_ID,TOTAL_CHANGES,ADDITIONS,DELETIONS) VALUES (?,?,?,?,?)",
            githubCommitSHAIdParam, fileSHAIdParam, totalChangesParam, additionsParam, deletionsParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                io:println("Committed File insertion failed:" + err.message);
            }
        }
    }

    return res;
}


public function updateGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList) returns int[] {
    int[] res = [];

    foreach i, githubCommitInfo in githubCommitInfoList {
        sql:Parameter totalChangesParam = (sql:TYPE_INTEGER, githubCommitInfo.TOTAL_CHANGES);
        sql:Parameter additionsParam = (sql:TYPE_INTEGER, githubCommitInfo.ADDITIONS);
        sql:Parameter deletionsParam = (sql:TYPE_INTEGER, githubCommitInfo.DELETIONS);
        sql:Parameter isUpdatedParam = (sql:TYPE_TINYINT, <int>githubCommitInfo.IS_UPDATED);
        sql:Parameter githubSHAIdParam = (sql:TYPE_VARCHAR, githubCommitInfo.GITHUB_SHA_ID);
        var rst = patchMetricDB ->
        update("UPDATE GITHUB_COMMIT_INFO SET TOTAL_CHANGES = ?, ADDITIONS = ?, DELETIONS= ?, IS_UPDATED = ? WHERE GITHUB_SHA_ID = ?",
            totalChangesParam, additionsParam, deletionsParam, isUpdatedParam, githubSHAIdParam);
        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                io:println("Commit info modification failed:" + err.message);
            }
        }

    }

    return res;
}


public function insertFileInfo(model:FileInfo[] fileInfoList) returns int[] {
    int[] res = [];

    foreach i, file in fileInfoList {
        sql:Parameter fileIdParam = (sql:TYPE_INTEGER, file.ID);
        sql:Parameter fileNameParam = (sql:TYPE_VARCHAR, file.FILE_NAME);
        sql:Parameter repositoryParam = (sql:TYPE_VARCHAR, file.REPOSITORY_NAME);
        var rst = patchMetricDB ->
        update("INSERT INTO FILE_INFO (ID,FILE_NAME,REPOSITORY_NAME) VALUES (?,?,?)", fileIdParam, fileNameParam, repositoryParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                io:println("File info insertion failed:" + err.message);
            }
        }
    }

    return res;
}


//public function insertTopUpdatedFiles(model:TopUpdatedFile[] topUpdatedFileList) returns int[] {
//
//    log:printDebug("Inserting most updated files");
//
//    io:print("list : ");
//    io:println(topUpdatedFileList);
//    int[] res = [];
//    foreach i, topUpdatedFile in topUpdatedFileList {
//        log:printTrace("Inserting most updated file with file id : " + topUpdatedFile.FILE_INFO_ID);
//
//        sql:Parameter fileIdParam = (sql:TYPE_VARCHAR, topUpdatedFile.FILE_INFO_ID);
//        sql:Parameter fromDateParam = (sql:TYPE_DATE, topUpdatedFile.FROM_DATE);
//        sql:Parameter toDateParam = (sql:TYPE_DATE, topUpdatedFile.TO_DATE);
//        sql:Parameter coveredLinesParam = (sql:TYPE_INTEGER, topUpdatedFile.TEST_COVERED_LINES);
//        sql:Parameter missedLinesParam = (sql:TYPE_INTEGER, topUpdatedFile.TEST_MISSED_LINES);
//        sql:Parameter noofPatchesParam = (sql:TYPE_INTEGER, topUpdatedFile.NO_OF_PATCHES);
//        var rst = patchMetricDB ->
//        update("INSERT INTO TOP_UPDATED_FILES (FILE_INFO_ID,FROM_DATE,TO_DATE,TEST_COVERED_LINES,TEST_MISSED_LINES,NO_OF_PATCHES) VALUES (?,?,?,?,?,?)",
//            fileIdParam, fromDateParam, toDateParam, coveredLinesParam, missedLinesParam, noofPatchesParam);
//
//        match rst {
//            int status => {
//                res[i] = status;
//            }
//            error err => {
//                log:printErrorCause("Error occured while inserting most updated files with file id : " + topUpdatedFile.FILE_INFO_ID, err);
//            }
//        }
//    }
//
//    return res;
//}

public function insertFileStats(model:FileStats[] fileStatsList) returns int[] {

    log:printDebug("Inserting file statistics");

    io:print("list : ");
    io:println(fileStatsList);
    int[] res = [];
    foreach i, fileStats in fileStatsList {
        log:printTrace("Inserting file statistics with file id : " + fileStats.FILE_INFO_ID);

        sql:Parameter fileIdParam = (sql:TYPE_INTEGER, fileStats.FILE_INFO_ID);
        sql:Parameter updatedDateParam = (sql:TYPE_DATE, fileStats.UPDATED_DATE);
        sql:Parameter coveredLinesParam = (sql:TYPE_INTEGER, fileStats.TEST_COVERED_LINES);
        sql:Parameter missedLinesParam = (sql:TYPE_INTEGER, fileStats.TEST_MISSED_LINES);

        var rst = patchMetricDB ->
        update("INSERT INTO FILE_STATS (FILE_INFO_ID,UPDATED_DATE,TEST_COVERED_LINES,TEST_MISSED_LINES) VALUES (?,?,?,?) ON " +
                "DUPLICATE KEY UPDATE UPDATED_DATE=VALUES(UPDATED_DATE), TEST_COVERED_LINES=VALUES(TEST_COVERED_LINES), TEST_MISSED_LINES=VALUES(TEST_MISSED_LINES)",
            fileIdParam, updatedDateParam, coveredLinesParam, missedLinesParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printErrorCause("Error occured while inserting  file statistics with file id : " + fileStats.FILE_INFO_ID, err);
            }
        }
    }

    return res;
}

//public function insertFileIssues(model:Issue[] issueList) returns int[] {
//
//
//    log:printDebug("Inserting files issues");
//
//    int[] res = [];
//    foreach i, issue in issueList {
//        log:printTrace("Inserting files issue with file id : " + issue.TOP_UPDATED_FILES_FILE_INFO_ID);
//
//        sql:Parameter IdParam = (sql:TYPE_INTEGER, issue.ID);
//        sql:Parameter fileIdParam = (sql:TYPE_INTEGER, issue.TOP_UPDATED_FILES_FILE_INFO_ID);
//        sql:Parameter lineParam = (sql:TYPE_VARCHAR, issue.LINE);
//        sql:Parameter descriptionParam = (sql:TYPE_VARCHAR, issue.DESCRIPTION);
//        sql:Parameter errorCodeParam = (sql:TYPE_VARCHAR, issue.ERROR_CODE);
//        var rst = patchMetricDB ->
//        update("INSERT INTO FILE_BUGS (ID, FILE_STATS_FILE_INFO_ID,LINE,DESCRIPTION,ERROR_CODE) VALUES (?,?,?,?,?)",
//            IdParam, fileIdParam, lineParam, descriptionParam, errorCodeParam);
//
//        match rst {
//            int status => {
//                res[i] = status;
//            }
//            error err => {
//                log:printErrorCause("Error occured while inserting files issues with file id : " + issue.TOP_UPDATED_FILES_FILE_INFO_ID, err);
//            }
//        }
//
//    }
//
//    return res;
//}


public function insertFileIssues(model:Issue[] issueList) returns int[] {


    log:printDebug("Inserting files issues");

    int[] res = [];
    foreach i, issue in issueList {
        log:printTrace("Inserting files issue with file id : " + issue.FILE_STATS_FILE_INFO_ID);

        sql:Parameter IdParam = (sql:TYPE_INTEGER, issue.ID);
        sql:Parameter fileIdParam = (sql:TYPE_INTEGER, issue.FILE_STATS_FILE_INFO_ID);
        sql:Parameter lineParam = (sql:TYPE_VARCHAR, issue.LINE);
        sql:Parameter descriptionParam = (sql:TYPE_VARCHAR, issue.DESCRIPTION);
        sql:Parameter errorCodeParam = (sql:TYPE_VARCHAR, issue.ERROR_CODE);
        var rst = patchMetricDB ->
        update("INSERT INTO ISSUE (ID, FILE_STATS_FILE_INFO_ID,LINE,DESCRIPTION,ERROR_CODE) VALUES (?,?,?,?,?)",
            IdParam, fileIdParam, lineParam, descriptionParam, errorCodeParam);

        match rst {
            int status => {
                res[i] = status;
            }
            error err => {
                log:printErrorCause("Error occured while inserting files issues with file id : " + issue.FILE_STATS_FILE_INFO_ID, err);
            }
        }

    }

    return res;
}


public function clearTopUpdatedFiles() returns int {
    int res;

    var rst = patchMetricDB -> update("DELETE FROM TOP_UPDATED_FILES");
    match rst {
        int status => {
            res = status;
        }
        error err => {
            io:println("Commit info modification failed:" + err.message);
        }
    }

    io:println("clear top updated files");

    return res;
}

//
//public function clearFileIssues() returns int {
//    int res;
//
//    var rst = patchMetricDB ->
//    update("DELETE FROM FILE_BUGS");
//    match rst {
//        int status => {
//            res = status;
//        }
//        error err => {
//            io:println("Commit info modification failed:" + err.message);
//        }
//    }
//
//    io:println("clear issues");
//
//    return res;
//}


public function clearFileIssues() returns int {
    int res;

    var rst = patchMetricDB ->
    update("DELETE FROM ISSUE");
    match rst {
        int status => {
            res = status;
        }
        error err => {
            io:println("Commit info modification failed:" + err.message);
        }
    }

    io:println("clear issues");

    return res;
}





public function getLastPatchInfoId() returns int {

    log:printDebug("Retrieve last patch info id");

    var dtReturned = patchMetricDB -> select("SELECT ID FROM PATCH_INFO ORDER BY ID DESC LIMIT 1", model:PatchInfo);

    //    table patchtable = check dtReturned;

    match dtReturned {
        table patchtable => {
            if (patchtable.hasNext()) {
                var rs = check <model:PatchInfo>patchtable.getNext();
                io:println(rs.ID);
                patchtable.close();
                return rs.ID;
            }
        }
        error err => {
            log:printErrorCause("Error occured while retrieving last patch info id", err);
        }
    }


    return 0;
}


public function getIncompleteGithubCommitInfo() returns model:GithubCommitInfo[] {
    var dtReturned = patchMetricDB ->
    select("SELECT GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED FROM GITHUB_COMMIT_INFO WHERE IS_UPDATED = 0 ORDER BY GITHUB_SHA_ID LIMIT 30",
        model:GithubCommitInfo);
    table dt = check dtReturned;

    model:GithubCommitInfo[] githubCommitInfoList = [];

    while (dt.hasNext()) {
        var rs = check <model:GithubCommitInfo>dt.getNext();
        githubCommitInfoList[lengthof githubCommitInfoList] = rs;
    }

    return githubCommitInfoList;
}


public function getFileInfo(string filename, string repository) returns (model:FileInfo?) {
    sql:Parameter fileNameParam = (sql:TYPE_VARCHAR, filename);
    sql:Parameter repositoryParam = (sql:TYPE_VARCHAR, repository);

    var dtReturned = patchMetricDB -> select("SELECT * FROM FILE_INFO WHERE FILE_NAME = ? AND REPOSITORY_NAME = ?", model:FileInfo, fileNameParam, repositoryParam);
    table dt = check dtReturned;

    if (dt.hasNext()) {
        var rs = check <model:FileInfo>dt.getNext();
        dt.close();
        return rs;
    }

    return;
}



public function getProductCompId(string productName) returns int {

    log:printDebug("Retrieve product component id");
    io:println("product Nmae : " + productName);

    sql:Parameter productNameParam = (sql:TYPE_VARCHAR, productName);

    var dtReturned = patchMetricDB -> select("SELECT ID FROM PRODUCT_COMPONENT WHERE COMPONENT_NAME = ?", model:ProductComponent, productNameParam);

    //    table patchtable = check dtReturned;

    match dtReturned {
        table patchtable => {
            if (patchtable.hasNext()) {
                var rs = check <model:ProductComponent>patchtable.getNext();
                io:print("product id " + productName + " ");
                io:println(rs.ID);
                patchtable.close();
                return rs.ID;
            }
        }
        error err => {
            io:println(err);
            log:printErrorCause("Error occured while retrieving last patch info id", err);
        }
    }


    return 0;
}

public function getCommitInfo(string id) returns (model:GithubCommitInfo?) {

    io:println(id);
    sql:Parameter idParam = (sql:TYPE_VARCHAR, id);

    var dtReturned = patchMetricDB -> select("SELECT * FROM GITHUB_COMMIT_INFO WHERE GITHUB_SHA_ID = ?", model:GithubCommitInfo, idParam);
    table dt = check dtReturned;

    if (dt.hasNext()) {
        var rs = check <model:GithubCommitInfo>dt.getNext();
        dt.close();
        return rs;
    }

    return;
}


public function getLastFileId() returns int {

    var dtReturned = patchMetricDB -> select("SELECT ID FROM FILE_INFO ORDER BY ID DESC LIMIT 1", model:FileInfo);

    table dt = check dtReturned;

    if (dt.hasNext()) {
        var rs = check <model:FileInfo>dt.getNext();
        dt.close();
        return rs.ID;
    }

    return 0;
}


public function getJAVAFileInfo(int id, string updatedDate) returns model:FileInfo[] {

    sql:Parameter idParam = (sql:TYPE_INTEGER, id);
    sql:Parameter updatedDateParam = (sql:TYPE_DATE, updatedDate);
    string dbQuery = "SELECT fi.* FROM FILE_INFO fi LEFT JOIN FILE_STATS fs ON fi.ID = fs.FILE_INFO_ID WHERE fi.ID > ? AND FILE_NAME LIKE '%.java' AND (fs.UPDATED_DATE IS NULL OR fs.UPDATED_DATE < ?) ORDER BY fi.ID LIMIT 100";

    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfo, idParam, updatedDateParam);

    table dt = check dtReturned;

    model:FileInfo[] fileInfoList;
    while (dt.hasNext()) {
        var rs = check <model:FileInfo>dt.getNext();
        fileInfoList[lengthof fileInfoList] = rs;
    }

    return fileInfoList;
}


public function getFileInfoById(int id) returns model:FileInfo {

    sql:Parameter idParam = (sql:TYPE_VARCHAR, id);
    var dtReturned = patchMetricDB -> select("SELECT * FROM FILE_INFO WHERE ID = ?", model:FileInfo, idParam);

    table dt = check dtReturned;

    model:FileInfo fileInfo;
    if (dt.hasNext()) {
        var rs = check <model:FileInfo>dt.getNext();
        io:println("Last File ID : " + rs.ID);
        dt.close();
        fileInfo = rs;
    }

    return fileInfo;
}


public function getHighestNoOfPatchesModifiedFile(int morethan) returns model:FileModification[] {

    string? dislikePharse;
    foreach file in exculdeFiles {
        match dislikePharse {
            string pharse => {
                dislikePharse = pharse + " OR '%" + file + "'";
            }
            () => {
                dislikePharse = "subquery.FILE_NAME NOT LIKE '%" + file + "'";
            }
        }
    }

    if (morethan > 0) {
        match dislikePharse {
            string pharse => {
                if (pharse.contains(" OR ")){
                    pharse = "(" + pharse + ")";
                }
                dislikePharse = pharse + " AND subquery.NO_OF_PATCHES >= " + morethan;
            }
            () => {
                dislikePharse = "subquery.NO_OF_PATCHES >= " + morethan;
            }
        }
    }

    string dbQuery;
    match dislikePharse {
        string pharse => {
            dbQuery = "SELECT subquery.*, SUM(pf.TOTAL_CHANGES) AS CHURNS FROM " +
                "(SELECT fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "GROUP BY fi.ID ORDER BY No_of_Patches DESC) subquery " +
                "JOIN FILE_INFO f ON subquery.ID=f.ID " +
                "JOIN FILE_CHANGES pf ON f.ID = pf.FILE_INFO_ID WHERE " + pharse + " GROUP BY f.ID ORDER BY subquery.NO_OF_PATCHES DESC";
        }
        () => {
            dbQuery = "SELECT subquery.*, SUM(pf.TOTAL_CHANGES) AS CHURNS FROM " +
                "(SELECT fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "GROUP BY fi.ID ORDER BY No_of_Patches DESC) subquery " +
                "JOIN FILE_INFO f ON subquery.ID=f.ID " +
                "JOIN FILE_CHANGES pf ON f.ID = pf.FILE_INFO_ID GROUP BY f.ID ORDER BY subquery.NO_OF_PATCHES DESC";

        }
    }
    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileModification);

    table dt = check dtReturned;
    model:FileModification[] fileModificationList = [];

    while (dt.hasNext()) {
        var rs = check <model:FileModification>dt.getNext();
        //json ss = check <json> dt.getNext();
        //io:println(ss);
        fileModificationList[lengthof fileModificationList] = rs;
        //io:println(rs);
        //  dt.close();
        //return rs.ID;
    }

    // return 0;
    return fileModificationList;
}




public function getHighestLOCChangesFile(int morethan) returns model:FileModification[] {

    string? dislikePharse;
    foreach file in exculdeFiles {
        match dislikePharse {
            string pharse => {
                dislikePharse = pharse + " OR '%" + file + "'";
            }
            () => {
                dislikePharse = "subquery.FILE_NAME NOT LIKE '%" + file + "'";
            }
        }
    }

    string havingPharse = "";
    if (morethan > 0) {
        havingPharse = " HAVING CHURNS >= " + morethan;
    }

    string dbQuery;
    match dislikePharse {
        string pharse => {
            dbQuery = "SELECT subquery.*, SUM(pf.TOTAL_CHANGES) AS CHURNS FROM " +
                "(SELECT fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "GROUP BY fi.ID ORDER BY No_of_Patches DESC) subquery " +
                "JOIN FILE_INFO f ON subquery.ID=f.ID " +
                "JOIN FILE_CHANGES pf ON f.ID = pf.FILE_INFO_ID WHERE " + pharse + " GROUP BY f.ID" + havingPharse + " ORDER BY CHURNS DESC";
        }
        () => {
            dbQuery = "SELECT subquery.*, SUM(pf.TOTAL_CHANGES) AS CHURNS FROM " +
                "(SELECT fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "GROUP BY fi.ID ORDER BY No_of_Patches DESC) subquery " +
                "JOIN FILE_INFO f ON subquery.ID=f.ID " +
                "JOIN FILE_CHANGES pf ON f.ID = pf.FILE_INFO_ID GROUP BY f.ID" + havingPharse + " ORDER BY CHURNS DESC";

        }
    }
    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileModification);

    table dt = check dtReturned;
    model:FileModification[] fileModificationList = [];

    while (dt.hasNext()) {
        var rs = check <model:FileModification>dt.getNext();
        fileModificationList[lengthof fileModificationList] = rs;
        //io:println(rs);
    }

    return fileModificationList;
}


public function getRepositories(string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Repository[] {

    log:printDebug("Retrieving repositories with paging no : " + pageIndex);

    string dbQuery = "SELECT fi.REPOSITORY_NAME,COUNT(pi.ID) as No_of_Patches, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
        "GROUP BY fi.REPOSITORY_NAME ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);
    //
    //string dbQuery = "SELECT fi.REPOSITORY_NAME,COUNT(pi.ID) as No_of_Patches, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
    //    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    //    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    //    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    //    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    //    "GROUP BY fi.REPOSITORY_NAME ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Repository);

    model:Repository[] repositoryList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Repository>dt.getNext();
                repositoryList[lengthof repositoryList] = rs;
                //io:println(rs);
            }
        }
        error err => {

        }
    }


    //table dt = check dtReturned;

    return repositoryList;
}


public function getRepositoriesbyProduct(string productName, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Repository[] {

    log:printDebug("Retrieving repositories by Product with product name : " + productName + "  paging no : " + pageIndex);

    sql:Parameter productNameParam = (sql:TYPE_VARCHAR, productName);

    string dbQuery = "SELECT fi.REPOSITORY_NAME,COUNT(pi.ID) as No_of_Patches, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
        "WHERE p.PRODUCT_NAME = ? " +
        "GROUP BY fi.REPOSITORY_NAME ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Repository, productNameParam);

    model:Repository[] repositoryList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Repository>dt.getNext();
                repositoryList[lengthof repositoryList] = rs;
            }
        }
        error err => {

        }
    }


    //table dt = check dtReturned;

    return repositoryList;
}


public function getProducts(string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Product[] {

    log:printDebug("Retrieving repositories with paging no : " + pageIndex);

    string dbQuery = "SELECT getChurnQuery.PRODUCT_NAME, getChurnQuery.CHURNS, getPatchesCountQuery.No_of_Patches FROM " +
        "(SELECT p.PRODUCT_NAME, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
        "GROUP BY p.PRODUCT_NAME) getChurnQuery " +
        "JOIN (SELECT p.PRODUCT_NAME, COUNT(pi.ID) as No_of_Patches FROM PATCH_INFO pi " +
        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
        "GROUP BY p.PRODUCT_NAME) getPatchesCountQuery ON getChurnQuery.PRODUCT_NAME = getPatchesCountQuery.PRODUCT_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Product);

    model:Product[] productList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Product>dt.getNext();
                productList[lengthof productList] = rs;
            }
        }
        error err => {

        }
    }

    return productList;
}


public function getPatches(string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Patch[]|error {

    log:printDebug("Retrieving patches with paging no : " + pageIndex);

    string dbQuery = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
        "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
        "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
        "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            io:println(patchList);
            return patchList;
        }
        error err => {
            io:println(err);
            log:printErrorCause("Error occured while retrieving  patches list ", err);
            return err;
        }
    }
}


public function getPatchesbyProduct(string productName, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Patch[]|error {

    log:printDebug("Retrieving patches by product with product : " + productName + " paging no : " + pageIndex);

    sql:Parameter productNameParam = (sql:TYPE_VARCHAR, productName);

    string dbQuery = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
        "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
        "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
        "WHERE p.PRODUCT_NAME = ? " +
        "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch, productNameParam);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            io:println(patchList);
            return patchList;
        }
        error err => {
            io:println(err);
            log:printErrorCause("Error occured while retrieving  patches list by product ", err);
            return err;
        }
    }
}

public function getPatchesbyRepository(string repositoryName, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Patch[]|error {

    log:printDebug("Retrieving patches by repository with repository : " + repositoryName + " paging no : " + pageIndex);

    sql:Parameter repositoryNameParam = (sql:TYPE_VARCHAR, repositoryName);

    string dbQuery = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
        "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
        "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
        "WHERE fi.REPOSITORY_NAME = ? " +
        "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Patch, repositoryNameParam);

    model:Patch[] patchList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Patch>dt.getNext();
                patchList[lengthof patchList] = rs;
            }
            io:println(patchList);
            return patchList;
        }
        error err => {
            io:println(err);
            log:printErrorCause("Error occured while retrieving  patches list by repository ", err);
            return err;
        }
    }
}


public function getFileInfoWithStatsbyRepository(string repositoryName, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:FileInfoWithStats[]|error {

    log:printDebug("Retrieving files information with stattics by reposiotry with repository : " + repositoryName + " paging no : " + pageIndex);

    sql:Parameter repositoryNameParam = (sql:TYPE_VARCHAR, repositoryName);

    string dbQuery = " SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, IF(fi.FILE_NAME LIKE '%.java', " +
        "IF(fs.UPDATED_DATE IS NULL, 'Not Updated', fs.UPDATED_DATE), 'N/A') AS UPDATED_DATE, " +
        "IF(fs.TEST_COVERED_LINES IS NULL OR fs.TEST_MISSED_LINES IS NULL, -1, " +
        "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, " +
        "ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%')) AS TEST_COVERAGE FROM PRODUCT p " +
        "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
        "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
        "LEFT JOIN FILE_STATS fs ON fi.ID = fs.FILE_INFO_ID " +
        "WHERE fi.REPOSITORY_NAME = ? " +
        "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
        "JOIN ISSUE i ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
        "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, repositoryNameParam);

    model:FileInfoWithStats[] fileList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                fileList[lengthof fileList] = rs;
            }
            io:println(fileList);
            return fileList;
        }
        error err => {
            io:println(err);
            log:printErrorCause("Error occured while retrieving files information with stattics by reposiotry ", err);
            return err;
        }
    }
}




public function getTopUpdatedFileTypesByProducts(string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Product[] {

    log:printDebug("Retrieving repositories with paging no : ");

    string dbQuery = "SELECT PRODUCT_NAME, COUNT(ID) FROM PATCH_INFO GROUP BY PRODUCT_NAME";

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:Product);

    model:Product[] productList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:Product>dt.getNext();
                productList[lengthof productList] = rs;
                //io:println(rs);
            }
        }
        error err => {

        }
    }

    return productList;
}

public function getDefaultPatchChanges(int minOrMaxChurns, boolean minChurns) returns model:PatchChanges[] {
    return getPatchChanges([], [], minOrMaxChurns, minChurns);
}

public function getPatchJavaCodeChangesExceptTestCases(int maxChurns) returns model:PatchChanges[] {
    return getPatchChanges([".java"], ["/test/"], maxChurns, false);
}

public function getPatchUIChanges(int maxChurns) returns model:PatchChanges[] {
    return getPatchChanges([".js", ".html", ".htm", ".css", ".jsp", ".jag", ".svg", ".png"], [], maxChurns, false);
}

//
function getPatchChanges(string[] likeValues, string[] dislikeValues, int minOrMaxChurns, boolean minChurns) returns model:PatchChanges[] {

    string? likePharse;
    foreach value in likeValues {
        match likePharse {
            string pharse => {
                likePharse = pharse + " OR '%" + value + "%'";
            }
            () => {
                likePharse = "fi.FILE_NAME LIKE '%" + value + "%'";
            }
        }
    }

    string? disLikePharse;
    foreach value in dislikeValues {
        match disLikePharse {
            string pharse => {
                disLikePharse = pharse + " OR '%" + value + "%'";
            }
            () => {
                disLikePharse = "fi.FILE_NAME NOT LIKE '%" + value + "%'";
            }
        }
    }

    string? wherePharse;
    match likePharse {
        string like => {
            match disLikePharse {
                string dislike => {
                    if (like.contains(" OR ")){
                        like = "(" + like + ")";
                    }
                    if (dislike.contains(" OR ")){
                        dislike = "(" + dislike + ")";
                    }
                    wherePharse = like + " AND " + dislike;
                }
                () => {
                    wherePharse = like;
                }
            }
        }
        () => {
            match disLikePharse {
                string dislike => {
                    wherePharse = dislike;
                }
                () => {
                }
            }
        }
    }


    string havingPharse = "";
    if (minOrMaxChurns > 0) {
        havingPharse = " HAVING CHURNS " + (minChurns ? "<= " : ">= ") + minOrMaxChurns;
    }

    string dbQuery;
    match wherePharse {
        string pharse => {
            dbQuery = "SELECT pi.ID, pi.PATCH_NAME, pi.CLIENT, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "WHERE " + pharse +
                " GROUP BY pi.ID" + havingPharse + " ORDER BY CHURNS DESC";
        }
        () => {
            dbQuery = "SELECT pi.ID, pi.PATCH_NAME, pi.CLIENT, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
                "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
                "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
                "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
                "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
                "GROUP BY pi.ID" + havingPharse + " ORDER BY CHURNS DESC";

        }
    }
    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:PatchChanges);

    table dt = check dtReturned;
    model:PatchChanges[] patchChangesList = [];

    while (dt.hasNext()) {
        var rs = check <model:PatchChanges>dt.getNext();
        //json ss = check <json> dt.getNext();
        //io:println(ss);
        patchChangesList[lengthof patchChangesList] = rs;
        //io:println(rs);
        //  dt.close();
        //return rs.ID;
    }

    // return 0;
    return patchChangesList;

}


//public function highestNoPatchesModifiedFiles(string startDate, string endDate) returns model:FileWithNoofPatches[] {
//
//    log:printDebug("Retrieving patchs from Patch ETA");
//
//    sql:Parameter periodStartDateParam = (sql:TYPE_DATE, startDate);
//    sql:Parameter periodEndDateParam = (sql:TYPE_DATE, endDate);
//
//    var dtReturned = patchMetricDB -> select("SELECT * FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
//            "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
//            "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
//            "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
//            "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
//            "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
//            "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
//            "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%'  " +
//            "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME ORDER BY p.PRODUCT_NAME, NO_OF_PATCHES DESC) as fileInfo " +
//            "WHERE (SELECT COUNT(*) FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_INFO fi " +
//            "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
//            "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
//            "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
//            "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
//            "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
//            "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
//            "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%'  " +
//            "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME ORDER BY p.PRODUCT_NAME, NO_OF_PATCHES DESC) as filterFileInfo " +
//            "WHERE filterFileInfo.PRODUCT_NAME = fileInfo.PRODUCT_NAME and filterFileInfo.NO_OF_PATCHES > fileInfo.NO_OF_PATCHES) <= 5 " +
//            "ORDER BY NO_OF_PATCHES DESC",
//        model:FileWithNoofPatches, periodStartDateParam, periodEndDateParam, periodStartDateParam, periodEndDateParam);
//
//    model:FileWithNoofPatches[] fileWithNoofPatchList = [];
//    match dtReturned{
//        table fileTable => {
//            while (fileTable.hasNext()) {
//                var rs = check <model:FileWithNoofPatches>fileTable.getNext();
//                io:println(rs);
//                fileWithNoofPatchList[lengthof fileWithNoofPatchList] = rs;
//            }
//        }
//        error err => {
//            log:printErrorCause("Error occured while retrieving WSO2 product name from WSO2_PRODUCT_COMPONENTS_wso2dev", err);
//        }
//    }
//
//    return fileWithNoofPatchList;
//
//}



public function getMostModifiedJavaClasses(string startDate, string endDate, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:FileInfoWithStats[] {

    log:printDebug("Retrieving most modified java classes with paging no : " + pageIndex);

    sql:Parameter periodStartDateParam = (sql:TYPE_DATE, startDate);
    sql:Parameter periodEndDateParam = (sql:TYPE_DATE, endDate);

    string dbQuery = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM ISSUE i RIGHT JOIN (SELECT * FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, fs.UPDATED_DATE, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
        "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
        "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%' " +
        "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) as fileInfo " +
        "WHERE (SELECT COUNT(*) FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_STATS fs " +
        "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
        "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%' " +
        "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) as filterFileInfo " +
        "WHERE filterFileInfo.PRODUCT_NAME = fileInfo.PRODUCT_NAME and filterFileInfo.NO_OF_PATCHES > fileInfo.NO_OF_PATCHES) <= 5) fileStats ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
        "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME " +
        "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);


    //string dbQuery = "SELECT fileInfo.*, issuesCount.NO_OF_ISSUES FROM " +
    //    "(SELECT tup.FILE_INFO_ID, p.PRODUCT_NAME, fi.FILE_NAME, tup.FROM_DATE, tup.TO_DATE, tup.NO_OF_PATCHES, " +
    //    "CONCAT(IF(tup.TEST_COVERED_LINES = 0 AND tup.TEST_MISSED_LINES = 0, 0, ROUND(((tup.TEST_COVERED_LINES/(tup.TEST_COVERED_LINES +  tup.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM TOP_UPDATED_FILES tup " +
    //    "JOIN FILE_INFO fi ON fi.ID = tup.FILE_INFO_ID " +
    //    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    //    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    //    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    //    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    //    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    //    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    //    "GROUP BY p.PRODUCT_NAME, fi.ID, tup.FILE_INFO_ID) fileInfo " +
    //    "LEFT JOIN (SELECT fb.TOP_UPDATED_FILES_FILE_INFO_ID, COUNT(fb.ID) AS NO_OF_ISSUES FROM FILE_BUGS fb GROUP BY fb.TOP_UPDATED_FILES_FILE_INFO_ID) issuesCount ON fileInfo.FILE_INFO_ID = issuesCount.TOP_UPDATED_FILES_FILE_INFO_ID " +
    //    "ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, periodStartDateParam, periodEndDateParam, periodStartDateParam, periodEndDateParam);

    model:FileInfoWithStats[] fileInfoWithStatsList = [];
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                fileInfoWithStatsList[lengthof fileInfoWithStatsList] = rs;
                //io:println(rs);
            }
        }
        error err => {

        }
    }

    return fileInfoWithStatsList;
}

public function getJavaClassWithDateRange(int id, string startDate, string endDate) returns model:FileInfoWithStats {

    log:printDebug("Retrieving java class with file id : " + id);

    sql:Parameter idParam = (sql:TYPE_INTEGER, id);
    sql:Parameter periodStartDateParam = (sql:TYPE_DATE, startDate);
    sql:Parameter periodEndDateParam = (sql:TYPE_DATE, endDate);

    string dbQuery = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, fs.UPDATED_DATE, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs
        JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID
        JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID
        JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID
        JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID
        JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID
        JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID
        JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID
        WHERE fi.ID = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%'
        GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats
        JOIN ISSUE i ON fileStats.ID = i.FILE_STATS_FILE_INFO_ID
        GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME";

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, idParam, periodStartDateParam, periodEndDateParam);

    model:FileInfoWithStats javaClass;
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                javaClass = rs;
                //io:println(rs);
            }
        }
        error err => {

        }
    }

    return javaClass;
}

public function getJavaClass(int id) returns model:FileInfoWithStats {

    log:printDebug("Retrieving java class with file id : " + id);

    sql:Parameter idParam = (sql:TYPE_INTEGER, id);

    string dbQuery = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, fs.UPDATED_DATE, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs
        JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID
        JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID
        JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID
        JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID
        JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID
        JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID
        JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID
        WHERE fi.ID = ?
        GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats
        JOIN ISSUE i ON fileStats.ID = i.FILE_STATS_FILE_INFO_ID
        GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME";

    io:println(dbQuery);
    var dtReturned = patchMetricDB -> select(dbQuery, model:FileInfoWithStats, idParam);

    model:FileInfoWithStats javaClass;
    match dtReturned {
        table dt => {
            while (dt.hasNext()) {
                var rs = check <model:FileInfoWithStats>dt.getNext();
                javaClass = rs;
                //io:println(rs);
            }
        }
        error err => {

        }
    }

    return javaClass;
}

//public function getModifiedJavaClass(int id) returns model:ModifiedJavaClassInfo {
//
//    log:printDebug("Retrieving modified java class with file id : " + id);
//
//    sql:Parameter idParam = (sql:TYPE_INTEGER, id);
//
//    string dbQuery = "SELECT tup.FILE_INFO_ID, p.PRODUCT_NAME, fi.FILE_NAME, tup.FROM_DATE, tup.TO_DATE, tup.NO_OF_PATCHES, " +
//        "CONCAT(IF(tup.TEST_COVERED_LINES = 0 AND tup.TEST_MISSED_LINES = 0, 0, ROUND(((tup.TEST_COVERED_LINES/(tup.TEST_COVERED_LINES +  tup.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM TOP_UPDATED_FILES tup " +
//        "JOIN FILE_INFO fi ON fi.ID = tup.FILE_INFO_ID " +
//        "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
//        "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
//        "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
//        "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
//        "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
//        "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
//        "WHERE tup.FILE_INFO_ID = ? " +
//        "GROUP BY p.PRODUCT_NAME, fi.ID, tup.FILE_INFO_ID";
//
//    io:println(dbQuery);
//    var dtReturned = patchMetricDB -> select(dbQuery, model:ModifiedJavaClassInfo, idParam);
//
//    model:ModifiedJavaClassInfo modifiedJavaClass;
//    match dtReturned {
//        table dt => {
//            while (dt.hasNext()) {
//                var rs = check <model:ModifiedJavaClassInfo>dt.getNext();
//                modifiedJavaClass = rs;
//                //io:println(rs);
//            }
//        }
//        error err => {
//
//        }
//    }
//
//    return modifiedJavaClass;
//}



public function getJavaClassIssuesFromDB(int fileId, string sortColumn, int sortDir, int pageIndex, int pageSize) returns model:Issue[] {

    log:printDebug("Retrieving issues in modified java class with file id : " + fileId);

    sql:Parameter idParam = (sql:TYPE_INTEGER, fileId);

    string dbQuery = "SELECT * FROM ISSUE WHERE FILE_STATS_FILE_INFO_ID = ? ORDER BY " + sortColumn + " " + (sortDir == 1 ? "DESC" : "ASC") + " LIMIT " + pageSize + " OFFSET " + ((pageIndex - 1) * pageSize);

    io:println(dbQuery);
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

        }
    }

    return issueList;
}
