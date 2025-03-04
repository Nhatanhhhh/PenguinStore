<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
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
                    <p><strong><%= item.getProductName()%></strong></p>
                    <p>Color: <%= item.getColorName()%></p>
                    <p>Price: $<span class="price"><%= item.getPrice()%></span></p>
                </div>
                <div class="quantity">
                    <button onclick="changeQuantity(-1, <%= item.getPrice()%>, '<%= item.getProductName()%>')">-</button>
                    <span id="quantity_<%= item.getProductName()%>"><%= item.getQuantity()%></span>
                    <button onclick="changeQuantity(1, <%= item.getPrice()%>, '<%= item.getProductName()%>')">+</button>
                </div>
                <p>Total: $<span id="total_<%= item.getProductName()%>"><%= item.getPrice() * item.getQuantity()%></span></p>
            </div>
            <% subtotal += item.getPrice() * item.getQuantity(); %>
            <% } %>
            <% } else { %>
            <p>Your cart is empty.</p>
            <% }%>

            <p>Subtotal: $<span id="subtotal"><%= subtotal%></span></p>
            <div class="checkout">
                <form action="<%= request.getContextPath()%>/Checkout" method="post">
                    <button type="submit">Checkout</button>
                </form>

                <p><a href="#"></a></p>
            </div>
        </div>

        <script>
            function changeQuantity(amount, price, productName) {
                let quantityElement = document.getElementById("quantity_" + productName);
                let totalElement = document.getElementById("total_" + productName);
                let subtotalElement = document.getElementById("subtotal");

                let quantity = Math.max(1, parseInt(quantityElement.innerText) + amount);
                quantityElement.innerText = quantity;

                let total = (price * quantity).toFixed(2);
                totalElement.innerText = total;

                let newSubtotal = 0;
                document.querySelectorAll(".product p span.total").forEach(span => {
                    newSubtotal += parseFloat(span.innerText);
                });
                subtotalElement.innerText = newSubtotal.toFixed(2);
            }
        </script>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
