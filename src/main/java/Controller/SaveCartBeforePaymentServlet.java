/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CartDAO;
import Models.CartItem;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Nhat_Anh
 */

//@WebServlet(name = "SaveCartBeforePaymentServlet", urlPatterns = {"/SaveCartBeforePayment"})
public class SaveCartBeforePaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            Customer customer = (Customer) session.getAttribute("user");
            String customerId = customer.getCustomerID();
            String total = request.getParameter("total");

            // Lưu giỏ hàng hiện tại vào session
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.viewCart(customerId);

            session.setAttribute("tempCart", cartItems);
            session.setAttribute("tempTotal", total);

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
