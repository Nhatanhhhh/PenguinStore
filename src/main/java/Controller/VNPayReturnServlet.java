package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import DB.DBContext;
import Models.CartItem;
import Models.Customer;
import Models.TempOrder;
import Models.Type;
import Service.EmailService;
import com.vnpay.common.Config;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/VNPayReturn"})
public class VNPayReturnServlet extends HttpServlet {

    private final EmailService emailService = new EmailService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        request.setAttribute("listProduct", productDAO.getProductCustomer());
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);
        try {
            // Xác thực chữ ký VNPay
            System.out.println("Received VNPay callback with parameters:");
            request.getParameterMap().forEach((k, v)
                    -> System.out.println(k + "=" + String.join(",", v)));

            // Use TreeMap for automatic parameter sorting
            Map<String, String> fields = new TreeMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    // Skip vnp_SecureHash and vnp_SecureHashType as they shouldn't be included in hash calculation
                    if (!fieldName.equals("vnp_SecureHash") && !fieldName.equals("vnp_SecureHashType")) {
                        fields.put(fieldName, fieldValue);
                    }
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (vnp_SecureHash == null || vnp_SecureHash.isEmpty()) {
                response.sendRedirect("Checkout?error=missing_signature");
                return;
            }

            String signValue = Config.hashAllFields(fields);

            // Debug logging
            System.out.println("Parameters being hashed: " + fields);
            System.out.println("Calculated hash: " + signValue);
            System.out.println("Received hash: " + vnp_SecureHash);

            // Compare hashes (case-insensitive as VNPay may send uppercase)
            if (!signValue.equalsIgnoreCase(vnp_SecureHash)) {
                System.err.println("Hash verification failed");
                response.sendRedirect("Checkout?error=invalid_signature");
                return;
            }

            // Xử lý kết quả thanh toán
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("Login");
                return;
            }

            Customer customer = (Customer) session.getAttribute("user");

            // Lấy thông tin đơn hàng tạm từ session
            TempOrder tempOrder = (TempOrder) session.getAttribute("tempOrder");
            if (tempOrder == null) {
                response.sendRedirect("Checkout?error=order_not_found");
                return;
            }

            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                // Thanh toán thành công - xử lý tạo đơn hàng
                String orderID = processOrder(
                        customer,
                        tempOrder.getCartItems(),
                        tempOrder.getVoucherID(),
                        tempOrder.getSubtotal(),
                        tempOrder.getDiscount(),
                        tempOrder.getTotal(),
                        response
                );

                if (orderID != null) {
                    // Xóa thông tin tạm sau khi xử lý thành công
                    session.removeAttribute("tempOrder");
                    session.removeAttribute("vnpay_cart");
                    session.removeAttribute("vnpay_voucher");

                    // To just:
                    session.removeAttribute("tempOrder");

                    // Chuyển hướng đến trang thành công
                    response.sendRedirect("View/CheckoutSuccess.jsp?orderID=" + orderID);
                } else {
                    response.sendRedirect("Checkout?error=order_failed");
                }
            } else {
                // Thanh toán thất bại
                response.sendRedirect("Checkout?error=payment_failed&code="
                        + request.getParameter("vnp_TransactionStatus"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Checkout?error=system_error");
        }
    }

    private String processOrder(Customer customer, List<CartItem> cartItems,
            String voucherID, double subtotal, double discount,
            double total, HttpServletResponse response) {
        String customerID = customer.getCustomerID();
        String orderID = UUID.randomUUID().toString();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String orderDate = LocalDateTime.now().format(dtf);
        CheckoutDAO checkoutDAO = new CheckoutDAO();
        CartDAO cartDAO = new CartDAO();

        try ( Connection conn = DBContext.getConn()) {
            conn.setAutoCommit(false);

            // 1. Thêm đơn hàng vào database
            insertOrder(conn, orderID, checkoutDAO.getPendingStatusOID(),
                    voucherID, customerID, subtotal, discount, total, orderDate);

            // 2. Thêm chi tiết đơn hàng và cập nhật tồn kho
            processOrderDetails(conn, cartItems, orderID, orderDate);

            conn.commit();

            // 3. Xóa giỏ hàng
            cartDAO.clearCart(customerID);

            // 4. Cập nhật voucher nếu có
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

            return orderID;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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

                // Cập nhật tồn kho
                stockStmt.setInt(1, item.getQuantity());
                stockStmt.setString(2, item.getProVariantID());
                stockStmt.addBatch();
            }

            detailStmt.executeBatch();
            stockStmt.executeBatch();
        }
    }
}
