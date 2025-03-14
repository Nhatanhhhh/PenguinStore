<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, Models.Order, Models.Customer" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null)
        orders = new ArrayList<Order>();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order History</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <style>
            .order {
                border-bottom: 1px solid #E5E5E5;
                padding: 20px 0;
            }

            .order-info p {
                margin: 5px 0;
                font-size: 16px;
            }

            .status {
                font-size: 14px;
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 5px;
            }

            .delivered {
                background-color: #E1FCEF;
                color: #198754;
            }

            .in-process {
                background-color: #FFF4E5;
                color: #D97706;
            }

            .btn-container {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .btn-view {
                background-color: #000;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
            }

            .btn-view:hover {
                background-color: #333;
            }

            .btn-review {
                background-color: #000;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
            }

            .btn-review:hover {
                background-color: #333;
            }

            .btn-cancel {
                background-color: #FF4D4D;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
            }

            .btn-cancel:hover {
                background-color: #E60000;
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer customer = (Customer) session.getAttribute("user");
        %>

        <h1 class="text-center mb-4" style="font-size: 35px;">My Order</h1>

        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Order</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            View your Order
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="list col-md-2">
                    <div class="divider"></div>
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="orderhistory"><a style="font-weight: bold;">Order</a></div>
                    <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
                    <div class="ViewFeedbackCustomer"><a href="<%= request.getContextPath()%>/ViewFeedbackCustomer">Feedback</a></div>
                    <div class="divider"></div>
                </div>

                <div class="col-md-10">
                    <% for (Order order : orders) {%>
                    <div class="order row" data-status="<%= order.getStatusName()%>">
                        <div class="col-md-10">
                            <div class="order-info">
                                <!-- Ẩn OrderID -->
                                <p><strong>Voucher code:</strong> <%= order.getVoucherName()%></p>
                                <p><strong>Order date:</strong> <%= order.getOrderDate()%></p>
                                <span class="status <%= order.getStatusName().toLowerCase().replace(" ", "-")%>">
                                    <%= order.getStatusName()%>
                                </span> Your product has been <%= order.getStatusName().toLowerCase()%>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="btn-container">
                                <form action="<%= request.getContextPath()%>/OrderDetail" method="GET">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <button type="submit" class="button button-outline-dark">View Order</button>
                                </form>
                                <% if ("Delivery successful".equals(order.getStatusName())) { %>
                                <button class="button button-dark">Write A Review</button>
                                <% } else { %>
                                <button class="btn btn-cancel">Cancel Order</button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% }%>
                </div>
            </div>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>