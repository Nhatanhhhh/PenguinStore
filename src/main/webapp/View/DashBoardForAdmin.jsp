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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoard.css"/>

    </head>
    <body>
        <!-- Header -->
        <%@include file="HeaderAD.jsp"%>

        <!-- Navigation Menu -->
        <div class="row">
            <div class="col-md-2">
                <%@include file="NavigationMenu.jsp"%>
            </div>

            <div class="col-md-10">
                <div class="content">
                    <h1>Admin Page</h1>

                    <!-- Biểu đồ doanh thu -->
                    <h2>Revenue In February</h2>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>

                    <!-- Kho hàng -->
                    <h2>Warehouse</h2>
                    <table>
                        <tr>
                            <th>Product Name</th>
                            <th>Size</th>
                            <th>Color</th>
                            <th>Status</th>
                            <th>Restock</th>
                        </tr>
                        <tr>
                            <td>Spring Polo</td>
                            <td>L</td>
                            <td>Red</td>
                            <td>Out of stock</td>
                            <td><button>Restock</button></td>
                        </tr>
                        <tr>
                            <td>Spring Polo</td>
                            <td>M</td>
                            <td>Blue</td>
                            <td>Out of stock</td>
                            <td><button>Restock</button></td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>





        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        
        <!-- Thư viện Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Script biểu đồ doanh thu -->
        <script>
            const ctx = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
                    datasets: [{
                            label: 'Revenue',
                            data: [200, 500, 750, 400, 600, 450, 700, 550, 650, 600, 300, 800],
                            borderColor: '#ff5733', // Màu cam đỏ nổi bật
                            backgroundColor: 'rgba(255, 87, 51, 0.2)', // Màu nền nhẹ
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4, // Làm mềm các góc của đường biểu đồ
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </body>
</html>
