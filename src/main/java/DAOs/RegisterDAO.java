/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Customer;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class RegisterDAO {

    public boolean isUserExists(String username) {
        Connection connection = DBContext.getConn();
        String checkQuery = "SELECT * FROM Customer WHERE customerName = ?";
        PreparedStatement checkStatement = null;
        ResultSet rs = null;

        try {
            checkStatement = connection.prepareStatement(checkQuery);
            checkStatement.setString(1, username);
            rs = checkStatement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(checkStatement, rs);
        }
    }

    public boolean isEmailExist(String email) {
        Connection connection = DBContext.getConn();
        String checkQuery = "SELECT * FROM Customer WHERE email = ?";
        PreparedStatement checkStatement = null;
        ResultSet rs = null;

        try {
            checkStatement = connection.prepareStatement(checkQuery);
            checkStatement.setString(1, email);
            rs = checkStatement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(checkStatement, rs);
        }
        return false;
    }

    public String registerUser(String username, String password, String fullName, String email, String phone) {
        Connection connection = DBContext.getConn();
        String insertQuery = "INSERT INTO Customer (customerName, password, fullName, email, phoneNumber, isVerified) VALUES (?,?,?,?,?, 1)";
        PreparedStatement insertStatement = null;

        try {
            insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setString(1, username);
            insertStatement.setString(2, password);  // Nên mã hóa trước khi lưu
            insertStatement.setString(3, fullName);
            insertStatement.setString(4, email);
            insertStatement.setString(5, phone);

            int affectedRows = insertStatement.executeUpdate();
            if (affectedRows > 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            return "An error occurred while processing your request.";
        } finally {
            closeResources(insertStatement, null);
        }
        return "An error occurred while processing your request.";
    }

    public String getUserIdByEmail(String email) {
        Connection connection = DBContext.getConn();
        String sql = "SELECT customerID FROM Customer WHERE email = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String customerID = null;

        try {
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            if (rs.next()) {
                customerID = rs.getString("customerID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(stmt, rs);
        }
        return customerID;
    }

    public Customer getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE email = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerID(rs.getString("customerID"));
                    customer.setUserName(rs.getString("customerName"));
                    customer.setPassWord(rs.getString("password"));
                    customer.setFullName(rs.getString("fullName"));
                    customer.setEmail(rs.getString("email"));
                    customer.setPhoneNumber(rs.getString("phoneNumber"));
                    customer.setAddress(rs.getString("address"));
                    customer.setState(rs.getString("state"));
                    customer.setZip(rs.getString("zip"));
                    customer.setIsVerified(rs.getBoolean("isVerified"));
                    return customer;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void closeResources(PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Hàm đăng ký ngư�?i dùng qua Google.
     *
     * @param customerName tên đăng nhập (có thể dùng email nếu chưa có tên
     * riêng)
     * @param fullName H�? và tên của ngư�?i dùng
     * @param email email của ngư�?i dùng
     * @param googleID mã định danh Google (payload.getSubject())
     * @param accessToken token truy cập của Google
     * @param address địa chỉ (nếu có, hoặc truy�?n chuỗi rỗng)
     * @param phone số điện thoại (nếu có, hoặc truy�?n chuỗi rỗng)
     * @param state tỉnh/thành phố (nếu có, hoặc truy�?n chuỗi rỗng)
     * @param zip mã bưu điện (nếu có, hoặc truy�?n chuỗi rỗng)
     * @return "SUCCESS" nếu đăng ký thành công, ngược lại trả v�? thông báo lỗi.
     */
    public String registerUserGoogle(String customerName, String fullName, String email, String googleID,
            String accessToken) {
        Connection connection = DBContext.getConn();
        String insertQuery = "INSERT INTO Customer (customerName, password, fullName, googleID, email, accessToken, isVerified) "
                + "VALUES (?,?,?,?,?,?,1)";
        PreparedStatement insertStatement = null;

        try {
            insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setString(1, customerName);
            String randomPassword = generateRandomPassword();
            String hashedPassword = DBContext.hashPasswordMD5(randomPassword);
            insertStatement.setString(2, hashedPassword);
            insertStatement.setString(3, fullName);
            insertStatement.setString(4, googleID);
            insertStatement.setString(5, email);
            insertStatement.setString(6, accessToken);

            int affectedRows = insertStatement.executeUpdate();
            if (affectedRows > 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            System.out.println("Error in registerUserGoogle: " + e.getMessage());
            return "An error occurred while processing your request.";
        } finally {
            closeResources(insertStatement, null);
        }
        return "An error occurred while processing your request.";
    }

    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[12]; // �?ộ dài mật khẩu 12 ký tự
        random.nextBytes(bytes);
        return Base64.getEncoder().encodeToString(bytes).substring(0, 12); // Chỉ lấy 12 ký tự đầu
    }
}