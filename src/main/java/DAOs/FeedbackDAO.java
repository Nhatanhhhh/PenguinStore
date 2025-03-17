/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Feedback;
import Models.Order;
import Models.Product;
import Models.Size;
import Models.ViewFeedbackCus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
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
        // Initialize a list to store feedback objects
        List<Feedback> feedbackList = new ArrayList<>();

        // SQL query to retrieve distinct products from orders for a specific customer
        // where the order status is 'Delivery successful'
        String sql = "SELECT DISTINCT p.productID, p.productName, img.imgName, p.price, s.sizeName, o.orderID\n"
                + "FROM OrderDetail od\n"
                + "JOIN [Order] o ON od.orderID = o.orderID\n"
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID\n"
                + "JOIN Product p ON pv.productID = p.productID\n"
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID\n"
                + "LEFT JOIN Image img ON p.productID = img.productID\n"
                + "WHERE o.customerID = ?\n"
                + "AND o.statusOID = (SELECT statusOID FROM StatusOrder WHERE statusName = 'Delivery successful')";

        try (
                // Establish a database connection and create a PreparedStatement
                 Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            // Set the customer ID parameter in the SQL query
            ps.setString(1, customerID);

            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();

            // Iterate through the result set
            while (rs.next()) {
                // Create a new Product object and populate its fields from the result set
                Product product = new Product();
                product.setProductID(rs.getString("productID"));
                product.setProductName(rs.getString("productName"));
                product.setImgName(rs.getString("imgName"));
                product.setPrice(rs.getDouble("price"));

                // Create a new Size object and populate its fields from the result set
                Size size = new Size();
                size.setSizeName(rs.getString("sizeName"));

                // Create a new Order object and populate its fields from the result set
                Order order = new Order();
                order.setOrderID(rs.getString("orderID"));

                // Create a new Feedback object and populate its fields
                Feedback feedback = new Feedback();
                feedback.setProductID(product.getProductID()); // Set the product ID
                feedback.setOrderID(order.getOrderID()); // Set the order ID
                feedback.setComment(""); // Initialize comment as empty
                feedback.setRating(0); // Initialize rating as 0
                feedback.setFeedbackCreateAt(new Date()); // Set the feedback creation date to the current date

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Return the list of feedback objects
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
                feedback.setProductName(rs.getString("productName"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getDouble("rating"));
                feedback.setFeedbackCreateAt(rs.getTimestamp("feedbackCreateAt"));
                feedback.setIsViewed(rs.getBoolean("isViewed"));
                feedback.setIsResolved(rs.getBoolean("isResolved"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public static boolean isProductInOrder(String orderID, String productID) {
        String sql = "SELECT COUNT(*) FROM OrderDetail od "
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "WHERE od.orderID = ? AND pv.productID = ?";
        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            ps.setString(2, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<Feedback> getProductsByOrderID(String orderID) {
        List<Feedback> productList = new ArrayList<>();
        String sql = "SELECT DISTINCT p.productID, p.productName, img.imgName, p.price, s.sizeName, o.orderID "
                + "FROM OrderDetail od "
                + "JOIN [Order] o ON od.orderID = o.orderID "
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                + "LEFT JOIN Image img ON p.productID = img.productID "
                + "WHERE o.orderID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            ResultSet rs = ps.executeQuery();

            System.out.println("SQL Query: " + sql);
            System.out.println("OrderID: " + orderID);

            while (rs.next()) {
                System.out.println("ProductID: " + rs.getString("productID"));
                System.out.println("ProductName: " + rs.getString("productName"));
                System.out.println("ImgName: " + rs.getString("imgName"));
                System.out.println("Price: " + rs.getDouble("price"));
                System.out.println("SizeName: " + rs.getString("sizeName"));

                Feedback feedback = new Feedback();
                feedback.setProductID(rs.getString("productID"));
                feedback.setOrderID(rs.getString("orderID"));
                feedback.setProductName(rs.getString("productName"));
                feedback.setImgName(rs.getString("imgName"));
                feedback.setPrice(rs.getDouble("price"));
                feedback.setSizeName(rs.getString("sizeName"));

                productList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productList;
    }

    public static List<ViewFeedbackCus> getFeedbackByCustomerID(String customerID) {
        List<ViewFeedbackCus> feedbackList = new ArrayList<>();

        String sql = "SELECT "
                + "    m.managerName AS managerName, "
                + "    fr.replyComment, "
                + "    p.productName, "
                + "    fr.replyCreatedAt AS createAt "
                + "FROM dbo.Feedback f "
                + "LEFT JOIN dbo.Product p ON f.productID = p.productID "
                + "LEFT JOIN dbo.FeedbackReplies fr ON f.feedbackID = fr.feedbackID "
                + "LEFT JOIN dbo.Manager m ON fr.managerID = m.managerID "
                + "WHERE f.customerID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, UUID.fromString(customerID));

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ViewFeedbackCus view = new ViewFeedbackCus();
                    view.setManagerNam(rs.getString("managerName"));
                    view.setComment(rs.getString("replyComment"));
                    view.setProductName(rs.getString("productName"));

                    Timestamp ts = rs.getTimestamp("createAt");
                    if (ts != null) {
                        LocalDate localDate = ts.toLocalDateTime().toLocalDate();
                        view.setCreateAt(localDate);
                    } else {
                        view.setCreateAt(null);
                    }
                    feedbackList.add(view);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

}
