<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Models.CartItem, Models.Voucher" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>PENGUIN Checkout</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/co.css"/>
    </head>
    <body style="padding: 0">
        <%@include file="Header.jsp"%>
        <h1>PENGUIN Checkout</h1>
        <div class="container">
            <div class="form-section">
                <form action="OrderHistory" method="post">
                    <h2>Contact</h2>
                    <input type="email" name="email" placeholder="Email Address" required>

                    <h2>Delivery</h2>
                    <input type="text" name="fullName" placeholder="Full Name" required>
                    <input type="text" name="address" placeholder="Address" required>

                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="zip" placeholder="Zip" style="width: 50%;" required>
                        <input type="text" name="state" placeholder="State" style="width: 50%;" required>
                    </div>

                    <input type="hidden" name="subtotal" id="hiddenSubtotal" value="0">
                    <input type="hidden" name="voucher" id="hiddenVoucher">
                    <input type="hidden" name="discount" id="hiddenDiscount">
                    <input type="hidden" name="total" id="hiddenTotal">

                    <button type="submit" id="payNow">Order Now</button>
                </form>
            </div>
            <div class="summary-section">
                <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems"); %>
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <% double subtotal = 0; %>
                <% for (CartItem item : cartItems) {%>
                <% subtotal += item.getPrice() * item.getQuantity();%>
                <div class="product">
                    <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                         alt="<%= item.getProductName()%>" width="80" height="80">
                    <div>
                        <h3><%= item.getProductName()%></h3>
                        <p>Color: <%= item.getColorName()%></p>
                        <p>Quantity: <%= item.getQuantity()%></p>
                        <p>Price: $<%= String.format("%.2f", item.getPrice() * item.getQuantity())%></p>
                    </div>
                </div>
                <% }%>
                <hr>
                <p>Subtotal: $<span id="subtotal"><%= String.format("%.2f", subtotal)%></span></p>
                <a href="<%= request.getContextPath()%>/VVCustomer" class="btn btn-primary">
                    View Vouchers
                </a>


                <div style="display: flex; gap: 10px; align-items: center;">
                    <input type="text" id="voucher" placeholder="Voucher code">
                    <button type="button" id="applyVoucher" class="btn btn-danger btn-sm" style="width: 60px;">Apply</button>
                </div>

                <p>Voucher Discount: <span id="discount">$0</span></p>
                <p>Shipping: $40.00</p>
                <h3>Total: <span id="total">$<%= String.format("%.2f", subtotal + 40)%></span></h3>
                <% } else { %>
                <p>Your cart is empty!</p>
                <% }%>
            </div>

        </div>

        <%@include file="Footer.jsp"%>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>

</html>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        let subtotal = parseFloat(document.getElementById("subtotal").textContent);
        let shippingFee = 40.00;
        let discount = 0.00;

        function updateTotal() {
            let total = subtotal + shippingFee - discount;
            document.getElementById("total").textContent = "$" + total.toFixed(2);
            document.getElementById("hiddenTotal").value = total.toFixed(2);
        }

        document.getElementById("applyVoucher").addEventListener("click", function () {
            let voucherCode = document.getElementById("voucher").value;
            if (!voucherCode) {
                alert("Vui l�ng nh?p m� voucher!");
                return;
            }

            $.ajax({
                url: "<%= request.getContextPath()%>/UseVoucher",
                type: "GET",
                data: {
                    voucherCode: voucherCode,
                    subtotal: parseFloat(document.getElementById("subtotal").textContent)
                },
                dataType: "json",
                success: function (response) {
                    if (response.status === "error") {
                        alert(response.message);
                        document.getElementById("discount").textContent = "$0.00";
                    } else {
                        document.getElementById("discount").textContent = "$" + response.discount.toFixed(2);
                    }
                },
                error: function () {
                    alert("L?i khi ki?m tra voucher!");
                }
            });
        });


        updateTotal();
    });

    document.addEventListener("DOMContentLoaded", function () {
        let params = new URLSearchParams(window.location.search);
        let voucherCode = params.get("voucher");
        if (voucherCode) {
            document.getElementById("voucher").value = voucherCode; // ?i?n m� v�o � input
        }
    });
</script>