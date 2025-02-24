<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>
<%@ page import="java.util.List, java.util.ArrayList, Models.Order" %>

<% 
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<Order>();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order List</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="Assets/CSS/style.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h2>Your Orders</h2>
        <% if (orders.isEmpty()) { %>
        <p>You have no orders yet. <a href="/ProductController">Start shopping now!</a></p>
        <% } else { %>
        <table border="1">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Total Price</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order order : orders) { %>
                <tr>
                    <td><%= order.getOrderID() %></td>
                    <td><%= order.getOrderDate() %></td>
                    <td>$<%= order.getFinalAmount() %></td>
                    <td><%= order.getStatusOID() %></td>
                    <td><a href="OrderDetail?orderID=<%= order.getOrderID() %>">View Details</a></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
        <%@include file="Footer.jsp"%>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>
