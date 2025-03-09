<%@page import="Models.Manager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Navigation Menu</title>

        <!-- Bootstrap & Styles -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/bootstrap.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
    </head>
    <body>

        <!-- Sidebar Navigation -->
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">

                    <!-- Management Section -->
                    <div class="sb-sidenav-menu-heading">Manage</div>
                    <ul class="nav flex-column ml-2">

                        <!-- Type Dropdown -->
                        <li class="nav-item">
                            <a href="#typeMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Type</strong>
                            </a>
                            <ul id="typeMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/Type?action=list'/>">View Types</a></li>
                                <li><a class="nav-link" href="<c:url value='/Type?action=create'/>">Create Type</a></li>
                            </ul>
                        </li>

                        <!-- Product Dropdown -->
                        <li class="nav-item">
                            <a href="#productMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Product</strong>
                            </a>
                            <ul id="productMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/ManageProduct?action=view'/>">View Products</a></li>
                                <li><a class="nav-link" href="<c:url value='/ManageProduct?action=create'/>">Create Product</a></li>
                            </ul>
                        </li>

                        <!-- Staff Dropdown -->
                        <li class="nav-item">
                            <a href="#staffMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Staff</strong>
                            </a>
                            <ul id="staffMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/Staff?action=list'/>">View Staffs</a></li>
                                <li><a class="nav-link" href="<c:url value='/Staff?action=create'/>">Create Account Staff</a></li>
                            </ul>
                        </li>

                        <!-- Order Dropdown -->
                        <li class="nav-item">
                            <a href="#orderMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Order</strong>
                            </a>
                            <ul id="orderMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="#">View Orders</a></li>
                            </ul>
                        </li>

                        <!-- Voucher Dropdown -->
                        <li class="nav-item">
                            <a href="#voucherMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Voucher</strong>
                            </a>
                            <ul id="voucherMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/Voucher?action=view'/>">View Vouchers</a></li>
                                <li><a class="nav-link" href="<c:url value='/Voucher?action=create'/>">Create Vouchers</a></li>
                            </ul>
                        </li>

                        <!-- Feedback Dropdown -->
                        <li class="nav-item">
                            <a href="#feedbackMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Feedback</strong>
                            </a>
                            <ul id="feedbackMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="ListFeedbackForStaff">View Feedbacks</a></li>
                            </ul>
                        </li>

                        <!-- Customer Dropdown -->
                        <li class="nav-item">
                            <a href="#customerMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Customer</strong>
                            </a>
                            <ul id="customerMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/Customer?action=list'/>">View Customers</a></li>
                            </ul>
                        </li>

                        <!-- Statistic Dropdown -->
                        <li class="nav-item">
                            <a href="#statisticMenu" class="nav-link dropdown-toggle" data-bs-toggle="collapse">
                                <strong>Statistic</strong>
                            </a>
                            <ul id="statisticMenu" class="nav flex-column collapse">
                                <li><a class="nav-link" href="<c:url value='/Statistic?action=revenueStatistic'/>">Revenue</a></li>
                                <li><a class="nav-link" href="<c:url value='/Restock?action=restockHistory'/>">Restock History</a></li>
                                <li><a class="nav-link" href="#">Profit</a></li>
                                <li><a class="nav-link" href="<c:url value='/Statistic?action=orderStatistic'/>">Order</a></li>
                                <li><a class="nav-link" href="#">Product</a></li>
                            </ul>
                        </li>

                    </ul>
                </div>
            </div>

            <!-- Footer: Display Logged-in Manager Name -->
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                <strong><%= (manager != null) ? manager.getFullName() : "Anonymous"%></strong>
            </div>
        </nav>

        <!-- JavaScript for Icons & Charts -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://kit.fontawesome.com/a076d05399.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>