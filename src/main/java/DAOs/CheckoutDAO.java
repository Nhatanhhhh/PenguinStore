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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CheckoutDAO {

    private DBContext dbContext = new DBContext();

    public Customer getCustomerInfo(String customerID) {
        Customer customer = null;
        String sql = "SELECT customerID, fullName, email, address, zip, state FROM Customer WHERE id = ?";

        try ( ResultSet rs = dbContext.execSelectQuery(sql, new Object[]{customerID})) {
            if (rs.next()) {
                customer = new Customer(
                        rs.getString("customerID"), // Đổi từ rs.getInt() sang rs.getString() nếu customerID là String
                        rs.getString("userName"),
                        rs.getString("passWord"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("googleID"),
                        rs.getString("accessToken"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"), // Đảm bảo phoneNumber trong database là kiểu số
                        rs.getString("zip"),
                        rs.getString("state"),
                        rs.getBoolean("isVerified") // Nếu cột này là boolean trong DB
                );
            }
        } catch (SQLException e) {
            Logger.getLogger(CheckoutDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return customer;
    }

    public List<Cart> getCartItems(String customerID) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT cartID, customerID, proVariantID, productID, quantity FROM Cart WHERE customerID = ?";

        try ( ResultSet rs = dbContext.execSelectQuery(sql, new Object[]{customerID})) {
            while (rs.next()) {
                int productID = rs.getInt("productID");
                Product product = getProductDetails(productID);
                cartItems.add(new Cart(
                        rs.getInt("cartID"),
                        rs.getInt("customerID"),
                        rs.getInt("proVariantID"),
                        productID,
                        rs.getInt("quantity")));
            }
        } catch (SQLException e) {
            Logger.getLogger(CheckoutDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return cartItems;
    }

    private Product getProductDetails(int productID) {
        String sql = "SELECT productID, productName, price FROM Product WHERE id = ?";
        try ( ResultSet rs = dbContext.execSelectQuery(sql, new Object[]{productID})) {
            if (rs.next()) {
                return new Product(
                        rs.getString("productID"),
                        rs.getString("productName"),
                        rs.getDouble("price"));
            }
        } catch (SQLException e) {
            Logger.getLogger(CheckoutDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return null;
    }

    public double calculateSubtotal(String customerId) {
        double subtotal = 0.0;
        List<Cart> cartItems = getCartItems(customerId);

        for (Cart cartItem : cartItems) {
            Product product = getProductDetails(cartItem.getProductID());
            if (product != null) {
                subtotal += product.getPrice() * cartItem.getQuantity();
            }
        }
        return subtotal;
    }

}