/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Voucher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nhat Anh - CE181843
 */
public class VVCustomerDAO {

    private Connection conn;

    public VVCustomerDAO() {
        try {
            conn = new DBContext().getConn();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Voucher> getVouchersByCustomerID(String customerID) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT V.voucherCode, V.discountAmount, V.validUntil "
                + "FROM UsedVoucher UV "
                + "JOIN Vouchers V ON UV.voucherID = V.voucherID "
                + "WHERE UV.customerID = ?";

        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherCode(rs.getString("voucherCode"));
                voucher.setDiscountAmount(rs.getDouble("discountAmount"));
                voucher.setValidUntil(rs.getDate("validUntil").toLocalDate());
                vouchers.add(voucher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public List<Voucher> getAvailableVouchersByCustomerID(String customerID) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT V.* "
                + "FROM Vouchers V "
                + "WHERE V.voucherStatus = 1 "
                + "AND V.validUntil >= GETDATE() "
                + "AND V.voucherID NOT IN ("
                + "    SELECT UV.voucherID FROM UsedVoucher UV "
                + "    WHERE UV.customerID = ? AND UV.status = 1"
                + ")";

        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherID(rs.getString("voucherID"));
                voucher.setVoucherCode(rs.getString("voucherCode"));
                voucher.setDiscountPer(rs.getDouble("discountPer"));
                voucher.setDiscountAmount(rs.getDouble("discountAmount"));
                voucher.setMinOrderValue(rs.getDouble("minOrderValue"));
                voucher.setValidFrom(rs.getDate("validFrom").toLocalDate());
                voucher.setValidUntil(rs.getDate("validUntil").toLocalDate());
                voucher.setMaxDiscountAmount(rs.getDouble("maxDiscountAmount"));
                vouchers.add(voucher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vouchers;
    }
}
