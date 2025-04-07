package Controller;

import DB.DBContext;
import org.json.JSONObject; // Thay đổi import này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/api/chatbot/save")
public class ChatBotHistorySave extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ChatBotHistoryServlet reached!"); // Debug log

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            System.out.println("ChatBotHistoryServlet reached!");

            // Read JSON body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JSONObject json = new JSONObject(sb.toString());
            String customerId = json.optString("customerId", null);
            String customerName = json.optString("customerName", "Khách");
            String question = json.getString("question");
            String answer = json.getString("answer");

            System.out.println("Parsed data - customerId: " + customerId
                    + ", customerName: " + customerName
                    + ", question: " + question
                    + ", answer: " + answer);

            // Validate input
            if (question == null || question.trim().isEmpty()
                    || answer == null || answer.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\":\"error\",\"message\":\"Question and answer are required\"}");
                return;
            }

            // Nếu là khách (customerId = null)
            if (customerId == null) {
                System.out.println("Lưu chat cho khách - không có customerId");
                out.write("{\"status\":\"success\",\"message\":\"Chat saved for guest\"}");
                return;
            }

            // Validate UUID format
            UUID uuid;
            try {
                uuid = UUID.fromString(customerId);
            } catch (IllegalArgumentException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\":\"error\",\"message\":\"Invalid customer ID format\"}");
                return;
            }

            try ( Connection conn = DBContext.getConn()) {
                // Kiểm tra customer tồn tại
                String checkSql = "SELECT 1 FROM Customer WHERE customerID = ?";
                try ( PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setObject(1, uuid);
                    ResultSet rs = checkStmt.executeQuery();
                    if (!rs.next()) {
                        System.out.println("Không tìm thấy customer với ID: " + customerId);
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("{\"status\":\"error\",\"message\":\"Customer not found\"}");
                        return;
                    }
                }

                // Insert vào database
                String insertSql = "INSERT INTO ChatBotHistory (customerID, customerName, question, answer, isAnswered) "
                        + "VALUES (?, ?, ?, ?, 1)";

                try ( PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setObject(1, uuid);
                    insertStmt.setString(2, customerName);
                    insertStmt.setString(3, question);
                    insertStmt.setString(4, answer);

                    int affectedRows = insertStmt.executeUpdate();

                    if (affectedRows > 0) {
                        System.out.println("Đã lưu thành công chat vào database");
                        out.write("{\"status\":\"success\"}");
                    } else {
                        System.out.println("Không có dòng nào được insert vào database");
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("{\"status\":\"error\",\"message\":\"Failed to save chat history\"}");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi server khi lưu chat:");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }
}
