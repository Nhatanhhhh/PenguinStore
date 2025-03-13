/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import DTO.ShowCusDTO;
import Models.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class CustomerDAO {

    private final DBContext dbContext;

    public CustomerDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Retrieve customer information using username and password (hashed)
     *
     * @param username Username
     * @param hashedPassword Password encrypted with MD5
     * @return Customer object if found, otherwise null
     */
    public static Customer getCustomerByUsernameAndPassword(String username, String hashedPassword) {
        Customer customer = null;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConn();
            String sql = "SELECT * FROM Customer WHERE customerName = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);

            rs = ps.executeQuery();
            if (rs.next()) {
                customer = new Customer(
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close rs, ps, conn to avoid connection leaks
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return customer;
    }

    /**
     * Register a new user
     *
     * @param customer Customer object containing user information
     * @return True if registration is successful, otherwise False
     */
    public static boolean registerCustomer(Customer customer) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isSuccess = false;

        // Hash the password before saving to DB
        String hashedPassword = DBContext.hashPasswordMD5(customer.getPassWord());

        try {
            conn = DBContext.getConn();
            String sql = "INSERT INTO Customer (customerID, customerName, password, fullName, email, "
                    + "address, phoneNumber, state, zip, isVerified) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);

            ps.setString(1, customer.getCustomerID());
            ps.setString(2, customer.getUserName());
            ps.setString(3, hashedPassword);
            ps.setString(4, customer.getFullName());
            ps.setString(5, customer.getEmail());
            ps.setString(6, customer.getAddress());
            ps.setString(7, customer.getPhoneNumber());
            ps.setString(8, customer.getState());
            ps.setString(9, customer.getZip());
            ps.setBoolean(10, customer.isIsVerified());

            int rowsAffected = ps.executeUpdate();
            isSuccess = (rowsAffected > 0);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close ps, conn
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return isSuccess;
    }

    /**
     * Retrieve a list of customers
     *
     * @return ArrayList containing customer details
     */
    public ArrayList<ShowCusDTO> getListCus() {
        ArrayList<ShowCusDTO> getListCustomer = new ArrayList<>();

        String query = "SELECT customerName, fullName, address, email, phoneNumber, state, zip FROM Customer";

        try (ResultSet rs = dbContext.execSelectQuery(query)) {
            while (rs.next()) {
                getListCustomer.add(new ShowCusDTO(
                        rs.getString("customerName"),
                        rs.getString("fullName"),
                        rs.getString("address"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("state"),
                        rs.getString("zip")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return getListCustomer;
    }
}
