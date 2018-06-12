package wso2.services;

import ballerina/io;
//import ballerina /http;
import wso2/testcoverage;
import wso2/dao;
import wso2/model;

//@Description {value:"Attributes associated with the service endpoint is defined here."}
//endpoint http:Listener helloWorldEP {
//    port:9090
//};
//
//@Description {value:"By default Ballerina assumes that the service is to be exposed via HTTP/1.1."}
//service<http:Service> hello bind helloWorldEP {
//    @Description {value:"All resources are invoked with arguments of server connector and request"}
//    sayHello(endpoint conn, http:Request req) {
//        http:Response res = new;
//        // A util method that can be used to set string payload.
//        res.setStringPayload("Hello, World!");
//        // Sends the response back to the client.
//        _ = conn -> respond(res);
//    }
//}




public function highestNoPatchesModifiedFilesWithTestCoverage(string startDate, string endDate) returns model:FileWithNoofPatches[] {

    model:FileWithNoofPatches[] fileList = dao:highestNoPatchesModifiedFiles(startDate, endDate);

    testcoverage:ClassTestCoverageRequestPayload[] requestPaylodaList = [];

    map<string> tempMap;

    io:print("length : ");
    io:println(lengthof fileList);

    foreach file in fileList {
        testcoverage:ClassTestCoverageRequestPayload payload = {};
        // io:println(file);
        if (file.FILE_NAME.contains(".java")) {
            string[] splitedFileName = file.FILE_NAME.split("/");
            string[] splitedRepoName = file.REPOSITORY_NAME.split("/");

            payload.className = splitedFileName[lengthof splitedFileName - 1];
            payload.packageName = generatePackageName(splitedFileName);
            payload.componentName = splitedRepoName[1];
            payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
            // io:println("payload : " + generatePackageName(splitedFileName));
            //  io:println(payload);
            requestPaylodaList[lengthof requestPaylodaList] = payload;
            tempMap[payload.packageName + "/" + payload.className] = file.FILE_NAME;

        }

    }
    testcoverage:ClassTestCoverageResponsePayload[] returnTo = testcoverage:getClassesTestCoverage(requestPaylodaList);

    //  io:println(tempMap);

    foreach fileCoverage in returnTo {
        model:FileLineCoverage fileLineCoverage;
        fileLineCoverage.missedLines = check <int>fileCoverage.lineCoverageData.missedLines;
        fileLineCoverage.coveredLines = check <int>fileCoverage.lineCoverageData.coveredLines;

        foreach file in fileList {
            io:println(file.FILE_NAME);
            io:println(tempMap[fileCoverage.sourceFile]);
            if (file.FILE_NAME.equalsIgnoreCase(tempMap[fileCoverage.sourceFile])) {
                file.LINE_COVERAGE = fileLineCoverage;
                file.ISSUES = fileCoverage.issues;
                io:println(fileCoverage.issues);
                io:println("\n");
                break;
            }

        }
        model:FileWithNoofPatches[] test = fileList.filter((model:FileWithNoofPatches file1) => boolean {
                //   io:println(file1.FILE_NAME);
                //io:println(tempMap[fileCoverage.sourceFile]);
                return true;
            });

        //tempMap[fileCoverage.sourceFile].LINE_COVERAGE = fileLineCoverage;
        // io:println(tempMap[fileCoverage.sourceFile]);
    }

    io:println(fileList);

    return fileList;

}

function generatePackageName(string[] splitedFileName) returns string {
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

//
//string productId;
//string componentName;
//string packageName;
//string className;

//
//string PRODUCT_NAME;
//string FILE_NAME;
//string REPOSITORY_NAME;
//int NO_OF_PATCHES;
//FileLineCoverage LINE_COVERAGE;