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

import ballerina/task;
import ballerina/log;
import ballerina/math;
import ballerina/time;
import ballerina/config;
import model;
import dao;
import testcoverage;

public function testCoverageAppointment() {
    log:printInfo("Starting file statistic processing task appointment");

    (function() returns error?) onTriggerFunction = createTask;
    (function(error)) onErrorFunction = loggedTetsCoverageProcessError;

    task:Appointment appointment = new task:Appointment(onTriggerFunction, onErrorFunction,
        config:getAsString(TEST_COVERAGE_DATA_REQUEST_CRON));
    _ = appointment.schedule();
}


public function createTask() returns error? {
    log:printInfo("Start processing file statistic");
    time:Time time = time:currentTime();
    int res = dao:clearFileIssues();    //todo this comment want to uncomment before commit
    getJavaClassesTestCoverage(time.format("yyyy-MM-dd"));
    log:printInfo("Ended processing file statistic");
    return null;
}

public function getJavaClassesTestCoverage(string updatedDate) {

    model:FileInfo[] fileList = dao:getJavaFileInfo(0, updatedDate);

    while (lengthof fileList > 0) {
        testcoverage:ClassTestCoverageRequestPayload[] requestPaylodaList = [];

        foreach file in fileList {
            testcoverage:ClassTestCoverageRequestPayload payload = {};

            if (file.FILE_NAME.contains(".java")) {
                string[] splitedFileName = file.FILE_NAME.split("/");
                string[] splitedRepoName = file.REPOSITORY_NAME.split("/");

                payload.fileId = <string>file.ID;
                payload.className = splitedFileName[lengthof splitedFileName - 1];
                payload.packageName = generatePackageName(splitedFileName);
                payload.componentName = splitedRepoName[1];
                payload.productId = <string>dao:getProductComponent(splitedRepoName[1]);
                requestPaylodaList[lengthof requestPaylodaList] = payload;
            }

        }
        testcoverage:ClassTestCoverageResponsePayload[] returnTo = testcoverage:getClassesTestCoverage(requestPaylodaList);
        model:FileStats[] fileStatsList = [];
        model:Issue[] issuesList = [];

        foreach fileCoverage in returnTo {
            model:FileStats fileStats;
            fileStats.TEST_COVERED_LINES = check <int>fileCoverage.lineCoverageData.coveredLines;
            fileStats.TEST_MISSED_LINES = check <int>fileCoverage.lineCoverageData.missedLines;
            fileStats.UPDATED_DATE = updatedDate;
            fileStats.FILE_INFO_ID = check <int>fileCoverage.fileId;
            issuesList = processIssues(fileStats.FILE_INFO_ID, fileCoverage.issues, issuesList);
            fileStatsList[lengthof fileStatsList] = fileStats;
        }

        int[] res = dao:insertFileStats(fileStatsList);
        res = dao:insertFileIssues(issuesList);

        fileList = dao:getJavaFileInfo(fileList[(lengthof fileList) -1].ID, updatedDate);
    }

}

function loggedTetsCoverageProcessError(error err) {
    log:printError("Error occured while requesting test coverage and java class issues", err = err);
}


function generatePackageName(string[] splitedFileName) returns string {
    int count = 0;

    while (count < (lengthof splitedFileName - 1) && !splitedFileName[count].equalsIgnoreCase("org")) {
        count = count + 1;
    }

    if (count == (lengthof splitedFileName - 1)) {
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
    } else {
        packageName = splitedFileName[count];

        while (count < lengthof splitedFileName - 2) {
            count = count + 1;
            packageName = packageName + "/" + splitedFileName[count];
        }
    }
    return packageName;
}

function processIssues(int id, string[] issuesArr, model:Issue[] issueList) returns model:Issue[] {

    foreach issueStr in issuesArr {
        model:Issue issue;
        string[] issueSplit = issueStr.split(":");
        if (lengthof issueSplit >= 3) {
            issue.ID = lengthof issueList + 1;
            issue.FILE_STATS_FILE_INFO_ID = id;
            issue.ERROR_CODE = issueSplit[0];
            issue.DESCRIPTION = issueSplit[1];
            issue.LINE = issueSplit[lengthof issueSplit - 1].substring(1, issueSplit[lengthof issueSplit - 1].length() - 1).split(" ")[1];

            issueList[lengthof issueList] = issue;
        }
    }

    return issueList;
}