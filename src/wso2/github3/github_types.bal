package wso2.github3;

documentation {Represents Github repository}
public type GitHubRepository {
    string name;
    string owner;
};

documentation {Represents Github commit changes}
public type GitHubCommitChanges {
    GitHubCommitStat gitCommitStat;
    GitHubFileChanges[] gitCommitFiles;
};


documentation {Represents Github commit statistics"}
public type GitHubCommitStat {
    int total;
    int additions;
    int deletions;
};

documentation {Represents Github commit file changes"}
public type GitHubFileChanges {
    string sha;
    string filename;
    string status;
    int totalChanges;
    int additions;
    int deletions;
};

documentation {Represents error occured during Github communication}   //todo
public type GitHubError {
    string message;
    error? cause;
    int statusCode;
};