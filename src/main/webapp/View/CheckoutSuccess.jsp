<%--
    Document   : CheckoutSuccess
    Created on : Mar 2, 2025, 3:29:05 PM
    Author     : Loc_LM
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Successful</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <style>
            .success-container {
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                background-color: #f9f9f9;
                text-align: center;
            }

            .success-container h2 {
                color: #28a745; /* Green color for success */
                margin-bottom: 15px;
                font-size: 2.2rem;
            }

            .success-container p {
                font-size: 1.1rem;
                color: #555;
                margin-bottom: 20px;
            }

            .order-id {
                font-weight: bold;
                color: #007bff; /* Blue color for emphasis */
            }

            .button-group {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-top: 25px;
            }

            .button-group a {
                display: inline-block;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }

            .back-home {
                background-color: #007bff; /* Blue color */
                color: white;
            }

            .back-home:hover {
                background-color: #0056b3;
            }

            .my-order {
                background-color: #28a745; /* Green color */
                color: white;
            }

            .my-order:hover {
                background-color: #1e7e34;
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%        String orderID = request.getParameter("orderID");
        %>
        <div class="container">
            <div class="success-container">
                <h2>Order Successful</h2>
                <p>Thank you for your purchase!</p>
                <p>Your order ID is: 
                    <span class="order-id">
                        <%= orderID != null && orderID.length() >= 4 ? orderID.substring(0, 4).toUpperCase() : (orderID != null ? orderID.toUpperCase() : "N/A")%>
                    </span>
                </p>
                <div class="button-group">
                    <a href="<%= request.getContextPath()%>/Product" class="back-home">Back to Home</a>
                    <a href="<%= request.getContextPath()%>/OrderHistory" class="my-order">My Order</a>
                </div>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>