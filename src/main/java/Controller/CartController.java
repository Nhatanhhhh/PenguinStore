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
 * CartController handles user cart operations, including viewing, deleting, and
 * clearing the shopping cart.
 *
 * @author PC
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
     * Handles HTTP POST requests for cart actions (delete, clear).
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

        if ("delete".equals(action)) {
            // Remove a product from the cart
            String productID = request.getParameter("productID");
            if (productID != null && !productID.isEmpty()) {
                cartDAO.removeFromCart(customerID, productID);
            }
        } else if ("clear".equals(action)) {
            // Clear the entire cart
            cartDAO.clearCart(customerID);
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        }

        // Reload the cart after updates
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        // Update the Map containing productIDs
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
