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
                <form action="<%= request.getContextPath()%>/Payment" method="post">
                    <h2>Contact</h2>
                    <% Customer customer = (Customer) request.getAttribute("customer");%>

                    <input type="email" name="email" placeholder="Email Address" required 
                           value="<%= (customer != null) ? customer.getEmail() : ""%>">

                    <h2>Delivery</h2>
                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="fullName" placeholder="Full Name" required 
                               value="<%= (customer != null) ? customer.getFullName() : ""%>" style="width: 50%;">

                        <input type="text" name="phoneNumber" placeholder="Phone Number" required 
                               value="<%= (customer != null) ? customer.getPhoneNumber() : ""%>" style="width: 50%;">
                    </div>
                    <input type="text" name="address" placeholder="Address" required 
                           value="<%= (customer != null) ? customer.getAddress() : ""%>">

                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="zip" placeholder="Zip" style="width: 50%;" required 
                               value="<%= (customer != null) ? customer.getZip() : ""%>">

                        <input type="text" name="state" placeholder="State" style="width: 50%;" required 
                               value="<%= (customer != null) ? customer.getState() : ""%>">
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
                <h3>Total: <span id="total">$<%= String.format("%.2f", subtotal)%></span></h3>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var discount = 0.00; // Bi?n to�n c?c l?u gi?m gi�
        var shippingFee = 40.00; // Ph� v?n chuy?n c? ??nh

        function updateTotal() {
            let subtotal = parseFloat(document.getElementById("subtotal").textContent);
            let total = subtotal + shippingFee - discount;

            // C?p nh?t t?ng ti?n hi?n th?
            document.getElementById("total").textContent = "$" + total.toFixed(2);

            // C?p nh?t input hidden ?? g?i l�n server
            document.getElementById("hiddenSubtotal").value = subtotal.toFixed(2);
            document.getElementById("hiddenDiscount").value = discount.toFixed(2);
            document.getElementById("hiddenTotal").value = total.toFixed(2);
        }

        // �p d?ng voucher
        document.getElementById("applyVoucher").addEventListener("click", function () {
            let voucherCode = document.getElementById("voucher").value.trim();

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
                        discount = 0.00;
                        document.getElementById("discount").textContent = "$0.00";
                    } else {
                        discount = response.discount; // C?p nh?t gi?m gi�
                        document.getElementById("discount").textContent = "$" + response.discount.toFixed(2);
                        document.getElementById("hiddenVoucher").value = voucherCode; // L?u m� voucher
                    }
                    updateTotal(); // C?p nh?t t?ng ti?n
                },
                error: function () {
                    alert("L?i khi ki?m tra voucher!");
                }
            });
        });

        // N?u c� m� voucher tr�n URL, t? ??ng ?i?n v�o input
        let params = new URLSearchParams(window.location.search);
        let voucherCode = params.get("voucher");
        if (voucherCode) {
            document.getElementById("voucher").value = voucherCode;
        }
        // C?p nh?t t?ng ti?n ban ??u
        updateTotal();
    });
    document.querySelector("form").addEventListener("submit", function (e) {
        console.log("Subtotal:", document.getElementById("hiddenSubtotal").value);
        console.log("Discount:", document.getElementById("hiddenDiscount").value);
        console.log("Total:", document.getElementById("hiddenTotal").value);

    });

</script>