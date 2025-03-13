/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CartDAO;
import DAOs.OrderDAO;
import DAOs.OrderDetailDAO;
import Models.Cart;
import Models.Customer;
import Models.Order;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * Servlet handling the payment process.
 *
 * @author PC
 */
public class Payment extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO: Implement the payment processing logic here */
        }
    }

    /**
     * Handles the HTTP GET request (not used in this process).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP POST request for processing payment.
     *
     * @param request The HTTP request containing payment details.
     * @param response The HTTP response to redirect or display errors.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException If an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Redirect to login page if the user is not logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

        List<Cart> cartList = cartDAO.getCartByCustomerID(customerID);

        // Redirect if the cart is empty
        if (cartList.isEmpty()) {
            response.sendRedirect("Cart.jsp?message=Cart is empty");
            return;
        }

        double totalAmount = 0;
        for (Cart cart : cartList) {
            totalAmount += cartDAO.getProductPrice(cart.getProductID()) * cart.getQuantity();
        }

        double discount = 0; // If there is a voucher, apply discount logic here
        double finalAmount = totalAmount - discount;

        Order order = new Order();
        order.setCustomerID(String.valueOf(customerID));
        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discount);
        order.setFinalAmount(finalAmount);
        order.setOrderDate(new Date());
        order.setStatusOID("Pending");
        order.setVoucherID(null);

        // Create a new order and retrieve the order ID
        String orderID = orderDAO.createOrder(order);

        // Save order details for each item in the cart
        for (Cart cart : cartList) {
            orderDetailDAO.addOrderDetail(orderID, cart.getProductID(), cart.getQuantity());
        }

        // Clear the cart after successful order placement
        cartDAO.clearCart(customerID);

        response.sendRedirect("CheckoutSuccess.jsp?orderID=" + orderID);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return A string containing the servlet description.
     */
    @Override
    public String getServletInfo() {
        return "Handles the payment process for orders.";
    }
}
