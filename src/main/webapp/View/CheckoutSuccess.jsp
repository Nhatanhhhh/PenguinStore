<%-- 
    Document   : CheckoutSuccess
    Created on : Mar 2, 2025, 3:29:05 PM
    Author     : Loc_LM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Successful</title>
        
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        
        <div class="container text-center mt-5">
            <% String orderID = request.getParameter("orderID"); %>
            <h2 class="text-success">Order Successful</h2>
            <p class="lead">Thank you for your purchase!</p>
            
            <p>Your Order ID is: 
                <span class="order-id font-weight-bold">
                    <%= (orderID != null && orderID.length() >= 4) ? orderID.substring(0, 4).toUpperCase() : orderID.toUpperCase() %>
                </span>
            </p>
            
            <div class="button-group mt-4">
                <a href="<%= request.getContextPath()%>/Product" class="btn btn-primary">Back to Home</a>
                <a href="<%= request.getContextPath()%>/OrderHistory" class="btn btn-secondary">My Order</a>
            </div>
        </div>
        
        <%@include file="Footer.jsp"%>
        
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>