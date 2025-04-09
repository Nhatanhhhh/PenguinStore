package Controller;

import DAOs.FeedBackReplyDAO;
import DAOs.FeedbackDAO;
import Models.FeedbackReply;
import Models.Manager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;

@WebServlet(name = "Re_De_FeedbackController", urlPatterns = {"/feedbackreply"})
public class Re_De_FeedbackController extends HttpServlet {

    private FeedBackReplyDAO feedBackReplyDAO;
    private FeedbackDAO feedBackDao;

    @Override
    public void init() {
        feedBackReplyDAO = new FeedBackReplyDAO();
        feedBackDao = new FeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String feedbackID = request.getParameter("feedbackID");
        String redirectPage = request.getParameter("redirectPage");

        if ("delete".equals(action)) {
            handleDelete(feedbackID, request, response, redirectPage);
        } else if ("reply".equals(action)) {
            handleReply(request, response, redirectPage);
        }
    }

    private void handleDelete(String feedbackID, HttpServletRequest request, HttpServletResponse response, String redirectPage)
            throws IOException, ServletException {
        HttpSession session = request.getSession(); // Lấy session
        boolean isDeleted = feedBackReplyDAO.deleteFeedback(feedbackID);
        
        if (isDeleted) {
            session.setAttribute("message", "Feedback deleted successfully");
        } else {
            session.setAttribute("error", "Failed to delete feedback");
        }

        // Xác định redirect dựa trên role
        redirectBasedOnRole(session, request, response, redirectPage);
    }

    private void handleReply(HttpServletRequest request, HttpServletResponse response, String redirectPage)
            throws ServletException, IOException {
        HttpSession session = request.getSession(); // Lấy session
        try {
            String feedbackID = request.getParameter("feedbackID");
            String replyComment = request.getParameter("replyMessage");

            Manager manager = (Manager) session.getAttribute("user");
            String managerID = (manager != null) ? manager.getManagerID() : null;

            if (managerID == null || feedbackID == null || replyComment.trim().isEmpty()) {
                session.setAttribute("error", "Invalid input for reply");
            } else {
                FeedbackReply reply = new FeedbackReply();
                reply.setReplyId(UUID.randomUUID().toString());
                reply.setFeedbackId(feedbackID);
                reply.setManagerId(managerID);
                reply.setReplyComment(replyComment);
                reply.setFeedRepCreateAt(new Date());

                boolean success = feedBackReplyDAO.insetReplyFeed(reply);

                if (success) {
                    session.setAttribute("message", "Reply sent successfully");
                } else {
                    session.setAttribute("error", "Failed to send reply");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while processing the reply");
        }

        // Xác định redirect dựa trên role
        redirectBasedOnRole(session, request, response, redirectPage);
    }

    // Phương thức phụ để xác định redirect dựa trên role
    private void redirectBasedOnRole(HttpSession session, HttpServletRequest request, HttpServletResponse response, String redirectPage)
            throws IOException {
        String role = (String) session.getAttribute("role"); // Lấy role từ session
        String redirectUrl;

        if (role != null && role.equals("ADMIN")) {
            // Nếu là ADMIN, redirect về DashBoardForAdmin
            redirectUrl = request.getContextPath() + "/ViewListFeedback";
        } else if (role != null && role.equals("STAFF")) {
            // Nếu là STAFF, redirect về DashBoardForStaff
            redirectUrl = request.getContextPath() + "/ViewListFeedback";
        } else {
            // Nếu không có role hoặc role không hợp lệ, dùng redirectPage hoặc mặc định
            redirectUrl = (redirectPage != null && !redirectPage.trim().isEmpty())
                    ? request.getContextPath() + "/" + redirectPage
                    : request.getContextPath() + "/ViewListFeedback"; // Mặc định cho STAFF
        }

        response.sendRedirect(redirectUrl); // Thực hiện redirect
    }
}