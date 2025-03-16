<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Purchase Statistic</title>
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
                <h2 class="text-center">Purchase Statistics</h2>
                <form action="Statistic" method="get">
                    <input type="hidden" name="action" value="orderStatusStatistic">
                    <label for="timeUnit">Select the time period:</label>
                    <select name="timeUnit" onchange="this.form.submit()">
                        <option value="day" ${timeUnit == 'day' ? 'selected' : ''}>Day</option>
                        <option value="month" ${timeUnit == 'month' ? 'selected' : ''}>Month</option>
                         <option value="year" ${timeUnit == 'year' ? 'selected' : ''}>Year</option>
                    </select>
                </form>
                    
                <canvas id="orderChart" width="400" height="100"></canvas>
                
                <div class="container">
                    <c:choose>
                        <c:when test="${not empty topCustomers}">
                           
                                <table border="1">
                                    <tr>
                                        <th>Completed Orders</th>
                                        <th>Delivery Failed</th>
                                        <th>Canceled Orders</th>
                                    </tr>

                                    <c:forEach var="i" begin="0" end="2"> 
                                        <tr>
                                            <td>
                                                <c:if test="${i < fn:length(topCustomersCompleted)}">
                                                    <c:out value="${topCustomersCompleted[i]}" />
                                                     
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${i < fn:length(topCustomersFailed)}">
                                                    <c:out value="${topCustomersFailed[i]}" />
                                                    
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${i < fn:length(topCustomersCanceled)}">
                                                    <c:out value="${topCustomersCanceled[i]}" />
                                                   
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>


                               
                                <tr>
                                    <td><c:out value="${completedOrders}" escapeXml="false" /></td>
                                    <td><c:out value="${deliveryFailed}" escapeXml="false" /></td>
                                    <td><c:out value="${canceledOrders}" escapeXml="false" /></td>
                                </tr>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p>No top customers found.</p>
                        </c:otherwise>
                    </c:choose>


                </div>
                
                <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
                
                <script>
                    var labels = [];
                    var completedOrders = [];
                    var deliveryFailed = [];
                    var canceledOrders = [];

                    <c:forEach var="stat" items="${statistics}">
                        labels.push("${stat.orderDate}");
                        completedOrders.push(${stat.completedOrders});
                        deliveryFailed.push(${stat.deliveryFailed});
                        canceledOrders.push(${stat.canceledOrders});
                    </c:forEach>

                    var ctx = document.getElementById('orderChart').getContext('2d');
                    var orderChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [
                                {
                                    label: 'Completed Orders',
                                    data: completedOrders,
                                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                    borderColor: 'rgba(75, 192, 192, 1)',
                                    borderWidth: 1
                                },
                                {
                                    label: 'Delivery Failed',
                                    data: deliveryFailed,
                                    backgroundColor: 'rgba(255, 206, 86, 0.6)',
                                    borderColor: 'rgba(255, 206, 86, 1)',
                                    borderWidth: 1
                                },
                                {
                                    label: 'Canceled Orders',
                                    data: canceledOrders,
                                    backgroundColor: 'rgba(255, 99, 132, 0.6)',
                                    borderColor: 'rgba(255, 99, 132, 1)',
                                    borderWidth: 1
                                }
                            ]
                        },
                        options: {
                            responsive: true,
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
