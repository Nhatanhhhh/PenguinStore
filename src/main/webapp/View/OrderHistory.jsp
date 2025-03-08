<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, Models.Order, Models.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) {
        orders = new ArrayList<Order>();
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order List</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/oh.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>

        <%                Customer customer = (Customer) session.getAttribute("user");
        %>
        <h1 class="text-center mb-4" style="font-size: 35px;">Order History</h1>

        <!-- Error or Success Messages -->
        <%
            String message = (String) request.getAttribute("errorMessage");
            if (message != null) {
        %>
        <div class="alert alert-danger text-center"><%= message%></div>
        <%
            }
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <div class="alert alert-success text-center"><%= successMessage%></div>
        <%
            }
        %>

        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Order</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            Order
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="list col-md-2">
                    <div class="divider"></div>
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a  href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="order"><a style="font-weight: bold;">Order</a></div>
                    <div class="password"><a href="#">Password</a></div>
                </div>

                <% for (Order order : orders) {%>
                <div class="order" data-status="<%= order.getStatusName()%>">
                    <div class="order-info">
                        <p><strong>OrderID:</strong> <%= (order.getOrderID().length() >= 4) ? order.getOrderID().substring(0, 4) : order.getOrderID()%></p>
                        <p><strong>Voucher code:</strong> <%= order.getVoucherName()%></p>
                        <p><strong>Order date:</strong> <%= order.getOrderDate()%></p>
                        <span class="status <%= order.getStatusName().toLowerCase().replace(" ", "-")%>">
                            <%= order.getStatusName()%>
                        </span> Your product has been <%= order.getStatusName().toLowerCase()%>
                    </div>
                    <div class="btn-container">
                        <form action="<%= request.getContextPath()%>/OrderDetail" method="GET">
                            <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                            <button type="submit" class="btn btn-view">View Order</button>
                        </form>
                        <% if ("Delivery successful".equals(order.getStatusName())) { %>
                        <button class="btn btn-review">Write A Review</button>
                        <% } else { %>
                        <button class="btn btn-cancel">Cancel Order</button>
                        <% } %>
                    </div>
                </div>
                <% }%>

            </div>
    </body>
    <div style="background-color: #F9FAFB;  padding: 40px 0px;">
        <div class="row">
            <div class="col-md-6 d-flex justify-content-center">
                <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
            </div>
            <div class="col-md-6">
                <div style="width: 300px; height: 80px; margin-top: 40px;">
                    <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                    <div style="margin-left: 50px; margin-top: 50px;">
                        <a href="#" class="button button-dark">New Products</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@include file="Footer.jsp"%>

</html>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".order").forEach(order => {
            let status = order.getAttribute("data-status");
            let reviewBtn = order.querySelector(".btn-review");
            let cancelBtn = order.querySelector(".btn-cancel");

            if (status === "Delivery successful") {
                if (cancelBtn)
                    cancelBtn.style.display = "none";
            } else {
                if (reviewBtn)
                    reviewBtn.style.display = "none";
            }
        });
    });
</script>
<style>

</style>