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

package wso2.services;

import ballerina/http;

@final public http:CorsConfig SERVICES_CORS_PARAMS = {
    allowOrigins:["*"],
    allowCredentials:false,
    allowHeaders:["Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept", "CORELATION_ID"],
    exposeHeaders:["X-CUSTOM-HEADER"],
    maxAge:84900
};