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
 * @author Nhat_Anh
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
        String query = "SELECT V.voucherCode, V.discountAmount, V.validUntil " +
                       "FROM UsedVoucher UV " +
                       "JOIN Vouchers V ON UV.voucherID = V.voucherID " +
                       "WHERE UV.customerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
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
}
