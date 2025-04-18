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
import Models.UsedVoucher;
import static com.fasterxml.jackson.databind.jsonFormatVisitors.JsonValueFormat.UUID;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
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

    public double getVoucherDiscount(String voucherID) {
        double discount = 0;
        String sql = "SELECT discountAmount, minOrderValue, validFrom, validUntil, voucherStatus "
                + "FROM Vouchers "
                + "WHERE voucherID = ? "
                + "AND voucherStatus = 1 "
                + "AND validFrom <= GETDATE() "
                + "AND validUntil >= GETDATE()";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucherID);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Kiểm tra ngày hiệu lực và trạng thái voucher
                    if (rs.getInt("voucherStatus") == 1) {
                        discount = rs.getDouble("discountAmount");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discount;
    }

    public UsedVoucher getUsedVoucherByCode(String customerID, String voucherCode) {
        String query = "SELECT uv.[usedVoucherID], uv.[voucherID], uv.[customerID], uv.[usedAt], uv.[status], "
                + "v.[voucherCode], v.[discountAmount], v.[minOrderValue], "
                + "v.[validFrom], v.[validUntil] "
                + "FROM dbo.[UsedVoucher] uv "
                + "JOIN dbo.[Vouchers] v ON uv.[voucherID] = v.[voucherID] "
                + "WHERE uv.[customerID] = ? AND v.[voucherCode] = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ps.setString(2, voucherCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UsedVoucher(
                        rs.getString("usedVoucherID"),
                        rs.getString("voucherID"),
                        rs.getString("customerID"),
                        rs.getString("voucherCode"),
                        rs.getDate("usedAt"),
                        rs.getInt("status"),
                        rs.getDouble("discountAmount"),
                        rs.getDouble("minOrderValue"),
                        rs.getDate("validFrom"),
                        rs.getDate("validUntil")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getVoucherIDByCode(String voucherCode) {
        String voucherID = null;
        String sql = "SELECT voucherID FROM Vouchers WHERE voucherCode = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, voucherCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                voucherID = rs.getString("voucherID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return voucherID;
    }

    public void updateUsedVoucherStatus(String customerID, String voucherID) {
        String sql = "UPDATE UsedVoucher SET status = 1, usedAt = ? WHERE customerID = ? AND voucherID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, LocalDate.now().toString());
            stmt.setString(2, customerID);
            stmt.setString(3, voucherID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Customer getCustomerByID(String customerID) {
        Customer customer = null;
        String query = "SELECT customerID, customerName, fullName, email, address, phoneNumber, state, zip "
                + "FROM Customer WHERE customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                customer = new Customer(
                        rs.getString("customerID"),
                        rs.getString("customerName"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("state"),
                        rs.getString("zip")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    public String getProductVariantID(String productID, String colorName, String sizeName) {
        String proVariantID = null;
        String sql = "SELECT pv.proVariantID "
                + "FROM ProductVariants pv "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "JOIN Size s ON pv.sizeID = s.sizeID "
                + "WHERE pv.productID = ? "
                + "AND c.colorName = ? "
                + "AND s.sizeName = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productID);
            ps.setString(2, colorName);
            ps.setString(3, sizeName);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    proVariantID = rs.getString("proVariantID");
                } else {
                    System.out.println("No ProductVariant found for ProductID=" + productID
                            + ", Color=" + colorName + ", Size=" + sizeName);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return proVariantID;
    }

    public String getProductIDByCartItem(String cartID) {
        String productID = null;
        String sql = "SELECT pv.productID "
                + "FROM Cart c "
                + "JOIN ProductVariants pv ON c.proVariantID = pv.proVariantID "
                + "WHERE c.cartID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cartID);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    productID = rs.getString("productID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productID;
    }

    public List<String> getProductVariantIDs(String cartID, String customerID, String productID) {
        List<String> variantIDs = new ArrayList<>();
        String sql = "SELECT proVariantID FROM Cart WHERE cartID = ? AND customerID = ? AND productID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, cartID);
            stmt.setString(2, customerID);
            stmt.setString(3, productID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                variantIDs.add(rs.getString("proVariantID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return variantIDs;
    }

    public String getPendingStatusOID() {
        String sql = "SELECT statusOID FROM StatusOrder WHERE statusName = 'Pending processing'";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("statusOID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy
    }

    public double getProductPrice(String productID) {
        double price = 0;
        String sql = "SELECT price FROM Product WHERE productID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("price");
            } else {
                System.out.println("No product found with ID: " + productID);
            }
        } catch (SQLException e) {
            System.err.println("Error getting product price for ID: " + productID);
            e.printStackTrace();
        }

        return price;
    }

}
