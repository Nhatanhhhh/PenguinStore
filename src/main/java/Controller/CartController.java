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

public class CartController extends HttpServlet {

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

        Map<CartItem, String> productIDs = new HashMap<>();
        Map<String, Integer> stockQuantities = new HashMap<>();

        for (CartItem item : cartItems) {
            int stockQty = cartDAO.getStockQuantityByCartItem(item.getCartID());
            stockQuantities.put(item.getCartID().trim(), stockQty);
            System.out.println("CartID: " + item.getCartID() + ", Stock: " + stockQty);
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productIDs", productIDs);
        request.setAttribute("stockQuantities", stockQuantities);
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

        if ("update".equals(action)) {
            String cartID = request.getParameter("cartID");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Lấy thông tin variant và stock
            String variantId = cartDAO.getVariantIdByCartId(cartID);
            int stockQuantity = cartDAO.getStockQuantityByCartItem(cartID);
            int currentQuantityInCart = cartDAO.getCurrentQuantity(cartID);

            // Kiểm tra số lượng mới có vượt quá stock không
            if (quantity > stockQuantity) {
                JsonObject json = new JsonObject();
                json.addProperty("status", "failed");
                json.addProperty("message", "Cannot update quantity. Only " + stockQuantity + " items available in stock.");

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
                return;
            }

            // Cập nhật số lượng
            boolean success = cartDAO.updateCartItemQuan(cartID, quantity);
            JsonObject json = new JsonObject();

            if (success) {
                // Tính toán lại subtotal
                List<CartItem> updatedCartItems = cartDAO.viewCart(customerID);
                double subtotal = updatedCartItems.stream()
                        .mapToDouble(item -> item.getPrice() * item.getQuantity())
                        .sum();

                json.addProperty("status", "success");
                json.addProperty("subtotal", subtotal);
            } else {
                json.addProperty("status", "failed");
                json.addProperty("message", "Failed to update quantity.");
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());
            return;
        } else if ("delete".equals(action)) {
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

    @Override
    public String getServletInfo() {
        return "Cart Controller handles cart operations";
    }
}
