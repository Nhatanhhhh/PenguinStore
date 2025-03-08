<%-- 
    Document   : Checkout
    Created on : Mar 1, 2025, 2:52:17 PM
    Author     : Loc_LM
--%>
<%@ page import="Models.Customer, Models.Cart, Models.Product, Models.ProductVariant, java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    double subtotal = (double) request.getAttribute("subtotal");
    double shippingFee = (double) request.getAttribute("shippingFee");
    double total = (double) request.getAttribute("total");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>

    </head>
    <body>
        <%@include file="Header.jsp"%>

        <div class="checkout-container">
            <h1 class="checkout-title">PENGUIN Checkout</h1>

            <div class="checkout-content">
                <!-- Left Side: Form -->
                <div class="checkout-form">
                    <h2>Contact</h2>
                    <input type="email" placeholder="Email Address" value="<%= customer.getEmail() %>">

                    <h2>Delivery</h2>
                    <input type="text" placeholder="Full Name" value="<%= customer.getFullName() %>">
                    <input type="text" placeholder="Address" value="<%= customer.getAddress() %>">
                    <div class="row">
                        <input type="text" placeholder="Zip" value="<%= customer.getZip() %>">
                        <input type="text" placeholder="State" value="<%= customer.getState() %>">
                    </div>
                    <div class="checkbox-container">
                        <input type="checkbox" id="save-info">
                        <label for="save-info">Save This Info For Future</label>
                    </div>
                    <button class="pay-button">Pay Now</button>
                </div>

                <!-- Right Side: Order Summary -->
                <div class="checkout-summary">
                    <% for (Cart cart : cartItems) { %>
                    <div class="item">
                        <img src="https://via.placeholder.com/80" alt="<%= cart.getProduct().getProductName() %>">
                        <div class="item-details">
                            <p class="item-title"><%= cart.getProduct().getProductName() %></p>
                            <p class="item-color"><%= cart.getProductVariant().getColorName() %></p>
                        </div>
                        <p class="item-price">$<%= cart.getProduct().getPrice() %></p>
                    </div>
                    <% } %>
                    <hr>
                    <div class="summary">
                        <p>Subtotal <span>$<%= subtotal %></span></p>
                        <p>Shipping <span>$<%= shippingFee %></span></p>
                        <p class="total">Total <span>$<%= total %></span></p>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
    }

    body {
        background-color: #f8f8f8;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .checkout-container {
        width: 80%;
        background: white;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .checkout-title {
        text-align: center;
        font-size: 28px;
        margin-bottom: 20px;
    }

    .checkout-content {
        display: flex;
        justify-content: space-between;
    }

    .checkout-form {
        width: 48%;
    }

    .checkout-form h2 {
        font-size: 18px;
        margin-bottom: 10px;
    }

    .checkout-form input {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .row {
        display: flex;
        gap: 10px;
    }

    .row input {
        width: 48%;
    }

    .checkbox-container {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .pay-button {
        width: 100%;
        padding: 12px;
        background-color: black;
        color: white;
        font-size: 16px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 10px;
    }

    .checkout-summary {
        width: 48%;
        background: #f4f4f4;
        padding: 20px;
        border-radius: 5px;
    }

    .item {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .item img {
        width: 80px;
        height: auto;
        border-radius: 5px;
    }

    .item-details {
        flex-grow: 1;
    }

    .item-title {
        font-size: 16px;
        font-weight: bold;
    }

    .item-color {
        color: gray;
    }

    .item-price {
        font-weight: bold;
    }

    .summary p {
        display: flex;
        justify-content: space-between;
        margin: 10px 0;
    }

    .total {
        font-weight: bold;
    }

    footer {
        text-align: center;
        margin-top: 20px;
        font-size: 12px;
        color: gray;
    }

</style>