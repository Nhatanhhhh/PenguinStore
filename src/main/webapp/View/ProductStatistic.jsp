<%-- 
    Document   : ProductStatistic
    Created on : Mar 8, 2025, 6:58:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <title>Product Statistics</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .chart-container {
                width: 100%;
                max-width: 800px;
                margin: 0 auto 20px auto;
            }
            .table-container {
                width: 80%;
                margin: auto;
            }
            .scrollable-table {
                max-height: 400px; /* Giới hạn chiều cao bảng */
                overflow-y: auto; /* Hiển thị thanh cuộn dọc khi dữ liệu quá nhiều */
                border: 1px solid #ddd; /* Đường viền cho bảng */
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: center;
            }

            th {
                background-color: #f4f4f4;
                position: sticky;
                top: 0;
            }

            .btn-bestsales {
                position: absolute;
                top: 70px;
                right: 20px;
                background: linear-gradient(45deg, #ff6b6b, #ffa502);
                color: white;
                font-weight: bold;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(255, 107, 107, 0.5);
                transition: all 0.3s ease-in-out;
            }

            .btn-bestsales:hover {
                background: linear-gradient(45deg, #ff4757, #ff9f1a);
                box-shadow: 0 6px 15px rgba(255, 107, 107, 0.7);
                transform: translateY(-3px);
            }


        </style>
    </head>
    <body>


        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <div class="container-fuild">
            <div class="row">
                <div class="col-md-2">
                    <%@include file="Admin/NavigationMenu.jsp"%>
                </div>
                <div class="col-md-10">
                    <%@include file="Admin/HeaderAD.jsp"%>
                    <h2 class="text-center">Product Statistics</h2>

                    <button type="button" class="btn btn-bestsales" data-bs-toggle="modal" data-bs-target="#bestSalesModal">
                        Best Sales
                    </button>

                    <div class="text-center my-3">
                        <label for="productFilter">Filter by Product:</label>
                        <select id="productFilter" class="form-select w-auto d-inline-block">
                            <option value="all">All Products</option>
                            <c:forEach var="product" items="${productList}">
                                <option value="${product.productName}">${product.productName}</option>
                            </c:forEach>
                        </select>
                    </div>



                    <!-- Line Chart for Import/Export Statistics -->
                    <div class="chart-container">
                        <canvas id="productChart"></canvas>
                    </div>

                    <!-- Table for Import/Export Statistics -->
                    <div class="table-container">
                        <div class="scrollable-table">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Product</th>
                                        <th>Size</th>
                                        <th>Color</th>
                                        <th>Quantity Sold</th>
                                        <th>Quantity Imported</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="stat" items="${productStatistics}">
                                        <tr>
                                            <td>${stat.timePeriod}</td>
                                            <td>${stat.productName}</td>
                                            <td>${stat.sizeName}</td>
                                            <td><div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${stat.colorName}; margin: auto;"></div></td>
                                            <td>${stat.soldQuantity}</td>
                                            <td>${stat.importedQuantity}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <!-- Best Sales Modal -->
                    <div class="modal fade" id="bestSalesModal" tabindex="-1" aria-labelledby="bestSalesModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="bestSalesModalLabel">Best Selling Products</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Size</th>
                                                    <th>Color</th>
                                                    <th>Quantity Sold</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="product" items="${bestSellingProducts}">
                                                    <tr>
                                                        <td>${product.productName}</td>
                                                        <td>${product.sizeName}</td>
                                                        <td>
                                                            <div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${product.colorName}; margin: auto;"></div>
                                                        </td>
                                                        <td>${product.soldQuantity}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const ctx = document.getElementById('productChart').getContext('2d');

                            let labels = [];
                            let soldData = [];
                            let importedData = [];

                        <c:forEach var="stat" items="${productStatistics}">
                            labels.push("${stat.timePeriod} - ${stat.productName}");
                                    soldData.push(${stat.soldQuantity});
                                    importedData.push(${stat.importedQuantity});
                        </c:forEach>;

                                    new Chart(ctx, {
                                        type: 'line',
                                        data: {
                                            labels: labels,
                                            datasets: [
                                                {
                                                    label: 'Quantity Sold',
                                                    data: soldData,
                                                    borderColor: 'rgba(0, 200, 0, 1)',
                                                    backgroundColor: 'rgba(0, 255, 0, 0.2)',
                                                    fill: true
                                                },
                                                {
                                                    label: 'Quantity Imported',
                                                    data: importedData,
                                                    borderColor: 'rgba(54, 162, 235, 1)',
                                                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                                    fill: true
                                                }
                                            ]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: {
                                                legend: {
                                                    position: 'top'
                                                }
                                            },
                                            scales: {
                                                y: {
                                                    beginAtZero: true
                                                }
                                            }
                                        }
                                    });
                                });
                    </script>
                </div>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>