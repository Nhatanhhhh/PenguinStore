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

        // Chỉ STAFF hoặc ADMIN mới có quyền cập nhật đơn hàng
        if (!role.equals("STAFF") && !role.equals("ADMIN")) {
            response.sendRedirect("View/AccessDenied.jsp");
            return;
        }

        // Lấy thông tin từ request
        String orderID = request.getParameter("orderID");
        String statusName = request.getParameter("statusName");
        
        // Cập nhật trạng thái đơn hàng
        OrderDAO orderDAO = new OrderDAO();
        String statusOID = orderDAO.getStatusOIDByName(statusName);

        if (statusOID == null) {
            request.setAttribute("error", "Invalid status name received.");
        } else {
            boolean isUpdated = orderDAO.updateOrderStatus(orderID, statusOID);
            request.setAttribute("message", isUpdated ? "Order status updated successfully!" : "Failed to update order status.");
        }

        // Load lại danh sách đơn hàng
        List<Order> orderList = orderDAO.getAllOrders();
        request.setAttribute("orderList", orderList);

        // Chuyển hướng tới trang tương ứng với vai trò
        if (role.equals("ADMIN")) {
            request.getRequestDispatcher("View/AdminOrder.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("View/OrderManagement.jsp").forward(request, response);
        }
    }
}
