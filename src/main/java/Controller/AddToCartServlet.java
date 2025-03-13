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
 * Servlet handling adding products to the shopping cart.
 *
 * @author Le Minh Loc CE180992
 */
public class AddToCartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            // TODO: Implement logic if needed
        }
    }

    /**
     * Handles HTTP GET requests.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles HTTP POST requests to add a product to the cart.
     */
    @Override
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

        if (customerID == null || productID == null || proVariantID == null || quantityStr == null) {
            response.sendRedirect("ProductDetail.jsp?error=MissingData");
            return;
        }

        int quantity = Integer.parseInt(quantityStr);

        try ( Connection conn = DBContext.getConn()) {
            // Check if the product already exists in the cart
            String checkSql = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, customerID);
            checkPs.setString(2, productID);
            checkPs.setString(3, proVariantID);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // If the product exists, update the quantity
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
                // If the product does not exist, add a new entry
                String insertSql = "INSERT INTO Cart (customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setString(1, customerID);
                insertPs.setString(2, productID);
                insertPs.setString(3, proVariantID);
                insertPs.setInt(4, quantity);
                insertPs.executeUpdate();
            }

            // Redirect to the product page with a success message
            response.sendRedirect("Product?id=" + productID + "&message=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ProductDetail.jsp?error=DatabaseError");
        }
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Handles adding products to the cart";
    }
}
