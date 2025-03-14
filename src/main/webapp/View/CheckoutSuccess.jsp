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
        <title>Home Page</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>

    </head>
    <body>
        <%@include file="Header.jsp"%>


        <%            String orderID = request.getParameter("orderID");
        %>
        <h2>Order Successful</h2>
        <p>Your order ID is: <%= orderID.length() >= 4 ? orderID.substring(0, 4) : orderID%></p>
        <a href="/Product">Back to Home</a>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>