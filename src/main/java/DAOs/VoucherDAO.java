/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Voucher;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import DB.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.UUID;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class VoucherDAO extends DBContext {

    // 1. Read all vouchers
    public ArrayList<Voucher> getAll() {
        ArrayList<Voucher> vouchers = new ArrayList<>();
        String updateStatusSQL = "UPDATE Vouchers SET voucherStatus = 0 WHERE validUntil < GETDATE()";
        String query = "SELECT voucherID, voucherCode, discountAmount, minOrderValue, validFrom, validUntil, voucherStatus FROM Vouchers ORDER BY validFrom DESC";

        try {
            execQuery(updateStatusSQL, null);
            try ( ResultSet rs = execSelectQuery(query)) {
                while (rs.next()) {
                    vouchers.add(new Voucher(
                            rs.getString("voucherID"),
                            rs.getString("voucherCode"),
                            rs.getDouble("discountAmount"),
                            rs.getDouble("minOrderValue"),
                            rs.getDate("validFrom").toLocalDate(),
                            rs.getDate("validUntil").toLocalDate(),
                            rs.getBoolean("voucherStatus")
                    ));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Error when get Vouchers data", ex);
        }
        return vouchers;
    }

    // 2. Read a voucher by ID
    public Voucher getOnlyById(String voucherID) {
        Voucher voucher = null;
        String sql = "SELECT voucherID, voucherCode, discountAmount, minOrderValue, validFrom, validUntil, voucherStatus FROM Vouchers WHERE voucherID = ?";
        Object param[] = {voucherID};

        try ( ResultSet rs = execSelectQuery(sql, param)) {
            if (rs.next()) {
                voucher = new Voucher(
                        rs.getString("voucherID"),
                        rs.getString("voucherCode"),
                        rs.getDouble("discountAmount"),
                        rs.getDouble("minOrderValue"),
                        rs.getDate("validFrom").toLocalDate(),
                        rs.getDate("validUntil").toLocalDate(),
                        rs.getBoolean("voucherStatus")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Get only By ID of voucher failer", ex);
        }
        return voucher;
    }

    public boolean isVoucherCodeExists(String voucherCode) {
        String sql = "SELECT COUNT(*) FROM Vouchers WHERE voucherCode = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, voucherCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isVoucherCodeExistsForUpdate(String voucherCode, String voucherID) {
        String sql = "SELECT COUNT(*) FROM Vouchers WHERE voucherCode = ? AND voucherID <> ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, voucherCode);
            stmt.setString(2, voucherID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Create a new voucher
    public int create(Voucher voucher) {
        if (isVoucherCodeExists(voucher.getVoucherCode())) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.WARNING, "VoucherCode đã tồn tại: " + voucher.getVoucherCode());
            return -1;
        }

        String sql = "INSERT INTO Vouchers (voucherCode, discountAmount, minOrderValue, validFrom, validUntil ) VALUES(?,?,?,?,?)";

        Object[] params = {
            voucher.getVoucherCode(),
            voucher.getDiscountAmount(),
            voucher.getMinOrderValue(),
            voucher.getValidFrom(),
            voucher.getValidUntil(),};

        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Lỗi khi chèn voucher", ex);
            return 0;
        }
    }

    public int update(Voucher voucher) {
        if (isVoucherCodeExistsForUpdate(voucher.getVoucherCode(), voucher.getVoucherID())) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.WARNING, "Voucher Code đã tồn tại: " + voucher.getVoucherCode());
            return -1;
        }

        String sql = "UPDATE Vouchers SET voucherCode = ?, discountAmount = ?, minOrderValue = ?, validFrom = ?, validUntil = ? , voucherStatus = ? WHERE voucherID = ?";
        Object[] params = {
            voucher.getVoucherCode(),
            voucher.getDiscountAmount(),
            voucher.getMinOrderValue(),
            voucher.getValidFrom(),
            voucher.getValidUntil(),
            voucher.isVoucherStatus() ? 1 : 0,
            voucher.getVoucherID()
        };

        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Lỗi khi cập nhật voucher", ex);
            return 0;
        }
    }

    public void sendVoucherToAllCustomers(UUID voucherID) {
        String sql = "INSERT INTO UsedVoucher (usedVoucherID, voucherID, customerID, usedAt, status) "
                + "SELECT NEWID(), ?, customerID, NULL, 0 FROM Customer";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            int rowsInserted = stmt.executeUpdate();
            System.out.println("Gửi voucher thành công cho " + rowsInserted + " khách hàng.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void sendVoucherTo1OrderCustomers(UUID voucherID) {
        String sql = "INSERT INTO UsedVoucher (usedVoucherID, voucherID, customerID, usedAt, status) "
                + "SELECT NEWID(), ?, o.customerID, NULL, 0 "
                + "FROM [Order] o "
                + "WHERE o.customerID IS NOT NULL "
                + "GROUP BY o.customerID";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            int rowsInserted = stmt.executeUpdate();
            System.out.println("Gửi voucher thành công cho " + rowsInserted + " khách hàng.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isVoucherSent(UUID voucherID) {
        String sql = "SELECT COUNT(*) FROM UsedVoucher WHERE voucherID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertUsedVoucher(UUID voucherID, String customerEmail) {
        String sql = "INSERT INTO UsedVoucher (usedVoucherID, voucherID, customerID, usedAt, status) "
                + "SELECT NEWID(), ?, c.customerID, NULL, 0 FROM Customer c WHERE c.email = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            stmt.setString(2, customerEmail);
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isVoucherSentToCustomer(UUID voucherID, String customerEmail) {
        String sql = "SELECT COUNT(*) FROM UsedVoucher uv "
                + "JOIN Customer c ON uv.customerID = c.customerID "
                + "WHERE uv.voucherID = ? AND c.email = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            stmt.setString(2, customerEmail);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int isStatusUsedVoucher(String voucherID) {
        String sql = "SELECT voucherStatus FROM Vouchers WHERE voucherID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, voucherID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int check = rs.getInt(1);
                return check;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ArrayList<String> getAllCustomerEmails() {
        ArrayList<String> emails = new ArrayList<>();
        String query = "SELECT email FROM Customer";

        try ( Connection conn = getConn();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                emails.add(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emails;
    }

    public ArrayList<String> getCustomersWithOrders() {
        ArrayList<String> emails = new ArrayList<>();
        String query = "SELECT DISTINCT c.email FROM Customer c JOIN [Order] o ON c.customerID = o.customerID";

        try ( Connection conn = getConn();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                emails.add(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emails;
    }
}
