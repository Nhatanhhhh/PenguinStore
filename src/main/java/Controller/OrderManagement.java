/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.OrderDAO;
import Models.Order;
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
public class OrderManagement extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Khởi tạo DAO
        OrderDAO orderDAO = new OrderDAO();

        // Lấy danh sách tất cả đơn hàng
        List<Order> orderList = orderDAO.getAllOrders();

        // Đẩy danh sách đơn hàng vào request
        request.setAttribute("orderList", orderList);

        // Chuyển hướng tới trang JSP để hiển thị dữ liệu
        request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ request
        String orderID = request.getParameter("orderID");
        String statusName = request.getParameter("statusName");

        // Chuyển đổi statusName thành statusOID
        OrderDAO orderDAO = new OrderDAO();
        String statusOID = orderDAO.getStatusOIDByName(statusName);
        if (statusOID == null) {
            request.setAttribute("error", "Invalid status name received.");
            request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
            return;
        }

        if (statusOID != null) {
            // Cập nhật trạng thái đơn hàng
            boolean isUpdated = orderDAO.updateOrderStatus(orderID, statusOID);
            if (isUpdated) {
                request.setAttribute("message", "Order status updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update order status.");
            }
        } else {
            request.setAttribute("error", "Invalid status name.");
        }

        // Load lại danh sách đơn hàng
        List<Order> orderList = orderDAO.getAllOrders();
        request.setAttribute("orderList", orderList);

        // Quay lại trang quản lý đơn hàng
        request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
