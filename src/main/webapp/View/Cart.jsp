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
                    <p><strong><%= item.getProductName()%></strong></p>
                    <p>Color: <%= item.getColorName()%></p>
                    <p>Price: <span class="price"><fmt:formatNumber value="<%=item.getPrice()%>"  /></span></p>
                    <!-- Form ?? x�a s?n ph?m -->
                    <form action="<%= request.getContextPath()%>/Cart" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="cartID" value="<%= (item.getCartID() != null) ? item.getCartID() : ""%>">
                        <button type="submit" class="remove-btn" onclick="return confirm('Are you sure?')">Remove</button>
                    </form>
                </div>
                <div class="quantity">
                    <button onclick="changeQuantity(-1, <%= item.getPrice()%>, '<%= item.getCartID()%>')">-</button>
                    <span id="quantity_<%= item.getCartID()%>"><%= item.getQuantity()%></span>
                    <button onclick="changeQuantity(1, <%= item.getPrice()%>, '<%= item.getCartID()%>')">-</button>
                </div>
                <p>Total: <span id="total_<%= item.getCartID()%>">
                        <fmt:formatNumber value="<%= item.getPrice() * item.getQuantity()%>"  /> 
                    </span></p>
            </div>
            <% subtotal += item.getPrice() * item.getQuantity(); %>
            <% } %>
            <% } else { %>
            <p>Your cart is empty.</p>
            <% }%>
            <p>Subtotal: <span id="subtotal"><fmt:formatNumber value="<%= subtotal%>"  /></span></p>
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

        <script>
            function changeQuantity(amount, price, cartID) {
                console.log("Updating cart - cartID:", cartID);
                let quantityElement = document.getElementById("quantity_" + cartID);
                let totalElement = document.getElementById("total_" + cartID);
                let subtotalElement = document.getElementById("subtotal");

                if (!quantityElement || !totalElement) {
                    console.error("Error: Element not found for cartID:", cartID);
                    return;
                }

                let quantity = Math.max(0, parseInt(quantityElement.innerText) + amount);

                if (quantity === 0) {
                    if (!confirm("Do you want to remove this item from the cart?")) {
                        return;
                    }
                }

                quantityElement.innerText = quantity;
                totalElement.innerText = "$" + (price * quantity).toLocaleString();
                console.log("Updating cart - cartID:", quantity);

                $.ajax({
                    url: "<%= request.getContextPath()%>/Cart",
                    type: "POST",
                    data: {
                        action: quantity > 0 ? 'update' : 'delete',
                        cartID: cartID,
                        quantity: quantity
                    },
                    success: function (data) {
                        if (data.success) {
                            updateSubtotal();
                        }
                        location.reload();
                    },
                    error: function (xhr, status, error) {
                        console.error("Error updating cart:", error);
                    }
                });
            }

            function updateSubtotal() {
                let totalElements = document.querySelectorAll("[id^=total_]");
                let subtotal = 0;

                totalElements.forEach(el => {
                    subtotal += parseFloat(el.innerText.replace("$", "").replace(/,/g, ""));
                });

                document.getElementById("subtotal").innerText = "$" + subtotal.toLocaleString();
            }

        </script>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>