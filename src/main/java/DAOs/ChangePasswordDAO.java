/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class ChangePasswordDAO {

    public boolean checkPassword(String username, String oldPassword) throws SQLException {
        String sql = "SELECT password FROM Customer WHERE customerName = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConn();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                String currentPassword = rs.getString("password");
                // So sánh mật khẩu cũ với mật khẩu hiện tại
                return currentPassword.equals(oldPassword);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return false;
    }
    // Phương thức cập nhật mật khẩu mới

    public void updatePassword(String username, String newPassword) throws SQLException {
        String sql = "UPDATE Customer SET password = ? WHERE customerName = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBContext.getConn();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    public Customer getCustomerByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE customerName = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Customer customer = null;

        try {
            conn = DBContext.getConn();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                customer = new Customer();
                customer.setCustomerID(rs.getString("customerID"));
                customer.setUserName(rs.getString("customerName"));
                customer.setPassWord(rs.getString("password"));
                customer.setFullName(rs.getString("fullName"));
                customer.setEmail(rs.getString("email"));
                customer.setGoogleID(rs.getString("googleID"));
                customer.setAccessToken(rs.getString("accessToken"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phoneNumber"));
                customer.setZip(rs.getString("zip"));
                customer.setState(rs.getString("state"));
                customer.setIsVerified(rs.getBoolean("isVerified"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return customer;
    }

}
