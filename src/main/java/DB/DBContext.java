/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DB;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class DBContext {

    private static Connection conn;

    public static Connection getConn() {
        Connection conn;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=PenguinDB;user=sa;password=23032004;encrypt=false";
            conn = DriverManager.getConnection(url);
        } catch (Exception ex) {
            conn = null;
        }
        return conn;
    }

    /**
     * Executes a SELECT query with parameters.
     *
     * @param query SQL query string
     * @param params Query parameters
     * @return ResultSet containing query results
     * @throws SQLException if a database error occurs
     */
    public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        Connection connection = getConn();
        if (connection == null) {
            throw new SQLException("Unable to establish a database connection.");
        }
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        return preparedStatement.executeQuery();
    }

    /**
     * Executes a SELECT query without parameters.
     *
     * @param query SQL query string
     * @return ResultSet containing query results
     * @throws SQLException if a database error occurs
     */
    public ResultSet execSelectQuery(String query) throws SQLException {
        return execSelectQuery(query, null);
    }

    /**
     * Executes an INSERT, UPDATE, or DELETE query.
     *
     * @param query SQL query string
     * @param params Query parameters
     * @return Number of affected rows
     * @throws SQLException if a database error occurs
     */
    public int execQuery(String query, Object[] params) throws SQLException {
        try ( Connection connection = getConn();  PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            if (connection == null) {
                throw new SQLException("Unable to establish a database connection.");
            }

            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    preparedStatement.setObject(i + 1, params[i]);
                }
            }
            return preparedStatement.executeUpdate();
        }
    }

    /**
     * Hashes a password using MD5 algorithm
     *
     * @param password - The plain text password to hash
     * @return A string representing the MD5 hashed password
     */
    public static String hashPasswordMD5(String password) {
        String hashedPassword = null;
        if (password != null) {
            try {
                MessageDigest md = MessageDigest.getInstance("MD5");
                md.update(password.getBytes());
                byte[] digest = md.digest();
                StringBuilder sb = new StringBuilder();
                for (byte b : digest) {
                    sb.append(String.format("%02x", b & 0xff));
                }
                hashedPassword = sb.toString();
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
        }
        return hashedPassword;
    }
}
