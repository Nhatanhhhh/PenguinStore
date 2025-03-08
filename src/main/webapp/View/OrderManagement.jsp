<%@page import="Models.Order"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Order Management</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <style>
            #layoutSidenav {
                display: flex;
            }

            .col-md-10 {
                flex-grow: 1;
                max-width: calc(100% - 250px);
                padding-left: 0 !important;
                margin-left: 0 !important;
            }

            #orderTable thead {
                background-color: #343a40 !important;
                color: white !important;
            }

            #orderTable th {
                text-align: center;
                vertical-align: middle;
            }

            .text-success {
                color: green !important;
                font-weight: bold;
            }

            .text-danger {
                color: red !important;
                font-weight: bold;
            }

        </style>
    </head>
    <body class="sb-nav-fixed">
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <!-- Hiển thị thông báo lỗi hoặc thành công -->
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

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 p-0">
                    <%@include file="Staff/NavigationStaff.jsp" %>
                </div>

                <!-- Nội dung chính -->
                <div class="col-md-10 p-0">
                    <%@include file="Staff/HeaderStaff.jsp" %>

                    <div class="px-4">
                        <h2 class="mt-4 text-danger">Order Management</h2>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">Manage Orders</li>
                        </ol>

                        <!-- Bộ lọc và tìm kiếm -->
                        <div class="d-flex justify-content-between mb-3">
                            <div>
                                <label>Filter by order status:</label>
                                <select id="filterStatus" class="form-select d-inline-block w-auto">
                                    <option value="all">All</option>
                                    <option value="pending-processing">Pending processing</option>
                                    <option value="processed">Processed</option>
                                    <option value="order-cancellation-request">Order Cancellation Request</option>
                                    <option value="cancel-order">Cancel order</option>
                                    <option value="delivered-to-carrier">Delivered to the carrier</option>
                                    <option value="delivery-failed">Delivery failed</option>
                                    <option value="delivery-successful">Delivery successful</option>
                                </select>
                                <button class="btn btn-primary" onclick="filterOrders()">Filter</button>
                            </div>
                            <div>
                                <label for="searchBox">Search:</label>
                                <input type="text" id="searchBox" class="form-control d-inline-block w-auto" onkeyup="searchOrders()">
                            </div>
                        </div>

                        <!-- Bảng danh sách đơn hàng -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-shopping-cart me-1"></i>
                                Order List
                            </div>
                            <div class="card-body">
                                <table id="orderTable" class="table table-bordered text-center">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Order Date</th>
                                            <th>Total Amount</th>
                                            <th>Order Status</th>
                                            <th>Update Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                            if (orderList != null) {
                                                for (Order order : orderList) {%>
                                        <tr>
                                            <td><%= order.getOrderID().substring(0, 4)%></td>
                                            <td><%= order.getFullName()%></td>
                                            <td><%= order.getOrderDate()%></td>
                                            <td>$<%= order.getTotalAmount()%></td>
                                            <td><%= order.getOrderStatus()%></td>
                                            <td>
                                                <select class="form-select">
                                                    <option <%= order.getOrderStatus().equals("Pending processing") ? "selected" : ""%>>Pending processing</option>
                                                    <option <%= order.getOrderStatus().equals("Processed") ? "selected" : ""%>>Processed</option>
                                                    <option <%= order.getOrderStatus().equals("Order Cancellation Request") ? "selected" : ""%>>Order Cancellation Request</option>
                                                    <option <%= order.getOrderStatus().equals("Cancel order") ? "selected" : ""%>>Cancel order</option>
                                                    <option <%= order.getOrderStatus().equals("Delivered to the carrier") ? "selected" : ""%>>Delivered to the carrier</option>
                                                    <option <%= order.getOrderStatus().equals("Delivery failed") ? "selected" : ""%>>Delivery failed</option>
                                                    <option <%= order.getOrderStatus().equals("Delivery successful") ? "selected" : ""%>>Delivery successful</option>
                                                </select>
                                            </td>
                                            <td>
                                                <button class="btn btn-primary btn-sm" onclick="confirmUpdate('<%= order.getOrderID()%>', this)">Update</button>
                                                <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET" class="d-inline">
                                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                    <button type="submit" class="btn btn-info btn-sm">View Details</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% }
                                        } else { %>
                                        <tr><td colspan="7">No orders found.</td></tr>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div> <!-- End px-4 -->
                </div> <!-- End col-md-10 -->
            </div> <!-- End row -->
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/Staff/scripts.js"></script>
    </body>
</html>
