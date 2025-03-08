/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

/**
 *
 * @author PC
 */

import DB.DBContext;
import Models.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * DAO class for Order
 * @author Nhat_Anh
 */
public class OrderDAO {
private DBContext db = new DBContext();
    public List<Order> getOrdersByCustomerID(String customerID) {
        List<Order> orderList = new ArrayList<>();
        String query = "SELECT orderID, totalAmount, discountAmount, finalAmount, orderDate, statusOID, voucherID FROM [Order] WHERE customerID = ?";
        
        try (Connection conn = DBContext.getConn();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setDiscountAmount(rs.getDouble("discountAmount"));
                order.setFinalAmount(rs.getDouble("finalAmount"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setStatusOID(rs.getString("statusOID"));
                order.setVoucherID(rs.getString("voucherID"));
                order.setCustomerID(customerID);
                
                orderList.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }
    public String createOrder(Order order) {
        String orderID = UUID.randomUUID().toString();
        String sql = "INSERT INTO Orders (orderID, customerID, totalAmount, discountAmount, finalAmount, orderDate, statusOID, voucherID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            db.execQuery(sql, new Object[]{
                orderID,
                order.getCustomerID(),
                order.getTotalAmount(),
                order.getDiscountAmount(),
                order.getFinalAmount(),
                new java.sql.Date(order.getOrderDate().getTime()),
                order.getStatusOID(),
                order.getVoucherID()
            });
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderID;
    }
}