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
        <title>Revenue</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/restockstyles.css"/>
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
                <h2 class="text-center">REVENUE</h2>

                <form action="Statistic" method="get">
                    <input type="hidden" name="action" value="revenueStatistic">
                    <label for="timeUnit">Select the time period:</label>
                    <select name="timeUnit" onchange="this.form.submit()">
                        <option value="day" ${timeUnit == 'day' ? 'selected' : ''}>Day</option>
                        <option value="month" ${timeUnit == 'month' ? 'selected' : ''}>Month</option>
                        <option value="year" ${timeUnit == 'year' ? 'selected' : ''}>Year</option>
                    </select>
                </form>
                <div class="container">
                    <c:choose>
                        <c:when test="${not empty revenuelist}">

                            <canvas id="revenueChart" width="50" height="10"></canvas>


                            <table border="1">
                                <tr>
                                    <th>Time</th>
                                    <th>Revenue (VND)</th>
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
                            <h3>Total Revenue: <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
                        </c:when>
                        <c:otherwise>
                            <p>There are no statistical data for this time period.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
                <script>

                    var labels = [];
                    var revenueData = [];

                    <c:forEach var="stat" items="${revenuelist}">
                    labels.push("${stat.timePeriod}");
                    revenueData.push(${stat.revenue});
                    </c:forEach>


                    var ctx = document.getElementById('revenueChart').getContext('2d');
                    var revenueChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                    label: 'Revenue (VND)',
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
            </div>
        </div>
    </body>
</html>
