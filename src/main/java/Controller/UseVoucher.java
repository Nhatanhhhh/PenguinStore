/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CheckoutDAO;
import Models.Customer;
import Models.UsedVoucher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Le Minh Loc - CE180992
 */
public class UseVoucher extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CheckoutDAO checkoutDAO = new CheckoutDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        String voucherCode = request.getParameter("voucherCode");
        double subtotal = Double.parseDouble(request.getParameter("subtotal"));

        UsedVoucher voucher = checkoutDAO.getUsedVoucherByCode(customerID, voucherCode);
        session.setAttribute("useVoucher", voucher);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (voucher == null) {
            out.print("{\"status\": \"error\", \"message\": \"Voucher does not exist or has expired\"}");
            return;
        }

        // Check the validity period of the voucher
        java.util.Date currentDate = new java.util.Date();
        if (voucher.getValidFrom() != null && voucher.getValidFrom().after(currentDate)) {
            out.print("{\"status\": \"error\", \"message\": \"Voucher is not yet valid\"}");
            return;
        }
        if (voucher.getValidUntil() != null && voucher.getValidUntil().before(currentDate)) {
            out.print("{\"status\": \"error\", \"message\": \"Voucher has expired\"}");
            return;
        }

        double discount = 0;
        if (voucher.getDiscountPer() > 0) { // Percentage discount
            if (subtotal < voucher.getMinOrderValue()) {
                out.print("{\"status\": \"error\", \"message\": \"Order value must be greater than " + voucher.getMinOrderValue() + "đ  to apply\"}");
                return;
            }
            discount = (subtotal * voucher.getDiscountPer()) / 100;
            if (discount > voucher.getMaxDiscountAmount()) {
                discount = voucher.getMaxDiscountAmount();
            }
        } else { // Giảm số tiền cố định
            discount = voucher.getDiscountAmount();
        }
        
        session.setAttribute("discount", discount);

        out.print(
                "{\"status\": \"success\", \"discount\": " + discount + "}");
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
