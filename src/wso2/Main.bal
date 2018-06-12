import ballerina/io;
import ballerina/runtime;
import ballerina/config;
import ballerina/sql;
import wso2/csv;
import wso2/github3;
import wso2/model;
import wso2/dao;
import wso2/timetasks;
import wso2/services;

endpoint github3:Client githubClient {
    accessToken: "9eb5e0a3ec30e09d1ddfadb9071fd31930e5da29",
    clientConfig:{}
};

//endpoint sql:Client testDB {
//database:sql:DB_MYSQL,
//host:"localhost",
//port:3306,
//name:"testdb",
//username:"root",
//password:"root",
//options:{maximumPoolSize:5}
//};

endpoint sql:Client pmtDB {
    url: "mysql://localhost:3306/pmtdb?useSSL=false",
    username:"root",
    password:"password123",
    poolOptions:{maximumPoolSize:5}
};


//const string accessToken = config:getGlobalValue("github.access_token");

public function main (string[] args) {

    io:print("test product id : ");
 //   io:println(dao:getProductComponent("carbon-appmgt"));

   // io:println(dao:highestChurnsFiles("2018-01-01", "2018-04-01"));

    //var test = services:highestChurnsFilesWithTestCoverage("2018-01-01", "2018-04-01");
   // _ = untaint csv:saveHighestNoPatchesModifiedFilesWithTestCoverageCSV();

    int i = 10;
    int j = i * -1;
    int k = j * -1;

    io:println(i + "   " + j + "    " + k);

    string accessToken = untaint config:getAsString("github.access_token");
    io:println(accessToken);
    var accessToken1 = untaint config:getAsString("exclude.files");
    io:println(accessToken1);

   // var sss = dao:getFilesModifiedInPatches();

 //  _ = untaint csv:saveHighestNoOfPatchesModifiedFileCSV(10);
  // _ = untaint csv:saveHighestLOCFileCSV(5000);
  // _ = untaint csv:saveHighestLOCPatchCSV(5000);
  // _ = untaint csv:saveLowestLOCPatchCSV(5000);
   //_ = untaint csv:saveHighestJavaFileLOCWithoutTestcasesPatchCSV(1000);
   //_ = untaint csv:saveHighestUILOCPatchCSV(1000);

  //  var res = dao:getPatchETARecords(10);
   // io:println(res);

    //timetasks:patchETAProcessingAppointment();
   // timetasks:githubCommitRetrievingAppointment();
    timetasks:testCoverageAppointment();
   // _ = timetasks:processPatchETA();

    while(true){
        runtime:sleepCurrentWorker(5*60*1000);
       // runtime:sleep(5*60*1000);
    }
//    _ = timetasks:processPatchETA();
//Status twitterStatus = check twitterClient -> tweet(status, "986498203800354816", "");

   // io:println("ABC");
   // io:println(sql:TYPE_INTEGER);
   // //sql:Parameter[] params = [];
   // sql:Parameter startIndexParam = (sql:TYPE_INTEGER, 10);
   //// sql:Pavirameter para1 = {sqlType:sql:TYPE_VARCHAR, value:"8"};
   // sql:Parameter[] params = [startIndexParam];
   // var dtReturned = pmtDB -> select("SELECT ID, PATCH_NAME, SVN_GIT_PUBLIC, SVN_GIT_SUPPORT FROM PATCH_ETA WHERE ID > ?", model:PatchETA, startIndexParam);
   //
   // io:println(dtReturned);
   //
   // table dt = check dtReturned;
   // string jsonRes;
   // var j = check <json>dt;
   // jsonRes = j.toString() but {() => ""};
   // io:println(jsonRes);








//var response = githubClient -> getCommitChanges("carbon-business-process", "wso2-support", "003c2a9094ac5f2b6941fd7acbe20d7599bc472e");
//var response = githubClient -> searchRepositoryViaPR("003c2a9094ac5f2b6941fd7acbe20d7599bc472e");
//io:println(response);
    //string ss = (string)model:GithubRepoType.SUPPORT
  //  io:println("Hello, World!"); c24c4fb396da701c619eb374bcd2b55bfe5c2cba
//    endpoint<github3:ClientConnector> githubConnector {
//        create github3:ClientConnector(accessToken);
//    }
//
//io:println(accessToken);
//
//    string shaId = "cd19639d1adf73f42947e2a24519c37620e4a06a";
//    var response, e = githubConnector.searchRepositoryViaPR(shaId);
//    io:println(response);
//    //io:println(e);
//
//
//    github3:GitHubRepository[] repo = response.filter(function (github3:GitHubRepository repository)(boolean){
//            io:println(repository);
//            return repository.owner.contains("wso2");
//        });
//
//    io:println(repo);
//    var response1, e1 = githubConnector.getCommitChanges(repo[0].name, repo[0].owner, shaId);
//    io:println(response1);
}


//import org.wso2.connectors.github3;
//import ballerina.config;
//import org.wso2.services;
//import org.wso2.dao;
//import org.wso2.model;