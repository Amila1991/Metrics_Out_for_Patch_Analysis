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

import ballerina/time;

public type PatchInfo {
    int ID;
    string PATCH_NAME;
    string CLIENT;
    string SUPPORT_JIRA;
    string REPORT_DATE;
    int PRODUCT_COMPONENT_ID;
};

public type GithubCommitInfo {
    string GITHUB_SHA_ID;
    string GITHUB_SHA_ID_REPO_TYPE;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
    boolean IS_UPDATED;
};

public type FileInfo {
    int ID;
    string FILE_NAME;
    string REPOSITORY_NAME;
    int LOC;
};

public type CommitFileInfo {
    int GITHUB_COMMIT_INFO_PATCH_INFO_ID;
    string GITHUB_COMMIT_INFO_GITHUB_SHA_ID;
    int FILE_INFO_ID;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
};

public type PatchETA {
    int ID;
    string PATCH_NAME;
    string? SVN_GIT_PUBLIC;
    string? SVN_GIT_SUPPORT;
    string CLIENT;
    string SUPPORT_JIRA;
    string PRODUCT_NAME;
    string REPORT_DATE;
};

public type PatchCommitInfo {
    string GITHUB_COMMIT_INFO_GITHUB_SHA_ID;
    int PATCH_INFO_ID;
};

public type Repository {
    string REPOSITORY_NAME;
    int NO_OF_PATCHES;
    float CHURNS;
};

public type Product {
    string PRODUCT_NAME;
    int NO_OF_PATCHES;
    float CHURNS;
};

public type Patch {
    int ID;
    string PATCH_NAME;
    string SUPPORT_JIRA;
    string REPORT_DATE;
    string CLIENT;
    string PRODUCT_NAME;
    int NO_OF_FILES_CHANGES;
    float CHURNS;
};

public type WSO2ProductComponent {
    string REPO_NAME;
    int PRODUCT_ID;
};

public type FileLineCoverage {
    int missedLines;
    int coveredLines;
};

public type ProductComponent {
    int ID;
    int PRODUCT_ID;
    string COMPONENT_NAME;
};

public type FileStats {
    int FILE_INFO_ID;
    int TEST_COVERED_LINES;
    int TEST_MISSED_LINES;
    string UPDATED_DATE;
};

public type Issue {
    int ID;
    int FILE_STATS_FILE_INFO_ID;
    string LINE;
    string DESCRIPTION;
    string ERROR_CODE;
};

public type FileInfoWithStats {
    string PRODUCT_NAME;
    int ID;
    string FILE_NAME;
    string UPDATED_DATE;
    string REPOSITORY_NAME;
    int NO_OF_PATCHES;
    float CHURNS;
    string TEST_COVERAGE;
    int NO_OF_ISSUES;
};
