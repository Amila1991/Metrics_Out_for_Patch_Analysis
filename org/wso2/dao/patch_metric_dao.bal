package org.wso2.dao;

import ballerina.data.sql;
import ballerina.io;
import org.wso2.model;

sql:ClientConnector patchMetricDBConn = create sql:ClientConnector( sql:DB. MYSQL, "localhost", 3306, "patch_metrics_db?useSSL=false", "root", "password123", {maximumPoolSize:5});

public function insertPatchInfo(model:PatchInfo[] patchInfoList)(int[]) {

    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter[][] patchInfoParams = [];
    foreach patchInfo in patchInfoList {
        sql:Parameter idParam = {sqlType:sql:Type.INTEGER, value:patchInfo.ID};
        sql:Parameter patchNameParam = {sqlType:sql:Type.VARCHAR, value:patchInfo.PATCH_NAME};
        sql:Parameter[] params = [idParam, patchNameParam];
        patchInfoParams[lengthof patchInfoParams] = params;
    }

    int[] res = patchMetricsDB.batchUpdate("INSERT INTO PATCH_INFO (ID,PATCH_NAME) VALUES (?,?)", patchInfoParams);

   return res;

}


public function getLastPatchInfoId()(int) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    table dt = patchMetricsDB.select("SELECT ID FROM PATCH_INFO ORDER BY ID DESC LIMIT 1", null, typeof model:PatchInfo);

    if (dt.hasNext()) {
        var rs, _ = (model:PatchInfo)dt.getNext();
        io:println(rs.ID);
        dt.close();
        return rs.ID;
    }
    return 0;
}


public function insertGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList)(int[]) {

    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter[][]  githubCommitInfoParams = [];
    foreach githubCommitInfo in githubCommitInfoList {
        sql:Parameter patchIdParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.PATCH_INFO_ID};
        sql:Parameter githubSHAIdParam = {sqlType:sql:Type.VARCHAR, value:githubCommitInfo.GITHUB_SHA_ID};
        sql:Parameter githubSHAIdRepoTypeParam = {sqlType:sql:Type.VARCHAR, value:githubCommitInfo.GITHUB_SHA_ID_REPO_TYPE};
        sql:Parameter totalChangesParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.TOTAL_CHANGES};
        sql:Parameter additionsParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.ADDITIONS};
        sql:Parameter deletionsParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.DELETIONS};
        sql:Parameter isUpdatedParam = {sqlType:sql:Type.TINYINT, value:<int>githubCommitInfo.IS_UPDATED};
        sql:Parameter[] params = [patchIdParam, githubSHAIdParam, githubSHAIdRepoTypeParam, totalChangesParam, additionsParam, deletionsParam, isUpdatedParam];
        githubCommitInfoParams[lengthof githubCommitInfoParams] = params;
    }

    int[] res = patchMetricsDB.batchUpdate("INSERT INTO GITHUB_COMMIT_INFO (PATCH_INFO_ID,GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED) VALUES (?,?,?,?,?,?,?)", githubCommitInfoParams);

    return res;

}


public function getIncompleteGithubCommitInfo()(model:GithubCommitInfo[]) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    table dt = patchMetricsDB.select("SELECT PATCH_INFO_ID,GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED FROM GITHUB_COMMIT_INFO WHERE IS_UPDATED = 0 ORDER BY PATCH_INFO_ID LIMIT 30", null, typeof model:GithubCommitInfo);
    model:GithubCommitInfo[] githubCommitInfoList = [];

    while (dt.hasNext()) {
        var rs,_ = (model:GithubCommitInfo)dt.getNext();
        githubCommitInfoList[lengthof githubCommitInfoList] = rs;
    }

    return githubCommitInfoList;
}


public function getIncompletePublicGithubCommitInfo()(model:GithubCommitInfo[]) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    table dt = patchMetricsDB.select("SELECT PATCH_INFO_ID,GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED FROM GITHUB_COMMIT_INFO WHERE IS_UPDATED = 0 ORDER BY PATCH_INFO_ID", null, typeof model:GithubCommitInfo);
    model:GithubCommitInfo[] githubCommitInfoList = [];

    while (dt.hasNext()) {
        var rs,_ = (model:GithubCommitInfo)dt.getNext();
        githubCommitInfoList[lengthof githubCommitInfoList] = rs;
    }

    return githubCommitInfoList;
}


public function getIncompleteSupportGithubCommitInfo()(model:GithubCommitInfo[]) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    table dt = patchMetricsDB.select("SELECT PATCH_INFO_ID,GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED FROM GITHUB_COMMIT_INFO WHERE IS_UPDATED = 0 AND GITHUB_SHA_ID_REPO_TYPE = 'SUPPORT' ORDER BY PATCH_INFO_ID LIMIT 30", null, typeof model:GithubCommitInfo);
    // SELECT ID FROM PATCH_INFO ORDER BY ID DESC LIMIT 1;
    model:GithubCommitInfo[] githubCommitInfoList = [];
    while (dt.hasNext()) {
        var rs,_ = (model:GithubCommitInfo)dt.getNext();
        githubCommitInfoList[lengthof githubCommitInfoList] = rs;
    }

    return githubCommitInfoList;
}


public function getFileInfo(string filename)(model:FileInfo) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter fileNameParam = {sqlType:sql:Type.VARCHAR, value:filename};
    sql:Parameter[] params = [fileNameParam];
    table dt = patchMetricsDB.select("SELECT * FROM FILE_INFO WHERE FILE_NAME = ?", params, typeof model:FileInfo);

    if (dt.hasNext()) {
        var rs,_ = (model:FileInfo)dt.getNext();
        dt.close();
        return rs;
    }

    return null;
}


public function insertGithubCommitFileInfo(model:CommitFileInfo[] commitFileInfoList)(int[]) {

    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter[][]  commitFileInfoParams = [];
    foreach commitFileInfo in commitFileInfoList {
        sql:Parameter patchIdParam = {sqlType:sql:Type.INTEGER, value:commitFileInfo.GITHUB_COMMIT_INFO_PATCH_INFO_ID};
        sql:Parameter githubCommitSHAIdParam = {sqlType:sql:Type.VARCHAR, value:commitFileInfo.GITHUB_COMMIT_INFO_GITHUB_SHA_ID};
        sql:Parameter fileSHAIdParam = {sqlType:sql:Type.INTEGER, value:commitFileInfo.FILE_INFO_ID};
        sql:Parameter totalChangesParam = {sqlType:sql:Type.INTEGER, value:commitFileInfo.TOTAL_CHANGES};
        sql:Parameter additionsParam = {sqlType:sql:Type.INTEGER, value:commitFileInfo.ADDITIONS};
        sql:Parameter deletionsParam = {sqlType:sql:Type.INTEGER, value:commitFileInfo.DELETIONS};
        sql:Parameter[] params = [patchIdParam, githubCommitSHAIdParam, fileSHAIdParam, totalChangesParam, additionsParam, deletionsParam];
        commitFileInfoParams[lengthof commitFileInfoParams] = params;
    }

    int[] res = patchMetricsDB.batchUpdate("INSERT INTO PATCH_INFO_has_FILE_INFO (GITHUB_COMMIT_INFO_PATCH_INFO_ID,GITHUB_COMMIT_INFO_GITHUB_SHA_ID,FILE_INFO_ID,TOTAL_CHANGES,ADDITIONS,DELETIONS) VALUES (?,?,?,?,?,?)", commitFileInfoParams);

    return res;

}


public function updateGithubCommitInfo(model:GithubCommitInfo[] githubCommitInfoList)(int[]) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter[][]  githubCommitInfoParams = [];
    foreach githubCommitInfo in githubCommitInfoList {
        sql:Parameter totalChangesParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.TOTAL_CHANGES};
        sql:Parameter additionsParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.ADDITIONS};
        sql:Parameter deletionsParam = {sqlType:sql:Type.INTEGER, value:githubCommitInfo.DELETIONS};
        sql:Parameter isUpdatedParam = {sqlType:sql:Type.TINYINT, value:<int>githubCommitInfo.IS_UPDATED};
        sql:Parameter githubSHAIdParam = {sqlType:sql:Type.VARCHAR, value:githubCommitInfo.GITHUB_SHA_ID};
        sql:Parameter[] params = [totalChangesParam, additionsParam, deletionsParam, isUpdatedParam, githubSHAIdParam];
        githubCommitInfoParams[lengthof githubCommitInfoParams] = params;
    }
    int[] res = patchMetricsDB.batchUpdate("UPDATE GITHUB_COMMIT_INFO SET TOTAL_CHANGES = ?, ADDITIONS = ?, DELETIONS= ?, IS_UPDATED = ? WHERE GITHUB_SHA_ID = ?", githubCommitInfoParams);

    return res;

}


public function insertFileInfo(model:FileInfo [] fileInfoList)(int[]) {

    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    sql:Parameter[][]  fileInfoParams = [];
    foreach file in fileInfoList {
        sql:Parameter fileSHAIdParam = {sqlType:sql:Type.INTEGER, value:file.ID};
        sql:Parameter fileNameParam = {sqlType:sql:Type.VARCHAR, value:file.FILE_NAME};
        sql:Parameter[] params = [fileSHAIdParam, fileNameParam];
        fileInfoParams[lengthof fileInfoParams] = params;
    }

    int[] res = patchMetricsDB.batchUpdate("INSERT INTO FILE_INFO (ID,FILE_NAME) VALUES (?,?)", fileInfoParams);

    return res;

}

public function getLastFileId()(int) {
    endpoint <sql:ClientConnector> patchMetricsDB {
        patchMetricDBConn;
    }

    table dt = patchMetricsDB.select("SELECT ID FROM FILE_INFO ORDER BY ID DESC LIMIT 1", null, typeof model:FileInfo);

    if (dt.hasNext()) {
        var rs, _ = (model:FileInfo)dt.getNext();
        io:println(rs.ID);
        dt.close();
        return rs.ID;
    }

    return 0;
}




