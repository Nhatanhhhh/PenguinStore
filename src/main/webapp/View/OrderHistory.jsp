<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Models.Order" %>
<jsp:useBean id="orders" scope="request" type="java.util.List" />

<!DOCTYPE html>
<html>
<head>
    <title>Order List</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<h2>Your Orders</h2>

<% if (orders.isEmpty()) { %>
    <p>You have no orders yet. <a href="products.jsp">Start shopping now!</a></p>
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

</body>
</html>
