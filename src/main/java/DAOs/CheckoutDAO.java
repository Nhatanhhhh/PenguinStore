/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Loc_LM
 */
package DAOs;

import Models.Cart;
import Models.Customer;
import Models.Product;
import Models.ProductVariant;
import DB.DBContext;
import Models.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CheckoutDAO {

    private DBContext dbContext = new DBContext();

        public List<CartItem> viewCart(String customerID) {
            List<CartItem> cartItems = new ArrayList<>();
            String sql = "SELECT p.productName, "
                    + "       p.price, "
                    + "       ca.quantity, "
                    + "       c.colorName, "
                    + "       STRING_AGG(i.imgName, ', ') AS imgName "
                    + "FROM Cart ca "
                    + "JOIN ProductVariants pv ON ca.proVariantID = pv.proVariantID "
                    + "JOIN Product p ON pv.productID = p.productID "
                    + "JOIN Color c ON pv.colorID = c.colorID "
                    + "LEFT JOIN Image i ON p.productID = i.productID "
                    + "WHERE ca.customerID = ? "
                    + "GROUP BY p.productID, p.productName, p.price, ca.quantity, c.colorName";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String productName = rs.getString("productName");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                String colorName = rs.getString("colorName");
                String imgNames = rs.getString("imgName"); // Chuỗi các tên ảnh, cách nhau bởi dấu phẩy

                cartItems.add(new CartItem(productName, price, quantity, colorName, imgNames));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    

}
