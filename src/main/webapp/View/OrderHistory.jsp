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
                padding: 8px 20px;
                border-radius: 4px;
                background-color: #FF4D4D;
                color: #FFF;
                font-size: 13px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-cancel:hover {
                color: #FF4D4D;
                border: 1px solid #FF4D4D;
                background: transparent;
            }
            
            .btn-recancel {
                padding: 8px 20px;
                border-radius: 4px;
                background-color: #3498DB;
                color: #FFF;
                font-size: 13px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-recancel:hover {
                color: #3498DB;
                border: 1px solid #3498DB;
                background: transparent;
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
                    <div class="ViewFeedbackCustomer"><a href="<%= request.getContextPath()%>/ViewFeedbackCustomer">View Reply</a></div>
                    <div class="divider"></div>
                </div>

                <div class="col-md-10">
                    <% for (Order order : orders) {%>
                    <div class="order row" data-status="<%= order.getStatusName()%>">
                        <div class="col-md-10">
                            <div class="order-info">
                                <p><strong>OrderID:</strong> <%= (order.getOrderID().length() >= 4) ? order.getOrderID().substring(0, 4) : order.getOrderID()%></p>
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
                                    <button type="submit" class="button button-outline-dark" style="display: inline-block; white-space: nowrap; border-radius: 3px; width: 137px;">View Order</button>
                                </form>
                                <% if ("Delivery successful".equals(order.getStatusName())) {%>
                                <form action="<%= request.getContextPath()%>/Feedback" method="GET">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <button class="button button-dark" style="display: inline-block; white-space: nowrap; border-radius: 3px;">Write A Review</button>
                                </form>
                                <% } else if ("Order Cancellation Request".equals(order.getStatusName())) {%>
                                <form action="<%= request.getContextPath()%>/OrderHistory" method="POST">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <input type="hidden" name="newStatus" value="Pending processing">
                                    <button type="submit" class="btn btn-recancel" style="display: inline-block; white-space: nowrap; border-radius: 3px; width: 137px; height: 42px;">ReCancel</button>
                                </form>
                                <% } else {%>
                                <form action="<%= request.getContextPath()%>/OrderHistory" method="POST">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <input type="hidden" name="newStatus" value="Order Cancellation Request">
                                    <button type="submit" class="btn btn-cancel" style="display: inline-block; width: 137px; height: 42px;">Cancel Order</button>
                                </form>
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