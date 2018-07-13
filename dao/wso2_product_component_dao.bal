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

import ballerina/sql;
import ballerina/mysql;
import ballerina/log;
import model as model;

endpoint mysql:Client productComponentDB {
    host: config:getAsString(WSO2_COMPOMEMT_DB_HOST),
    port: config:getAsInt(WSO2_COMPOMEMT_DB_PORT),
    name: config:getAsString(WSO2_COMPOMEMT_DB_NAME),
    username: config:getAsString(WSO2_COMPOMEMT_DB_USER),
    password:config:getAsString(WSO2_COMPOMEMT_DB_PASSWORD),
    poolOptions:{maximumPoolSize: config:getAsInt(WSO2_COMPOMEMT_DB_MAX_POOL_SIZE)},
    dbOptions:{useSSL:false}
};

documentation {GET file inofrmation by file id
        P{{repository}} Repository name
        returns int as a product compoennt id.
}
public function getProductComponent(string repository) returns int {

    log:printDebug("Retrieving WSO2 product name from WSO2_PRODUCT_COMPONENTS with repository name : " + repository);

    sql:Parameter repositoryParam = {sqlType: sql:TYPE_VARCHAR, value: repository};

    var dtReturned = productComponentDB -> select( WSO2_COMPOMEMT_GET_PRODUCT_ID, model:WSO2ProductComponent, repositoryParam);

    match dtReturned{
        table product_com_id => {
            if (product_com_id.hasNext()) {
                var rs = check <model:WSO2ProductComponent> product_com_id.getNext();
                product_com_id.close();
                return rs.PRODUCT_ID;
            }
        }
        error err => {
            log:printError("Error occured while retrieving WSO2 product name from WSO2_PRODUCT_COMPONENTS", err = err);
        }
    }

    return -1;

}