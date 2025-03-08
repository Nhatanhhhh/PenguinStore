package Controller;

import DAOs.CartDAO;
import DB.DBContext;
import Models.CartItem;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
public class CartController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        try {

            Connection conn = DBContext.getConn();
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.viewCart(customerID);

            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("View/Cart.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            Logger.getLogger(CartController.class.getName()).log(Level.SEVERE, "Invalid customerID format", e);
            response.sendRedirect("404.jsp"); // Chuyển hướng đến trang báo lỗi
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
