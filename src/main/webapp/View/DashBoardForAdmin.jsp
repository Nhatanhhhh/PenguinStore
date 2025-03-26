<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Import CSS -->
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <title>Admin Dashboard</title>


        <style>
            #layoutSidenav {
                display: flex;
                min-height: 100vh;
            }

            body {
                background: #17a2b8;
                min-height: 100vh;
                color: white;
            }

            .content h1 {
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }


            .col-md-2 {
                display: flex;
                flex-direction: column;
                flex-grow: 1;
                min-height: 100vh;
                padding-right: 0;
            }


            .col-md-10 {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                padding-left: 0 !important;
                margin-left: 0 !important;
                padding-right: 0 !important;
            }


            .content {
                flex-grow: 1;
                overflow: auto;
                padding: 20px;
            }


            #feedbackTable thead {
                background-color: #343a40 !important;
                color: white !important;
            }


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

            .card {
                transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
                border-radius: 10px;
                box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            }

            .card:hover {
                transform: translateY(-10px);
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            }


            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .card {
                animation: fadeInUp 0.8s ease-out;
            }

            @keyframes blink {
                0% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.6;
                }
                100% {
                    opacity: 1;
                }
            }

            .stat-number {
                animation: blink 1.5s infinite;
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
            <div class="col-md-2" style="padding-right: 0; min-height: 100vh;">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>

            <div class="col-md-10">
                <!-- Header -->
                <%@include file="Admin/HeaderAD.jsp"%>
                <div class="content pl-4 pr-4">
                    <div class="content pl-4 pr-4">
                        <h1>Admin Dashboard</h1>


                        <div class="row justify-content-center text-center">

                            <div class="col-md-3" onclick="window.location.href = '<c:url value='/Statistic?action=orderStatistic'/>'" style="cursor: pointer;">
                                <div class="card bg-success text-white text-center p-3">
                                    <h4>Orders Today</h4>
                                    <h2 class="stat-number">${todayOrders}</h2>
                                </div>
                            </div>
                            <div class="col-md-3" onclick="window.location.href = '<c:url value='/Statistic?action=revenueStatistic'/>'" style="cursor: pointer;">
                                <div class="card bg-primary text-white text-center p-3">
                                    <h4>Revenue This Week</h4>
                                    <h2 class="stat-number"><fmt:formatNumber value="${todayRevenue}" pattern="#,###" /> ₫</h2>
                                </div>
                            </div>
                            <div class="col-md-3" onclick="window.location.href = '<c:url value='/Restock?action=restockHistory'/>'" style="cursor: pointer;">
                                <div class="card bg-warning text-white text-center p-3">
                                    <h4>Restock Today</h4>
                                    <h2 class="stat-number">${todayRestockQuantity}</h2>
                                </div>
                            </div>
                        </div>
                        <canvas id="weeklySalesChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <!-- Thư viện Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
                                // Lấy dữ liệu từ Servlet truyền sang
                                var labels = [];
                                var salesData = [];

            <c:forEach var="sale" items="${weeklySales}">
                                labels.push("${sale.timePeriod}");
                                salesData.push(${sale.soldQuantity});
            </c:forEach>

                                // Vẽ biểu đồ đường bằng Chart.js
                                var ctx = document.getElementById('weeklySalesChart').getContext('2d');
                                var myChart = new Chart(ctx, {
                                    type: 'line',
                                    data: {
                                        labels: labels, // Ngày trong tuần
                                        datasets: [{
                                                label: 'Number of products sold ',
                                                data: salesData,
                                                borderColor: 'blue',
                                                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                                borderWidth: 2,
                                                tension: 0.3 // Làm đường mượt hơn
                                            }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: {
                                            legend: {position: 'top'}
                                        },
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {
                                                    stepSize: 5
                                                }
                                            }
                                        }
                                    }
                                });
        </script>


    </body>
</html>
