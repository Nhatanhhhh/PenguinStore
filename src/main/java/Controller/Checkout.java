package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import DAOs.VVCustomerDAO;
import DAOs.VoucherDAO;
import Models.CartItem;
import Models.Customer;
import Models.Type;
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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

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

        // Lấy thông tin giỏ hàng
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        // Lấy danh sách voucher của khách hàng
        VVCustomerDAO dao = new VVCustomerDAO();
        List<Voucher> vouchers = dao.getVouchersByCustomerID(customerID);

        // Lấy thông tin khách hàng từ database
        Customer customerDetails = checkoutDAO.getCustomerByID(customerID);

        // Gửi dữ liệu tới JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("customer", customerDetails);

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
