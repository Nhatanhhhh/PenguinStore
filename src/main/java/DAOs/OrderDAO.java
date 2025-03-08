package DAOs;

import DB.DBContext;
import Models.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderDAO {

    private DBContext db = new DBContext();

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

    public String createOrder(Order order) {
        String orderID = UUID.randomUUID().toString();
        String sql = "INSERT INTO [Order] (orderID, customerID, totalAmount, discountAmount, finalAmount, orderDate, statusOID, voucherID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            ps.setString(2, order.getCustomerID());
            ps.setDouble(3, order.getTotalAmount());
            ps.setDouble(4, order.getDiscountAmount());
            ps.setDouble(5, order.getFinalAmount());
            ps.setDate(6, new java.sql.Date(order.getOrderDate().getTime()));
            ps.setString(7, order.getStatusOID());
            ps.setString(8, order.getVoucherID());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderID;
    }

    //Use for Staff
    public List<Order> getAllOrders() {
        List<Order> orderList = new ArrayList<>();
        String query = "SELECT o.orderID, c.fullName, o.orderDate, o.finalAmount, s.statusName "
                + "FROM dbo.[Order] o "
                + "JOIN dbo.Customer c ON o.customerID = c.customerID "
                + "JOIN dbo.StatusOrder s ON o.statusOID = s.statusOID "
                + "ORDER BY o.orderDate DESC";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));
                order.setFullName(rs.getString("fullName"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setTotalAmount(rs.getDouble("finalAmount"));
                order.setOrderStatus(rs.getString("statusName"));
                orderList.add(order);
            }
        } catch (Exception e) {
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

// Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(String orderID, String statusOID) {
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

}
