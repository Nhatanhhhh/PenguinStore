<%-- 
    Document   : ViewOStatistic
    Created on : Mar 5, 2025, 7:20:09 AM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Order Statistic</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <h2 class="text-center">ORDER STATISTICS</h2>
                <form action="Statistic" method="get">
                    <input type="hidden" name="action" value="orderStatistic">
                    <label for="timeUnit">Select the time period:</label>
                    <select name="timeUnit" onchange="this.form.submit()">
                        <option value="day" ${timeUnit == 'day' ? 'selected' : ''}>Day</option>
                        <option value="month" ${timeUnit == 'month' ? 'selected' : ''}>Month</option>
                    </select>
                </form>
                <div class="container">
                    <c:choose>
                        <c:when test="${not empty statistics}">
                            <canvas id="orderChart" width="50" height="10"></canvas>
                            <table>
                                <div id="pagination"></div>
                                <thead>
                                    <tr>
                                        <th>Time</th>
                                        <th>Order Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalOrders" value="0"/>
                                    <c:forEach var="stat" items="${statistics}">
                                        <tr>
                                            <td>${stat.orderDate}</td>
                                            <td>${stat.orderCount}</td>
                                        </tr>
                                        <c:set var="totalOrders" value="${totalOrders + stat.orderCount}"/>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <h3>Total Orders: ${totalOrders}</h3>
                        </c:when>
                        <c:otherwise>
                            <p>There are no statistical data for this time period.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
                <script>
                    var labels = [];
                    var orderData = [];

                    <c:forEach var="stat" items="${statistics}">
                    labels.push("${stat.orderDate}");
                    orderData.push(Math.round(${stat.orderCount})); // Ép kiểu số nguyên
                    </c:forEach>

                    var ctx = document.getElementById('orderChart').getContext('2d');
                    var orderChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                    label: 'Order Quantity',
                                    data: orderData,
                                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                    borderColor: 'rgba(75, 192, 192, 1)',
                                    borderWidth: 1
                                }]
                        },
                        options: {
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        stepSize: 1, // Bước nhảy 1 đơn vị
                                        precision: 0 // Không hiển thị số lẻ
                                    }
                                }
                            }
                        }
                    });
                </script>

            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var rowsPerPage = 5; // Số hàng trên mỗi trang
                var table = document.querySelector("table");
                var tbody = table.querySelector("tbody"); // Lấy tbody trước
                if (!tbody)
                    return; // Nếu không có tbody thì dừng

                var rows = tbody.querySelectorAll("tr"); // Lấy tất cả hàng trong tbody
                var totalRows = rows.length;
                var totalPages = Math.ceil(totalRows / rowsPerPage);
                var paginationDiv = document.getElementById("pagination");

                function showPage(page) {
                    var start = (page - 1) * rowsPerPage;
                    var end = start + rowsPerPage;
                    rows.forEach((row, index) => {
                        row.style.display = (index >= start && index < end) ? "" : "none";
                    });
                }

                function createPaginationButtons() {
                    paginationDiv.innerHTML = "";
                    for (let i = 1; i <= totalPages; i++) {
                        let button = document.createElement("button");
                        button.textContent = i;
                        button.classList.add("pagination-btn");
                        button.addEventListener("click", function () {
                            showPage(i);
                        });
                        paginationDiv.appendChild(button);
                    }
                }

                if (totalPages > 1) {
                    showPage(1);
                    createPaginationButtons();
                }
            });

        </script>

    </body>
</html>