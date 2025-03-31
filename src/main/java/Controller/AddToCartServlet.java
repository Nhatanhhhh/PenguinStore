package Controller;

import DAOs.AddCartDAO;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AddToCartServlet extends HttpServlet {

    private final AddCartDAO addCartDAO = new AddCartDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("Invalid request method");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
    
    try {
        if ("getVariant".equals(action)) {
            handleGetVariant(request, response);
            return;
        } else if ("getStock".equals(action)) {
            handleGetStock(request, response);
            return;
        } else if ("getCartQuantity".equals(action)) {
            handleGetCartQuantity(request, response);
            return;
        }

        // Các action khác yêu cầu đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }
            Customer customer = (Customer) session.getAttribute("user");

            String customerID = customer.getCustomerID();
            String productID = request.getParameter("productID");
            String variantId = request.getParameter("selectedVariantId");
            String quantityStr = request.getParameter("quantity");

            try {
                int quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    session.setAttribute("alertType", "error");
                    session.setAttribute("alertMessage", "Quantity must be greater than 0");
                    response.sendRedirect("Product?id=" + productID + "&action=detail");
                    return;
                }

                // Get current stock and cart quantities
                int stockQuantity = addCartDAO.getStockQuantity(variantId);
                int cartQuantity = addCartDAO.getCartQuantity(customerID, variantId);
                int remaining = stockQuantity - cartQuantity;

                if (quantity > remaining) {
                    String message;
                    if (remaining > 0) {
                        message = "You can only add " + remaining + " more items (already have " + cartQuantity + " in cart)";
                    } else {
                        message = "You already have the maximum quantity in cart";
                    }

                    session.setAttribute("alertType", "error");
                    session.setAttribute("alertMessage", message);
                    response.sendRedirect("Product?id=" + productID + "&action=detail");
                    return;
                }

                // Proceed with adding to cart
                boolean success = addCartDAO.addOrUpdateCart(customerID, variantId, quantity);

                if (success) {
                    session.setAttribute("alertType", "success");
                    session.setAttribute("alertMessage", "Product added to cart successfully");
                } else {
                    session.setAttribute("alertType", "error");
                    session.setAttribute("alertMessage", "Failed to add to cart - please try again");
                }

                response.sendRedirect("Product?id=" + productID + "&action=detail");

            } catch (NumberFormatException e) {
                session.setAttribute("alertType", "error");
                session.setAttribute("alertMessage", "Invalid quantity");
                response.sendRedirect("Product?id=" + productID + "&action=detail");
            }
        } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System error");
    }

    }

    private void handleGetCartQuantity(HttpServletRequest request, HttpServletResponse response){
        
    }
    
    private void handleGetStock(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String variantId = request.getParameter("variantId");
        if (variantId == null || variantId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing variantId parameter");
            return;
        }

        try {
            int stock = addCartDAO.getStockQuantity(variantId);
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.valueOf(stock));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System error");
        }
    }

    private void handleGetVariant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String productID = request.getParameter("productID");
        String sizeName = request.getParameter("size");
        String colorName = request.getParameter("color");

        if (productID == null || productID.isEmpty() || colorName == null || colorName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try {
            String variantId = addCartDAO.getVariantId(productID, sizeName, colorName);
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(variantId != null ? variantId : "null");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System error");
        }
    }

    private boolean validateInput(String productID, String variantId, String quantityStr) {
        return productID != null && !productID.isEmpty()
                && variantId != null && !variantId.isEmpty()
                && quantityStr != null && !quantityStr.isEmpty();
    }

    private void setSessionAlert(HttpSession session, String type, String message) {
        if (session != null) {
            session.setAttribute("alertType", type);
            session.setAttribute("alertMessage", message);
        }
    }
}
