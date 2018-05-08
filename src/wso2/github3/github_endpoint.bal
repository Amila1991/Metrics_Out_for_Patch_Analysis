package wso2.github3;

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
    F{{githubConfig}} Github connector configurations
    F{{githubConnector}} GithubConnector Connector object
}
public type Client object {
    public {
        GithubConfiguration githubConfig = {};
        GithubConnector githubConnector = new;
    }

    documentation {Github connector endpoint initialization function
        P{{githubConfig}} Github connector configuration
    }
    public function init (GithubConfiguration githubConfig);

    documentation {Return the Github connector client
        returns Github connector client
    }
    public function getClient () returns GithubConnector;
};


documentation {Set the client configuration}
public function <GithubConfiguration githubConfig> GithubConfiguration () {
    githubConfig.clientConfig = {};
}

public function Client::init (GithubConfiguration githubConfig) {
    githubConfig.uri = "https://api.github.com";
    self.githubConnector.accessToken = githubConfig.accessToken;
    githubConfig.clientConfig.targets = [{url:githubConfig.uri}];
    //githubConfig.clientConfig.url = githubConfig.uri;
    self.githubConnector.clientEndpoint.init(githubConfig.clientConfig);

}

public function Client::getClient() returns GithubConnector {
    return self.githubConnector;
}
