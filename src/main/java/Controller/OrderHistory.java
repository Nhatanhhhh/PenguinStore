/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.OrderDAO;
import DAOs.OrderDetailDAO;
import DAOs.CartDAO;
import Models.Customer;
import Models.Order;
import Models.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class OrderHistory extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByCustomerID(customerID);

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("View/OrderHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        try {
            double totalAmount = Double.parseDouble(request.getParameter("subtotal"));
            double discountAmount = Double.parseDouble(request.getParameter("discount"));
            double finalAmount = Double.parseDouble(request.getParameter("total"));

            String voucher = request.getParameter("voucher");
            voucher = (voucher != null && !voucher.isEmpty()) ? voucher : null;

            OrderDAO orderDAO = new OrderDAO();
            OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
            CartDAO cartDAO = new CartDAO();

            List<Cart> cartItems = cartDAO.getCartByCustomerID(customerID);
            if (cartItems.isEmpty()) {
                response.sendRedirect("View/Cart.jsp?message=Cart is empty");
                return;
            }

            Order order = new Order(null, customerID, totalAmount, discountAmount, finalAmount, new Date(), "Pending processing", null, null, null);
            String orderID = orderDAO.createOrder(order);

            orderDetailDAO.saveOrderDetails(orderID, cartItems);
            cartDAO.clearCart(customerID);

            response.sendRedirect("View/OrderHistory.jsp?message=Order placed successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("View/Checkout.jsp?message=Invalid input format");
        }
    }
}
