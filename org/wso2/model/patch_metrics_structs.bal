package org.wso2.model;


@Description {value:"Patch informsaion struct."}
public struct PatchInfo {
    int ID;
    string PATCH_NAME;
}

@Description {value:"Github Commit informsaion struct."}
public struct GithubCommitInfo {
    int PATCH_INFO_ID;
    string GITHUB_SHA_ID;
    string GITHUB_SHA_ID_REPO_TYPE;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
    boolean IS_UPDATED;
}

@Description {value:"File informsaion struct."}
public struct FileInfo {
    int ID;
    string FILE_NAME;
}

@Description {value:"Commit changes struct."}
public struct CommitFileInfo {
    int GITHUB_COMMIT_INFO_PATCH_INFO_ID;
    string GITHUB_COMMIT_INFO_GITHUB_SHA_ID;
    int FILE_INFO_ID;
    int TOTAL_CHANGES;
    int ADDITIONS;
    int DELETIONS;
}

@Description {value:"Patch ETA struct."}
public struct PatchETA {
    int ID;
    string PATCH_NAME;
    string SVN_GIT_PUBLIC;
    string SVN_GIT_SUPPORT;
}


public enum GithubRepoType {
    PUBLIC,
    SUPPORT
}


