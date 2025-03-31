package DAOs;

import DB.DBContext;
import Models.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

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
        String query = "SELECT o.orderID, c.fullName, o.orderDate, o.finalAmount, s.statusName "
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
                order.setTotalAmount(rs.getDouble("finalAmount"));
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

    public boolean updateOrderStatusCus(String orderID, String newStatus) {
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

    // Cập nhật trạng thái đơn hàng cho Admin
    public boolean updateOrderStatus(String orderID, String statusOID) {
        logger.info("Attempting to update order " + orderID + " to status " + statusOID);
        Connection conn = null;
        try {
            conn = db.getConn();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Kiểm tra trạng thái hiện tại
            String currentStatus = getCurrentStatus(orderID, conn);
            if (currentStatus.equals(statusOID)) {
                // Trạng thái đã được cập nhật trước đó
                conn.rollback();
                return true;
            }

            // Cập nhật trạng thái
            String query = "UPDATE [Order] SET statusOID = ? WHERE orderID = ?";
            try ( PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, statusOID);
                ps.setString(2, orderID);
                int affectedRows = ps.executeUpdate();

                if (affectedRows > 0) {
                    conn.commit(); // Commit transaction nếu thành công
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                }
            }
        }
    }

    private String getCurrentStatus(String orderID, Connection conn) throws SQLException {
        String query = "SELECT statusOID FROM [Order] WHERE orderID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("statusOID");
            }
        }
        return null;
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

    /**
     * Restores stock quantities when an order is cancelled
     */
    public void restoreStockQuantities(String orderID) {
        Connection conn = null;
        try {
            conn = db.getConn();
            conn.setAutoCommit(false);

            // 1. Get all order details
            String getDetailsSQL = "SELECT productVariantID, quantity FROM OrderDetail WHERE orderID = ?";
            try ( PreparedStatement stmt = conn.prepareStatement(getDetailsSQL)) {
                stmt.setString(1, orderID);
                ResultSet rs = stmt.executeQuery();

                // 2. Restore stock
                String updateStockSQL = "UPDATE ProductVariants SET stockQuantity = stockQuantity + ? WHERE proVariantID = ?";
                try ( PreparedStatement updateStmt = conn.prepareStatement(updateStockSQL)) {
                    while (rs.next()) {
                        String productVariantID = rs.getString("productVariantID");
                        int quantity = rs.getInt("quantity");

                        updateStmt.setInt(1, quantity);
                        updateStmt.setString(2, productVariantID);
                        updateStmt.addBatch();
                    }
                    updateStmt.executeBatch();
                }

                // 3. Record restock
                recordRestock(conn, orderID);

                conn.commit();
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                }
            }
        }
    }

    /**
     * Records the restock operation in the Restock table
     */
    private void recordRestock(Connection conn, String orderID) throws SQLException {
        String restockSQL = "INSERT INTO Restock (restockID, proVariantID, quantity, restockDate) "
                + "SELECT NEWID(), od.productVariantID, od.quantity, GETDATE() "
                + "FROM OrderDetail od "
                + "WHERE od.orderID = ?";

        try ( PreparedStatement stmt = conn.prepareStatement(restockSQL)) {
            stmt.setString(1, orderID);
            stmt.executeUpdate();
        }
    }

    public long getLastOrderUpdateTime(String customerID) {
        String sql = "SELECT MAX(orderDate) FROM [Order] WHERE customerID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp(1);
                return timestamp != null ? timestamp.getTime() : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
