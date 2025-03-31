package Controller;

import DAOs.OrderDAO;
import Models.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Le Minh Loc - CE180992
 */
public class OrderManagement extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("View/LoginManager.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Chỉ STAFF hoặc ADMIN mới có quyền truy cập
        if (!role.equals("STAFF") && !role.equals("ADMIN")) {
            response.sendRedirect("View/AccessDenied.jsp");
            return;
        }

        // Khởi tạo DAO
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getAllOrders();

        // Đẩy danh sách đơn hàng vào request
        request.setAttribute("orderList", orderList);

        // Chuyển hướng tới trang tương ứng với vai trò
        if (role.equals("ADMIN")) {
            request.getRequestDispatcher("View/AdminOrder.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("View/LoginManager.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!role.equals("STAFF") && !role.equals("ADMIN")) {
            response.sendRedirect("View/AccessDenied.jsp");
            return;
        }

        String orderID = request.getParameter("orderID");
        String statusName = request.getParameter("statusName");

        OrderDAO orderDAO = new OrderDAO();
        String statusOID = orderDAO.getStatusOIDByName(statusName);

        if (statusOID == null) {
            request.setAttribute("error", "Invalid status name received.");
        } else {
            boolean isUpdated = orderDAO.updateOrderStatus(orderID, statusOID);

            // Chỉ khôi phục stock khi chuyển sang trạng thái hủy
            if (isUpdated && ("Cancel order".equals(statusName) || "Order Cancellation Request".equals(statusName))) {
                orderDAO.restoreStockQuantities(orderID);

                // Gửi signal đến tất cả session rằng đơn hàng đã được cập nhật
                getServletContext().setAttribute("lastOrderUpdate", System.currentTimeMillis());
            }

            if (isUpdated) {
                request.setAttribute("message", "Order status updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update order status. It may already be in the requested state.");
            }
        }

        // Load updated order list
        List<Order> orderList = orderDAO.getAllOrders();
        request.setAttribute("orderList", orderList);

        // Forward to appropriate view
        if (role.equals("ADMIN")) {
            request.getRequestDispatcher("View/AdminOrder.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
        }
    }
}
