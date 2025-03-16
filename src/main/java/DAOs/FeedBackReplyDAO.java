/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.FeedbackReply;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

/**
 *
 * @author Thuan
 */
public class FeedBackReplyDAO {
    
    public static boolean insetReplyFeed(FeedbackReply reply) throws SQLException {
        String sql = "INSERT INTO FeedbackReplies (replyID, feedbackID, managerID,replyComment,replyCreatedAt) "
                + "VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(sql)) {

            

            // Chuyển đổi giá trị thành UUID hợp lệ
            ps.setObject(1, UUID.fromString(reply.getReplyId()));
            ps.setObject(2, UUID.fromString(reply.getFeedbackId()));
            ps.setObject(3, UUID.fromString(reply.getManagerId()));
            ps.setString(4, reply.getReplyComment());
            ps.setTimestamp(5, new java.sql.Timestamp(reply.getFeedRepCreateAt().getTime()));

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid UUID format: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            return false;
        }
    }
    
    public static boolean deleteFeedback(String feedbackID) {
        String sql = "DELETE FROM Feedback WHERE feedbackID = ?";
        try (Connection conn = DBContext.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, feedbackID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; 
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
