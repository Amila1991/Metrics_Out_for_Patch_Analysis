package org.wso2.conn;

import ballerina.data.sql;
import ballerina.io;
import ballerina.collections;


struct PATCH_ETA {
    int ID;
    string SVN_GIT_PUBLIC;
    string SVN_GIT_SUPPORT;
}

const string NA = "N/A";
Regex REGEX = {pattern:"^[a-fA-F0-9]{40}$"};
sql:ClientConnector sql_conn = create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306, "pmtdb?useSSL=false", "root", "password123", {maximumPoolSize:5});
//sql:ClientConnector sqlHttpClient = create sql:ClientConnector(sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});


function main (string[] args) {

    endpoint <sql:ClientConnector> testDB {
        sql_conn;
    }

    table dt = testDB.select("SELECT ID, SVN_GIT_PUBLIC, SVN_GIT_SUPPORT FROM PATCH_ETA", null, typeof PATCH_ETA);
    var jsonRes, err = <json>dt;

//io:println(jsonRes);

                                                                                                                                                               

io:println(dt);
    string [] pr_commit_id = [];
    int last_index = 0;


    while (dt.hasNext()) {
        var rs, _ = (PATCH_ETA)dt.getNext();
      //  io:println("Patch ETA:"+ rs.ID + "|" + rs.SVN_GIT_PUBLIC +  "|" + rs.SVN_GIT_SUPPORT +  "|" + rs.SVN_GIT_SUPPORT.length());
        boolean has_pub_git_id = false;
        if (rs.SVN_GIT_PUBLIC != null && !NA.equalsIgnoreCase(rs.SVN_GIT_PUBLIC)) {
            string[] git_sha_ids = rs.SVN_GIT_PUBLIC.split(",");

            foreach id in git_sha_ids {
               // Regex reg = {pattern:"^[a-fA-F0-9]{40}$"};
                var idbool, _ = id.trim().matchesWithRegex(REGEX);
                has_pub_git_id = idbool ? idbool : has_pub_git_id;
                if (idbool) {
                    pr_commit_id[last_index] = id.trim() + "_public";
                    last_index = last_index + 1;
                }
                //io:println("Public GITHUB SHA IDs : " + id + "  |  " + idbool);
            }

        }

        if (!has_pub_git_id && rs.SVN_GIT_SUPPORT != null && !NA.equalsIgnoreCase(rs.SVN_GIT_SUPPORT)) {
            string[] git_sha_ids = rs.SVN_GIT_SUPPORT.split(",");

            foreach id in git_sha_ids {
                var idbool, _ = id.trim().matchesWithRegex(REGEX);
                if (idbool) {
                    pr_commit_id[last_index] = id.trim();
                    last_index = last_index + 1;
                }
                //io:println("SUPPORT GITHUB SHA IDs : " + id + "  |  " + idbool);
            }
        }
    }

 //   io:println("GITHUB SHA IDs : " + id );

    foreach id in pr_commit_id {
        io:println("GITHUB SHA IDs : " + id );
    }

}

