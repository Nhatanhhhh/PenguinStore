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
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>

        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/restockstyles.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .table-container {
                max-height: 400px;
                overflow-y: auto;
                overflow-x: auto;
                border: 1px solid #ccc;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid black;
                padding: 10px;
                text-align: center;
                white-space: nowrap; /* Ngăn chữ bị xuống dòng */
            }

            th {
                background-color: lightgray;
            }

            #exportExcel {
                background-color: #28a745;
                border-color: #28a745;
            }

            #exportPDF {
                background-color: #dc3545;
                border-color: #dc3545;
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

                <div class="text-center mt-3 mb-5">
                    <form action="Statistic" method="get" style="display: inline;">
                        <input type="hidden" name="action" value="exportExcel">
                        <input type="hidden" name="timeUnit" value="${timeUnit}">
                        <input type="hidden" name="startDate" value="${startDate}">
                        <input type="hidden" name="endDate" value="${endDate}">
                        <button type="submit" id="exportExcel" class="btn btn-success mr-2" 
                                ${empty revenuelist ? 'disabled' : ''}>
                            <i class="bi bi-file-excel"></i> Export to Excel
                        </button>
                    </form>
                    <form action="Statistic" method="get" style="display: inline;">
                        <input type="hidden" name="action" value="exportPDF">
                        <input type="hidden" name="timeUnit" value="${timeUnit}">
                        <input type="hidden" name="startDate" value="${startDate}">
                        <input type="hidden" name="endDate" value="${endDate}">
                        <button type="submit" id="exportPDF" class="btn btn-danger" 
                                ${empty revenuelist ? 'disabled' : ''}>
                            <i class="bi bi-file-pdf"></i> Export to PDF
                        </button>
                    </form>
                </div>
                <form action="Statistic" method="get">
                    <input type="hidden" name="action" value="revenueStatistic">
                    <label for="timeUnit">Select the time period:</label>
                    <select name="timeUnit" id="timeUnit" onchange="this.form.submit(); handleTimeUnitChange();">

                        <option value="day" ${timeUnit == 'day' ? 'selected' : ''}>Day</option>
                        <option value="week" ${timeUnit == 'week' ? 'selected' : ''}>Week</option>
                        <option value="month" ${timeUnit == 'month' ? 'selected' : ''}>Month of the Year</option>
                        <option value="year" ${timeUnit == 'year' ? 'selected' : ''}>Year</option>
                        <option value="custom" ${timeUnit == 'custom' ? 'selected' : ''}>Custom Range</option>
                    </select>


                    <div id="customDateRange" style="display: none;">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}">

                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}">

                        <button type="submit">Filter</button>
                        <button type="button" onclick="resetForm()">Reset</button>
                    </div>
                </form>


                <div class="container">
                    <c:choose>
                        <c:when test="${not empty revenuelist}">

                            <canvas id="revenueChart" width="50" height="10"></canvas>


                            <div class="table-container">
                                <table border="1">
                                    <tr>
                                        <th>Time</th>
                                        <th>Revenue (VND)</th>
                                    </tr>
                                    <c:set var="totalRevenue" value="0"/>
                                    <c:forEach var="stat" items="${revenuelist}">
                                        <tr>
                                            <td>${stat.timePeriod}</td> 
                                            <td><fmt:formatNumber value="${stat.revenue}" pattern="#,###" /> VND</td>
                                        </tr>
                                        <c:set var="totalRevenue" value="${totalRevenue + stat.revenue}"/>

                                    </c:forEach>
                                </table>
                            </div>

                            <h3>Total Revenue: <fmt:formatNumber value="${totalRevenue}" pattern="#,###" /> VND</h3>
                        </c:when>
                        <c:otherwise>
                            <p>There are no statistical data for this time period.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

                <script>
                    function handleTimeUnitChange() {
                        var timeUnit = document.getElementById("timeUnit").value;
                        var customDateRange = document.getElementById("customDateRange");

                        if (timeUnit === "custom") {
                            customDateRange.style.display = "block";
                        } else {
                            customDateRange.style.display = "none";
                        }
                    }

                    function resetForm() {
                        window.location.href = "Statistic?action=revenueStatistic"; // Thay bằng URL bạn muốn điều hướng đến
                    }


                    window.onload = function () {
                        handleTimeUnitChange();
                    };

                </script>

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
                                    beginAtZero: true,
                                    min: 0,
                                    ticks: {
                                        stepSize: 200000, // Chia step 100,000 VND
                                        callback: function (value) {
                                            return value.toLocaleString() + ' ₫'; // Hiển thị số có dấu phẩy
                                        }
                                    },
                                    suggestedMax: Math.ceil(Math.max(...revenueData) / 500000) * 500000
                                }
                            }
                        }
                    });
                </script>
            </div>
        </div>
    </body>
</html>