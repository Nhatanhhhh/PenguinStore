/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CartDAO;
import DB.DBContext;
import Models.Cart;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Nhat_Anh
 */
public class AddToCartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//
//        // Nếu chưa đăng nhập, chuyển hướng về trang đăng nhập
//        if (session == null || session.getAttribute("user") == null) {
//            response.sendRedirect("View/LoginCustomer.jsp");
//            return;
//        }
//
//        Customer customer = (Customer) session.getAttribute("user");
//        String customerID = customer.getCustomerID();
//
//        try {
//            String productID = request.getParameter("productId");
//            String proVariantID = request.getParameter("proVariantID");
//            int quantity = Integer.parseInt(request.getParameter("quantity"));
//
//            Cart cartItem = new Cart(customerID, productID, proVariantID, quantity);
//            CartDAO cartDAO = new CartDAO();
//
//            boolean added = cartDAO.addToCart(cartItem);
//
//            if (added) {
//                response.sendRedirect("Cart.jsp?message=added_success");
//            } else {
//                response.sendRedirect("Cart.jsp?message=add_failed");
//            }
//        } catch (NumberFormatException e) {
//            e.printStackTrace();
//            response.sendRedirect("ProductDetail.jsp?error=invalid_data");
//        }
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect("View/LoginCustomer.jsp");
        return;
    }
    String customerID = customer.getCustomerID();
    String productID = request.getParameter("productID");
    String proVariantID = request.getParameter("variantId");
    String quantityStr = request.getParameter("quantity");
    System.out.println("cusid:" + customerID);
    if (customerID == null || productID == null || proVariantID == null || quantityStr == null) {
        response.sendRedirect("ProductDetail.jsp?error=MissingData");
        return;
    }

    int quantity = Integer.parseInt(quantityStr);

    try (Connection conn = DBContext.getConn()) {
        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        String checkSql = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
        PreparedStatement checkPs = conn.prepareStatement(checkSql);
        checkPs.setString(1, customerID);
        checkPs.setString(2, productID);
        checkPs.setString(3, proVariantID);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            // Nếu sản phẩm đã có, cập nhật số lượng
            int existingQuantity = rs.getInt("quantity");
            int newQuantity = existingQuantity + quantity;

            String updateSql = "UPDATE Cart SET quantity = ? WHERE customerID = ? AND productID = ? AND proVariantID = ?";
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, newQuantity);
            updatePs.setString(2, customerID);
            updatePs.setString(3, productID);
            updatePs.setString(4, proVariantID);
            updatePs.executeUpdate();
        } else {
            // Nếu sản phẩm chưa có, thêm mới vào giỏ hàng
            String insertSql = "INSERT INTO Cart (customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql);
            insertPs.setString(1, customerID);
            insertPs.setString(2, productID);
            insertPs.setString(3, proVariantID);
            insertPs.setInt(4, quantity);
            insertPs.executeUpdate();
        }

        // Hiển thị thông báo thành công kèm hai nút "Checkout" và "View Cart"
   response.sendRedirect("Product?id=" + productID + "&message=success");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ProductDetail.jsp?error=DatabaseError");
    }
}
}