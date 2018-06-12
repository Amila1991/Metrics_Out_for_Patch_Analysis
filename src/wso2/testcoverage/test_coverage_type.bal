package wso2.testcoverage;

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
