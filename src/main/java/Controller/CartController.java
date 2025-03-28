package Controller;

import DAOs.CartDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import Models.CartItem;
import Models.Customer;
import Models.Type;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.JsonObject;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;

/**
 * CartController handles user cart operations, including viewing, updating,
 * deleting, and clearing the shopping cart.
 */
public class CartController extends HttpServlet {

    /**
     * Handles HTTP GET requests to display the cart contents.
     */
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

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        // Create a Map to store productID corresponding to each CartItem
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

    /**
     * Handles HTTP POST requests for cart actions (update, delete, clear).
     */
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

        if ("update".equals(action)) {
            String cartID = request.getParameter("cartID");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity == 0) {
                // Xóa sản phẩm khỏi giỏ hàng nếu quantity = 0
                boolean deleted = cartDAO.removeFromCart(cartID);

                JsonObject json = new JsonObject();
                json.addProperty("status", deleted ? "deleted" : "failed");
                json.addProperty("cartID", cartID);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
                return;
            }

            // Kiểm tra số lượng tồn kho
            int stockQuantity = cartDAO.getStockQuantityByCartItem(cartID);

            if (quantity > stockQuantity) {
                // Send an error response indicating insufficient stock
                JsonObject json = new JsonObject();
                json.addProperty("status", "failed");
                json.addProperty("message", "This product variation is not available in stock.");
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
                return;
            }

            // Proceed with updating the cart item quantity
            boolean success = cartDAO.updateCartItemQuan(cartID, quantity);
            String successMessage = success ? "success" : "failed";

            JsonObject json = new JsonObject();
            json.addProperty("status", successMessage);
            json.addProperty("cartID", cartID);
            json.addProperty("quantity", quantity);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());
        } else if ("delete".equals(action)) {
            // Handle deletion as previously
            String cartID = request.getParameter("cartID");
            if (cartID != null && !cartID.isEmpty()) {
                cartDAO.removeFromCart(cartID);
            }
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        } else if ("clear".equals(action)) {
            cartDAO.clearCart(customerID);
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.viewCart(customerID);
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

    /**
     * Returns a short description of the servlet.
     *
     * @return A string containing servlet description.
     */
    @Override
    public String getServletInfo() {
        return "Cart Controller handles cart operations";
    }
}
