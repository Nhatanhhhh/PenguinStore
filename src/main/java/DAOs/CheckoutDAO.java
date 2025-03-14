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

    public List<UsedVoucher> getVoucherCheckout(String customerID) {
        List<UsedVoucher> vouchers = new ArrayList<>();
        String sql = "SELECT uv.usedVoucherID, uv.voucherID, uv.customerID, uv.usedAt, uv.status "
                + "FROM UsedVoucher uv "
                + "JOIN Vouchers v ON uv.voucherID = v.voucherID "
                + "WHERE uv.customerID = ? AND uv.status = 0 AND v.validUntil >= GETDATE()";

        try ( Connection conn = dbContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String usedVoucherID = rs.getString("usedVoucherID");
                String voucherID = rs.getString("voucherID");
                String custID = rs.getString("customerID");
                Date usedAt = rs.getTimestamp("usedAt");
                int status = rs.getInt("status");

                vouchers.add(new UsedVoucher(usedVoucherID, voucherID, custID, usedAt, status));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public UsedVoucher getVoucherByCode(String voucherCode, String customerID) {
        String query = "SELECT uv.[status], v.[voucherCode], v.[discountPer], v.[discountAmount], "
                + "v.[minOrderValue], v.[validFrom], v.[validUntil], v.[maxDiscountAmount] "
                + "FROM dbo.[UsedVoucher] uv "
                + "JOIN dbo.[Vouchers] v ON uv.[voucherID] = v.[voucherID] "
                + "WHERE uv.[customerID] = ? AND v.[voucherCode] = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, customerID);
            ps.setString(2, voucherCode);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int status = rs.getInt("status");
                double discountPer = rs.getDouble("discountPer");
                double discountAmount = rs.getDouble("discountAmount");
                double minOrderValue = rs.getDouble("minOrderValue");
                double maxDiscountAmount = rs.getDouble("maxDiscountAmount");
                Date validFrom = rs.getDate("validFrom");
                Date validUntil = rs.getDate("validUntil");
                Date currentDate = new Date();

                // Kiểm tra trạng thái và thời gian hợp lệ
                if (status == 1 && currentDate.after(validFrom) && currentDate.before(validUntil)) {
                    return new UsedVoucher(voucherCode, discountPer, discountAmount, minOrderValue, maxDiscountAmount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UsedVoucher getUsedVoucherByCode(String customerID, String voucherCode) {
        String query = "SELECT uv.[usedVoucherID], uv.[voucherID], uv.[customerID], uv.[usedAt], uv.[status], "
                + "v.[voucherCode], v.[discountPer], v.[discountAmount], v.[minOrderValue], "
                + "v.[validFrom], v.[validUntil], v.[maxDiscountAmount] "
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
                        rs.getDouble("discountPer"),
                        rs.getDouble("maxDiscountAmount"),
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

}
