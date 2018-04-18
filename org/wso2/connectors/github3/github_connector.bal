package org.wso2.connectors.github3;


//import ballerina.util.arrays;
import ballerina.net.http;
//import ballerina.net.uri;
//import ballerina.util;
import ballerina.io;


const string BASE_URL = "https://api.github.com";

@Description{ value : "Github client connector."}
@Param{ value : "accessToken: The personal acess token to access Github Rest API"}
public connector ClientConnector(string accessToken) {

    endpoint<http:HttpClient> githubEP {
        create http:HttpClient("https://api.github.com", {});
    }

    http:HttpConnectorError e;

    @Description{ value : "Search repositories info using given github commit sha id."}
    @Param{ value : "Commit sha id"}
    @Return{ value : "Array of GitRepository object"}
    @Return { value:"GitHubError object" }
    action searchRepositoryViaCommit(string id) (GitHubRepository[], GitHubError) {
        http:OutRequest request = {};

        http:InResponse response = {};
        map parameters = {};
        string serviceUrl = "/search/commits";
        string queryParams = "q=hash:" + id;

        constructRequestHeaders(request, accessToken, "application/vnd.github.cloak-preview");
        serviceUrl = serviceUrl + "?" + queryParams;

        response, e = githubEP.get(serviceUrl, request);

        if (e != null) {
            return [],{errorMessage: e.message, statusCode: e.statusCode};
        } else if (response.statusCode < 200 || response.statusCode >= 300) {
            return [],{errorMessage: response.reasonPhrase, statusCode: response.statusCode};
        }

        return extractGitRepositories(response.getJsonPayload()), null;
    }

    @Description{ value : "Search repositories info using given github pull request sha id."}
    @Param{ value : "Pull request sha id"}
    @Return{ value : "Array of GitRepository object"}
    @Return { value:"GitHubError object" }
    action searchRepositoryViaPR(string id) (GitHubRepository[], GitHubError) {
                                                http:OutRequest request = {};

        http:InResponse response = {};
        map parameters = {};
        string serviceUrl = "/search/issues";
        string queryParams = "q=" + id;

        constructRequestHeaders(request, accessToken, "application/vnd.github.cloak-preview");
                                         serviceUrl = serviceUrl + "?" + queryParams;

        response, e = githubEP.get(serviceUrl, request);

        if (e != null) {
           return [],{errorMessage: e.message, statusCode: e.statusCode};
        } else if (response.statusCode < 200 || response.statusCode >= 300) {
           return [],{errorMessage: response.reasonPhrase, statusCode: response.statusCode};
        }

        return extractGitRepositoriesFromPR(response.getJsonPayload()), null;
    }

    @Description{ value : "search repositories info using given github commit sha id."}
    @Param{ value : "Repository name"}
    @Param{ value : "Repository owner name"}
    @Param{ value : "Commit sha id"}
    @Return{ value : "GitHubCommitChanges object"}
    @Return { value:"GitHubError object" }
    action getCommitChanges(string repo, string owner, string commitId)(GitHubCommitChanges, GitHubError) {
        http:OutRequest request = {};

        http:InResponse response = {};
        map parameters = {};
        string serviceUrl = "/repos";
        string pathParams = "/" + owner + "/" + repo + "/commits/" + commitId;

        constructRequestHeaders(request, accessToken, "application/vnd.github.cloak-preview");
        serviceUrl = serviceUrl + pathParams;

        response, e = githubEP.get(serviceUrl, request);

        if (e != null) {
            io:println(e);
            return null,{errorMessage: e.message, statusCode: e.statusCode};
        } else if (response.statusCode < 200 || response.statusCode >= 300) {
            return null,{errorMessage: response.reasonPhrase, statusCode: response.statusCode};
        }
        io:print("response");
        io:println(response);
        return extractCommitChanges(response.getJsonPayload()), null;

     //   return e != null ? (null, {errorMessage: e.message, statusCode: e.statusCode}): {}, null;
    }

}

