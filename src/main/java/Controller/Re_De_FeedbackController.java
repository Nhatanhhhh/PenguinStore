/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.FeedBackReplyDAO;
import DAOs.FeedbackDAO;
import Models.Feedback;
import Models.FeedbackReply;
import Models.Manager;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author Thuan
 */
@WebServlet(name = "Re_DE_FeedbackController", urlPatterns = {"/feedbackreply"})
public class Re_De_FeedbackController extends HttpServlet{
    
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
            String replyMessage = request.getParameter("replyMessage");
            handleReply(request, response, redirectPage);
        }
    }

    private void handleDelete(String feedbackID, HttpServletRequest request, HttpServletResponse response, String redirectPage)
        throws IOException, ServletException {
        boolean isDeleted = feedBackReplyDAO.deleteFeedback(feedbackID);

        List<Feedback> listAllFeed = feedBackDao.getAllFeedbacks();
        request.setAttribute("feedbacks", listAllFeed);

        if (redirectPage == null || redirectPage.trim().isEmpty()) {
            redirectPage = "View/DashBoardForStaff.jsp";
        }

        request.getRequestDispatcher(redirectPage).forward(request, response);
    }


     private void handleReply(HttpServletRequest request, HttpServletResponse response, String redirectPage)
        throws ServletException, IOException {
        try {
            String feedbackID = request.getParameter("feedbackID");
            String replyComment = request.getParameter("replyMessage");

            HttpSession session = request.getSession();
            Manager manager = (Manager) session.getAttribute("user");
            String managerID = (manager != null) ? manager.getManagerID() : null;

            if (managerID == null || feedbackID == null || replyComment.trim().isEmpty()) {
                response.sendRedirect("View/DashBoardForStaff.jsp");
                return;
            }

            FeedbackReply reply = new FeedbackReply();
            reply.setReplyId(UUID.randomUUID().toString()); 
            reply.setFeedbackId(feedbackID);
            reply.setManagerId(managerID);
            reply.setReplyComment(replyComment);
            reply.setFeedRepCreateAt(new Date());

            boolean success = feedBackReplyDAO.insetReplyFeed(reply);

            List<Feedback> listAllFeed = feedBackDao.getAllFeedbacks();
            request.setAttribute("feedbacks", listAllFeed);

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (redirectPage == null || redirectPage.trim().isEmpty()) {
            redirectPage = "View/DashBoardForStaff.jsp";
        }

        request.getRequestDispatcher(redirectPage).forward(request, response);
    }

}
