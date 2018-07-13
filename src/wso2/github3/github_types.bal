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

documentation {Represents Github commit statistics}
public type GitHubCommitStat {
    int total;
    int additions;
    int deletions;
};

documentation {Represents Github commit file changes}
public type GitHubFileChanges {
    string sha;
    string filename;
    string status;
    int totalChanges;
    int additions;
    int deletions;
};

documentation {Represents error occured during Github communication}
public type GitHubError {
    string message;
    error? cause;
    int statusCode;
};