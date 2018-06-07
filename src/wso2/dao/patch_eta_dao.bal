package wso2.dao;

import ballerina/sql;
import ballerina/io;
import ballerina/log;
import wso2/model;

endpoint sql:Client pmtDB {
    url: "mysql://localhost:3306/pmtdb?useSSL=false",
    username:"root",
    password:"password123",
    poolOptions:{maximumPoolSize:5}
};


// Retrieve patches from Patch ETA and Patch Queue records.
// startIndex - Patch ID whch is used to start position
public function getPatchETARecords(int startIndex) returns model:PatchETA[] {

    log:printDebug("Retrieving patchs from Patch ETA");

    io:println(startIndex);
    sql:Parameter startIndexParam = (sql:TYPE_INTEGER, startIndex);

    var dtReturned = pmtDB -> select(
                                  "SELECT pe.ID, pe.PATCH_NAME, pe.SVN_GIT_PUBLIC, pe.SVN_GIT_SUPPORT, pq.CLIENT, pq.SUPPORT_JIRA, pq.PRODUCT_NAME, pq.REPORT_DATE FROM PATCH_ETA pe JOIN PATCH_QUEUE pq ON pq.ID = pe.PATCH_QUEUE_ID WHERE pe.ID > ? AND pe.LC_STATE LIKE 'Released%'",
                                  model:PatchETA, startIndexParam);

    model:PatchETA[] patchETAList = [];
    match dtReturned{
        table patchtable => {
            while (patchtable.hasNext()) {
                var rs = check <model:PatchETA>patchtable. getNext();
                patchETAList[lengthof patchETAList] = rs;
            }
        }
        error err => {
            log:printErrorCause("Error occured while retrieving patchs from Patch ETA", err);
        }
    }

   return patchETAList;

}