<%-- 
    Document   : OrderDetail
    Created on : Feb 22, 2025, 1:16:45 AM
    Author     : PC
--%>

<%@ page import="java.util.List, DTO.OrderDetailDTO" %>
<jsp:useBean id="orderDetails" scope="request" type="java.util.List" />
<jsp:useBean id="orderID" scope="request" type="java.lang.String" />

<!DOCTYPE html>
<html>
    <head>
        <title>Order Detail</title> 
        <link rel="stylesheet" href="styles.css">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="Assets/CSS/styles.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h2>Order Details for Order ID: <%= orderID %></h2>

        <% if (orderDetails.isEmpty()) { %>
        <p>No details found for this order.</p>
        <% } else { %>
        <table border="1">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Size</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% double totalAmount = 0; %>
                <% for (OrderDetailDTO detail : orderDetails) { 
                    double total = detail.getQuantity() * detail.getPrice();
                    totalAmount += total;
                %>
                <tr>
                    <td>
                        <img src="images/<%= detail.getImgName() %>" alt="<%= detail.getProductName() %>" width="50">
                        <%= detail.getProductName() %>
                    </td>
                    <td><%= detail.getSizeName() %></td>
                    <td><%= detail.getQuantity() %></td>
                    <td>$<%= detail.getPrice() %></td>
                    <td>$<%= total %></td>
                    <td><%= detail.getStatus() %></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="4"><strong>Total Amount</strong></td>
                    <td><strong>$<%= totalAmount %></strong></td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
        <% } %>

        <a href="/OrderHistory">Back to Order List</a>
        <%@include file="Footer.jsp"%>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>
