<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>

        <!-- Import CSS -->
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <style>
            #layoutSidenav {
                display: flex;
                min-height: 100vh; /* Giữ chiều cao tự động */
            }

            /* Sidebar Navigation */
            .col-md-2 {
                display: flex;
                flex-direction: column; /* Giúp navigation tự động mở rộng */
                flex-grow: 1;
                min-height: 100vh; /* Luôn chiếm toàn bộ chiều cao màn hình */
                padding-right: 0;
            }

            /* Content Section */
            .col-md-10 {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                padding-left: 0 !important;
                margin-left: 0 !important;
                padding-right: 0 !important; /* Đảm bảo padding right bằng 0 */
            }

            /* Đảm bảo header cố định và nội dung mở rộng */
            .content {
                flex-grow: 1;
                overflow: auto; /* Giữ nội dung cuộn khi cần */
                padding: 20px; /* Thêm khoảng cách cho đẹp */
            }

            /* Màu nền đậm như table-dark */
            #feedbackTable thead {
                background-color: #343a40 !important; /* Màu đen nhạt của Bootstrap */
                color: white !important; /* Chữ trắng */
            }

            /* Căn giữa nội dung trong các cột */
            #feedbackTable th {
                text-align: center !important;
                vertical-align: middle !important;
            }

            .text-success {
                color: green !important;
                font-weight: bold !important;
            }

            .text-danger {
                color: red !important;
                font-weight: bold !important;
            }


        </style>
    </head>
    <body>
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>

        <!-- Navigation Menu -->
        <div class="row">
            <div class="col-md-2" style="padding-right: 0; min-height: 100vh;">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>

            <div class="col-md-10">
                <!-- Header -->
                <%@include file="Admin/HeaderAD.jsp"%>
                <div class="content pl-4 pr-4">
                    <div class="content pl-4 pr-4">
                        <h1>Admin Dashboard</h1>

                        <!-- Thẻ thống kê -->
                        <div class="row">
                            <div class="col-md-3">
                                <div class="card bg-primary text-white text-center p-3">
                                    <h4>Nhân viên</h4>
                                    <h2>25</h2>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-success text-white text-center p-3">
                                    <h4>Đơn hàng</h4>
                                    <h2>120</h2>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-warning text-white text-center p-3">
                                    <h4>Doanh thu</h4>
                                    <h2>$15,000</h2>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-danger text-white text-center p-3">
                                    <h4>Phản hồi</h4>
                                    <h2>35</h2>
                                </div>
                            </div>
                        </div>

                        <!-- Tổng doanh thu -->
                        <div class="row mt-4">
                            <div class="col-md-8">
                                <div class="card p-3 text-center">
                                    <h5>Tổng doanh thu</h5>
                                    <h2 class="text-success">
                                        <c:out value="${totalRevenue}"/> VNĐ
                                    </h2>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <!-- Thư viện Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


    </body>
</html>
