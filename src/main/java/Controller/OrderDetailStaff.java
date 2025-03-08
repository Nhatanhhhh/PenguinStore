/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.OrderDetailDAO;
import DTO.OrderDetailDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Le Minh Loc - CE180992
 */
public class OrderDetailStaff extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderID = request.getParameter("orderID");
        System.out.println("Received orderID: " + orderID);

        if (orderID != null && !orderID.trim().isEmpty()) {
            try {
                OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                List<OrderDetailDTO> orderDetails = orderDetailDAO.getOrderDetailForManager(orderID);

                System.out.println("Order details size: " + (orderDetails != null ? orderDetails.size() : 0));

                request.setAttribute("orderDetails", orderDetails);
                request.getRequestDispatcher("View/OrderDetailStaff.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace(); // Debug nếu có lỗi từ DAO
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
