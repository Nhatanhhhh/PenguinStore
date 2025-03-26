package DAOs;

import DB.DBContext;
import Models.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final DBContext db = new DBContext();

    // Lấy danh sách đơn hàng theo Customer ID
    public List<Order> getOrdersByCustomerID(String customerID) {
        List<Order> orderList = new ArrayList<>();
        String query = "SELECT o.orderID, v.voucherCode, s.statusName, o.orderDate, o.totalAmount "
                + "FROM [Order] o "
                + "LEFT JOIN Vouchers v ON o.voucherID = v.voucherID "
                + "LEFT JOIN StatusOrder s ON o.statusOID = s.statusOID "
                + "WHERE o.customerID = ?";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));
                order.setVoucherName(rs.getString("voucherCode") != null ? rs.getString("voucherCode") : "No Voucher");
                order.setStatusName(rs.getString("statusName"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setCustomerID(customerID);
                orderList.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }

    // Lấy tất cả đơn hàng (dùng cho Staff/Admin)
    public List<Order> getAllOrders() {
        List<Order> orderList = new ArrayList<>();
        String query = "SELECT o.orderID, c.fullName, o.orderDate, o.totalAmount, s.statusName "
                + "FROM [Order] o "
                + "JOIN Customer c ON o.customerID = c.customerID "
                + "JOIN StatusOrder s ON o.statusOID = s.statusOID "
                + "ORDER BY o.orderDate DESC";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));
                order.setFullName(rs.getString("fullName"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setOrderStatus(rs.getString("statusName"));
                orderList.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }

    // Lấy statusOID từ statusName
    public String getStatusOIDByName(String statusName) {
        String query = "SELECT statusOID FROM StatusOrder WHERE statusName = ?";
        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, statusName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("statusOID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật trạng thái đơn hàng (gộp 2 hàm updateOrderStatus và updateOrderStatusForCus)
    public boolean updateOrderStatus(String orderID, String newStatus) {
        String statusOID = getStatusOIDByName(newStatus);
        if (statusOID == null) {
            return false;
        }

        String query = "UPDATE [Order] SET statusOID = ? WHERE orderID = ?";
        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, statusOID);
            ps.setString(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Khôi phục số lượng stock khi đơn hàng bị hủy
    public void restoreStockQuantity(String orderID) {
        String query = "UPDATE ProductVariant "
                + "SET stockQuantity = stockQuantity + ( "
                + "    SELECT quantity FROM OrderDetail WHERE orderID = ? AND ProductVariant.proVariantID = OrderDetail.proVariantID "
                + ") "
                + "WHERE proVariantID IN (SELECT proVariantID FROM OrderDetail WHERE orderID = ?)";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, orderID);
            ps.setString(2, orderID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}