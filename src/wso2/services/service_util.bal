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

public function generatePackageName(string[] splitedFileName) returns string {
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

