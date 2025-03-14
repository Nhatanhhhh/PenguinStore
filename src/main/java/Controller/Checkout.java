package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.VVCustomerDAO;
import DAOs.VoucherDAO;
import Models.CartItem;
import Models.Customer;
import Models.UsedVoucher;
import Models.Voucher;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class Checkout extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CheckoutDAO checkoutDAO = new CheckoutDAO();

    @Override
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

        VVCustomerDAO dao = new VVCustomerDAO();
        List<Voucher> vouchers = dao.getVouchersByCustomerID(customerID);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("View/Checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Checkout Controller";
    }

}
