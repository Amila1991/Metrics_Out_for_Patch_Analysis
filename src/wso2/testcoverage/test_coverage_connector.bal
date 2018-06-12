package wso2.testcoverage;

import ballerina/http;
import ballerina/log;
import ballerina/config;
import ballerina/io;
import ballerina/util;


endpoint http:Client jacocoEndpoint {
    targets:[{url:"https://localhost:8090",
        secureSocket:{
            keyStore:{
                filePath:"/home/amila/Code/Metrics_Out_for_Patch_Analysis/resource/ballerinaKeystore.p12",
                password:"ballerina"
            }
        }
    }],
    auth:{
        scheme:"basic",
        username:"root",
        password:"root"
    },
    timeoutMillis:7200000
};


public function getClassesTestCoverage(ClassTestCoverageRequestPayload[] classesList) returns ClassTestCoverageResponsePayload[] {

    http:Request request = new;
    string requestPath = "/product-coverage-service/source-file-report";
    log:printInfo("Requesting url from jacoco service " + requestPath + ".");
    json jsonObject = check <json>classesList;
    json payload = {sourceFileJsons:jsonObject};
    request.setJsonPayload(payload);
    var jacoResponse = jacocoEndpoint -> post(untaint requestPath, request);

    ClassTestCoverageResponsePayload[] toReturn;
    match jacoResponse{
        http:Response jacocoRes => {
            match jacocoRes.getJsonPayload(){
                json load => {
                    io:println(load.toString());
                    var jsonItems = check <json[]> load;
                    foreach item in jsonItems {
                        var responseItem = <ClassTestCoverageResponsePayload> item;
                        io:println(item);
                        io:println(responseItem);
                        io:println("\n");
                        match responseItem{
                            ClassTestCoverageResponsePayload fileCoverage => {
                                toReturn[lengthof toReturn] = fileCoverage;
                            }
                            error err => {
                                log:printErrorCause(err.message, err);
                            }
                        }

                    }
                    // log:printInfo(load.toString());
                }
                http:PayloadError err => {
                    log:printErrorCause(err.message, err);
                }
            }
        }
        http:HttpConnectorError err => {
            log:printErrorCause(err.message, err);
        }
    }
    return toReturn;
}


//
//endpoint http:Client testCoverageEndpoint {
//    url:"https://postman-echo.com"
//};
//
//public function getClassesTestCoverage(ClassTestCoverageRequestPayload[] classesList) returns map {
//
//    http:Request req = new;
//    json jsonObject = check <json>classesList;
//
//    req.setJsonPayload(jsonObject);
//
//    var response = testCoverageEndpoint -> post("/post", request = req);
//
//    map toReturn;
//    match response {
//        http:Response resp => {
//            log:printInfo("\nPOST request:");
//            var msg = resp.getJsonPayload();
//            match msg {
//                json jsonPayload => {
//                    log:printInfo(jsonPayload.toString());
//                    var jsonItems = check < json[]>jsonPayload;
//                    foreach i, item in jsonItems {
//                        toReturn[item.sourceFile] = item.lineCoverageData;
//                    }
//                }
//                error err => {
//                    log:printError(err.message, err = err);
//                }
//            }
//        }
//        error err => { log:printError(err.message, err = err); }
//
//    }
//
//    return toReturn;
//}
//
//




//"sourceFile":"org/wso2/carbon/apimgt/impl/dao/ApiMgtDAO.java",
//"instructionCoverageData":{
//"missedInstructions":"8584",
//"coveredInstructions":"16304"
//},
//"branchCoverageData":{
//"missedBranches":"709",
//"coveredBranches":"851"
//},
//"lineCoverageData":{
//"missedLines":"2052",
//"coveredLines":"4583"
//},
//"methodCoverageData":{
//"missedMethods":"45",
//"coveredMethods":"230"
//}
//},