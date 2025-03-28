package DAOs;

import DB.DBContext;
import Models.Cart;
import Models.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CartDAO {

    private DBContext db = new DBContext();

    public List<CartItem> viewCart(String customerID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ca.cartID, p.productName, p.price, ca.quantity, c.colorName, s.sizeName, "
                + "STRING_AGG(i.imgName, ', ') AS imgName "
                + "FROM Cart ca "
                + "JOIN ProductVariants pv ON ca.proVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "LEFT JOIN Color c ON pv.colorID = c.colorID "
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                + "LEFT JOIN Image i ON p.productID = i.productID "
                + "WHERE ca.customerID = ? "
                + "GROUP BY ca.cartID, p.productID, p.productName, p.price, ca.quantity, c.colorName, s.sizeName";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String cartID = rs.getString("cartID");
                String productName = rs.getString("productName");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                String colorName = rs.getString("colorName");
                String sizeName = rs.getString("sizeName");
                String imgNames = rs.getString("imgName");

                cartItems.add(new CartItem(cartID, productName, price, quantity, colorName, sizeName, imgNames));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public boolean updateCartItemQuan(String cartID, int quantity) {
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement("UPDATE Cart SET quantity = ? WHERE cartID = ?")) {
            ps.setInt(1, quantity);
            ps.setString(2, cartID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItem> getCartItemsByCustomerID(String customerID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.cartID, c.productID, p.productName, c.quantity, p.price "
                + "FROM Cart c "
                + "JOIN ProductVariants v ON c.proVariantID = v.proVariantID "
                + "JOIN Product p ON c.productID = p.productID "
                + "WHERE c.customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartID(rs.getString("cartID"));  // Thêm cartID
                item.setProductID(rs.getString("productID"));
                item.setProductName(rs.getString("productName"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                cartItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public int getStockQuantityByCartItem(String cartID) {
        int stockQuantity = 0;
        String sql = "SELECT pv.stockQuantity "
                + "FROM ProductVariants pv "
                + "JOIN Cart c ON c.proVariantID = pv.proVariantID "
                + "WHERE c.cartID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cartID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stockQuantity = rs.getInt("stockQuantity");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stockQuantity;
    }

    public String getCartIDByCustomerIDAndProductID(String customerID, String productID) {
        String query = "SELECT c.cartID FROM Cart c "
                + "JOIN ProductVariants pv ON c.proVariantID = pv.proVariantID "
                + "WHERE c.customerID = ? AND pv.productID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ps.setString(2, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("cartID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addToCart(Cart cartItem) {
        String checkQuery = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
        String updateQuery = "UPDATE Cart SET quantity = quantity + ? WHERE customerID = ? AND productID = ? AND proVariantID = ?";
        String insertQuery = "INSERT INTO Cart (cartID, customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DBContext.getConn();  PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            checkStmt.setString(1, cartItem.getCustomerID());
            checkStmt.setString(2, cartItem.getProductID());
            checkStmt.setString(3, cartItem.getProVariantID());

            try ( ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    try ( PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                        updateStmt.setInt(1, cartItem.getQuantity());
                        updateStmt.setString(2, cartItem.getCustomerID());
                        updateStmt.setString(3, cartItem.getProductID());
                        updateStmt.setString(4, cartItem.getProVariantID());
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    try ( PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setString(1, cartItem.getCartID());
                        insertStmt.setString(2, cartItem.getCustomerID());
                        insertStmt.setString(3, cartItem.getProductID());
                        insertStmt.setString(4, cartItem.getProVariantID());
                        insertStmt.setInt(5, cartItem.getQuantity());
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCartItem(Cart cart) {
        String query = "UPDATE Cart SET customerID = ?, productID = ?, proVariantID = ?, quantity = ? WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, cart.getCustomerID());
            stmt.setString(2, cart.getProductID());
            stmt.setString(3, cart.getProVariantID());
            stmt.setInt(4, cart.getQuantity());
            stmt.setString(5, cart.getCartID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
//
//    public void removeFromCart(String customerID, String productID) {
//        String sql = "DELETE FROM Cart WHERE customerID = ? AND productID = ?";
//        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, customerID);
//            ps.setString(2, productID);
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }

    public boolean removeFromCart(String cartID) {
        String sql = "DELETE FROM Cart WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cartID);
            int affectedRows = stmt.executeUpdate();

            return affectedRows > 0; // Trả về true nếu có dòng bị xóa
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getProductPrice(String productID) {
        double price = 0;
        String query = "SELECT price FROM Products WHERE productID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getDouble("price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }

    public String getProductIDByItem(CartItem item) {
        String productID = null;
        String sql = "SELECT p.productID FROM Product p "
                + "JOIN ProductVariants pv ON p.productID = pv.productID "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "WHERE p.productName = ? AND c.colorName = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getProductName());
            ps.setString(2, item.getColorName());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                productID = rs.getString("productID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productID;
    }

    public void clearCart(String customerID) {
        String query = "DELETE FROM Cart WHERE customerID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, customerID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
