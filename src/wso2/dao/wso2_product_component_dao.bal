package wso2.dao;

import ballerina/sql;
import ballerina/mysql;
import ballerina/io;
import ballerina/log;
import wso2/model;


//endpoint sql:Client pmtDB {
//    url:"mysql://localhost:3306/WSO2_PRODUCT_COMPONENTS_wso2dev?useSSL=false",
//    username:"root",
//    password:"password123",
//    poolOptions:{maximumPoolSize:5}
//};

endpoint mysql:Client productComponentDB {
    host:"localhost",
    port:3306,
    name:"WSO2_PRODUCT_COMPONENTS_wso2dev",
    username:"root",
    password:"password123",
    poolOptions:{maximumPoolSize:5},
    dbOptions:{useSSL:false}
};

// Retrieve patches from Patch ETA and Patch Queue records.
// startIndex - Patch ID whch is used to start position
public function getProductComponent(string repository) returns int {

    log:printDebug("Retrieving WSO2 product name from WSO2_PRODUCT_COMPONENTS_wso2dev with repository name : " + repository);

   // io:println(repository);
    sql:Parameter repositoryParam = (sql:TYPE_VARCHAR, repository);

    var dtReturned = productComponentDB -> select( "SELECT REPO_NAME,PRODUCT_ID FROM PRODUCT_REPOS WHERE REPO_NAME = ?",
                                  model:WSO2ProductComponent, repositoryParam);

    match dtReturned{
        table product_com_id => {
            if (product_com_id.hasNext()) {

                var rs = check < model:WSO2ProductComponent> product_com_id.getNext();

               // io:println(rs);
                product_com_id.close();
                return rs.PRODUCT_ID;
            }
        }
        error err => {
            log:printErrorCause("Error occured while retrieving WSO2 product name from WSO2_PRODUCT_COMPONENTS_wso2dev", err);
        }
    }

    return -1;

}