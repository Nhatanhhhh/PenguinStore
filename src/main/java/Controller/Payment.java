package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import Models.CartItem;
import Models.Customer;
import DB.DBContext;
import Models.TempOrder;
import Models.Type;
import Service.EmailService;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

//@WebServlet("/Payment")
public class Payment extends HttpServlet {

    private final EmailService emailService = new EmailService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }
        response.sendRedirect("Checkout");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
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

        // Kiểm tra nếu là callback từ VNPay
        if (request.getParameter("vnp_ResponseCode") != null) {
            handleVNPayCallback(request, response);
            return;
        }

        // Xử lý thanh toán thông thường
        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        String paymentMethod = request.getParameter("paymentMethod");

        // Lấy giỏ hàng
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Checkout?error=empty_cart");
            return;
        }

        // Xử lý voucher
        String voucherCode = request.getParameter("voucher");
        String voucherID = null;
        CheckoutDAO checkoutDAO = new CheckoutDAO();

        if (voucherCode != null && !voucherCode.isEmpty()) {
            voucherID = checkoutDAO.getVoucherIDByCode(voucherCode);
            if (voucherID == null) {
                response.sendRedirect("Checkout?error=invalid_voucher");
                return;
            }
        }

        // Tính toán tổng tiền
        double subtotal = calculateSubtotal(cartItems);
        double discount = voucherID != null ? checkoutDAO.getVoucherDiscount(voucherID) : 0;
        double shippingFee = 40000; // Add this line
        double total = subtotal + shippingFee - discount; // Include shipping fee

        // Nếu là thanh toán VNPay
        if ("vnpay".equals(paymentMethod)) {
            // Lưu thông tin đơn hàng tạm vào session
            session.setAttribute("tempOrder", new TempOrder(
                    customerID,
                    cartItems,
                    voucherID,
                    subtotal,
                    discount,
                    total
            ));

            // Chuyển hướng đến VNPay
            response.sendRedirect(request.getContextPath() + "/VNPayPayment?amount=" + total);
            return;
        }

        // If payment method is MoMo
        if ("momo".equals(paymentMethod)) {
            // Save temp order to session
            session.setAttribute("tempOrder", new TempOrder(
                    customerID,
                    cartItems,
                    voucherID,
                    subtotal,
                    discount,
                    total
            ));

            // Redirect to MoMo payment
            response.sendRedirect(request.getContextPath() + "/MoMoPayment?"
                    + "amount=" + total
                    + "&subtotal=" + subtotal
                    + "&discount=" + discount
                    + "&voucher=" + (voucherID != null ? voucherID : ""));
            return;
        }

        // Xử lý thanh toán COD
        processOrder(customer, cartItems, voucherID, subtotal, discount, total, response);
    }

    private void handleVNPayCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        // Kiểm tra kết quả thanh toán VNPay
        if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
            // Thanh toán thành công
            TempOrder tempOrder = (TempOrder) session.getAttribute("tempOrder");
            if (tempOrder == null) {
                response.sendRedirect("Checkout?error=order_not_found");
                return;
            }

            // Xử lý tạo đơn hàng
            processOrder(
                    (Customer) session.getAttribute("user"),
                    tempOrder.getCartItems(),
                    tempOrder.getVoucherID(),
                    tempOrder.getSubtotal(),
                    tempOrder.getDiscount(),
                    tempOrder.getTotal(),
                    response
            );

            // Xóa thông tin đơn hàng tạm
            session.removeAttribute("tempOrder");
        } else if ("0".equals(request.getParameter("errorCode"))) { // MoMo
            TempOrder tempOrder = (TempOrder) session.getAttribute("tempOrder");
            if (tempOrder == null) {
                response.sendRedirect("Checkout?error=order_not_found");
                return;
            }

            // Xử lý tạo đơn hàng
            processOrder(
                    (Customer) session.getAttribute("user"),
                    tempOrder.getCartItems(),
                    tempOrder.getVoucherID(),
                    tempOrder.getSubtotal(),
                    tempOrder.getDiscount(),
                    tempOrder.getTotal(),
                    response
            );
        } else {
            // Thanh toán thất bại
            response.sendRedirect("Checkout?error=payment_failed");
        }
    }

    private void processOrder(Customer customer, List<CartItem> cartItems,
            String voucherID, double subtotal, double discount,
            double total, HttpServletResponse response) throws IOException {
        String customerID = customer.getCustomerID();
        String orderID = UUID.randomUUID().toString();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String orderDate = LocalDateTime.now().format(dtf);
        CheckoutDAO checkoutDAO = new CheckoutDAO();
        CartDAO cartDAO = new CartDAO();

        try ( Connection conn = DBContext.getConn()) {
            conn.setAutoCommit(false);

            // 1. Thêm đơn hàng vào bảng Order
            insertOrder(conn, orderID, checkoutDAO.getPendingStatusOID(),
                    voucherID, customerID, subtotal, discount, total, orderDate);

            // 2. Thêm chi tiết đơn hàng và cập nhật số lượng tồn kho
            processOrderDetails(conn, cartItems, orderID, orderDate);

            conn.commit();

            // 3. Xóa giỏ hàng sau khi thanh toán thành công
            cartDAO.clearCart(customerID);

            // 4. Cập nhật trạng thái voucher nếu có
            if (voucherID != null) {
                checkoutDAO.updateUsedVoucherStatus(customerID, voucherID);
            }

            // 5. Gửi email xác nhận
            boolean emailSent = emailService.sendInvoiceEmail(
                    customer.getEmail(),
                    orderID,
                    cartItems,
                    subtotal,
                    discount,
                    total
            );
            if (!emailSent) {
                System.err.println("Failed to send invoice email for order: " + orderID);
            }

            response.sendRedirect("View/CheckoutSuccess.jsp?orderID=" + orderID);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Checkout?error=order_failed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Checkout?error=system_error");
        }
    }

    private double calculateSubtotal(List<CartItem> cartItems) {
        return cartItems.stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
    }

    private void insertOrder(Connection conn, String orderID, String statusOID,
            String voucherID, String customerID, double subtotal,
            double discount, double total, String orderDate) throws SQLException {
        String sql = "INSERT INTO [Order] (orderID, statusOID, voucherID, customerID, "
                + "totalAmount, discountAmount, finalAmount, orderDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try ( PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderID);
            stmt.setString(2, statusOID);
            stmt.setString(3, voucherID);
            stmt.setString(4, customerID);
            stmt.setDouble(5, subtotal);
            stmt.setDouble(6, discount);
            stmt.setDouble(7, total);
            stmt.setString(8, orderDate);
            stmt.executeUpdate();
        }
    }

    private void processOrderDetails(Connection conn, List<CartItem> cartItems,
            String orderID, String orderDate) throws SQLException {
        String detailSQL = "INSERT INTO OrderDetail (orderDetailID, orderID, productVariantID, "
                + "quantity, unitPrice, totalPrice, dateOrder) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        String updateStockSQL = "UPDATE ProductVariants SET stockQuantity = stockQuantity - ? "
                + "WHERE proVariantID = ?";

        try ( PreparedStatement detailStmt = conn.prepareStatement(detailSQL);  PreparedStatement stockStmt = conn.prepareStatement(updateStockSQL)) {

            for (CartItem item : cartItems) {
                // Thêm chi tiết đơn hàng
                detailStmt.setString(1, UUID.randomUUID().toString());
                detailStmt.setString(2, orderID);
                detailStmt.setString(3, item.getProVariantID());
                detailStmt.setInt(4, item.getQuantity());
                detailStmt.setDouble(5, item.getPrice());
                detailStmt.setDouble(6, item.getPrice() * item.getQuantity());
                detailStmt.setString(7, orderDate);
                detailStmt.addBatch();

                // Cập nhật số lượng tồn kho
                stockStmt.setInt(1, item.getQuantity());
                stockStmt.setString(2, item.getProVariantID());
                stockStmt.addBatch();
            }

            detailStmt.executeBatch();
            stockStmt.executeBatch();
        }
    }

}
