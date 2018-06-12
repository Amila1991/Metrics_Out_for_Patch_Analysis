import ballerina/http;
import ballerina/io;
import wso2/dao;
import wso2/model;
import wso2/testcoverage;
//import wso2/util;

@Description {value:"Attributes associated with the service endpoint is defined here."}
endpoint http:Listener patchMetricsEP {
    port:9090
};

//@Description {value:"By default Ballerina assumes that the service is to be exposed via HTTP/1.1."}
//service<http:Service> hello bind helloWorldEP {
//    @Description {value:"All resources are invoked with arguments of server connector and request"}
//    sayHello (endpoint conn, http:Request req) {
//        http:Response res = new;
//        // A util method that can be used to set string payload.
//        res.setStringPayload("Hello, World!");
//        // Sends the response back to the client.
//        _ = conn -> respond(res);
//    }
//}
//
//endpoint http:Listener helloWorldEP {
//    port:9095,
//    secureSocket: {
//        keyStore: {
//            filePath: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
//            password: "ballerina"
//        }
//    }
//};

@Description {value:"Ballerina server connector can be used to connect to a https client. If client needs to verify server authenticity when establishing the connection, server needs to provide keyStoreFile, keyStorePassword and certificate password as given here."}
@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/repository",
    cors:{
        allowOrigins:["*"],
        allowCredentials:false,
        allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
        exposeHeaders:["X-CUSTOM-HEADER"],
        maxAge:84900
    }
}
service<http:Service> repositoryService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }

    getRepositories(endpoint conn, http:Request req) {
        io:println(req.getQueryParams());

        //"sortColumn":"No of Patches", "sortDir":"1"
        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        var result = dao:getRepositories(sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);
        json j = check <json>result;

        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/product/{product}"
    }

    getRepositoriesByProduct(endpoint conn, http:Request req, string product) {
        io:println(req.getQueryParams());

        //"sortColumn":"No of Patches", "sortDir":"1"
        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        var result = dao:getRepositoriesbyProduct(product, sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);
        json j = check <json>result;

        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }
}


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/product",
    cors:{
        allowOrigins:["*"],
        allowCredentials:false,
        allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
        exposeHeaders:["X-CUSTOM-HEADER"],
        maxAge:84900
    }
}
service<http:Service> productService bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }

    getProducts(endpoint conn, http:Request req) {
        io:println(req.getQueryParams());

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }
        var result = dao:getProducts(sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);
        json j = check <json>result;
        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }
}


@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/patch",
    cors:{
        allowOrigins:["*"],
        allowCredentials:false,
        allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
        exposeHeaders:["X-CUSTOM-HEADER"],
        maxAge:84900
    }
}
service<http:Service> patcheSrvice bind patchMetricsEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getPatches(endpoint conn, http:Request req) {
        io:println(req.getQueryParams());

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }
        json jsonResponse;
        http:Response res = new;
        var result = dao:getPatches(sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);

        match result {
            model:Patch[] patchList => {
                jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        //res.setStringPayload("Successful");
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/product/{product}"
    }
    getPatchesByProduct(endpoint conn, http:Request req, string product) {
        io:println(req.getQueryParams());
        io:println(product);

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }
        json jsonResponse;
        http:Response res = new;
        var result = dao:getPatchesbyProduct(product, sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);

        match result {
            model:Patch[] patchList => {
                jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        //res.setStringPayload("Successful");
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/repository/{org}/{repo}"
    }
    getPatchesByRepository(endpoint conn, http:Request req, string org, string repo) {
        io:println(req.getQueryParams());
        string repository = org + "/" + repo;
        io:print("repository : ");
        io:println(repository);

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }
        json jsonResponse;
        http:Response res = new;
        var result = dao:getPatchesbyRepository(repository, sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);

        match result {
            model:Patch[] patchList => {
                jsonResponse = check <json>patchList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }

        //res.setStringPayload("Successful");
        _ = conn -> respond(res);
    }
}



@http:ServiceConfig {
    endpoints:[patchMetricsEP],
    basePath:"/file",
    cors:{
        allowOrigins:["*"],
        allowCredentials:false,
        allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
        exposeHeaders:["X-CUSTOM-HEADER"],
        maxAge:84900
    }
}
service<http:Service> fileService bind patchMetricsEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/repository/{org}/{repo}"
    }
    getFileInfoWithStatsByRepositoryList(endpoint conn, http:Request req, string org, string repo) {
        io:println(req.getQueryParams());
        string repository = org + "/" + repo;

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        http:Response res = new;
        var result = dao:getFileInfoWithStatsbyRepository(repository, sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);
        match result {
            model:FileInfoWithStats[] fileList => {
                json jsonResponse = check <json>fileList;
                res.setJsonPayload(jsonResponse);
            }
            error err => {
                res.statusCode = 500;
                res.setPayload(err.message);
            }
        }
      //  json j = check <json>result;

        //res.setStringPayload("Successful");
      //  res.setJsonPayload(j);
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/mostModifiedJavaClasses/"
    }
    getMostModifiedJavaClassesList(endpoint conn, http:Request req) {
        io:println(req.getQueryParams());

        var pageIndexStr = <int>(<string>untaint req.getQueryParams().pageIndex);
        var pageSizeStr = <int>(<string>untaint req.getQueryParams().pageSize);
        var sortDirStr = <int>(<string>untaint req.getQueryParams().sortDir);

        string sortColumn = <string>untaint req.getQueryParams().sortColumn;
        int pageIndex = 1;
        int pageSize = 10;
        int sortDir = 0;
        match pageIndexStr {
            int index => {
                io:println(index);
                pageIndex = index;
            }
            error err => {
                io:println(err);
            }
        }

        match pageSizeStr {
            int size => {
                io:println(size);
                pageSize = size;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }

        match sortDirStr {
            int dir => {
                io:println(dir);
                sortDir = dir;
            }
            error err => {
                io:println(err);
                io:println("ABC");
            }
        }
        var result = dao:getMostModifiedJavaClasses(sortColumn, sortDir, pageIndex, pageSize);
        io:println(result);
        json j = check <json>result;
        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/mostModifiedJavaClasses/{id}"
    }
    getMostModifiedJavaClass(endpoint conn, http:Request req, int id) {
        io:print("id : ");
        io:println(id);

        var result = dao:getModifiedJavaClass(id);
        io:println(result);
        json j = check <json>result;
        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}/issues"
    }
    getMostModifiedJavaClassIssues(endpoint conn, http:Request req, int id) {
        io:println(req.getQueryParams());
        io:print("id : ");
        io:println(id);

        var result = dao:getJavaClassIssuesFromDB(id);
        if (lengthof result == 0) {
            result = getFileTestCoverageAndIssues(id);//dao:getModifiedJavaClassIssues(id, sortColumn, sortDir, pageIndex, pageSize);
        }
        io:println(result);
        json j = check <json>result;
        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{id}/source"
    }
    getJavaFileSource(endpoint conn, http:Request req, int id) {
        io:println(req.getQueryParams());
        io:print("id : ");
        io:println(id);

        var result = getFileSource(id);//dao:getModifiedJavaClassIssues(id, sortColumn, sortDir, pageIndex, pageSize);

        io:println(result);
        json j = {id: id, source:result};
        http:Response res = new;
        //res.setStringPayload("Successful");
        res.setJsonPayload(j);
        _ = conn -> respond(res);
    }


}

public function getFileTestCoverageAndIssues(int id) returns model:Issue[] {

    model:FileInfo file = dao:getFileInfoById(id);

    testcoverage:ClassTestCoverageRequestPayload[] requestPaylodaList = [];

    testcoverage:ClassTestCoverageRequestPayload payload = {};
    // io:println(file);
    if (file.FILE_NAME.contains(".java")) {
        string[] splitedFileName = file.FILE_NAME.split("/");
        string[] splitedRepoName = file.REPOSITORY_NAME.split("/");

        payload.fileId = <string>file.ID;
        payload.className = splitedFileName[lengthof splitedFileName - 1];
        payload.packageName = generatePackageName(splitedFileName);
        payload.componentName = splitedRepoName[1];
        payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
        // io:println("payload : " + generatePackageName(splitedFileName));
        //  io:println(payload);
        requestPaylodaList[0] = payload;
    }

    io:println(requestPaylodaList);

    testcoverage:ClassTestCoverageResponsePayload[] returnTo = testcoverage:getClassesTestCoverage(requestPaylodaList);

    return processIssues(file.ID, returnTo[0].issues);

}

public function getFileSource(int id) returns string {

    model:FileInfo file = dao:getFileInfoById(id);

    testcoverage:ClassTestCoverageRequestPayload payload = {};
    // io:println(file);
    if (file.FILE_NAME.contains(".java")) {
        string[] splitedFileName = file.FILE_NAME.split("/");
        string[] splitedRepoName = file.REPOSITORY_NAME.split("/");

        payload.fileId = <string>file.ID;
        payload.className = splitedFileName[lengthof splitedFileName - 1];
        payload.packageName = generatePackageName(splitedFileName);
        payload.componentName = splitedRepoName[1];
        payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
    }

    io:println(payload);

    string returnTo = testcoverage:getClassesSourceAsString(payload);

    return returnTo;

}



public function generatePackageName(string[] splitedFileName) returns string {
    // string[] splitedFileName = fileName.split("/");
    int count = 0;
    //  io:println(splitedFileName);
    while (count < (lengthof splitedFileName - 1) && !splitedFileName[count].equalsIgnoreCase("org")) {
        count = count + 1;
    }

    if (count == (lengthof splitedFileName - 1)) {
        io:println(splitedFileName);
        count = 0;
        while (count < (lengthof splitedFileName - 1) && !splitedFileName[count].equalsIgnoreCase("java")) {
            count = count + 1;
        }
        count = count + 1;
    }

    string packageName = "";
    if (count >= (lengthof splitedFileName - 1)) {
        count = 0;
        while (count < (lengthof splitedFileName - 1) && !splitedFileName[count].contains("org.")) {
            count = count + 1;
        }
        packageName = splitedFileName[count].replaceAll("[.]+", "/");
        if (count == (lengthof splitedFileName - 1)) {
            io:println(splitedFileName);
        }
    } else {
        //  io:println(splitedFileName);
        // io:println(count);
        packageName = splitedFileName[count];//splitedFileName[count].replaceAll("[.]+", "/");

        while (count < lengthof splitedFileName - 2) {
            count = count + 1;
            packageName = packageName + "/" + splitedFileName[count];
        }
    }
    return packageName;
}

public function processIssues(int id, string[] issuesArr) returns model:Issue[] {

    model:Issue[] issueList;

    foreach issueStr in issuesArr {
        io:println("issue : " + issueStr);
        model:Issue issue;
        string[] issueSplit = issueStr.split(":");
        if (lengthof issueSplit >= 3) {
            issue.ID = lengthof issueList + 1;
            issue.TOP_UPDATED_FILES_FILE_INFO_ID = id;
            issue.ERROR_CODE = issueSplit[0];
            issue.DESCRIPTION = issueSplit[1];
            issue.LINE = issueSplit[lengthof issueSplit - 1].subString(1, issueSplit[lengthof issueSplit - 1].length() - 1).split(" ")[1];
            io:println(issue.LINE);

            issueList[lengthof issueList] = issue;
        }
        io:println("end");
    }

    return issueList;
}






//res.header("Access-Control-Allow-Origin", "*");
//  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");