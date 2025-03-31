package Controller;

import DAOs.CartDAO;
import Models.CartItem;
import Models.Customer;
import Models.TempOrder;
import com.vnpay.common.Config;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

//@WebServlet("/VNPayPayment")
public class VNPayPaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("Login");
                return;
            }

            // Lấy thông tin khách hàng
            Customer customer = (Customer) session.getAttribute("user");
            String customerId = customer.getCustomerID();

            // Lấy thông tin giỏ hàng
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.viewCart(customerId);
            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("Checkout?error=empty_cart");
                return;
            }

            // Lấy tổng tiền từ request hoặc tính toán lại
            String totalAmountParam = request.getParameter("amount");
            double totalAmount;
            if (totalAmountParam != null && !totalAmountParam.isEmpty()) {
                totalAmount = Double.parseDouble(totalAmountParam);
            } else {
                // Tính toán tổng tiền nếu không có tham số amount
                totalAmount = cartItems.stream()
                        .mapToDouble(item -> item.getPrice() * item.getQuantity())
                        .sum();
            }

            // Lưu thông tin giỏ hàng vào session để sử dụng sau khi thanh toán
            session.setAttribute("vnpay_cart", cartItems);
            session.setAttribute("vnpay_customer", customer);
            session.setAttribute("vnpay_amount", totalAmount);

            session.setAttribute("tempOrder", new TempOrder(
                    customer.getCustomerID(),
                    cartItems,
                    null, // voucherID if available  
                    totalAmount, // subtotal
                    0, // discount
                    totalAmount // total
            ));

            // Chuẩn bị tham số cho VNPay
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";
            long amount = (long) (totalAmount * 100); // VNPay yêu cầu số tiền nhân 100
            String vnp_TxnRef = Config.getRandomNumber(8);
            String vnp_IpAddr = Config.getIpAddress(request);
            String vnp_TmnCode = Config.vnp_TmnCode;

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");

            // Thêm thông tin khách hàng vào mô tả đơn hàng
            vnp_Params.put("vnp_OrderInfo", "Payment for customer: " + customer.getCustomerID());

            // Cấu hình return URL
            String returnUrl = request.getScheme() + "://" + request.getServerName()
                    + (request.getServerPort() != 80 ? ":" + request.getServerPort() : "")
                    + request.getContextPath() + "/VNPayReturn";
            vnp_Params.put("vnp_ReturnUrl", returnUrl);

            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            // Thêm thời gian tạo và hết hạn
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            cld.add(Calendar.MINUTE, 20); // Đơn hàng hết hạn sau 15 phút
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            // Sắp xếp tham số theo thứ tự alphabet
            vnp_Params = Config.sortParams(vnp_Params);

            // Tạo query string
            StringBuilder query = new StringBuilder();
            for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
                if (query.length() > 0) {
                    query.append('&');
                }
                query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII.toString()));
            }

            // Tạo chữ ký bảo mật
            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, query.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);

            // Tạo URL thanh toán VNPay
            String paymentUrl = Config.vnp_PayUrl + "?" + query.toString();

            // Chuyển hướng đến VNPay
            response.sendRedirect(paymentUrl);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("Checkout?error=invalid_amount");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Checkout?error=payment_error");
        }
    }
}
