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
        <title>Order List</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
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
                            View your Order
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

                <div class="col-md-10">
                    <% if (orders.isEmpty()) { %>
                    <p>You have no orders yet. <a href="/ProductController">Start shopping now!</a></p>
                    <% } else {%>
                    <table border="1">
                        <thead class="table table-bordered">
                            <tr class="thead-dark">
                                <th>Order Date</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order order : orders) {%>
                            <tr>
                                <td><%= order.getOrderDate()%></td>
                                <td><%= order.getFinalAmount()%><i class="fa-solid fa-dollar-sign"></i></td>
                                <td><%= order.getStatusOID()%></td>
                                <td><a href="OrderDetail?orderID=<%= order.getOrderID()%>">View Details</a></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% }%>
                </div>
            </div>


        </div>



        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
