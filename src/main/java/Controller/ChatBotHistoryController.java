package Controller;

import DAOs.ChatBotHistoryDAO;
import Models.ChatBotHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "ChatBotHistoryController", urlPatterns = {"/ChatBotHistory"})
public class ChatBotHistoryController extends HttpServlet {

    private ChatBotHistoryDAO chatBotHistoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        chatBotHistoryDAO = new ChatBotHistoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        if (request.getParameter("recordsPerPage") != null) {
            recordsPerPage = Integer.parseInt(request.getParameter("recordsPerPage"));
        }

        int offset = (page - 1) * recordsPerPage;

        List<ChatBotHistory> historyList = chatBotHistoryDAO.getAllChatHistory(
                offset, recordsPerPage);

        int totalRecords = chatBotHistoryDAO.getTotalRecords();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        int startRecord = (page - 1) * recordsPerPage + 1;
        int endRecord = Math.min(page * recordsPerPage, totalRecords);

        request.setAttribute("historyList", historyList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);

        request.getRequestDispatcher("/View/ChatBotHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ChatBotHistory");
            return;
        }

        switch (action) {
            case "update":
                handleUpdateAnswer(request, response);
                break;
            case "delete":
                handleDeleteHistory(request, response);
                break;
            case "list":
            default:
                List<ChatBotHistory> historyList = chatBotHistoryDAO.getAllChatHistory();
                request.setAttribute("historyList", historyList);
                request.getRequestDispatcher("/View/ChatBotHistory.jsp").forward(request, response);
        }
    }

    private void handleUpdateAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UUID historyID = UUID.fromString(request.getParameter("historyID"));
            String answer = request.getParameter("answer");

            boolean success = chatBotHistoryDAO.updateAnswer(historyID, answer);

            if (success) {
                request.getSession().setAttribute("message", "Answer updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update answer");
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Invalid history ID format");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "An error occurred while updating the answer");
        }

        response.sendRedirect(request.getContextPath() + "/ChatBotHistory");
    }

    private void handleDeleteHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UUID historyID = UUID.fromString(request.getParameter("historyID"));

            boolean success = chatBotHistoryDAO.deleteHistory(historyID);

            if (success) {
                request.getSession().setAttribute("message", "History deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete history");
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Invalid history ID format");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "An error occurred while deleting the history");
        }

        response.sendRedirect(request.getContextPath() + "/ChatBotHistory");
    }
}
