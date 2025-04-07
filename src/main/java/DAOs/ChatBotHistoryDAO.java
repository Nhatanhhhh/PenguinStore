package DAOs;

import DB.DBContext;
import Models.ChatBotHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ChatBotHistoryDAO {

    private static final Logger LOGGER = Logger.getLogger(ChatBotHistoryDAO.class.getName());

    public List<ChatBotHistory> getAllChatHistory() {
        List<ChatBotHistory> historyList = new ArrayList<>();
        String query = "SELECT * FROM ChatBotHistory ORDER BY questionDate DESC";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ChatBotHistory history = extractChatHistoryFromResultSet(rs);
                historyList.add(history);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all chat history", e);
        }

        return historyList;
    }

    public boolean updateAnswer(UUID historyID, String answer) {
        String query = "UPDATE ChatBotHistory SET answer = ?, isAnswered = ? WHERE historyID = ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, answer);
            stmt.setBoolean(2, answer != null && !answer.trim().isEmpty());
            stmt.setString(3, historyID.toString());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating answer for historyID: " + historyID, e);
            return false;
        }
    }

    public boolean deleteHistory(UUID historyID) {
        System.out.println("Attempting to delete history with ID: " + historyID);
        String query = "DELETE FROM ChatBotHistory WHERE historyID = ?";

        try ( Connection conn = DBContext.getConn()) {
            System.out.println("Connection established: " + (conn != null));
            try ( PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, historyID.toString());
                int affectedRows = stmt.executeUpdate();
                System.out.println("Affected rows: " + affectedRows);
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private ChatBotHistory extractChatHistoryFromResultSet(ResultSet rs) throws SQLException {
        ChatBotHistory history = new ChatBotHistory();
        history.setHistoryID(UUID.fromString(rs.getString("historyID")));
        history.setCustomerID(rs.getString("customerID") != null
                ? UUID.fromString(rs.getString("customerID")) : null);
        history.setCustomerName(rs.getString("customerName"));
        history.setQuestion(rs.getString("question"));
        history.setAnswer(rs.getString("answer"));
        history.setQuestionDate(rs.getTimestamp("questionDate"));
        history.setAnswered(rs.getBoolean("isAnswered"));
        return history;
    }

    public List<ChatBotHistory> getAllChatHistory(int offset, int limit) {
        List<ChatBotHistory> historyList = new ArrayList<>();
        String query = "SELECT * FROM ChatBotHistory ORDER BY questionDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, offset);
            stmt.setInt(2, limit);

            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    historyList.add(extractChatHistoryFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting paginated chat history", e);
        }
        return historyList;
    }

    public int getTotalRecords() {
        String query = "SELECT COUNT(*) FROM ChatBotHistory";
        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(query);  ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting chat history records", e);
        }
        return 0;
    }

    // In ChatBotHistoryDAO, add this method to test connection and data
    public boolean testConnectionAndData() {
        try ( Connection conn = DBContext.getConn()) {
            String query = "SELECT COUNT(*) FROM ChatBotHistory";
            try ( PreparedStatement stmt = conn.prepareStatement(query);  ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("Total records in ChatBotHistory: " + count);
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection or query failed", e);
        }
        return false;
    }
}
