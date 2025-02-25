<%-- 
    Document   : Cart
    Created on : Feb 25, 2025, 1:42:37 AM
    Author     : Loc_LM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>

    </head>
    <body>
        <%@include file="Header.jsp"%>

        <h1>Shopping Cart</h1>
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Color</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    if (cartItems != null) {
                        for (CartItem item : cartItems) {
                %>
                <tr>
                    <td><%= item.getProductName() %></td>
                    <td>$<%= item.getPrice() %></td>
                    <td><%= item.getColorName() %></td>
                    <td>
                        <button>-</button>
                        <%= item.getQuantity() %>
                        <button>+</button>
                    </td>
                    <td>$<%= item.getPrice() * item.getQuantity() %></td>
                    <td><a href="removeCartItem?product=<%= item.getProductName() %>">Remove</a></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="6">Your cart is empty.</td></tr>
                <% } %>
            </tbody>
        </table>

        <a href="/Checkout"><button>Checkout</button></a>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
    <script>
        function applyDiscountCode() {
            var discountCode = document.getElementById("voucherCode").value;
            if (discountCode.trim() !== "") {
                window.location.href = "/Cart?voucherCode=" + encodeURIComponent(discountCode);
            } else {
                alert("Vui lòng nhập mã giảm giá!");
            }
        }
        function checkPaymentMethod(event) {
            var usePointsCheckbox = document.getElementById('usePoints');
            var form = document.getElementById('orderForm');
            var pickupCheckbox = document.getElementById('pickup');
            var address = document.getElementById('address');

            if (pickupCheckbox.checked || (!pickupCheckbox.checked && address.value.trim() !== "")) {
                if (usePointsCheckbox.checked) {
                    form.action = "/Payment";
                } else {
                    form.action = "/Order";
                }
            } else {
                alert('Bạn phải chọn "Đến lấy" hoặc nhập địa chỉ nhận hàng!');
                event.preventDefault();
                return;
            }
        }

        function deleteCartItem(cartItemId) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', '/Cart', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        location.reload();
                    }
                };
                xhr.send('action=delete&cartItemId=' + cartItemId);
            }
        }
        function toggleCheckboxes() {
            var pickupCheckbox = document.getElementById('pickup');
            var addressInput = document.getElementById('address');
            var shippingFeeElement = document.getElementById('shippingFee');
            var totalElement = document.getElementById('totalPrice');
            var totalElementTemp = document.getElementById('totalPriceTemp');
            var originalTotal = parseInt(totalElement.textContent.replace(/[^\d]/g, ''), 10);
            if (pickupCheckbox.checked) {
                addressInput.disabled = true;
                if (shippingFeeElement.textContent === "20,000 đ") {
                    totalElement.textContent = (originalTotal - 20000).toLocaleString() + " đ";
                    totalElementTemp.value = (originalTotal - 20000);
                }
                shippingFeeElement.textContent = "0 đ";
            } else {
                addressInput.disabled = false;
                if (shippingFeeElement.textContent === "0 đ") {
                    totalElement.textContent = (originalTotal + 20000).toLocaleString() + " đ";
                    totalElementTemp.value = (originalTotal + 20000);
                }
                shippingFeeElement.textContent = "20,000 đ"; // Phí giao hàng mặc định
            }
        }
        window.onload = function () {
            var pickupCheckbox = document.getElementById('pickup');
            var usePointsCheckbox = document.getElementById('usePoints');
            usePointsCheckbox.checked = true;
            pickupCheckbox.checked = false;
            toggleCheckboxes();
        };
    </script>
</html>
