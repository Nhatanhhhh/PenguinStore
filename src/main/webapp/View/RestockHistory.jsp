<%-- 
    Document   : restockHistory
    Created on : Mar 1, 2025, 2:56:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Restock History</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid black;
                padding: 10px;
                text-align: center;
            }
            th {
                background-color: lightgray;
            }
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

        <div class="row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10">
                <%@include file="Admin/HeaderAD.jsp"%>
                <h2 class="text-center">Restock History</h2>
                <div class="container">
                    <c:if test="${empty restockHistory}">
                        <p>Not data Restock.</p>
                    </c:if>

                    <c:if test="${not empty restockHistory}">
                        <table>
                            <tr>

                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Total Cost</th>
                                <th>Restock Date</th>
                            </tr>
                            <c:forEach var="restock" items="${restockHistory}">
                                <tr>

                                    <td>${restock.quantity}</td>
                                    <td>${restock.price}</td>
                                    <td>${restock.totalCost}</td>
                                    <td>${restock.restockDay}</td>
                                </tr>
                            </c:forEach>
                        </table>
                        <a href="javascript:history.back()" class="btn btn-secondary">Cancel</a>
                    </c:if>
                </div>

            </div>
        </div>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>