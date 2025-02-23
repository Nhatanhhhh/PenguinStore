/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo The Vinh - CE567889
 */
public class DBContext {

    private Connection conn;

    // Phuong thuc khoi tao
    public DBContext() {
        try {
            String user = "sa";
            String url = "jdbc:sqlserver://127.0.0.1:1433;databaseName=PenguinDB;encrypt=false";
            String pass = "12345";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, user, pass);
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    // Lay connection
    public Connection getConnection() {
        return conn;
    }

    // Ph??ng th?c cho các l?nh SELECT (có params)
    public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(query);

        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        return preparedStatement.executeQuery();
    }

    // Ph??ng th?c cho các l?nh SELECT không có params 
    public ResultSet execSelectQuery(String query) throws SQLException {
        return this.execSelectQuery(query, null);
    }

    //Ph??ng th?c cho các l?nh INSERT, UPDATE, DELETE 
    public int execQuery(String query, Object[] params) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(query);

        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        return preparedStatement.executeUpdate();
    }
}
