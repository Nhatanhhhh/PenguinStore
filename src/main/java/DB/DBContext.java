/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DB;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nhat_Anh
 */
public class DBContext {

    private static Connection conn;

    public static Connection getConn() {
        if (conn == null) {
            try {
                String user = "nhatanh";
                String pass = "123";
                String url = "jdbc:sqlserver://localhost:1433;databaseName=EbookApp;encrypt=false";

                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection(url, user, pass);

            } catch (SQLException | ClassNotFoundException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return conn;
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
