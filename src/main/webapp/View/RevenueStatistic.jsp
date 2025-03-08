<%-- 
    Document   : RevenueStatistic
    Created on : Mar 8, 2025, 3:52:05 PM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Thống kê doanh thu</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <h2>Thống kê doanh thu</h2>

        <form action="Statistic" method="get">
            <input type="hidden" name="action" value="revenueStatistic">
            <label for="timeUnit">Chọn khoảng thời gian:</label>
            <select name="timeUnit" onchange="this.form.submit()">
                <option value="day" ${timeUnit == 'day' ? 'selected' : ''}>Theo ngày</option>
                <option value="month" ${timeUnit == 'month' ? 'selected' : ''}>Theo tháng</option>
                <option value="year" ${timeUnit == 'year' ? 'selected' : ''}>Theo năm</option>
            </select>
        </form>

        <c:choose>
            <c:when test="${not empty revenuelist}">
                <!-- Biểu đồ doanh thu -->
                <canvas id="revenueChart" width="50" height="10"></canvas>

                <!-- Bảng thống kê doanh thu -->
                <table border="1">
                    <tr>
                        <th>Thời gian</th>
                        <th>Doanh thu (VND)</th>
                    </tr>
                    <c:set var="totalRevenue" value="0"/>
                    <c:forEach var="stat" items="${revenuelist}">
                        <tr>
                            <td>${stat.timePeriod}</td>
                            <td>
                                <fmt:formatNumber value="${stat.revenue}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                        <c:set var="totalRevenue" value="${totalRevenue + stat.revenue}"/>
                    </c:forEach>
                </table>
                <h3>Tổng doanh thu: <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
            </c:when>
            <c:otherwise>
                <p>Không có dữ liệu thống kê trong khoảng thời gian này.</p>
            </c:otherwise>
        </c:choose>

        <script>
            // Lấy dữ liệu từ JSP vào JavaScript
            var labels = [];
            var revenueData = [];

            <c:forEach var="stat" items="${revenuelist}">
            labels.push("${stat.timePeriod}");
            revenueData.push(${stat.revenue});
            </c:forEach>

            // Vẽ biểu đồ bằng Chart.js
            var ctx = document.getElementById('revenueChart').getContext('2d');
            var revenueChart = new Chart(ctx, {
                type: 'bar', // Kiểu biểu đồ cột
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Doanh thu (VND)',
                            data: revenueData,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
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
