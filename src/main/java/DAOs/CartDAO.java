/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Cart;
import Models.CartItem;
import Models.ProductVariants;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Loc_LM
 */
public class CartDAO {

    public CartDAO(Connection conn) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<CartItem> viewCart(int customerID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT p.productName, p.price, c.colorName, ca.quantity " +
                     "FROM Cart ca " +
                     "JOIN ProductVariants pv ON ca.proVariantID = pv.proVariantID " +
                     "JOIN Product p ON pv.productID = p.productID " +
                     "JOIN Color c ON pv.colorID = c.colorID " +
                     "WHERE ca.customerID = ?";

        try (Connection conn = DBContext.getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String productName = rs.getString("productName");
                double price = rs.getDouble("price");
                String colorName = rs.getString("colorName");
                int quantity = rs.getInt("quantity");

                cartItems.add(new CartItem(productName, price, colorName, quantity));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public boolean addToCart(Cart cartItem) {
        String checkQuery = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
        String updateQuery = "UPDATE Cart SET quantity = quantity + ? WHERE customerID = ? AND productID = ? AND proVariantID = ?";
        String insertQuery = "INSERT INTO Cart (customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?)";

        if (cartItem.getProVariantID() == 0) {
            checkQuery = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID IS NULL";
            updateQuery = "UPDATE Cart SET quantity = quantity + ? WHERE customerID = ? AND productID = ? AND proVariantID IS NULL";
            insertQuery = "INSERT INTO Cart (customerID, productID, quantity) VALUES (?, ?, ?)";
        }

        try ( Connection conn = DBContext.getConn();  PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {

            checkStmt.setInt(1, cartItem.getCustomerID());
            checkStmt.setInt(2, cartItem.getProductID());
            if (cartItem.getProVariantID() != 0) {
                checkStmt.setInt(3, cartItem.getProVariantID());
            }

            try ( ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    try ( PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                        updateStmt.setInt(1, cartItem.getQuantity());
                        updateStmt.setInt(2, cartItem.getCustomerID());
                        updateStmt.setInt(3, cartItem.getProductID());
                        if (cartItem.getProVariantID() != 0) {
                            updateStmt.setInt(4, cartItem.getProVariantID());
                        }
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    try ( PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setInt(1, cartItem.getCustomerID());
                        insertStmt.setInt(2, cartItem.getProductID());

                        if (cartItem.getProVariantID() != 0) {
                            insertStmt.setInt(3, cartItem.getProVariantID());
                            insertStmt.setInt(4, cartItem.getQuantity());
                        } else {
                            insertStmt.setInt(3, cartItem.getQuantity());
                        }

                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
