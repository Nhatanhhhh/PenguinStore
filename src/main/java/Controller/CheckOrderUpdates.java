/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author Nhat_Anh
 */
@WebServlet("/CheckOrderUpdates")
public class CheckOrderUpdates extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String customerID = request.getParameter("customerID");
        long lastCheck = Long.parseLong(request.getParameter("lastCheck"));
        
        OrderDAO orderDAO = new OrderDAO();
        long lastUpdateTime = orderDAO.getLastOrderUpdateTime(customerID);
        
        response.setContentType("application/json");
        response.getWriter().write(String.format(
            "{\"updated\": %b, \"serverTime\": %d}",
            lastUpdateTime > lastCheck,
            System.currentTimeMillis()
        ));
    }
}
