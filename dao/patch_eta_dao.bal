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
import ballerina/config;
import ballerina/log;
import model as model;

endpoint mysql:Client pmtDB {
    host: config:getAsString(PMT_DB_HOST),
    port: config:getAsInt(PMT_DB_PORT),
    name: config:getAsString(PMT_DB_NAME),
    username: config:getAsString(PMT_DB_USER),
    password:config:getAsString(PMT_DB_PASSWORD),
    poolOptions:{maximumPoolSize: config:getAsInt(PMT_DB_MAX_POOL_SIZE)},
    dbOptions:{useSSL:false}
};

documentation {Retrieve patches from Patch ETA and Patch Queue records.
        P{{startIndex}} Patch id whch is used to start position
        returns Array of PatchETA objects.
}
public function getPatchETARecords(int startIndex) returns model:PatchETA[] {

    log:printDebug("Retrieving patchs from Patch ETA");

    sql:Parameter startIndexParam = {sqlType: sql:TYPE_INTEGER, value: startIndex};

    var dtReturned = pmtDB -> select(PMT_PATCH_RECORD_SELECT_QUERY, model:PatchETA, startIndexParam);

    model:PatchETA[] patchETAList = [];
    match dtReturned{
        table patchtable => {
            while (patchtable.hasNext()) {
                var rs = check <model:PatchETA>patchtable. getNext();
                patchETAList[lengthof patchETAList] = rs;
            }
        }
        error err => {
            log:printError("Error occured while retrieving patchs from Patch ETA", err = err);
        }
    }

   return patchETAList;
}