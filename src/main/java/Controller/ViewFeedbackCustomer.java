/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import Models.Customer;
import Models.ViewFeedbackCus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Thuan
 */
@WebServlet(name = "ViewFeedbackCustomer", urlPatterns = {"/ViewFeedbackCustomer"})
public class ViewFeedbackCustomer extends HttpServlet{
    
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        System.out.println("ViewFeedbackCustomer Servlet is running...");


        if (customer.getCustomerID() != null && !customer.getCustomerID().isEmpty()) {
            List<ViewFeedbackCus> feedbackList = feedbackDAO.getFeedbackByCustomerID(customer.getCustomerID());
            
            for(ViewFeedbackCus i : feedbackList){
                System.out.println("iii" + i);
            }
            request.setAttribute("feedbackList", feedbackList);
        } else {
            request.setAttribute("feedbackList", null);
        }

        request.getRequestDispatcher("View/ViewFeedbackCustomer.jsp").forward(request, response);
    }
    
    
}
