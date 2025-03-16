<%-- 
    Document   : CheckoutSuccess
    Created on : Mar 2, 2025, 3:29:05 PM
    Author     : Loc_LM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Successful</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <style>

        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            String orderID = request.getParameter("orderID");
        %>
        <div class="container">
            <h2>Order Successful</h2>
            <p>Thank you for your purchase!</p>
            <p>Your order ID is: <span class="order-id"><%= orderID.length() >= 4 ? orderID.substring(0, 4) : orderID%></span></p>
            <div class="button-group">
                <a href="<%= request.getContextPath()%>/Product" class="back-home">Back to Home</a>
                <a href="<%= request.getContextPath()%>/OrderHistory" class="my-order">My Order</a>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>