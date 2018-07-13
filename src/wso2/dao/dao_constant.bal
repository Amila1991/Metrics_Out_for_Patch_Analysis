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

package wso2.dao;

@final string PMT_DB_HOST = "pmt.database.host";
@final string PMT_DB_PORT = "pmt.database.port";
@final string PMT_DB_NAME = "pmt.database.name";
@final string PMT_DB_USER = "pmt.database.user";
@final string PMT_DB_PASSWORD = "pmt.database.password";
@final string PMT_DB_MAX_POOL_SIZE = "pmt.dbConecntion.maximumPoolSize";
@final string PMT_PATCH_RECORD_SELECT_QUERY = "SELECT pe.ID, pe.PATCH_NAME, pe.SVN_GIT_PUBLIC, pe.SVN_GIT_SUPPORT, pq.CLIENT, pq.SUPPORT_JIRA, pq.PRODUCT_NAME, pq.REPORT_DATE FROM " +
    "PATCH_ETA pe JOIN PATCH_QUEUE pq ON pq.ID = pe.PATCH_QUEUE_ID WHERE pe.ID > ? AND pe.LC_STATE LIKE 'Released%'";


@final string PATCH_METRICS_DB_HOST = "patch.mertics.database.host";
@final string PATCH_METRICS_DB_PORT = "patch.mertics.database.port";
@final string PATCH_METRICS_DB_NAME = "patch.mertics.database.name";
@final string PATCH_METRICS_DB_USER = "patch.mertics.database.user";
@final string PATCH_METRICS_DB_PASSWORD = "patch.mertics.database.password";
@final string PATCH_METRICS_DB_MAX_POOL_SIZE = "patch.mertics.dbConecntion.maximumPoolSize";

@final string PATCH_METRICS_INSERT_PATCH_INFO = "INSERT INTO PATCH_INFO (ID,PATCH_NAME,CLIENT,SUPPORT_JIRA,REPORT_DATE,PRODUCT_COMPONENT_ID) VALUES (?,?,?,?,?,?)";
@final string PATCH_METRICS_INSERT_GITHUB_COMMIT_INFO = "INSERT INTO GITHUB_COMMIT_INFO (GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED) VALUES (?,?,?,?,?,?)";
@final string PATCH_METRICS_INSERT_PATCH_COMMIT_INFO = "INSERT INTO PATCH_RELATED_COMMITS (GITHUB_COMMIT_INFO_GITHUB_SHA_ID,PATCH_INFO_ID) VALUES (?,?)";
@final string PATCH_METRICS_INSERT_FILE_CHANGES = "INSERT INTO FILE_CHANGES (GITHUB_COMMIT_INFO_GITHUB_SHA_ID,FILE_INFO_ID,TOTAL_CHANGES,ADDITIONS,DELETIONS) VALUES (?,?,?,?,?)";
@final string PATCH_METRICS_UPDATE_GITHUB_COMMIT_INFO = "UPDATE GITHUB_COMMIT_INFO SET TOTAL_CHANGES = ?, ADDITIONS = ?, DELETIONS= ?, IS_UPDATED = ? WHERE GITHUB_SHA_ID = ?";
@final string PATCH_METRICS_INSERT_FILE_INFO = "INSERT INTO FILE_INFO (ID,FILE_NAME,REPOSITORY_NAME) VALUES (?,?,?)";
@final string PATCH_METRICS_INSERT_FILE_STATS = "INSERT INTO FILE_STATS (FILE_INFO_ID,UPDATED_DATE,TEST_COVERED_LINES,TEST_MISSED_LINES) VALUES (?,?,?,?) ON " +
    "DUPLICATE KEY UPDATE UPDATED_DATE=VALUES(UPDATED_DATE), TEST_COVERED_LINES=VALUES(TEST_COVERED_LINES), TEST_MISSED_LINES=VALUES(TEST_MISSED_LINES)";

@final string PATCH_METRICS_INSERT_ISSUES = "INSERT INTO ISSUE (ID, FILE_STATS_FILE_INFO_ID,LINE,DESCRIPTION,ERROR_CODE) VALUES (?,?,?,?,?)";
@final string PATCH_METRICS_DELETE_ISSUES = "DELETE FROM ISSUE";

@final string PATCH_METRICS_GET_LAST_PATCH_ID = "SELECT ID FROM PATCH_INFO ORDER BY ID DESC LIMIT 1";
@final string PATCH_METRICS_GET_INCOMPLETED_COMMITS = "SELECT GITHUB_SHA_ID,GITHUB_SHA_ID_REPO_TYPE,TOTAL_CHANGES,ADDITIONS,DELETIONS,IS_UPDATED FROM GITHUB_COMMIT_INFO WHERE IS_UPDATED = 0 ORDER BY GITHUB_SHA_ID LIMIT 30";
@final string PATCH_METRICS_GET_FILES_INFO = "SELECT * FROM FILE_INFO WHERE FILE_NAME = ? AND REPOSITORY_NAME = ?";
@final string PATCH_METRICS_GET_PRODUCT_COMPONENT_ID = "SELECT ID FROM PRODUCT_COMPONENT WHERE COMPONENT_NAME = ?";
@final string PATCH_METRICS_GET_COMMIT_INFO = "SELECT * FROM GITHUB_COMMIT_INFO WHERE GITHUB_SHA_ID = ?";
@final string PATCH_METRICS_GET_LAST_FILE_ID = "SELECT ID FROM FILE_INFO ORDER BY ID DESC LIMIT 1";
@final string PATCH_METRICS_GET_JAVA_FILE_INFO = "SELECT fi.* FROM FILE_INFO fi LEFT JOIN FILE_STATS fs ON fi.ID = fs.FILE_INFO_ID " +
    "WHERE fi.ID > ? AND FILE_NAME LIKE '%.java' AND (fs.UPDATED_DATE IS NULL OR fs.UPDATED_DATE < ?) ORDER BY fi.ID LIMIT 100";

@final string PATCH_METRICS_GET_FILE_INFO = "SELECT * FROM FILE_INFO WHERE ID = ?";
@final string PATCH_METRICS_GET_REPOSITORIES = "SELECT getChurnQuery.REPOSITORY_NAME, getChurnQuery.CHURNS, getPatchesCountQuery.No_of_Patches FROM (SELECT fi.REPOSITORY_NAME, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? GROUP BY fi.REPOSITORY_NAME) getChurnQuery " +
    "JOIN (SELECT t1.REPOSITORY_NAME, COUNT(t1.ID) AS No_of_Patches FROM (SELECT distinct fi.REPOSITORY_NAME, pi.ID FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ?) t1 GROUP BY t1.REPOSITORY_NAME) getPatchesCountQuery " +
    "ON getChurnQuery.REPOSITORY_NAME = getPatchesCountQuery.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_REPOSITORIES_BY_PRODUCT = "SELECT getChurnQuery.REPOSITORY_NAME, getChurnQuery.CHURNS, getPatchesCountQuery.No_of_Patches FROM " +
    "(SELECT fi.REPOSITORY_NAME, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID WHERE p.PRODUCT_NAME = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? GROUP BY fi.REPOSITORY_NAME) getChurnQuery " +
    "JOIN (SELECT t1.REPOSITORY_NAME, COUNT(t1.ID) AS No_of_Patches FROM (SELECT distinct fi.REPOSITORY_NAME, pi.ID FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID WHERE p.PRODUCT_NAME = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ?) t1 GROUP BY t1.REPOSITORY_NAME) getPatchesCountQuery " +
    "ON getChurnQuery.REPOSITORY_NAME = getPatchesCountQuery.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_PRODUCTS = "SELECT getChurnQuery.PRODUCT_NAME, getChurnQuery.CHURNS, getPatchesCountQuery.No_of_Patches FROM " +
    "(SELECT p.PRODUCT_NAME, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? " +
    "GROUP BY p.PRODUCT_NAME) getChurnQuery " +
    "JOIN (SELECT DISTINCT t1.PRODUCT_NAME, COUNT(t1.ID) as No_of_Patches FROM (SELECT DISTINCT p.PRODUCT_NAME, pi.ID FROM FILE_INFO fi " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ?) t1 " +
    "GROUP BY t1.PRODUCT_NAME) getPatchesCountQuery ON getChurnQuery.PRODUCT_NAME = getPatchesCountQuery.PRODUCT_NAME ";

@final string PATCH_METRICS_GET_PATCHES = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, " +
    "p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
    "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
    "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? " +
    "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME ";

@final string PATCH_METRICS_GET_PATCHES_BY_PRODUCT = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, " +
    "p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
    "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
    "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
    "WHERE p.PRODUCT_NAME = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? " +
    "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME ";

@final string PATCH_METRICS_GET_PATCHES_BY_REPOSITORY = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, " +
    "pi.CLIENT, p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
    "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
    "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
    "WHERE fi.REPOSITORY_NAME = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? " +
    "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME ";

@final string PATCH_METRICS_GET_PATCH = "SELECT pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, DATE_FORMAT(pi.REPORT_DATE, '%d-%m-%Y') AS REPORT_DATE, pi.CLIENT, " +
    "p.PRODUCT_NAME, COUNT(fi.ID) AS NO_OF_FILES_CHANGES, SUM(fc.TOTAL_CHANGES) AS CHURNS FROM PRODUCT p " +
    "JOIN PRODUCT_COMPONENT pc ON p.ID = pc.PRODUCT_ID " +
    "JOIN PATCH_INFO pi ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN FILE_CHANGES fc ON gci.GITHUB_SHA_ID = fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN FILE_INFO fi ON fc.FILE_INFO_ID = fi.ID " +
    "WHERE pi.ID = ? " +
    "GROUP BY pi.ID, pi.PATCH_NAME, pi.SUPPORT_JIRA, pi.REPORT_DATE, pi.CLIENT, p.PRODUCT_NAME";

@final string PATCH_METRICS_GET_FILE_STATS_BY_REPOSITORY = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM " +
    "(SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, IF(fi.FILE_NAME LIKE '%.java', " +
    "IF(fs.UPDATED_DATE IS NULL, 'Not Updated', DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y')), 'N/A') AS UPDATED_DATE, fi.REPOSITORY_NAME, " +
    "COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
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
    "WHERE fi.REPOSITORY_NAME = ? AND pi.REPORT_DATE >= ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND pi.REPORT_DATE < ? AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "JOIN ISSUE i ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_FILE_STATS_BY_REPOSITORY_INCLUDE_INTERNAL_PATCHES = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM " +
    "(SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, IF(fi.FILE_NAME LIKE '%.java', " +
    "IF(fs.UPDATED_DATE IS NULL, 'Not Updated', DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y')), 'N/A') AS UPDATED_DATE, fi.REPOSITORY_NAME, " +
    "COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
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
    "WHERE fi.REPOSITORY_NAME = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "JOIN ISSUE i ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_FILE_STATS_BY_PATCH = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM " +
    "(SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, IF(fi.FILE_NAME LIKE '%.java', " +
    "IF(fs.UPDATED_DATE IS NULL, 'Not Updated', DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y')), 'N/A') AS UPDATED_DATE, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
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
    "WHERE pi.ID = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "JOIN ISSUE i ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_MOST_UPDATED_JAVA_CLASSES = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM ISSUE i RIGHT JOIN " +
    "(SELECT * FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y') AS UPDATED_DATE, " +
    "fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
    "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
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
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_MOST_UPDATED_JAVA_CLASSES_INCLUDE_INTERNAL_PATCHES = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM ISSUE i RIGHT JOIN " +
    "(SELECT * FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y') AS UPDATED_DATE, " +
    "fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
    "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
    "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) as fileInfo " +
    "WHERE (SELECT COUNT(*) FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES FROM FILE_STATS fs " +
    "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) as filterFileInfo " +
    "WHERE filterFileInfo.PRODUCT_NAME = fileInfo.PRODUCT_NAME and filterFileInfo.NO_OF_PATCHES > fileInfo.NO_OF_PATCHES) <= 5) fileStats ON i.FILE_STATS_FILE_INFO_ID = fileStats.ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME ";

@final string PATCH_METRICS_GET_JAVA_CLASS_WITH_TIME_PERIOD = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM " +
    "(SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y') AS UPDATED_DATE, " +
    "fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
    "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
    "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE fi.ID = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' AND pi.SUPPORT_JIRA NOT LIKE '%SECURITYINTERNAL%' AND pi.SUPPORT_JIRA NOT LIKE '%DEVINTERNAL%' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "LEFT JOIN ISSUE i ON fileStats.ID = i.FILE_STATS_FILE_INFO_ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME";

@final string PATCH_METRICS_GET_JAVA_CLASS_WITH_TIME_PERIOD_INCLUDE_INTERNAL_PATCHES = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM " +
    "(SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y') AS UPDATED_DATE, " +
    "fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
    "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES +  fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
    "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE fi.ID = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? AND fi.REPOSITORY_NAME LIKE 'wso2/%' AND fi.FILE_NAME LIKE '%.java' " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "LEFT JOIN ISSUE i ON fileStats.ID = i.FILE_STATS_FILE_INFO_ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME";

@final string PATCH_METRICS_GET_JAVA_CLASS = "SELECT fileStats.*, COUNT(i.ID) AS NO_OF_ISSUES FROM (SELECT p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, " +
    "DATE_FORMAT(fs.UPDATED_DATE, '%d-%m-%Y') AS UPDATED_DATE, fi.REPOSITORY_NAME, COUNT(pi.ID) AS NO_OF_PATCHES, " +
    "SUM(fc.TOTAL_CHANGES) AS CHURNS, " +
    "CONCAT(IF(fs.TEST_COVERED_LINES = 0 AND fs.TEST_MISSED_LINES = 0, 0, ROUND(((fs.TEST_COVERED_LINES/(fs.TEST_COVERED_LINES + fs.TEST_MISSED_LINES))* 100 ),2)),'%') AS TEST_COVERAGE FROM FILE_STATS fs " +
    "JOIN FILE_INFO fi ON fs.FILE_INFO_ID = fi.ID " +
    "JOIN FILE_CHANGES fc ON fi.ID = fc.FILE_INFO_ID " +
    "JOIN GITHUB_COMMIT_INFO gci ON fc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID = gci.GITHUB_SHA_ID " +
    "JOIN PATCH_RELATED_COMMITS prc ON gci.GITHUB_SHA_ID = prc.GITHUB_COMMIT_INFO_GITHUB_SHA_ID " +
    "JOIN PATCH_INFO pi ON pi.ID = prc.PATCH_INFO_ID " +
    "JOIN PRODUCT_COMPONENT pc ON pc.ID = pi.PRODUCT_COMPONENT_ID " +
    "JOIN PRODUCT p ON p.ID = pc.PRODUCT_ID " +
    "WHERE fi.ID = ? AND pi.REPORT_DATE >= ? AND pi.REPORT_DATE < ? " +
    "GROUP BY p.PRODUCT_NAME, fi.ID, fi.FILE_NAME, fi.REPOSITORY_NAME) fileStats " +
    "JOIN ISSUE i ON fileStats.ID = i.FILE_STATS_FILE_INFO_ID " +
    "GROUP BY fileStats.PRODUCT_NAME, fileStats.ID, fileStats.FILE_NAME, fileStats.REPOSITORY_NAME";

@final string PATCH_METRICS_GET_FILE_ISSUES = "SELECT * FROM ISSUE WHERE FILE_STATS_FILE_INFO_ID = ? " ;


@final string WSO2_COMPOMEMT_DB_HOST = "wso2.component.database.host";
@final string WSO2_COMPOMEMT_DB_PORT = "wso2.component.database.port";
@final string WSO2_COMPOMEMT_DB_NAME = "wso2.component.database.name";
@final string WSO2_COMPOMEMT_DB_USER = "wso2.component.database.user";
@final string WSO2_COMPOMEMT_DB_PASSWORD = "wso2.component.database.password";
@final string WSO2_COMPOMEMT_DB_MAX_POOL_SIZE = "wso2.component.dbConecntion.maximumPoolSize";

@final string  WSO2_COMPOMEMT_GET_PRODUCT_ID = "SELECT REPO_NAME,PRODUCT_ID FROM PRODUCT_REPOS WHERE REPO_NAME = ?";