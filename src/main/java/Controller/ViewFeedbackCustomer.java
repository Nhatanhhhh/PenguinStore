/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import Models.Customer;
import Models.Type;
import Models.ViewFeedbackCus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
        HttpSession session = request.getSession(false);
        Customer customer = (Customer) session.getAttribute("user");
        
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        request.setAttribute("listProduct", productDAO.getProductCustomer());
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);

        
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
