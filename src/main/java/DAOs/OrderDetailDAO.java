package DAOs;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author PC
 */
import DB.DBContext;
import DTO.OrderDetailDTO;
import Models.Cart;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for OrderDetail with DTO
 *
 * @author PC
 */
public class OrderDetailDAO {

    private DBContext db = new DBContext();

    public List<OrderDetailDTO> getOrderDetailsByOrderID(String orderID) {
        List<OrderDetailDTO> details = new ArrayList<>();

        String query = "SELECT img.imgName, p.productName, od.unitPrice, c.colorName, s.sizeName, "
                + "od.quantity, o.totalAmount, o.discountAmount, o.finalAmount, o.orderDate, so.statusName "
                + "FROM OrderDetail od "
                + "LEFT JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "LEFT JOIN Product p ON pv.productID = p.productID "
                + "LEFT JOIN Color c ON pv.colorID = c.colorID "
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                + "LEFT JOIN [Order] o ON od.orderID = o.orderID "
                + "LEFT JOIN StatusOrder so ON o.statusOID = so.statusOID "
                + "LEFT JOIN Image img ON p.productID = img.productID "
                + "WHERE od.orderID = ?";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, orderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetailDTO detail = new OrderDetailDTO(
                        rs.getString("imgName"),
                        rs.getString("productName"),
                        rs.getDouble("unitPrice"),
                        rs.getString("colorName"),
                        rs.getString("sizeName"),
                        rs.getInt("quantity"),
                        rs.getDouble("totalAmount"),
                        rs.getDouble("discountAmount"),
                        rs.getDouble("finalAmount"),
                        rs.getString("orderDate"),
                        rs.getString("statusName")
                );
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public List<OrderDetailDTO> getOrderDetailForManager(String orderID) {
        List<OrderDetailDTO> details = new ArrayList<>();

        String query = "SELECT img.imgName, p.productName, od.unitPrice, c.colorName, s.sizeName, "
                + "od.quantity, o.totalAmount, o.discountAmount, o.finalAmount, o.orderDate, "
                + "so.statusName, cu.fullName "
                + "FROM OrderDetail od "
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "JOIN Size s ON pv.sizeID = s.sizeID "
                + "JOIN [Order] o ON od.orderID = o.orderID "
                + "JOIN StatusOrder so ON o.statusOID = so.statusOID "
                + "JOIN Customer cu ON o.customerID = cu.customerID "
                + "LEFT JOIN Image img ON p.productID = img.productID "
                + "WHERE od.orderID = ?";

        try ( Connection conn = db.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, orderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetailDTO detail = new OrderDetailDTO(
                        rs.getString("imgName"),
                        rs.getString("productName"),
                        rs.getDouble("unitPrice"),
                        rs.getString("colorName"),
                        rs.getString("sizeName"),
                        rs.getInt("quantity"),
                        rs.getDouble("totalAmount"),
                        rs.getDouble("discountAmount"),
                        rs.getDouble("finalAmount"),
                        rs.getString("orderDate"),
                        rs.getString("statusName"),
                        rs.getString("fullName") // Thêm fullName vào DTO
                );
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }
}