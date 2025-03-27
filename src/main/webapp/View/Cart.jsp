<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/cart.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h1>PENGUIN Cart</h1>
        <div class="cart-container">
            <div class="cart-header">
                <span>Product</span>
                <span>Price</span>
                <span>Quantity</span>
                <span>Total</span>
            </div>

            <%@ page import="java.util.List, Models.CartItem" %>
            <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems"); %>

            <% double subtotal = 0; %>
            <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <% for (CartItem item : cartItems) {%>
            <div class="product">
                <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                     alt="<%= item.getProductName()%>">
                <div>
                    <p><strong>
                            <%= item.getProductName().length() > 15 ? item.getProductName().substring(0, 15) + "..." : item.getProductName()%>
                        </strong></p>
                        <% if (item.getColorName() != null && !item.getColorName().isEmpty()) {%>
                    <p>Color: <%= item.getColorName()%></p>
                    <% } %>

                    <% if (item.getSizeName() != null && !item.getSizeName().isEmpty()) {%>
                    <p>Size: <%= item.getSizeName()%></p>
                    <% }%>

                    <p>Price: <span class="price"><fmt:formatNumber value="<%= item.getPrice()%>" pattern="#,###"/></span></p>

                    <form action="<%= request.getContextPath()%>/Cart" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="cartID" value="<%= (item.getCartID() != null) ? item.getCartID() : ""%>">
                        <button type="submit" class="remove-btn" onclick="return confirm('Are you sure?')">Remove</button>
                    </form>
                </div>
                <div class="quantity">
                    <button onclick="changeQuantity(-1, <%= item.getPrice()%>, '<%= item.getCartID()%>')">-</button>
                    <span id="quantity_<%= item.getCartID()%>"><%= item.getQuantity()%></span>
                    <button onclick="changeQuantity(1, <%= item.getPrice()%>, '<%= item.getCartID()%>')">+</button>
                </div>
                <p>Total: <span id="total_<%= item.getCartID()%>">
                        <fmt:formatNumber value="<%= item.getPrice() * item.getQuantity()%>" pattern="#,###"/> ₫
                    </span></p>
            </div>
            <% subtotal += item.getPrice() * item.getQuantity(); %>
            <% } %>
            <% } else {%>
            <p>Your cart is empty. 
                <a href="<%= request.getContextPath()%>/Product" style="color: blue; text-decoration: underline;">
                    Start shopping now
                </a>
            </p>
            <% }%>
            <p>Subtotal: <span id="subtotal" data-subtotal="<%= subtotal%>">
                    <fmt:formatNumber value="<%= subtotal%>" pattern="#,###"/> ₫
                </span></p>
            <form action="<%= request.getContextPath()%>/Cart" method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="clear-cart-btn" onclick="return confirm('Are you sure you want to clear the cart?')">Clear Cart</button>
            </form>

            <div class="checkout">
                <form action="<%= request.getContextPath()%>/Checkout" method="post">
                    <button type="submit">Checkout</button>
                </form>
                <p><a href="#"></a></p>
            </div>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
<script>
    function changeQuantity(amount, price, cartID, stockQuantity) {
        console.log("Updating cart - cartID:", cartID);
        let quantityElement = document.getElementById("quantity_" + cartID);
        let totalElement = document.getElementById("total_" + cartID);
        let subtotalElement = document.getElementById("subtotal");

        if (!quantityElement || !totalElement || !subtotalElement) {
            console.error("Error: Element not found for cartID:", cartID);
            return;
        }

        let currentQuantity = parseInt(quantityElement.innerText);
        let newQuantity = currentQuantity + amount;

        if (newQuantity < 1) {
            newQuantity = 1;
        } else if (newQuantity > stockQuantity) {
            alert("This product variation is not available in stock.");
            return;
        }

        quantityElement.innerText = newQuantity;
        totalElement.innerText = (price * newQuantity).toLocaleString('vi-VN', {
            maximumFractionDigits: 0
        }) + " ₫";

        // Proceed with the AJAX call to update the cart
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
                } else {
                    console.error("Error updating cart:", data.message);
                }
            },
            error: function (xhr, status, error) {
                console.error("Error updating cart:", error);
            }
        });
    }

    function updateSubtotal() {
        let totalElements = document.querySelectorAll("[id^=total_]"); // Lấy danh sách các tổng giá sản phẩm
        let subtotalElement = document.getElementById("subtotal");
        let subtotal = 0;

        totalElements.forEach(el => {
            let value = parseFloat(el.innerText.replace(/\D/g, "")); // Loại bỏ ký tự không phải số
            if (!isNaN(value)) {
                subtotal += value;
            }
        });

        if (subtotalElement) {
            subtotalElement.innerText = subtotal.toLocaleString('vi-VN') + " ₫";
            subtotalElement.setAttribute("data-subtotal", subtotal);
        }
    }
</script>
<style>
    .product img {
        width: 80px;
        height: auto;
    }
    .quantity {
        display: flex;
        align-items: center;
        justify-content: center; /* Căn giữa nội dung */
        gap: 10px; /* Khoảng cách giữa các phần tử */
    }

    .quantity button {
        width: 30px; /* Điều chỉnh kích thước */
        height: 30px;
        font-size: 18px;
        border: 1px solid #000;
        background-color: white;
        color: black;
        cursor: pointer;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .quantity span {
        font-size: 18px;
        text-align: center;
        font-weight: bold;
    }


    .quantity button:hover {
        background-color: black; /* Khi hover sẽ đổi màu */
        color: white; /* Chữ trắng để dễ nhìn */
    }

    .quantity span {
        min-width: 30px;
        text-align: center;
        font-size: 16px;
    }


</style>