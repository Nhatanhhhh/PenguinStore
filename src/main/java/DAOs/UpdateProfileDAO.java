package DAOs;

import DB.DBContext;
import Models.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * DAO class for managing Customer profile updates and retrieval.
 * @author Nguyen Nhat Anh - CE181843
 */
public class UpdateProfileDAO {

    /**
     * Updates customer profile based on customerID.
     *
     * @param customer Customer object with updated details
     * @return true if update was successful, otherwise false
     * @throws SQLException
     */
    public boolean updateCustomer(Customer customer) throws SQLException {
        String sql = "UPDATE Customer SET fullName = ?, phoneNumber = ?, address = ?, state = ?, zip = ? WHERE customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Use setString for phoneNumber to avoid issues with formatting (e.g., dashes, leading zeros).
            ps.setString(1, customer.getFullName()); // fullName is a string, so using setString
            ps.setString(2, String.valueOf(customer.getPhoneNumber())); // changed to setString for phoneNumber
            ps.setString(3, customer.getAddress());  // address is string
            ps.setString(4, customer.getState());    // state is string
            ps.setString(5, customer.getZip());      // zip is string
            ps.setString(6, customer.getCustomerID()); // customerID is a string

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Updates customer profile based on email.
     *
     * @param customer Customer object with updated details
     * @return true if update was successful, otherwise false
     * @throws SQLException
     */
    public boolean updateCustomerByEmail(Customer customer) throws SQLException {
        String sql = "UPDATE Customer SET phoneNumber = ?, address = ?, state = ?, zip = ? WHERE email = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, String.valueOf(customer.getPhoneNumber())); // changed to setString for phoneNumber
            ps.setString(2, customer.getAddress());  // address is string
            ps.setString(3, customer.getState());    // state is string
            ps.setString(4, customer.getZip());      // zip is string
            ps.setString(5, customer.getEmail());    // email is string

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Retrieves a customer by email.
     *
     * @param email Customer email
     * @return Customer object if found, otherwise null
     * @throws SQLException
     */
    public Customer getCustomerByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE email = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getString("customerID"),
                            rs.getString("customerName"),
                            rs.getString("password"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("googleID"),
                            rs.getString("accessToken"),
                            rs.getString("address"),
                            rs.getString("phoneNumber"),
                            rs.getString("zip"),
                            rs.getString("state"),
                            rs.getBoolean("isVerified")
                    );
                }
            }
        }
        return null;
    }
}
