package com.example.demo;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.sql.SQLException;

@RestController
public class PggController {

    //for more version - controlled queries stored in the db under a certain alias
    @RequestMapping("/ctrlQuery")
    public String ctrlQueryRequest(@RequestParam(value="user") String usr,
                                   @RequestParam(value="pwd") String pwd,
                                   @RequestParam(value="alias") String alias) throws SQLException, IOException {
        QueryResponse response = new QueryResponse();
        return response.connectToPostGresRunVersionedQueryAndClose(usr, pwd, alias);
    }

    //for more ad hoc queries which we create on the fly
    @PostMapping("/adhocQuery")
    public String adhocQueryRequest(@RequestParam(value="user") String usr,
                                    @RequestParam(value="pwd") String pwd,
                                    @RequestParam(value="customQuery") String query) throws SQLException, IOException {
        QueryResponse response = new QueryResponse();
        return response.connectToPostGresRunCustomQueryAndClose(usr, pwd, query);
    }
}
