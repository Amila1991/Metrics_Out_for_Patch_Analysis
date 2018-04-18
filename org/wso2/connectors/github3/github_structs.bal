package org.wso2.connectors.github3;


//@Description {value: "Struct to define the GitHub connector."}
//public struct GitHubConnector {
//    string accessToken;
//    string accessTokenSecret;
//    string clientId;
//    string clientSecret;
//    http:ClientEndpoint clientEndpoint;
//}
//
//@Description {value:"GitHub Endpoint struct."}
//public struct GitHubEndpoint {
//    GitHubConfiguration gitHubConfig;
//    GitHubConnector gitHubConnector;
//}
//
//@Description {value:"Struct to set the github configuration."}
//public struct GitHubConfiguration {
//    string uri;
//    string accessToken;
//    string accessTokenSecret;
//    string clientId;
//    string clientSecret;
//    http:ClientEndpointConfiguration clientConfig;
//}
//
@Description {value:"Git repository struct."}
public struct GitHubRepository {
    string name;
    string owner;
}

@Description {value:"Git Commit changes struct."}
public struct GitHubCommitChanges {
    GitHubCommitStat gitCommitStat;
    GitHubFileChanges[] gitCommitFiles;
}


@Description {value:"Git commit statistics struct."}
public struct GitHubCommitStat {
    int total;
    int additions;
    int deletions;
}

@Description {value:"Git file changes struct."}
public struct GitHubFileChanges {
    string sha;
    string filename;
    int totalChanges;
    int additions;
    int deletions;
}

@Description {value: "Struct to define the error."}
public struct GitHubError {
    int statusCode;
    string errorMessage;
}