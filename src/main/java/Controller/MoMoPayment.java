package Controller;

import DAOs.CartDAO;
import DAOs.CheckoutDAO;
import Models.CartItem;
import Models.Customer;
import Models.TempOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.json.JSONObject;

@WebServlet("/MoMoPayment")
public class MoMoPayment extends HttpServlet {

    private static final String PARTNER_CODE = "MOMO"; // Replace with your MoMo partner code
    private static final String ACCESS_KEY = "YOUR_ACCESS_KEY"; // Replace with your MoMo access key
    private static final String SECRET_KEY = "YOUR_SECRET_KEY"; // Replace with your MoMo secret key
    private static final String PAYMENT_URL = "https://test-payment.momo.vn/gw_payment/transactionProcessor";
    private static final String RETURN_URL = "http://yourdomain.com/Payment"; // Your return URL
    private static final String NOTIFY_URL = "http://yourdomain.com/MoMoCallback"; // Your notify URL
    private static final String REQUEST_TYPE = "captureMoMoWallet";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        String amount = request.getParameter("amount");
        String phoneNumber = customer.getPhoneNumber();

        // Get cart items for order info
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.viewCart(customerID);

        // Create order info description
        String orderInfo = buildOrderInfo(cartItems);

        try {
            // Create MoMo payment request
            String requestId = UUID.randomUUID().toString();
            String orderId = UUID.randomUUID().toString();

            // Save temp order to session
            TempOrder tempOrder = new TempOrder(
                    customerID,
                    cartItems,
                    request.getParameter("voucher"),
                    Double.parseDouble(request.getParameter("subtotal")),
                    Double.parseDouble(request.getParameter("discount")),
                    Double.parseDouble(amount)
            );
            session.setAttribute("tempOrder", tempOrder);
            session.setAttribute("momoOrderId", orderId);

            // Create raw hash
            String rawHash = "partnerCode=" + PARTNER_CODE
                    + "&accessKey=" + ACCESS_KEY
                    + "&requestId=" + requestId
                    + "&amount=" + amount
                    + "&orderId=" + orderId
                    + "&orderInfo=" + orderInfo
                    + "&returnUrl=" + RETURN_URL
                    + "&notifyUrl=" + NOTIFY_URL
                    + "&extraData=" + "";

            // Create signature
            String signature = signHmacSHA256(rawHash, SECRET_KEY);

            // Create request body
            JSONObject requestBody = new JSONObject();
            requestBody.put("partnerCode", PARTNER_CODE);
            requestBody.put("accessKey", ACCESS_KEY);
            requestBody.put("requestId", requestId);
            requestBody.put("amount", amount);
            requestBody.put("orderId", orderId);
            requestBody.put("orderInfo", orderInfo);
            requestBody.put("returnUrl", RETURN_URL);
            requestBody.put("notifyUrl", NOTIFY_URL);
            requestBody.put("requestType", REQUEST_TYPE);
            requestBody.put("signature", signature);
            requestBody.put("extraData", "");

            // Redirect to MoMo payment page
            response.sendRedirect(PAYMENT_URL + "?requestId=" + requestId
                    + "&orderId=" + orderId
                    + "&amount=" + amount
                    + "&partnerCode=" + PARTNER_CODE
                    + "&signature=" + signature);

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Checkout?error=momo_error");
        }
    }

    private String buildOrderInfo(List<CartItem> cartItems) {
        StringBuilder orderInfo = new StringBuilder("Payment for: ");
        for (CartItem item : cartItems) {
            orderInfo.append(item.getProductName())
                    .append(" (x").append(item.getQuantity()).append("), ");
        }
        // Trim last comma
        if (orderInfo.length() > 2) {
            orderInfo.setLength(orderInfo.length() - 2);
        }
        return orderInfo.toString();
    }

    private String signHmacSHA256(String data, String secretKey)
            throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
        SecretKeySpec secret_key = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return bytesToHex(hash).toLowerCase();
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
