<%-- 
    Document   : Cart
    Created on : Feb 25, 2025, 1:42:37 AM
    Author     : Loc_LM
--%>

<%@page import="Models.Cart"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
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
                    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
                    if (cartItems != null && !cartItems.isEmpty()) {
                        for (Cart item : cartItems) {
                %>
                <tr>
                    <td><%= item.getCartID() %></td>
                    <td><%= item.getCustomerID() %></td>
                    <td><%= item.getProVariantID() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= item.getProductID() * item.getQuantity() %></td>
                    <td><a href="deleteCartItem?cartID=<%= item.getCartID() %>">Remove</a></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="6">Your cart is empty.</td></tr>
                <% } %>
            </tbody>
        </table>

        <a href="<%= request.getContextPath()%>/Checkout"><button>Checkout</button></a>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>