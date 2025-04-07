<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, Models.Order, Models.Customer" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) {
        orders = new ArrayList<Order>();
    }

    // Pagination variables
    int currentPage = 1;
    int recordsPerPage = 10;

    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    int start = (currentPage - 1) * recordsPerPage;
    int end = Math.min(start + recordsPerPage, orders.size());
    int totalPages = (int) Math.ceil((double) orders.size() / recordsPerPage);

    List<Order> ordersPerPage = orders.subList(start, end);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content="10">
        <title>Order History</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
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

            /* Delivery successful - Green */
            .delivery-successful {
                background-color: #4CAF50;
                color: white;
            }

            /* Processed - Light yellow */
            .processed {
                background-color: #FFF9C4;
                color: #FF8F00;
            }

            /* Order Cancellation Request - Gray */
            .order-cancellation-request {
                background-color: #9E9E9E;
                color: white;
            }

            /* Pending processing - Dark yellow */
            .pending-processing {
                background-color: #FFC107;
                color: white;
            }

            /* Delivered to the carrier - Orange */
            .delivered-to-the-carrier {
                background-color: #FF9800;
                color: white;
            }

            /* Cancel order - Red */
            .cancel-order {
                background-color: #F44336;
                color: white;
            }

            /* Delivery failed - Red */
            .delivery-failed {
                background-color: #F44336;
                color: white;
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

            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }

            .pagination a {
                color: black;
                padding: 8px 16px;
                text-decoration: none;
                border: 1px solid #ddd;
                margin: 0 4px;
            }

            .pagination a.active {
                background-color: #000;
                color: white;
                border: 1px solid #000;
            }

            .pagination a:hover:not(.active) {
                background-color: #ddd;
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
                    <% for (Order order : ordersPerPage) {%>
                    <div class="order row" data-status="<%= order.getStatusName()%>">
                        <div class="col-md-10">
                            <div class="order-info">
                                <p><strong>OrderID:</strong> <%= (order.getOrderID().length() >= 4) ? order.getOrderID().substring(0, 4) : order.getOrderID()%></p>
                                <p><strong>Voucher code:</strong> <%= order.getVoucherName()%></p>
                                <p><strong>Order date:</strong> <%= order.getOrderDate()%></p>
                                <p><strong>Your order status:</strong> 
                                    <span class="status <%= order.getStatusName().toLowerCase().replace(" ", "-")%>">
                                        <%= order.getStatusName()%>
                                    </span>
                                </p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="btn-container">
                                <form action="<%= request.getContextPath()%>/OrderDetail" method="GET">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <button type="submit" class="button button-outline-dark" style="display: inline-block; white-space: nowrap; border-radius: 3px; width: 137px;">View Order</button>
                                </form>
                                <% if (!"Cancel order".equals(order.getStatusName())) { %>
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
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% }%>
                    <!-- Pagination -->
                    <div class="pagination">
                        <% if (currentPage > 1) {%>
                        <a href="?page=<%= currentPage - 1%>">«</a>
                        <% } %>

                        <% for (int i = 1; i <= totalPages; i++) {%>
                        <a href="?page=<%= i%>" <%= (i == currentPage) ? "class='active'" : ""%>><%= i%></a>
                        <% } %>

                        <% if (currentPage < totalPages) {%>
                        <a href="?page=<%= currentPage + 1%>">»</a>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Biến lưu trạng thái hiện tại
            let currentStatus = {
            <% for (Order order : ordersPerPage) {%>
                '<%= order.getOrderID()%>': '<%= order.getStatusName()%>',
            <% }%>
            };

            // Hàm kiểm tra cập nhật
            function checkForUpdates() {
                fetch('<%= request.getContextPath()%>/CheckOrderUpdates?customerID=<%= customer.getCustomerID()%>&lastCheck=' + lastCheckTime)
                        .then(response => response.json())
                        .then(data => {
                            if (data.updated) {
                                // Nếu có cập nhật, reload trang
                                window.location.reload();
                            }
                            // Cập nhật thời gian kiểm tra lần cuối
                            lastCheckTime = data.serverTime;
                        });
            }

            // Kiểm tra mỗi 5 giây
            let lastCheckTime = Date.now();
            setInterval(checkForUpdates, 5000);

            // Kiểm tra ngay khi load trang
            window.addEventListener('load', function () {
            // Đảm bảo không lấy từ cache
                fetch('<%= request.getContextPath()%>/OrderHistory', {
                    headers: {
                        'Cache-Control': 'no-cache'
                    }
                });
            });
        </script>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>