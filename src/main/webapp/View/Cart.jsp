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
                    <p><strong><%= item.getProductName()%></strong></p>
                    <p>Color: <%= item.getColorName()%></p>
                    <p>Price: $<span class="price"><%= item.getPrice()%></span></p>
                    <!-- Form ?? x�a s?n ph?m -->
                    <form action="<%= request.getContextPath()%>/Cart" method="post">
                        <input type="hidden" name="action" value="delete">
                        <% Map<CartItem, String> productIDs = (Map<CartItem, String>) request.getAttribute("productIDs");%>
                        <input type="hidden" name="productID" value="<%= (productIDs.get(item) != null && !productIDs.get(item).isEmpty()) ? productIDs.get(item) : "empty.jsp" %>">
                        <button type="submit" class="remove-btn" onclick="return confirm('Are you sure?')">Remove</button>
                    </form>
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

            <p>Subtotal: $<span id="subtotal"><%= subtotal%></span></p><form action="<%= request.getContextPath()%>/Cart" method="post">
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