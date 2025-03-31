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
        String sql = "SELECT c.cartID, c.proVariantID, c.quantity, p.productName, "
                + "p.price, col.colorName, s.sizeName, img.imgName "
                + "FROM Cart c "
                + "JOIN ProductVariants pv ON c.proVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "LEFT JOIN Color col ON pv.colorID = col.colorID "
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                + "LEFT JOIN Image img ON p.productID = img.productID "
                + "WHERE c.customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartID(rs.getString("cartID"));
                    item.setProVariantID(rs.getString("proVariantID"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("productName"));
                    item.setPrice(rs.getDouble("price"));
                    item.setColorName(rs.getString("colorName"));
                    item.setSizeName(rs.getString("sizeName"));
                    item.setImgNames(rs.getString("imgName"));
                    cartItems.add(item);
                }
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
        String sql = "SELECT c.cartID, p.productID, p.productName, c.quantity, p.price, "
                + "v.proVariantID, col.colorName, s.sizeName, "
                + "(SELECT TOP 1 imgName FROM Image WHERE productID = p.productID) as imgName "
                + "FROM Cart c "
                + "JOIN ProductVariants v ON c.proVariantID = v.proVariantID "
                + "JOIN Product p ON v.productID = p.productID "
                + "LEFT JOIN Color col ON v.colorID = col.colorID "
                + "LEFT JOIN Size s ON v.sizeID = s.sizeID "
                + "WHERE c.customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartID(rs.getString("cartID"));
                item.setProductID(rs.getString("productID"));
                item.setProductName(rs.getString("productName"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setProVariantID(rs.getString("proVariantID"));
                item.setColorName(rs.getString("colorName"));
                item.setSizeName(rs.getString("sizeName"));
                item.setImgNames(rs.getString("imgName"));
                cartItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public int getStockQuantityByCartItem(String cartID) {
        int stockQuantity = 0;
        String sql = "SELECT pv.stockQuantity FROM ProductVariants pv "
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
        // First check stock availability
        String stockQuery = "SELECT pv.stockQuantity FROM ProductVariants pv WHERE pv.proVariantID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stockStmt = conn.prepareStatement(stockQuery)) {

            stockStmt.setString(1, cartItem.getProVariantID());
            try ( ResultSet rs = stockStmt.executeQuery()) {
                if (!rs.next()) {
                    return false; // Variant not found
                }

                int stockQuantity = rs.getInt("stockQuantity");
                int cartQuantity = getCartQuantity(cartItem.getCustomerID(), cartItem.getProVariantID());

                // Check if adding this quantity would exceed stock
                if (cartQuantity + cartItem.getQuantity() > stockQuantity) {
                    return false;
                }
            }

            // Proceed with add/update if stock is sufficient
            String checkQuery = "SELECT quantity FROM Cart WHERE customerID = ? AND proVariantID = ?";
            String updateQuery = "UPDATE Cart SET quantity = quantity + ? WHERE customerID = ? AND proVariantID = ?";
            String insertQuery = "INSERT INTO Cart (cartID, customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?, ?)";

            try ( PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setString(1, cartItem.getCustomerID());
                checkStmt.setString(2, cartItem.getProVariantID());

                try ( ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        try ( PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                            updateStmt.setInt(1, cartItem.getQuantity());
                            updateStmt.setString(2, cartItem.getCustomerID());
                            updateStmt.setString(3, cartItem.getProVariantID());
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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

    public int getCartQuantity(String customerID, String variantId) {
        String query = "SELECT SUM(quantity) FROM Cart WHERE customerID = ? AND proVariantID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ps.setString(2, variantId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            // Log the error and return 0
            System.err.println("Error getting cart quantity for customer: " + customerID
                    + " and variant: " + variantId);
            e.printStackTrace();
            return 0;
        }
    }

    public String getVariantIdByCartId(String cartID) {
        String query = "SELECT proVariantID FROM Cart WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, cartID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    // Log the error and return null if item not found
                    System.err.println("No cart item found with ID: " + cartID);
                    return null;
                }
                return rs.getString("proVariantID");
            }
        } catch (SQLException e) {
            // Log the error and return null
            System.err.println("Error getting variant ID for cart: " + cartID);
            e.printStackTrace();
            return null;
        }
    }

    public int getCurrentQuantity(String cartID) {
        String query = "SELECT quantity FROM Cart WHERE cartID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, cartID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    // Log the error and return 0 if item not found
                    System.err.println("No cart item found with ID: " + cartID);
                    return 0;
                }
                return rs.getInt("quantity");
            }
        } catch (SQLException e) {
            // Log the error and return 0
            System.err.println("Error getting quantity for cart: " + cartID);
            e.printStackTrace();
            return 0;
        }
    }

    public int getTotalQuantityForVariantExcludingCartItem(String customerID, String variantId, String excludeCartID) {
        String query = "SELECT SUM(quantity) FROM Cart WHERE customerID = ? AND proVariantID = ? AND cartID != ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ps.setString(2, variantId);
            ps.setString(3, excludeCartID);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            // Log the error and return 0
            System.err.println("Error calculating total quantity for variant: " + variantId);
            e.printStackTrace();
            return 0;
        }
    }
}
