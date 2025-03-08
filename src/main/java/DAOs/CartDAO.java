package DAOs;

import DB.DBContext;
import Models.Cart;
import Models.CartItem;
import Models.ProductVariant;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Loc_LM
 */
public class CartDAO {

    private DBContext db = new DBContext();


    public List<CartItem> viewCart(String customerID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT p.productName, p.price, c.colorName, ca.quantity "
                + "FROM Cart ca "
                + "JOIN ProductVariants pv ON ca.proVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "WHERE ca.customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
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

    public List<Cart> getCartByCustomerID(int customerID) {
        List<Cart> cartList = new ArrayList<>();
        String sql = "SELECT * FROM Cart WHERE customerID = ?";
        try {
            ResultSet rs = db.execSelectQuery(sql, new Object[]{customerID});
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartID(rs.getInt("cartID"));
                cart.setCustomerID(rs.getInt("customerID"));
                cart.setProVariantID(rs.getInt("proVariantID"));
                cart.setProductID(rs.getInt("productID"));
                cart.setQuantity(rs.getInt("quantity"));
                cartList.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartList;
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

    public double getProductPrice(int productID) {
        String sql = "SELECT price FROM Product WHERE id = ?";
        try ( ResultSet rs = db.execSelectQuery(sql, new Object[]{productID})) {
            if (rs.next()) {
                return rs.getDouble("price");
            }
        } catch (SQLException e) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return 0;
    }

    public boolean updateCartItem(Cart cart) {
        String query = "UPDATE Cart SET customerID = ?, productID = ?, proVariantID = ?, quantity = ? WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cart.getCustomerID());
            stmt.setInt(2, cart.getProductID());
            stmt.setInt(3, cart.getProVariantID());
            stmt.setInt(4, cart.getQuantity());
            stmt.setInt(5, cart.getCartID());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCartItem(int cartID) {
        String query = "DELETE FROM Cart WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, cartID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void clearCart(int customerID) {
        String query = "DELETE FROM Cart WHERE customerID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}