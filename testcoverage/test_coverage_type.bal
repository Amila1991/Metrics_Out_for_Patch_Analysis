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

public type ClassTestCoverageRequestPayload {
    string fileId;
    string productId;
    string componentName;
    string packageName;
    string className;
};

public type ClassTestCoverageResponsePayload {
    string fileId;
    string sourceFile;
    string[] issues;
    InstructionCoverageData? instructionCoverageData;
    BranchCoverageData? branchCoverageData;
    LineCoverageData lineCoverageData;
    MethodCoverageData? methodCoverageData;
};

public type InstructionCoverageData {
    string missedInstructions;
    string coveredInstructions;
};

public type BranchCoverageData {
    string missedBranches;
    string coveredBranches;
};

public type LineCoverageData {
    string missedLines;
    string coveredLines;
};

public type MethodCoverageData {
    string missedMethods;
    string coveredMethods;
};
