<%-- 
    Document   : ViewOStatistic
    Created on : Mar 5, 2025, 7:20:09 AM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="Models.OrderStatistic" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Order Statistic</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <h2>Statistics on the number of orders by day</h2>
        <canvas id="orderChart"></canvas>

        <form action="${pageContext.request.contextPath}/Statistic" method="GET">
            <label for="timeUnit">View by:</label>
            <select name="timeUnit" id="timeUnit">
                <option value="day" <c:if test="${timeUnit eq 'day'}">selected</c:if>>Day</option>
                <option value="month" <c:if test="${timeUnit eq 'month'}">selected</c:if>>Month</option>
                </select>
                <button type="submit">Filter</button>
            </form>

        <%
            List<OrderStatistic> statistics = (List<OrderStatistic>) request.getAttribute("statistics");
            String labels = "";
            String data = "";

            if (statistics != null) {
                for (OrderStatistic stat : statistics) {
                    labels += "'" + stat.getOrderDate() + "',";
                    data += stat.getOrderCount() + ",";
                }
            }

            if (!labels.isEmpty()) {
                labels = labels.substring(0, labels.length() - 1);
                data = data.substring(0, data.length() - 1);
            }
        %>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            var ctx = document.getElementById('orderChart').getContext('2d');
            var orderChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [<%= labels%>],
                    datasets: [{
                            label: 'Order quantity',
                            data: [<%= data%>],
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {beginAtZero: true}
                    }
                }
            });
        </script>
    </body>
</html>
