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
 * DAO class for handling user registration.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class RegisterDAO {

    /**
     * Checks if a username already exists in the database.
     */
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

    /**
     * Checks if an email is already registered.
     */
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

    /**
     * Registers a new user.
     */
    public String registerUser(String username, String password, String fullName, String email, String phone) {
        Connection connection = DBContext.getConn();
        String insertQuery = "INSERT INTO Customer (customerName, password, fullName, email, phoneNumber, isVerified) VALUES (?,?,?,?,?, 1)";
        PreparedStatement insertStatement = null;

        try {
            insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setString(1, username);
            insertStatement.setString(2, password);  // Should be encrypted before storing
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

    /**
     * Retrieves user ID based on the provided email.
     */
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

    /**
     * Retrieves user details by email.
     */
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

    /**
     * Registers a new user via Google authentication.
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

    /**
     * Generates a random password.
     */
    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[12]; // Password length: 12 characters
        random.nextBytes(bytes);
        return Base64.getEncoder().encodeToString(bytes).substring(0, 12); // Take the first 12 characters
    }

    /**
     * Closes SQL resources.
     */
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
}
