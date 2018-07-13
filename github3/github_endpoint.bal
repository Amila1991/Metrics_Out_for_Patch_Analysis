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

import ballerina/http;

documentation {Github connector configurations can be setup here
    F{{uri}} The Github API base URL
    F{{accessToken}} The access token of the Github account
    F{{clientConfig}} Client endpoint configurations provided by the user
}
public type GithubConfiguration {
    string uri;
    string accessToken;
    http:ClientEndpointConfig clientConfig = {};
};

documentation {Github Client object
    F{{githubConfiguration}} Github connector configurations
    F{{githubConnector}} GithubConnector Connector object
}
public type Client object {
    public {
        GithubConfiguration githubConfiguration = {};
        GithubConnector githubConnector = new;
    }

    documentation {Github connector endpoint initialization function
        P{{githubConfig}} Github connector configuration
    }
    public function init (GithubConfiguration githubConfig);

    //documentation {Return the Github connector client
    //    returns Github connector client
    //}
    //public function getClient () returns GithubConnector;
    //

    documentation { Return the GitHub connector client
            R{{cc}} - GitHub client
        }
    public function getCallerActions() returns GithubConnector;
};


public function Client::init (GithubConfiguration githubConfig) {
    githubConfig.uri = "https://api.github.com";
    self.githubConnector.accessToken = githubConfig.accessToken;
    githubConfig.clientConfig.url = githubConfig.uri;
    self.githubConnector.clientEndpoint.init(githubConfig.clientConfig);
}

public function Client::getCallerActions() returns GithubConnector {
    return self.githubConnector;
}
