package com.example.demo;

import java.io.*;
import java.sql.*;
import org.json.*;

public class QueryResponse {

    public String connectToPostGresRunCustomQueryAndClose(String usr, String pwd, String query) throws SQLException {
        ResultSet resultSet = null;
        String json = "";
        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5433/beacon", usr, pwd)) {
            System.out.println("Connected to PostgreSQL database!");
            Statement statement = connection.createStatement();
            resultSet = statement.executeQuery(query);
            json = getJsonString(resultSet);

        } catch (SQLException e) {
            System.out.println("Connection failure");
            e.printStackTrace();
        }
        return json;
    }

    public String connectToPostGresRunVersionedQueryAndClose(String usr, String pwd, String alias) throws SQLException, IOException {
        String versionedQuery = getVersionedQuery(usr, pwd, alias);
        ResultSet resultSet = null;
        String json = "";
        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5433/beacon", usr, pwd)) {
            System.out.println("Connected to PostgreSQL database!");
            Statement statement = connection.createStatement();
            resultSet = statement.executeQuery(versionedQuery);

            json = getJsonString(resultSet);

        } catch (SQLException e) {
            System.out.println("Connection failure");
            e.printStackTrace();
        }
        return json;
    }

    public String getVersionedQuery(String usr, String pwd, String alias) throws SQLException, IOException {

        String query = null;
        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5433/postgres", usr, pwd)) {
            System.out.println("Connected to PostgreSQL database!");
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT query FROM public.\"QA_QUERIES\" WHERE name = '" + alias + "'");
            while (resultSet.next()) {
                query = resultSet.getString("query");
            }

        } catch (SQLException e) {
            System.out.println("Connection failure");
            e.printStackTrace();
        }
        return query;
    }

    public String getJsonString(ResultSet resultSet) throws SQLException {
        String jsonString = "";
        JSONObject jsonobject = null;
        JSONArray jsonArray = new JSONArray();

        while (resultSet.next()) {
            ResultSetMetaData metaData = resultSet.getMetaData();
            jsonobject = new JSONObject();

            for (int i = 0; i < metaData.getColumnCount(); i++) {
                jsonobject.put(metaData.getColumnLabel(i + 1), resultSet.getObject(i + 1));
            }
            jsonArray.put(jsonobject);
        }

        if (jsonArray.length() > 0) {
            jsonString = jsonArray.toString();
        }

        System.out.println(jsonString);
        return jsonString;
    }
}
