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
 * @author Nhat_Anh
 */
public class CustomerDAO {

    private final DBContext dbContext;

    public CustomerDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * L?y thông tin khách hàng t? username và m?t kh?u (?ã hash)
     *
     * @param username Tên ng??i dùng
     * @param password M?t kh?u ch?a mã hóa (s? ???c mã hóa trong hàm này)
     * @return ??i t??ng Customer n?u tìm th?y, ng??c l?i tr? v? null
     */
    public Customer getCustomerByUsernameAndPassword(String username, String hashedPassword) {
        Customer customer = null;
        
        String query = "SELECT * FROM Customer WHERE customerName = ? AND password = ?";
        Object[] params = {username, hashedPassword};
        
        try ( ResultSet rs = dbContext.execSelectQuery(query, params)) {
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
                        rs.getInt("phoneNumber"),
                        rs.getString("state"),
                        rs.getString("zip"),
                        rs.getBoolean("isVerified")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customer;
    }

    /**
     * ??ng ký ng??i dùng m?i
     *
     * @param customer ??i t??ng Customer ch?a thông tin ng??i dùng
     * @return True n?u ??ng ký thành công, ng??c l?i False
     */
    public boolean registerCustomer(Customer customer) {
        String query = "INSERT INTO Customer (customerID, customerName, password, fullName, email, address, phoneNumber, state, zip, isVerified) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Mã hóa m?t kh?u tr??c khi l?u vào DB
        String hashedPassword = DBContext.hashPasswordMD5(customer.getPassWord());

        Object[] params = {
            customer.getCustomerID(),
            customer.getUserName(),
            hashedPassword,
            customer.getFullName(),
            customer.getEmail(),
            customer.getAddress(),
            customer.getPhoneNumber(),
            customer.getState(),
            customer.getZip(),
            customer.isIsVerified()
        };

        try {
            return dbContext.execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
