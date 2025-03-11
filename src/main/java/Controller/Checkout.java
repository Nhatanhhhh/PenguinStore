/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.VVCustomerDAO;
import DAOs.VoucherDAO;
import Models.Cart;
import Models.CartItem;
import Models.Customer;
import Models.UsedVoucher;
import Models.Voucher;
import com.nimbusds.jose.shaded.json.JSONObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Le Minh Loc CE180992
 */
public class Checkout extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
        }
    }

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

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        CheckoutDAO checkoutDAO = new CheckoutDAO();
        List<UsedVoucher> vouchers = checkoutDAO.getVoucherCheckout(customerID);

        // Debug danh sách voucher
        System.out.println("Vouchers: " + vouchers);

        // Gửi dữ liệu tới JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("View/Checkout.jsp").forward(request, response);
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
        String voucherCode = request.getParameter("voucherCode");

        System.out.println(customerID);

        CheckoutDAO dao = new CheckoutDAO();
        UsedVoucher voucher = dao.getVoucherByCode(voucherCode, customerID);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();

        if (voucher != null) {
            jsonResponse.put("valid", true);
            jsonResponse.put("discountPer", voucher.getDiscountPer());
            jsonResponse.put("discountAmount", voucher.getDiscountAmount());
            jsonResponse.put("minOrderValue", voucher.getMinOrderValue());
            jsonResponse.put("maxDiscountAmount", voucher.getMaxDiscountAmount());
        } else {
            jsonResponse.put("valid", false);
        }
        response.getWriter().write(jsonResponse.toString());

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        request.setAttribute(
                "cartItems", cartItems);
        request.getRequestDispatcher(
                "View/Checkout.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
