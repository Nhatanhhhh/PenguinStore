<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
        <%
            List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
            System.out.println("Debug JSP - cartItems: " + cartItems);
        %>
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
                           value="<%= (customer != null) ? customer.getAddress() : ""%>">

                    <h2>Delivery</h2>
                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="fullName" placeholder="Full Name" required 
                               value="<%= (customer != null) ? customer.getFullName() : ""%>" style="width: 50%;">
                        <input type="text" name="phoneNumber" placeholder="Phone Number" required 
                               value="<%= (customer != null) ? customer.getPhoneNumber() : ""%>" style="width: 50%;">
                    </div>
                    <input type="text" name="address" placeholder="Address" required 
                           value="<%= (customer != null) ? customer.getEmail() : ""%>">
                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="zip" placeholder="Zip" style="width: 50%;" required 
                               value="<%= (customer != null) ? customer.getZip() : ""%>">
                        <input type="text" name="state" placeholder="State" style="width: 50%;" required 
                               value="<%= (customer != null) ? customer.getState() : ""%>">
                    </div>

                    <%-- Input hidden để gửi giá trị --%>
                    <input type="hidden" name="subtotal" id="hiddenSubtotal" value="0">
                    <input type="hidden" name="voucher" id="hiddenVoucher">
                    <input type="hidden" name="discount" id="hiddenDiscount">
                    <input type="hidden" name="total" id="hiddenTotal">
                    <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <% for (CartItem item : cartItems) {%>
                    <input type="hidden" name="sizeName" value="<%= item.getSizeName() != null ? item.getSizeName() : ""%>">
                    <input type="hidden" name="colorName" value="<%= item.getColorName() != null ? item.getColorName() : ""%>">
                    <% } %>
                    <% } %>
                    <button type="submit" id="payNow">Order Now</button>
                </form>
            </div>
            <div class="summary-section">
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <% double subtotal = 0; %>
                <% for (CartItem item : cartItems) {%>
                <% subtotal += item.getPrice() * item.getQuantity();%>
                <div class="product">
                    <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                         alt="<%= item.getProductName()%>" width="80" height="80">
                    <div>
                        <h3><%= item.getProductName()%></h3>

                        <% if (item.getColorName() != null && !item.getColorName().isEmpty()) {%>
                        <p>Color: <%= item.getColorName()%></p>
                        <% } %>

                        <% if (item.getSizeName() != null && !item.getSizeName().isEmpty()) {%>
                        <p>Size: <%= item.getSizeName()%></p>
                        <% }%>
                        <p>Quantity: <%= item.getQuantity()%></p>
                        <p>Price: <fmt:formatNumber value="<%= item.getPrice() * item.getQuantity()%>" pattern="#,###" /> ₫</p>
                    </div>
                </div>
                <% }%>
                <hr>
                <p>Subtotal: <span id="subtotal"><fmt:formatNumber value="<%= subtotal%>" pattern="#,###" /> ₫</span></p>
                <a href="<%= request.getContextPath()%>/VVCustomer" class="btn btn-primary">
                    View Vouchers
                </a>


                <div style="display: flex; gap: 10px; align-items: center;">
                    <input type="text" id="voucher" placeholder="Voucher code">
                    <button type="button" id="applyVoucher" class="btn btn-danger btn-sm" style="width: 60px;">Apply</button>
                </div>

                <p>Voucher Discount: <span id="discount">0 ₫</span></p>
                <p>Shipping: 40.000 ₫</p>
                <h3>Total: <span id="total"><fmt:formatNumber value="<%= subtotal%>" pattern="#,###" /> </span></h3>
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
        var shippingFee = 40000; // Ph� v?n chuy?n c? ??nh
        function updateSubtotal() {
            let subtotal = 0;
            // Lặp qua tất cả các sản phẩm và tính tổng
            document.querySelectorAll('.product').forEach(product => {
                let totalElement = product.querySelector('[id^="total_"]');
                if (totalElement) {
                    let totalText = totalElement.innerText.replace(' ₫', '').replace(/\./g, '');
                    subtotal += parseFloat(totalText);
                }
            });

            // Cập nhật subtotal
            let subtotalElement = document.getElementById("subtotal");
            if (subtotalElement) {
                subtotalElement.innerText = subtotal.toLocaleString('vi-VN', {
                    maximumFractionDigits: 0
                }) + " ₫";
            }

            // Cập nhật hidden field nếu có
            let hiddenSubtotal = document.getElementById("hiddenSubtotal");
            if (hiddenSubtotal) {
                hiddenSubtotal.value = subtotal;
            }

            // Gọi hàm updateTotal để tính toán lại tổng cuối cùng
            updateTotal();
        }

        function updateTotal() {
            let subtotal = 0;
            let subtotalElement = document.getElementById("subtotal");
            if (subtotalElement) {
                let subtotalText = subtotalElement.innerText.replace(' ₫', '').replace(/\./g, '');
                subtotal = parseFloat(subtotalText);
            }

            // Lấy phí vận chuyển và giảm giá
            let shippingFee = 40000; // Hoặc lấy từ element nếu có
            let discount = 0; // Hoặc lấy từ element nếu có

            let total = subtotal + shippingFee - discount;

            // Cập nhật tổng tiền
            let totalElement = document.getElementById("total");
            if (totalElement) {
                totalElement.innerText = total.toLocaleString('vi-VN', {
                    maximumFractionDigits: 0
                }) + " ₫";
            }

            // Cập nhật hidden fields nếu có
            let hiddenDiscount = document.getElementById("hiddenDiscount");
            if (hiddenDiscount) {
                hiddenDiscount.value = discount;
            }

            let hiddenTotal = document.getElementById("hiddenTotal");
            if (hiddenTotal) {
                hiddenTotal.value = total;
            }
        }
        function changeQuantity(amount, price, cartID, stockQuantity) {
            console.log("Updating cart - cartID:", cartID);
            let quantityElement = document.getElementById("quantity_" + cartID);
            let totalElement = document.getElementById("total_" + cartID);
            let productElement = quantityElement.closest(".product"); // Lấy phần tử sản phẩm
            let subtotalElement = document.getElementById("subtotal");

            if (!quantityElement || !totalElement || !subtotalElement) {
                console.error("Error: Element not found for cartID:", cartID);
                return;
            }

            let currentQuantity = parseInt(quantityElement.innerText);
            let newQuantity = currentQuantity + amount;

            if (newQuantity < 0) {
                return; // Không cho phép số âm (tránh lỗi)
            }

            // Nếu số lượng = 0, thực hiện xóa sản phẩm khỏi giỏ hàng
            if (newQuantity === 0) {
                $.ajax({
                    url: "<%= request.getContextPath()%>/Cart",
                    type: "POST",
                    data: {
                        action: 'update',
                        cartID: cartID,
                        quantity: 0
                    },
                    success: function (data) {
                        if (data.status === "deleted") {
                            productElement.remove(); // Xóa sản phẩm khỏi giao diện
                            updateSubtotal();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error deleting cart item:", error);
                    }
                });
                return;
            }

            if (newQuantity > stockQuantity) {
                alert("This product variation is not available in stock.");
                return;
            }

            // Cập nhật số lượng trên giao diện
            quantityElement.innerText = newQuantity;
            totalElement.innerText = (price * newQuantity).toLocaleString('vi-VN', {
                maximumFractionDigits: 0
            }) + " ₫";

            // Gửi request cập nhật số lượng
            $.ajax({
                url: "<%= request.getContextPath()%>/Cart",
                type: "POST",
                data: {
                    action: 'update',
                    cartID: cartID,
                    quantity: newQuantity
                },
                success: function (data) {
                    if (data.status === "success") {
                        updateSubtotal();
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error updating cart:", error);
                }
            });
        }


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