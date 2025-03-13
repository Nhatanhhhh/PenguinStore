<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List of Types</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
      
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
                <div class="container mt-4">
                    <div class="text-center"><h2>List Type</h2></div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <input type="text" id="searchInput" class="form-control w-25" placeholder="Search Type Name..." />
                    </div>

                    <br>
                    <table id="typeTable" class="table table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Type Name</th>
                                <th>Category Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="type" items="${typeList}">
                                <tr>
                                    <td>${type.typeName}</td>
                                    <td>${type.categoryName}</td>
                                    <td>
                                        <a href="<c:url value='/Type?action=edit&id=${type.typeID}'/>" class="btn btn-warning btn-sm">Edit</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    

                    

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            let table = document.getElementById("typeTable");
                            let rows = table.querySelector("tbody").querySelectorAll("tr");
                            let searchInput = document.getElementById("searchInput");

                            // Hàm tìm kiếm
                            searchInput.addEventListener("keyup", function () {
                                let filter = searchInput.value.toLowerCase();
                                let visibleRows = 0;

                                rows.forEach(row => {
                                    let typeName = row.cells[0].textContent.toLowerCase(); // Lấy nội dung cột Type Name
                                    if (typeName.includes(filter)) {
                                        row.style.display = "";
                                        visibleRows++;
                                    } else {
                                        row.style.display = "none";
                                    }
                                });

                                // Cập nhật phân trang sau khi lọc
                                paginate(visibleRows);
                            });

                            let rowsPerPage = 10;
                            let currentPage = 1;
                            let totalPages = Math.ceil(rows.length / rowsPerPage);

                            function paginate(totalRows) {
                                totalPages = Math.ceil(totalRows / rowsPerPage);
                                currentPage = 1; // Reset về trang đầu
                                showPage(currentPage);
                            }

                            function showPage(page) {
                                let start = (page - 1) * rowsPerPage;
                                let end = start + rowsPerPage;
                                let visibleRows = Array.from(rows).filter(row => row.style.display !== "none");

                                visibleRows.forEach((row, index) => {
                                    row.style.display = (index >= start && index < end) ? "" : "none";
                                });

                                document.getElementById("pageInfo").innerText = `Page ${page} of ${totalPages}`;
                                document.getElementById("prevPage").style.display = (page > 1) ? "inline-block" : "none";
                                document.getElementById("nextPage").style.display = (page < totalPages) ? "inline-block" : "none";
                            }

                            document.getElementById("prevPage").addEventListener("click", function () {
                                if (currentPage > 1) {
                                    currentPage--;
                                    showPage(currentPage);
                                }
                            });

                            document.getElementById("nextPage").addEventListener("click", function () {
                                if (currentPage < totalPages) {
                                    currentPage++;
                                    showPage(currentPage);
                                }
                            });

                            if (rows.length > 0) {
                                showPage(currentPage);
                            }
                        });
                    </script>


                    <c:if test="${empty typeList}">
                        <p class="text-center">Not have Type!!!!</p>
                    </c:if>
                    <br>

                    <a href="<c:url value='/Type?action=create'/>" class="btn btn-success">Create</a>
                </div>
            </div>
        </div>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
