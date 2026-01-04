package com.warehouse.config;
import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/arinest?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"";
    private static final String USER = "warehouse_user";
    private static final String PASSWORD = "jens123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}

