package Controller;

import DAOs.CartDAO;
import Models.CartItem;
import Models.Customer;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
public class CartController extends HttpServlet {

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
        
        // Tạo Map để lưu productID tương ứng với từng CartItem
        Map<CartItem, String> productIDs = new HashMap<>();
        for (CartItem item : cartItems) {
            String productID = cartDAO.getProductIDByItem(item);
            if (productID != null) {
                productIDs.put(item, productID);
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productIDs", productIDs);
        request.getRequestDispatcher("View/Cart.jsp").forward(request, response);
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
        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        CartDAO cartDAO = new CartDAO();

        if ("delete".equals(action)) {
            // Xóa sản phẩm kh�?i gi�? hàng
            String productID = request.getParameter("productID");
            if (productID != null && !productID.isEmpty()) {
                cartDAO.removeFromCart(customerID, productID);
            }
        } else if ("clear".equals(action)) {
            // Xóa toàn bộ gi�? hàng
            cartDAO.clearCart(customerID);
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        }

        // Load lại gi�? hàng sau khi cập nhật
        List<CartItem> cartItems = cartDAO.viewCart(customerID);
        
        // Cập nhật Map chứa productID
        Map<CartItem, String> productIDs = new HashMap<>();
        for (CartItem item : cartItems) {
            String productID = cartDAO.getProductIDByItem(item);
            if (productID != null) {
                productIDs.put(item, productID);
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productIDs", productIDs);
        request.getRequestDispatcher("View/Cart.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Cart Controller handles cart operations";
    }

}
