/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Feedback;
import Models.Order;
import Models.Product;
import Models.ProductVariant;
import Models.Size;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class FeedbackDAO {

    public static List<Feedback> getOrderedProductsForFeedback(String customerID) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT DISTINCT p.productID, p.productName, img.imgName, p.price, s.sizeName, o.orderID\n"
                + "FROM OrderDetail od\n"
                + "JOIN [Order] o ON od.orderID = o.orderID\n"
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID\n"
                + "JOIN Product p ON pv.productID = p.productID\n"
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID\n"
                + "LEFT JOIN Image img ON p.productID = img.productID\n"
                + "WHERE o.customerID = ?\n"
                + "AND o.statusOID = (SELECT statusOID FROM StatusOrder WHERE statusName = 'Delivery successful')";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getString("productID"));
                product.setProductName(rs.getString("productName"));
                product.setImgName(rs.getString("imgName"));
                product.setPrice(rs.getDouble("price"));

                Size size = new Size();
                size.setSizeName(rs.getString("sizeName"));

                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));

                Feedback feedback = new Feedback();
                feedback.setProductID(product.getProductID());
                feedback.setOrderID(order.getOrderID());
                feedback.setComment("");
                feedback.setRating(0);
                feedback.setFeedbackCreateAt(new Date());

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public static boolean saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (feedbackID, customerID, productID, orderID, comment, rating, feedbackCreateAt, isResolved, isViewed) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Kiểm tra giá trị NULL hoặc chuỗi rỗng
            if (feedback.getCustomerID() == null || feedback.getCustomerID().trim().isEmpty()) {
                System.out.println("Error: customerID is NULL or empty.");
                return false;
            }
            if (feedback.getProductID() == null || feedback.getProductID().trim().isEmpty()) {
                System.out.println("Error: productID is NULL or empty.");
                return false;
            }
            if (feedback.getOrderID() == null || feedback.getOrderID().trim().isEmpty()) {
                System.out.println("Error: orderID is NULL or empty.");
                return false;
            }

            // Chuyển đổi giá trị thành UUID hợp lệ
            ps.setString(1, feedback.getFeedbackID());
            ps.setObject(2, UUID.fromString(feedback.getCustomerID()));
            ps.setObject(3, UUID.fromString(feedback.getProductID()));
            ps.setObject(4, UUID.fromString(feedback.getOrderID()));
            ps.setString(5, feedback.getComment());
            ps.setDouble(6, feedback.getRating());
            ps.setTimestamp(7, new java.sql.Timestamp(feedback.getFeedbackCreateAt().getTime()));
            ps.setBoolean(8, feedback.isIsResolved());
            ps.setBoolean(9, feedback.isIsViewed());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid UUID format: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Product getProductByID(String productID) {
        String sql = "SELECT p.productID, p.productName, p.price, img.imgName "
                + "FROM Product p "
                + "LEFT JOIN Image img ON p.productID = img.productID "
                + "WHERE p.productID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getString("productID"));
                product.setProductName(rs.getString("productName"));
                product.setPrice(rs.getDouble("price"));
                product.setImgName(rs.getString("imgName"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Size getSizeByProductVariant(String productID) {
        String sql = "SELECT s.sizeName FROM ProductVariants pv "
                + "JOIN Size s ON pv.sizeID = s.sizeID "
                + "WHERE pv.productID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Size size = new Size();
                size.setSizeName(rs.getString("sizeName"));
                return size;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<Feedback> getLatestFeedbacks(String productID) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT TOP 3 f.feedbackID, f.customerID, c.customerName, f.productID, f.comment, f.rating, f.feedbackCreateAt "
                + "FROM Feedback f "
                + "JOIN Customer c ON f.customerID = c.customerID "
                + "WHERE f.productID = ? "
                + "ORDER BY f.feedbackCreateAt DESC";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackID(rs.getString("feedbackID"));
                feedback.setCustomerID(rs.getString("customerID"));
                feedback.setCustomerName(rs.getString("customerName")); // Thêm customerName vào model Feedback
                feedback.setProductID(rs.getString("productID"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getDouble("rating"));
                feedback.setFeedbackCreateAt(rs.getTimestamp("feedbackCreateAt"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public static double getAverageRating(String productID) {
        double avgRating = 0.0;
        String sql = "SELECT AVG(rating) FROM Feedback WHERE productID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                avgRating = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return avgRating;
    }

    public static int getTotalReviews(String productID) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Feedback WHERE productID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.feedbackID, c.customerName, p.productName, f.comment, f.rating, f.feedbackCreateAt, f.isViewed, f.isResolved "
                + "FROM Feedback f "
                + "JOIN Customer c ON f.customerID = c.customerID "
                + "JOIN Product p ON f.productID = p.productID "
                + "ORDER BY f.feedbackCreateAt DESC";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackID(rs.getString("feedbackID"));
                feedback.setCustomerName(rs.getString("customerName"));
                feedback.setGetProductName(rs.getString("productName"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getDouble("rating"));
                feedback.setFeedbackCreateAt(rs.getTimestamp("feedbackCreateAt"));
                feedback.setIsViewed(rs.getBoolean("isViewed"));
                feedback.setIsResolved(rs.getBoolean("isResolved"));

                feedbackList.add(feedback);
            }
            System.out.println("✅ Số feedback lấy được từ DB: " + feedbackList.size());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

}
