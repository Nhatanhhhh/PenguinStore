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

        String query = "SELECT od.quantity, p.productName, p.price, p.imgName, s.sizeName, o.status "
                + "FROM OrderDetail od "
                + "JOIN Product p ON od.productID = p.productID "
                + "JOIN Size s ON od.sizeID = s.sizeID "
                + "JOIN Orders o ON od.orderID = o.orderID "
                + "WHERE od.orderID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, orderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetailDTO detail = new OrderDetailDTO(
                        rs.getInt("quantity"),
                        rs.getString("productName"),
                        rs.getDouble("price"),
                        rs.getString("imgName"),
                        rs.getString("sizeName"),
                        rs.getString("status")
                );
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public void addOrderDetail(String orderID, String productID, int quantity) {
        String sql = "INSERT INTO OrderDetail (orderID, productID, quantity) VALUES (?, ?, ?)";
        try {
            db.execQuery(sql, new Object[]{orderID, productID, quantity});
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
