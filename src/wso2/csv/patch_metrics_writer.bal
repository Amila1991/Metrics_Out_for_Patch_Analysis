package wso2.csv;

import ballerina/io;
import ballerina/log;
import wso2/dao;
import wso2/model;
import wso2/services;



//function getFileRecordChannel(string filePath, io:Mode permission, string encoding, string rs, string fs)
//    returns (io:DelimitedTextRecordChannel) {
//
//    io:ByteChannel channel = io:openFile(filePath, permission);
//    // Create a `character channel`
//    // from the `byte channel` to read content as text.
//    io:CharacterChannel characterChannel = new(channel, encoding);
//    // Convert the `character channel` to a `record channel`
//    //to read the content as records.
//    io:DelimitedTextRecordChannel delimitedRecordChannel = new(characterChannel,
//        rs = rs,
//        fs = fs);
//    return delimitedRecordChannel;
//}


function initDefaultCsvForWriting(string filePath) returns (io:DelimitedRecordChannel|io:IOError) {
    var csvDefaultChannel = io:createCsvChannel(filePath, mode = io:MODE_W);
    match csvDefaultChannel {
        io:DelimitedRecordChannel delimChannel => {
            //  csvChannel = untaint delimChannel;
            return delimChannel;
        }
        io:IOError err => {
            return err;
        }
    }
}


// This function reads the next record from the channel.
function readNext(io:DelimitedRecordChannel channel) returns (string[]) {
    match channel.nextTextRecord() {
        string[] records => {
            return records;
        }
        error err => {
            throw err.cause but { () => err };
        }

    }
}

// This function writes the next record to the channel.
function write(io:DelimitedRecordChannel channel, string[] records) {
    error? err = channel.writeTextRecord(records);
    match err {
        error e => throw e.cause but { () => e };
        () => {}
    }
}

public function main(string[] args) {
    io:println("Hello, World!");
    // fileModified();
}


public function saveHighestNoOfPatchesModifiedFileCSV(int morethan) {


    //string dstFileName = "./files/sample.csv";
    //io:DelimitedTextRecordChannel dstRecordChannel =
    //getFileRecordChannel(dstFileName, io:WRITE, "UTF-8", "\\r?\\n", ",");

    var initResult = initDefaultCsvForWriting("./resource/Highest_No_of_Patches_Modified_File.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {

                model:FileModification[] fileMadificationList = dao:getHighestNoOfPatchesModifiedFile(morethan);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["File name", "No of Patches", "Churn"];
                write(csvChannel, headers);


                foreach fileMadification in fileMadificationList {
                    string[] fileModified = [];
                    fileModified[0] = fileMadification.FILE_NAME;
                    fileModified[1] = <string>fileMadification.NO_OF_PATCHES;
                    fileModified[2] = <string>fileMadification.CHURNS;

                    write(csvChannel, fileModified);

                }
            } catch (error e) {
                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            // throw err;
        }
    }

    //  io:DelimitedRecordChannel csvChannel = initDefaultCsvForWriting("./resource/Highest_No_of_Patches_Modified_File.csv");
}

public function saveHighestLOCChangesFileCSV(int morethan) {

    //string dstFileName = "./files/sample.csv";
    //io:DelimitedTextRecordChannel dstRecordChannel =
    //getFileRecordChannel(dstFileName, io:WRITE, "UTF-8", "\\r?\\n", ",");

    var initResult = initDefaultCsvForWriting("./resource/Highest_LOC_Changes_File.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:FileModification[] fileMadificationList = dao:getHighestLOCChangesFile(morethan);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["File name", "No of Patches", "Churn"];
                write(csvChannel, headers);


                foreach fileMadification in fileMadificationList {
                    string[] fileModified = [];
                    fileModified[0] = fileMadification.FILE_NAME;
                    fileModified[1] = <string>fileMadification.NO_OF_PATCHES;
                    fileModified[2] = <string>fileMadification.CHURNS;
                    write(csvChannel, fileModified);
                }
            } catch (error e) {
                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}


public function saveHighestLOCFileCSV(int morethan) {

    //string dstFileName = "./files/sample.csv";
    //io:DelimitedTextRecordChannel dstRecordChannel =
    //getFileRecordChannel(dstFileName, io:WRITE, "UTF-8", "\\r?\\n", ",");

    var initResult = initDefaultCsvForWriting("./resource/Highest_LOC_Changes_File.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:FileModification[] fileMadificationList = dao:getHighestLOCChangesFile(morethan);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["File name", "No of Patches", "Churn"];
                write(csvChannel, headers);


                foreach fileMadification in fileMadificationList {
                    string[] fileModified = [];
                    fileModified[0] = fileMadification.FILE_NAME;
                    fileModified[1] = <string>fileMadification.NO_OF_PATCHES;
                    fileModified[2] = <string>fileMadification.CHURNS;
                    write(csvChannel, fileModified);
                }
            } catch (error e) {
                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}


public function saveHighestLOCPatchCSV(int morethan) {

    //string dstFileName = "./files/sample.csv";
    //io:DelimitedTextRecordChannel dstRecordChannel =
    //getFileRecordChannel(dstFileName, io:WRITE, "UTF-8", "\\r?\\n", ",");

    var initResult = initDefaultCsvForWriting("./resource/Highest_LOC_Patches.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:PatchChanges[] patchChangesList = dao:getDefaultPatchChanges(morethan, false);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["Patch name", "Client", "Churn"];
                write(csvChannel, headers);


                foreach patchChange in patchChangesList {
                    string[] patchChanges = [];
                    patchChanges[0] = patchChange.PATCH_NAME;
                    patchChanges[1] = patchChange.CLIENT;
                    patchChanges[2] = <string>patchChange.CHURNS;
                    write(csvChannel, patchChanges);
                }
            } catch (error e) {

                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}

public function saveLowestLOCPatchCSV(int lessthan) {

    var initResult = initDefaultCsvForWriting("./resource/Lowest_LOC_Patches.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:PatchChanges[] patchChangesList = dao:getDefaultPatchChanges(lessthan, true);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["Patch name", "Client", "Churn"];
                write(csvChannel, headers);


                foreach patchChange in patchChangesList {
                    string[] patchChanges = [];
                    patchChanges[0] = patchChange.PATCH_NAME;
                    patchChanges[1] = patchChange.CLIENT;
                    patchChanges[2] = <string>patchChange.CHURNS;
                    write(csvChannel, patchChanges);
                }
            } catch (error e) {

                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}

public function saveHighestJavaFileLOCWithoutTestcasesPatchCSV(int morethan) {

    //string dstFileName = "./files/sample.csv";
    //io:DelimitedTextRecordChannel dstRecordChannel =
    //getFileRecordChannel(dstFileName, io:WRITE, "UTF-8", "\\r?\\n", ",");

    var initResult = initDefaultCsvForWriting("./resource/Highest_LOC_Patches-Java_Code.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:PatchChanges[] patchChangesList = dao:getPatchJavaCodeChangesExceptTestCases(morethan);
                // string[][] fileMadificationStringList = [];
                string[] headers = ["Patch name", "Client", "Churn"];
                write(csvChannel, headers);


                foreach patchChange in patchChangesList {
                    string[] patchChanges = [];
                    patchChanges[0] = patchChange.PATCH_NAME;
                    patchChanges[1] = patchChange.CLIENT;
                    patchChanges[2] = <string>patchChange.CHURNS;
                    write(csvChannel, patchChanges);
                }
            } catch (error e) {

                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}

public function saveHighestUILOCPatchCSV(int morethan) {

    var initResult = initDefaultCsvForWriting("./resource/Highest_UI_Files_LOC_Patches.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:PatchChanges[] patchChangesList = dao:getPatchUIChanges(morethan);
                string[] headers = ["Patch name", "Client", "Churn"];
                write(csvChannel, headers);


                foreach patchChange in patchChangesList {
                    string[] patchChanges = [];
                    patchChanges[0] = patchChange.PATCH_NAME;
                    patchChanges[1] = patchChange.CLIENT;
                    patchChanges[2] = <string>patchChange.CHURNS;
                    write(csvChannel, patchChanges);
                }
            } catch (error e) {

                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}


public function saveHighestNoPatchesModifiedFilesWithTestCoverageCSV() {

    var initResult = initDefaultCsvForWriting("./resource/Highest_No_Patches_Modified_Files_With_Test_Coverage.csv");

    match initResult {
        io:DelimitedRecordChannel csvChannel => {
            try {
                model:FileWithNoofPatches[] fileWithNoofPatchesList = services:highestNoPatchesModifiedFilesWithTestCoverage("2018-01-01", "2018-04-01");
                string[] headers = ["Product Name", "File", "No of Patches", "Covered Lines", "Missed Lies"];
                write(csvChannel, headers);

                io:println(lengthof fileWithNoofPatchesList);

                foreach fileWithNoofPatches in fileWithNoofPatchesList {
                    io:println(fileWithNoofPatches);
                    io:println(fileWithNoofPatches.LINE_COVERAGE != null ? "yes" : "no");
                    string[] fileWithNoofPatchesStr = [];
                    fileWithNoofPatchesStr[0] = fileWithNoofPatches.PRODUCT_NAME;
                    fileWithNoofPatchesStr[1] = fileWithNoofPatches.FILE_NAME;
                    fileWithNoofPatchesStr[2] = <string>fileWithNoofPatches.NO_OF_PATCHES;
                    fileWithNoofPatchesStr[3] = fileWithNoofPatches.LINE_COVERAGE != null ? <string>fileWithNoofPatches.LINE_COVERAGE.missedLines : "N/A";
                    fileWithNoofPatchesStr[4] = fileWithNoofPatches.LINE_COVERAGE != null ? <string>fileWithNoofPatches.LINE_COVERAGE.coveredLines : "N/A";
                    io:println(fileWithNoofPatchesStr);
                    write(csvChannel, fileWithNoofPatchesStr);
                }
            } catch (error e) {

                //log:printError("An error occurred while processing the records: ",
                //    err = e);
                io:println(e);
            } finally {
                //Close the text record channel.
                match csvChannel.closeDelimitedRecordChannel() {
                    error destinationCloseError => {
                        //log:printError("Error occured while closing the channel: ",
                        //    err = destinationCloseError);
                    }
                    () => {
                        io:println("Destination channel closed successfully.");
                    }
                }
            }
        }
        io:IOError err => {
            //throw err;
        }
    }
}
