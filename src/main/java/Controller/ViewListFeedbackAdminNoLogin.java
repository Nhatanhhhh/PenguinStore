/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import Models.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Thuan
 */
@WebServlet(name = "ViewListFeedbackAdminNoLogin", urlPatterns = {"/Admin/ViewListFeedbackAdminNoLogin"})
public class ViewListFeedbackAdminNoLogin extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks();
        
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/View/ListFeedbackAdmin.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
   
}
