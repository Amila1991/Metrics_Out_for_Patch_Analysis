package org.wso2.dao;

import ballerina.data.sql;
import ballerina.io;
import org.wso2.model;

sql:ClientConnector sqlConn = create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306, "pmtdb?useSSL=false", "root", "password123", {maximumPoolSize:5});


public function getPatchETARecords(int startIndex)(model:PatchETA[]) {

    endpoint <sql:ClientConnector> pmtDB {
        sqlConn;
    }


    sql:Parameter[] params = [];
    sql:Parameter startIndexParam = {sqlType:sql:Type.INTEGER, value:startIndex};
    params = [startIndexParam];
    table patchtable = pmtDB.select("SELECT ID, PATCH_NAME, SVN_GIT_PUBLIC, SVN_GIT_SUPPORT FROM PATCH_ETA WHERE ID > ?", params, typeof model:PatchETA);

    model:PatchETA[] patchETAList = [];
    while (patchtable.hasNext()) {
        var rs, _ = (model:PatchETA)patchtable. getNext();
        patchETAList[lengthof patchETAList] = rs;
    }

  //  io:println(typeof dt);
//var jsonRes, err = <json>dt;
  //  io:println(jsonRes);
   // io:println("ABC");

   return patchETAList;

}
//
//public struct PatchETA {
//    int ID;
//    string PATCH_NAME;
//    string SVN_GIT_PUBLIC;
//    string SVN_GIT_SUPPORT;
//}


//function main (string[] args) {
//    table dt = getPatchETARecords(100);
//}