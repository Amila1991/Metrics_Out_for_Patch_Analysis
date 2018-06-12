package wso2.timetasks;

import ballerina/task;
import ballerina/log;
import ballerina/math;
import ballerina/io;
import ballerina/time;
import wso2/model;
import wso2/dao;
import wso2/testcoverage;


//function main(string[] args) {
//    testCoverageAppointment ();
//}

public function testCoverageAppointment() {
    log:printInfo("------- Scheduling Appointments 3 ----------------");


    (function() returns error?) onTriggerFunction = createTask;
    (function(error)) onErrorFunction = loggedError;

    task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction, "0 29 * * * ?");
    _ = appointment.schedule();
}


public function createTask() returns error? {
    time:Time time = time:currentTime();
  //  int res = dao:clearFileIssues();
   // res = dao:clearTopUpdatedFiles();

//    highestNoPatchesModifiedFilesWithTestCoverage(time.subtractDuration(0, 3, 0, 0, 0, 0, 0).format("yyyy-MM-dd"), time.format("yyyy-MM-dd"));
    getJavaClassesTestCoverage(time.format("yyyy-MM-dd"));
    return null;
}

public function getJavaClassesTestCoverage(string updatedDate) {

    model:FileInfo[] fileList = dao:getJAVAFileInfo(0, updatedDate);


    map<string> tempMap;

    while (lengthof fileList > 0) {
        testcoverage:ClassTestCoverageRequestPayload[] requestPaylodaList = [];

        io:print("length : ");
        io:println(lengthof fileList);
        io:println(lengthof fileList > 0 ? <string>fileList[0].ID : "null");

        foreach file in fileList {
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
                requestPaylodaList[lengthof requestPaylodaList] = payload;
                tempMap[payload.packageName + "/" + payload.className] = file.FILE_NAME;

            }

        }
        testcoverage:ClassTestCoverageResponsePayload[] returnTo = testcoverage:getClassesTestCoverage(requestPaylodaList);
        model:FileStats[] fileStatsList = [];

        //  io:println(tempMap);

        io:println(requestPaylodaList);
        io:println(returnTo);

        foreach fileCoverage in returnTo {
            //   model:FileLineCoverage fileLineCoverage;
            model:FileStats fileStats;
            fileStats.TEST_COVERED_LINES = check <int>fileCoverage.lineCoverageData.coveredLines;
            fileStats.TEST_MISSED_LINES = check <int>fileCoverage.lineCoverageData.missedLines;
            fileStats.UPDATED_DATE = updatedDate;
            fileStats.FILE_INFO_ID = check <int>fileCoverage.fileId;
            fileStats.NO_OF_ISSUES = lengthof fileCoverage.issues;

            // fileLineCoverage.missedLines = check <int>fileCoverage.lineCoverageData.missedLines;
            //fileLineCoverage.coveredLines = check <int>fileCoverage.lineCoverageData.coveredLines;

            //foreach file in fileList {
            //    io:println("file : " + file.FILE_NAME);
            //    io:println("temp Map : " + tempMap[fileCoverage.sourceFile]);
            //    if (file.FILE_NAME.equalsIgnoreCase(tempMap[fileCoverage.sourceFile])) {
            //        fileStats.FILE_INFO_ID = file.ID;
            //        fileStats.NO_OF_ISSUES = getIssueListLength(file.ID, fileCoverage.issues);
            //        // file.LINE_COVERAGE = fileLineCoverage;
            //        //file.ISSUES = fileCoverage.issues;
            //        io:println(fileCoverage.issues);
            //        io:println(file.ID);
            //        break;
            //    }
            //    io:println("\n");
            //
            //}

            fileStatsList[lengthof fileStatsList] = fileStats;

            //tempMap[fileCoverage.sourceFile].LINE_COVERAGE = fileLineCoverage;
            // io:println(tempMap[fileCoverage.sourceFile]);
        }

        int[] res = dao:insertFileStats(fileStatsList);


        fileList = dao:getJAVAFileInfo(fileList[(lengthof fileList) -1].ID, updatedDate);
    }

}








public function highestNoPatchesModifiedFilesWithTestCoverage(string startDate, string endDate) {

    io:println(startDate + ":" + endDate);

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

            payload.fileId = <string>file.ID;
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
    model:TopUpdatedFile[] topUpdatedFileList = [];
    model:FileStats[] fileStatsList = [];
    model:Issue[] issuesList = [];

    //  io:println(tempMap);

    foreach fileCoverage in returnTo {
        //   model:FileLineCoverage fileLineCoverage;
        model:TopUpdatedFile topUpdatedFile;
        topUpdatedFile.TEST_COVERED_LINES = check <int>fileCoverage.lineCoverageData.coveredLines;
        topUpdatedFile.TEST_MISSED_LINES = check <int>fileCoverage.lineCoverageData.missedLines;
        topUpdatedFile.FROM_DATE = startDate;
        topUpdatedFile.TO_DATE = endDate;
        topUpdatedFile.FILE_INFO_ID = check <int>fileCoverage.fileId;
        issuesList = processIssues(topUpdatedFile.FILE_INFO_ID, fileCoverage.issues, issuesList);

        model:FileStats fileStats;
        fileStats.TEST_COVERED_LINES = topUpdatedFile.TEST_COVERED_LINES;
        fileStats.TEST_MISSED_LINES = topUpdatedFile.TEST_MISSED_LINES;
        fileStats.UPDATED_DATE = endDate;
        fileStats.FILE_INFO_ID = topUpdatedFile.FILE_INFO_ID;
        fileStats.NO_OF_ISSUES = lengthof fileCoverage.issues;

        // fileLineCoverage.missedLines = check <int>fileCoverage.lineCoverageData.missedLines;
        //fileLineCoverage.coveredLines = check <int>fileCoverage.lineCoverageData.coveredLines;

        foreach file in fileList {
            if (file.ID == topUpdatedFile.FILE_INFO_ID) {
                topUpdatedFile.NO_OF_PATCHES = file.NO_OF_PATCHES;
              //  io:println(fileCoverage.issues);
               // io:println(file.ID);
               // io:println("\n");
                break;
            }

        }

        topUpdatedFileList[lengthof topUpdatedFileList] = topUpdatedFile;
        fileStatsList[lengthof fileStatsList] = fileStats;

    }


    int[] res = dao:insertTopUpdatedFiles(topUpdatedFileList);
    res = dao:insertFileStats(fileStatsList);
    res = dao:insertFileIssues(issuesList);
    io:println(fileList);

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

function processIssues(int id, string[] issuesArr, model:Issue[] issueList) returns model:Issue[] {

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


function getIssueListLength(int id, string[] issuesArr) returns int {

    model:Issue[] issueList = [];

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

    return (lengthof issueList);
}