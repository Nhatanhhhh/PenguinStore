package Controller;

import DAOs.CheckoutDAO;
import Models.Customer;
import Models.TempOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/MoMoCallback")
public class MoMoCallback extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCallback(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCallback(request, response);
    }

    private void processCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        String errorCode = request.getParameter("errorCode");
        String orderId = request.getParameter("orderId");
        String sessionOrderId = (String) session.getAttribute("momoOrderId");

        // Verify this is the callback for our order
        if (!orderId.equals(sessionOrderId)) {
            response.sendRedirect("Checkout?error=invalid_order");
            return;
        }

        if ("0".equals(errorCode)) {
            // Payment successful
            TempOrder tempOrder = (TempOrder) session.getAttribute("tempOrder");
            if (tempOrder == null) {
                response.sendRedirect("Checkout?error=order_not_found");
                return;
            }

            // Process the order
//            Payment paymentController = new Payment();
//            paymentController.processOrder(
//                    (Customer) session.getAttribute("user"),
//                    tempOrder.getCartItems(),
//                    tempOrder.getVoucherID(),
//                    tempOrder.getSubtotal(),
//                    tempOrder.getDiscount(),
//                    tempOrder.getTotal(),
//                    response
//            );

            // Clear session attributes
            session.removeAttribute("tempOrder");
            session.removeAttribute("momoOrderId");
        } else {
            // Payment failed
            response.sendRedirect("Checkout?error=payment_failed&code=" + errorCode);
        }
    }
}
