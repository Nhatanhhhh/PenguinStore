package DAOs;

import DB.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AddCartDAO {
    private static final Logger LOGGER = Logger.getLogger(AddCartDAO.class.getName());

    public boolean isVariantValid(String productID, String variantId) {
        String checkSql = "SELECT 1 FROM ProductVariants WHERE productID = ? AND proVariantID = ? AND status = 1";
        try (Connection conn = DBContext.getConn(); 
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            
            ps.setString(1, productID);
            ps.setString(2, variantId);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking variant validity for product: " + productID + " and variant: " + variantId, e);
            return false;
        }
    }

    public int getStockQuantity(String variantId) {
        String stockQuery = "SELECT stockQuantity FROM ProductVariants WHERE proVariantID = ? AND status = 1";
        try (Connection conn = DBContext.getConn(); 
             PreparedStatement ps = conn.prepareStatement(stockQuery)) {
            
            ps.setString(1, variantId);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("stockQuantity") : 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting stock quantity for variant: " + variantId, e);
            return 0;
        }
    }

    public String getVariantId(String productID, String sizeName, String colorName) {
        String variantQuery = "SELECT TOP 1 pv.proVariantID FROM ProductVariants pv "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                + "WHERE pv.productID = ? AND pv.status = 1 "
                + "AND c.colorName = ? "
                + "AND ((? IS NOT NULL AND s.sizeName = ?) OR (? IS NULL AND s.sizeID IS NULL))";

        try (Connection conn = DBContext.getConn(); 
             PreparedStatement ps = conn.prepareStatement(variantQuery)) {

            ps.setString(1, productID);
            ps.setString(2, colorName);

            if (sizeName != null && !sizeName.isEmpty()) {
                ps.setString(3, sizeName);
                ps.setString(4, sizeName);
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
                ps.setNull(4, java.sql.Types.VARCHAR);
                ps.setNull(5, java.sql.Types.VARCHAR);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("proVariantID") : null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting variant ID for product: " + productID 
                    + ", size: " + sizeName + ", color: " + colorName, e);
            return null;
        }
    }

    public int getCartQuantity(String customerID, String variantId) {
        String query = "SELECT SUM(quantity) FROM Cart WHERE customerID = ? AND proVariantID = ?";
        try (Connection conn = DBContext.getConn(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, customerID);
            ps.setString(2, variantId);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting cart quantity for customer: " + customerID 
                    + " and variant: " + variantId, e);
            return 0;
        }
    }

    public boolean addOrUpdateCart(String customerID, String variantId, int quantity) {
        try (Connection conn = DBContext.getConn()) {
            // First check stock availability
            int stockQuantity = getStockQuantity(variantId);
            int cartQuantity = getCartQuantity(customerID, variantId);
            
            if (quantity + cartQuantity > stockQuantity) {
                LOGGER.log(Level.WARNING, "Attempt to add more than available stock. Customer: " 
                        + customerID + ", Variant: " + variantId + ", Requested: " + quantity 
                        + ", Stock: " + stockQuantity + ", In Cart: " + cartQuantity);
                return false;
            }

            // Check if item exists in cart
            String checkSql = "SELECT quantity FROM Cart WHERE customerID = ? AND proVariantID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, customerID);
                checkPs.setString(2, variantId);

                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        // Update existing item
                        int existingQuantity = rs.getInt("quantity");
                        int newQuantity = existingQuantity + quantity;

                        String updateSql = "UPDATE Cart SET quantity = ? WHERE customerID = ? AND proVariantID = ?";
                        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                            updatePs.setInt(1, newQuantity);
                            updatePs.setString(2, customerID);
                            updatePs.setString(3, variantId);
                            return updatePs.executeUpdate() > 0;
                        }
                    } else {
                        // Add new item
                        String insertSql = "INSERT INTO Cart (cartID, customerID, proVariantID, quantity) "
                                + "VALUES (NEWID(), ?, ?, ?)";
                        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                            insertPs.setString(1, customerID);
                            insertPs.setString(2, variantId);
                            insertPs.setInt(3, quantity);
                            return insertPs.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding/updating cart for customer: " + customerID 
                    + ", variant: " + variantId, e);
            return false;
        }
    }
}