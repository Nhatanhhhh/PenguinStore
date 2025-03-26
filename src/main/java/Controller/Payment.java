package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.OrderDAO;
import DAOs.OrderDetailDAO;
import Models.CartItem;
import Models.Customer;
import DB.DBContext;
import Models.Cart;
import Service.EmailService;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.activation.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

public class Payment extends HttpServlet {

    private final EmailService emailService = new EmailService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        CheckoutDAO checkoutDAO = new CheckoutDAO();

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItemsByCustomerID(customerID);
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Checkout.jsp?error=empty_cart");
            return;
        }

        String statusOID = request.getParameter("statusOID");
        if (statusOID == null || statusOID.isEmpty()) {
            statusOID = checkoutDAO.getPendingStatusOID();
            if (statusOID == null) {
                response.sendRedirect("Checkout.jsp?error=status_not_found");
                return;
            }
        }

        String orderID = UUID.randomUUID().toString();
        String voucherCode = request.getParameter("voucher");
        String voucherID = null;
        if (voucherCode != null && !voucherCode.isEmpty()) {
            voucherID = checkoutDAO.getVoucherIDByCode(voucherCode);
        }

        double subtotal = Double.parseDouble(request.getParameter("subtotal"));
        double discount = Double.parseDouble(request.getParameter("discount"));
        double total = Double.parseDouble(request.getParameter("total"));
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String orderDate = LocalDateTime.now().format(dtf);
        try ( Connection conn = DBContext.getConn()) {
            conn.setAutoCommit(false);

            // Lưu vào bảng Order
            String insertOrderSQL = "INSERT INTO [Order] (orderID, statusOID, voucherID, customerID, totalAmount, discountAmount, finalAmount, orderDate) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try ( PreparedStatement orderStmt = conn.prepareStatement(insertOrderSQL)) {
                orderStmt.setString(1, orderID);
                orderStmt.setString(2, statusOID);
                orderStmt.setString(3, (voucherID != null && !voucherID.isEmpty()) ? voucherID : null);
                orderStmt.setString(4, customerID);
                orderStmt.setDouble(5, subtotal);
                orderStmt.setDouble(6, discount);
                orderStmt.setDouble(7, total);
                orderStmt.setString(8, orderDate);
                orderStmt.executeUpdate();
            }

            // Lưu vào bảng OrderDetail
            String insertOrderDetailSQL = "INSERT INTO OrderDetail (orderDetailID, orderID, productVariantID, quantity, unitPrice, totalPrice, dateOrder) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            // Câu lệnh cập nhật stockQuantity trong ProductVariants
            String updateStockSQL = "UPDATE ProductVariants SET stockQuantity = stockQuantity - ? WHERE proVariantID = ?";
            try ( PreparedStatement orderDetailStmt = conn.prepareStatement(insertOrderDetailSQL);  PreparedStatement updateStockStmt = conn.prepareStatement(updateStockSQL)) {

                String[] sizeNames = request.getParameterValues("sizeName");
                String[] colorNames = request.getParameterValues("colorName");

                for (int i = 0; i < cartItems.size(); i++) {
                    CartItem item = cartItems.get(i);

                    // Lấy giá trị tương ứng với sản phẩm hiện tại
                    String sizeName = (sizeNames != null && i < sizeNames.length) ? sizeNames[i] : "";
                    String colorName = (colorNames != null && i < colorNames.length) ? colorNames[i] : "";
                    // Cập nhật vào CartItem
                    item.setSizeName(sizeName);
                    item.setColorName(colorName);
                    // Lấy productVariantID chính xác
                    String proVariantID = checkoutDAO.getProductVariantID(item.getProductID(), colorName, sizeName);
                    System.out.println("Checking item: ProductID=" + item.getProductID()
                            + ", Color=" + colorName + ", Size=" + sizeName
                            + ", proVariantID=" + proVariantID);

                    if (proVariantID != null) {
                        // Thêm vào OrderDetail
                        orderDetailStmt.setString(1, UUID.randomUUID().toString());
                        orderDetailStmt.setString(2, orderID);
                        orderDetailStmt.setString(3, proVariantID);
                        orderDetailStmt.setInt(4, item.getQuantity());
                        orderDetailStmt.setDouble(5, item.getPrice());
                        orderDetailStmt.setDouble(6, item.getPrice() * item.getQuantity());
                        orderDetailStmt.setString(7, orderDate);
                        orderDetailStmt.addBatch();

                        // Cập nhật stockQuantity
                        updateStockStmt.setInt(1, item.getQuantity());
                        updateStockStmt.setString(2, proVariantID);
                        updateStockStmt.addBatch();
                    }
                }
                // Thực thi batch
                orderDetailStmt.executeBatch();
                updateStockStmt.executeBatch();
            }

            conn.commit();
            cartDAO.clearCart(customerID);
            if (voucherID != null) {
                checkoutDAO.updateUsedVoucherStatus(customerID, voucherID);
            }

            boolean emailSent = emailService.sendInvoiceEmail(customer.getEmail(), orderID, cartItems, subtotal, discount, total);
            if (!emailSent) {
                System.err.println("Failed to send invoice email for order: " + orderID);
            }

            response.sendRedirect("View/CheckoutSuccess.jsp?orderID=" + orderID);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Checkout.jsp?error=order_failed");
        }

    }
}