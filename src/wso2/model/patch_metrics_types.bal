package wso2.model;


//@Description {value:"Patch informsaion struct."}
public type PatchInfo {
    int ID;
    string PATCH_NAME;
    string CLIENT;
    string SUPPORT_JIRA;
    string REPORT_DATE;
    int PRODUCT_COMPONENT_ID;
};

//@Description {value:"Github Commit informsaion struct."}
public type GithubCommitInfo {
    string GITHUB_SHA_ID;
    string GITHUB_SHA_ID_REPO_TYPE;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
    boolean IS_UPDATED;
};

//@Description {value:"File informsaion struct."}
public type FileInfo {
    int ID;
    string FILE_NAME;
    string REPOSITORY_NAME;
};

//@Description {value:"Commit changes struct."}
public type CommitFileInfo {
    int GITHUB_COMMIT_INFO_PATCH_INFO_ID;
    string GITHUB_COMMIT_INFO_GITHUB_SHA_ID;
    int FILE_INFO_ID;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
};

//@Description {value:"Patch ETA struct."}
public type PatchETA {
    int ID;
    string PATCH_NAME;
    string SVN_GIT_PUBLIC;
    string SVN_GIT_SUPPORT;
    string CLIENT;
    string SUPPORT_JIRA;
    string PRODUCT_NAME;
    string REPORT_DATE;
};


public type PatchCommitInfo {
    string GITHUB_COMMIT_INFO_GITHUB_SHA_ID;
    int PATCH_INFO_ID;
};


public type FileModification {
    int ID;
    string FILE_NAME;
    string REPOSITORY_NAME;
    int NO_OF_PATCHES;
    float CHURNS;
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


public type PatchChanges {
    int ID;
    string PATCH_NAME;
    string CLIENT;
    float CHURNS;
};


public type WSO2ProductComponent {
    string REPO_NAME;
    int PRODUCT_ID;
};


public type FileWithNoofPatches {
    string PRODUCT_NAME;
    int ID;
    string FILE_NAME;
    string REPOSITORY_NAME;
    int NO_OF_PATCHES;
    FileLineCoverage LINE_COVERAGE;
    string[] ISSUES;
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


public type TopUpdatedFile {
    int FILE_INFO_ID;
    string FROM_DATE;
    string TO_DATE;
    int TEST_COVERED_LINES;
    int TEST_MISSED_LINES;
    int NO_OF_PATCHES;
};

public type FileStats {
    int FILE_INFO_ID;
    int TEST_COVERED_LINES;
    int TEST_MISSED_LINES;
    string UPDATED_DATE;
    int NO_OF_ISSUES;
};

public type Issue {
    int ID;
    int TOP_UPDATED_FILES_FILE_INFO_ID;
    string LINE;
    string DESCRIPTION;
    string ERROR_CODE;
};

public type ModifiedJavaClassInfo {
    int FILE_INFO_ID;
    string PRODUCT_NAME;
    string FILE_NAME;
    string FROM_DATE;
    string TO_DATE;
    int NO_OF_PATCHES;
    string TEST_COVERAGE;
    int NO_OF_ISSUES;
};


public type FileInfoWithStats {
    string PRODUCT_NAME;
    int ID;
    string FILE_NAME;
    string REPOSITORY_NAME;
    int NO_OF_PATCHES;
    string UPDATED_DATE;
    string TEST_COVERAGE;
    int NO_OF_ISSUES;
};





//public enum GithubRepoType {
//    PUBLIC,
//    SUPPORT
//}


