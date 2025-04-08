<%-- 
    Document   : restockHistory
    Created on : Mar 1, 2025, 2:56:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
    <head>
        <title>Restock History</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
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
            .search-container {
                margin-bottom: 15px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            #searchInput, #startDate, #endDate {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
        </style>
        <script>

            function searchTable() {
                let input, filter, table, tr, td, i, j, txtValue;
                input = document.getElementById("searchInput");
                filter = input.value.toLowerCase();
                table = document.getElementById("restockTable");
                tr = table.getElementsByTagName("tr");

                for (i = 1; i < tr.length; i++) {
                    let found = false;
                    td = tr[i].getElementsByTagName("td");
                    for (j = 0; j < td.length; j++) {
                        if (td[j]) {
                            txtValue = td[j].textContent || td[j].innerText;
                            if (txtValue.toLowerCase().indexOf(filter) > -1) {
                                found = true;
                                break;
                            }
                        }
                    }
                    tr[i].style.display = found ? "" : "none";
                }
                paginateTable(); // Update pagination after search
            }

            function filterByDate() {
                resetTable(); // Reset pagination and search before applying filter

                let startDate = document.getElementById("startDate").value;
                let endDate = document.getElementById("endDate").value;
                let table = document.getElementById("restockTable");
                let tr = table.getElementsByTagName("tr");

                for (let i = 1; i < tr.length; i++) {
                    let restockDate = tr[i].getElementsByTagName("td")[6].textContent.trim();

                    if (startDate && new Date(restockDate) < new Date(startDate)) {
                        tr[i].style.display = "none";
                    } else if (endDate && new Date(restockDate) > new Date(endDate)) {
                        tr[i].style.display = "none";
                    }
                }
                paginateTable(); // Reapply pagination after filtering
            }

            function resetTable() {
                document.getElementById("searchInput").value = ""; // Clear search input
                currentPage = 1; // Reset pagination
                let table = document.getElementById("restockTable");
                let tr = table.getElementsByTagName("tr");

                for (let i = 1; i < tr.length; i++) {
                    tr[i].style.display = ""; // Show all rows
                }
            }

            function updatePaginationControls(totalPages) {
                let paginationDiv = document.getElementById("pagination");
                paginationDiv.innerHTML = '';

                let prevButton = document.createElement("button");
                prevButton.innerText = "Previous";
                prevButton.onclick = () => {
                    currentPage--;
                    paginateTable();
                };
                prevButton.disabled = currentPage === 1;
                paginationDiv.appendChild(prevButton);

                for (let i = 1; i <= totalPages; i++) {
                    let pageButton = document.createElement("button");
                    pageButton.innerText = i;
                    pageButton.classList.add(currentPage === i ? "active" : "");
                    pageButton.onclick = () => {
                        currentPage = i;
                        paginateTable();
                    };
                    paginationDiv.appendChild(pageButton);
                }

                let nextButton = document.createElement("button");
                nextButton.innerText = "Next";
                nextButton.onclick = () => {
                    currentPage++;
                    paginateTable();
                };
                nextButton.disabled = currentPage === totalPages;
                paginationDiv.appendChild(nextButton);
            }

            window.onload = function () {
                paginateTable(); // Initialize pagination on page load
            };
        </script>

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
                        <p>No Restock Data.</p>
                    </c:if>

                    <c:if test="${not empty restockHistory}">
                        <div class="search-container">
                            <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Search restock history...">
                            <label>From: <input type="date" id="startDate" onchange="filterByDate()"></label>
                            <label>To: <input type="date" id="endDate" onchange="filterByDate()"></label>
                        </div>

                        <table id="restockTable">
                            <tr>
                                <th>Product Name</th>
                                <th>Size</th>
                                <th>Color</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Total Cost</th>
                                <th>Restock Date</th>
                            </tr>
                            <c:forEach var="restock" items="${restockHistory}">
                                <tr>
                                    <td>${restock.productName}</td>
                                    <td>${restock.sizeName}</td>
                                    <td>
                                        <div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${restock.colorName}; margin: auto;"></div>
                                    </td>
                                    <td>${restock.quantity}</td>
                                    <td><fmt:formatNumber value="${restock.price}" pattern="#,###" /> VND</td>
                                    <td><fmt:formatNumber value="${restock.totalCost}" pattern="#,###" /> VND</td>
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