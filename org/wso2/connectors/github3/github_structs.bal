package org.wso2.connectors.github3;


//@Description {value: "Struct to define the GitHub connector."}
//public struct GitHubConnector {
//    string accessToken;
//    string accessTokenSecret;
//    string clientId;
//    string clientSecret;
//    http:ClientEndpoint clientEndpoint;
//}
//
//@Description {value:"GitHub Endpoint struct."}
//public struct GitHubEndpoint {
//    GitHubConfiguration gitHubConfig;
//    GitHubConnector gitHubConnector;
//}
//
//@Description {value:"Struct to set the github configuration."}
//public struct GitHubConfiguration {
//    string uri;
//    string accessToken;
//    string accessTokenSecret;
//    string clientId;
//    string clientSecret;
//    http:ClientEndpointConfiguration clientConfig;
//}
//
@Description {value:"Git repository struct."}
public struct GitHubRepository {
    string name;
    string owner;
}

@Description {value:"Git Commit changes struct."}
public struct GitHubCommitChanges {
    GitHubCommitStat gitCommitStat;
    GitHubFileChanges[] gitCommitFiles;
}


@Description {value:"Git commit statistics struct."}
public struct GitHubCommitStat {
    int total;
    int additions;
    int deletions;
}

@Description {value:"Git file changes struct."}
public struct GitHubFileChanges {
    string sha;
    string filename;
    int totalChanges;
    int additions;
    int deletions;
}


//"stats": {
//"total": 44,
//"additions": 22,
//"deletions": 22
//},
//"files": [
//{
//"sha": "922581873efc9348a294ee76b7ba9233bc2be722",
//"filename": "esb/org.wso2.developerstudio.eclipse.gmf.esb.diagram/src/org/wso2/developerstudio/eclipse/gmf/esb/diagram/custom/deserializer/APIDeserializer.java",
//"status": "modified",
//"additions": 22,
//"deletions": 22,
//"changes": 44,
//"blob_url": "https://github.com/wso2/devstudio-tooling-esb/blob/49affa800fbcd5a2eeb4c39d549a69923fb72594/esb/org.wso2.developerstudio.eclipse.gmf.esb.diagram/src/org/wso2/developerstudio/eclipse/gmf/esb/diagram/custom/deserializer/APIDeserializer.java",
//"raw_url": "https://github.com/wso2/devstudio-tooling-esb/raw/49affa800fbcd5a2eeb4c39d549a69923fb72594/esb/org.wso2.developerstudio.eclipse.gmf.esb.diagram/src/org/wso2/developerstudio/eclipse/gmf/esb/diagram/custom/deserializer/APIDeserializer.java",
//"contents_url": "https://api.github.com/repos/wso2/devstudio-tooling-esb/contents/esb/org.wso2.developerstudio.eclipse.gmf.esb.diagram/src/org/wso2/developerstudio/eclipse/gmf/esb/diagram/custom/deserializer/APIDeserializer.java?ref=49affa800fbcd5a2eeb4c39d549a69923fb72594",
//"patch": "@@ -179,28 +179,6 @@ public SynapseAPI createNode(IGraphicalEditPart part,API api) {\n \t\t\t\t}\n \t\t\t}\n \t\t\t\n-\t\t\tfor(Handler handler : api.getHandlers()) {\n-\t\t\t\tAPIHandler apiHandler = EsbFactory.eINSTANCE.createAPIHandler();\t\t\t\n-\n-\t\t\t\tif(handler instanceof DummyHandler) {\n-\t\t\t\t\tDummyHandler dummyHandler = (DummyHandler) handler;\n-\t\t\t\t\tapiHandler.setClassName(dummyHandler.getClassName());\n-\t\t\t\t} else {\n-\t\t\t\t\tapiHandler.setClassName(handler.getClass().getName());\n-\t\t\t\t}\n-\t\t\t\t\t\n-\t\t\t\tIterator itr = handler.getProperties().keySet().iterator();\n-\t\t\t\twhile (itr.hasNext()) {\n-\t\t\t\t\tAPIHandlerProperty handlerProperty = EsbFactory.eINSTANCE.createAPIHandlerProperty();\n-\t\t\t\t\tString propertyName = (String) itr.next();\n-\t\t\t\t\thandlerProperty.setName(propertyName);\n-\t\t\t\t\thandlerProperty.setValue((String)handler.getProperties().get(propertyName));\n-\t\t\t\t\tapiHandler.getProperties().add(handlerProperty);\n-\t\t\t\t\t\n-\t\t\t\t}\n-\t\t\t\texecuteAddValueCommand(synapseAPI.getHandlers(),apiHandler);\n-\t\t\t}\n-\t\t\t\n \t\t\taddPairMediatorFlow(resource.getOutputConnector(),resource.getInputConnector());\n \t\t\t\n \t\t\tIGraphicalEditPart graphicalNode = (IGraphicalEditPart) AbstractEsbNodeDeserializer.getEditpart(resource);\n@@ -217,6 +195,28 @@ public SynapseAPI createNode(IGraphicalEditPart part,API api) {\n \t\t\t}\n \t\t}\n \t\t\n+\t\tfor(Handler handler : api.getHandlers()) {\n+\t\t\tAPIHandler apiHandler = EsbFactory.eINSTANCE.createAPIHandler();\t\t\t\n+\n+\t\t\tif(handler instanceof DummyHandler) {\n+\t\t\t\tDummyHandler dummyHandler = (DummyHandler) handler;\n+\t\t\t\tapiHandler.setClassName(dummyHandler.getClassName());\n+\t\t\t} else {\n+\t\t\t\tapiHandler.setClassName(handler.getClass().getName());\n+\t\t\t}\n+\t\t\t\t\n+\t\t\tIterator itr = handler.getProperties().keySet().iterator();\n+\t\t\twhile (itr.hasNext()) {\n+\t\t\t\tAPIHandlerProperty handlerProperty = EsbFactory.eINSTANCE.createAPIHandlerProperty();\n+\t\t\t\tString propertyName = (String) itr.next();\n+\t\t\t\thandlerProperty.setName(propertyName);\n+\t\t\t\thandlerProperty.setValue((String)handler.getProperties().get(propertyName));\n+\t\t\t\tapiHandler.getProperties().add(handlerProperty);\n+\t\t\t\t\n+\t\t\t}\n+\t\t\texecuteAddValueCommand(synapseAPI.getHandlers(),apiHandler);\n+\t\t}\n+\t\t\n \t\treturn synapseAPI;\n \t}\n "
//}
//]


@Description {value: "Struct to define the error."}
public struct GitHubError {
    int statusCode;
    string errorMessage;
}