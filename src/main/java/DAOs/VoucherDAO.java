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
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class VoucherDAO extends DBContext {

    // 1. Read all vouchers
    public ArrayList<Voucher> getAll() {
        ArrayList<Voucher> vouchers = new ArrayList<>();
        String updateStatusSQL = "UPDATE Vouchers SET voucherStatus = 0 WHERE validUntil < GETDATE()";
        String query = "SELECT * FROM Vouchers ORDER BY validFrom DESC";

        try {
            execQuery(updateStatusSQL, null);
            try ( ResultSet rs = execSelectQuery(query)) {
                while (rs.next()) {
                    vouchers.add(new Voucher(
                            rs.getString("voucherID"),
                            rs.getString("voucherCode"),
                            rs.getDouble("discountPer"),
                            rs.getDouble("discountAmount"),
                            rs.getDouble("minOrderValue"),
                            rs.getDate("validFrom").toLocalDate(),
                            rs.getDate("validUntil").toLocalDate(),
                            rs.getDouble("maxDiscountAmount"),
                            rs.getBoolean("voucherStatus")
                    ));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error when get Vouchers data", ex);
        }
        return vouchers;
    }

    // 2. Read a voucher by ID
    public Voucher getOnlyById(String voucherID) {
        Voucher voucher = null;
        String sql = "SELECT * FROM Vouchers WHERE voucherID = ?";
        Object param[] = {voucherID};

        try ( ResultSet rs = execSelectQuery(sql, param)) {
            if (rs.next()) {
                voucher = new Voucher(
                        rs.getString("voucherID"),
                        rs.getString("voucherCode"),
                        rs.getDouble("discountPer"),
                        rs.getDouble("discountAmount"),
                        rs.getDouble("minOrderValue"),
                        rs.getDate("validFrom").toLocalDate(),
                        rs.getDate("validUntil").toLocalDate(),
                        rs.getDouble("maxDiscountAmount"),
                        rs.getBoolean("voucherStatus")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Get only By ID of voucher failer", ex);
        }
        return voucher;
    }

    // 3. Create a new voucher
    public int create(Voucher voucher) {
        String sql = "INSERT INTO Vouchers ( voucherCode, discountPer, discountAmount, minOrderValue, validFrom, validUntil, maxDiscountAmount) VALUES(?,?,?,?,?,?,?)";

        Object[] params = {
            voucher.getVoucherCode(),
            voucher.getDiscountPer(),
            voucher.getDiscountAmount(),
            voucher.getMinOrderValue(),
            voucher.getValidFrom(),
            voucher.getValidUntil(),
            voucher.getMaxDiscountAmount()
        };

        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Error inserting new voucher", ex);
            return 0;
        }
    }

    // 4. Update a voucher
    public int update(Voucher voucher) {
        String sql = "UPDATE Vouchers SET voucherCode = ?, discountPer = ?, discountAmount = ?, minOrderValue = ?, validFrom = ?, validUntil = ?, maxDiscountAmount = ?, voucherStatus = ? where voucherID = ?";
        Object[] params = {
            voucher.getVoucherCode(),
            voucher.getDiscountPer(),
            voucher.getDiscountAmount(),
            voucher.getMinOrderValue(),
            voucher.getValidFrom(),
            voucher.getValidUntil(),
            voucher.getMaxDiscountAmount(),
            voucher.isVoucherStatus() ? 1 : 0,
            voucher.getVoucherID()
        };
        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(VoucherDAO.class.getName()).log(Level.SEVERE, "Edit voucher failer", ex);
            return 0;
        }
    }
}