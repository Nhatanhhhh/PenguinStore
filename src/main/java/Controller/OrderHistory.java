package Controller;

import DAOs.OrderDAO;
import DAOs.OrderDetailDAO;
import DAOs.CartDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import Models.Customer;
import Models.Order;
import Models.Cart;
import Models.Type;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
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
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        request.setAttribute("listProduct", productDAO.getProductCustomer());
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);

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

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            updateOrderStatus(request, response);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderID = request.getParameter("orderID");
        String newStatus = request.getParameter("newStatus");

        OrderDAO orderDAO = new OrderDAO();
        boolean success = orderDAO.updateOrderStatus(orderID, newStatus);

        if (success) {
            request.setAttribute("successMessage", "Order status updated successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to update order status.");
        }
        doGet(request, response);  // Load lại danh sách đơn hàng
    }

}
