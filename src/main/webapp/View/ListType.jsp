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

                    <!-- Kiểm tra danh sách rỗng trước khi hiển thị bảng -->
                    <c:choose>
                        <c:when test="${empty typeList}">
                            <p class="text-center text-danger fw-bold">No types available!</p>
                        </c:when>
                        <c:otherwise>
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

                            <!-- PHÂN TRANG (chỉ hiển thị khi totalPages > 1) -->
                            <c:if test="${totalPages > 1}">
                                <div class="d-flex justify-content-center mt-3">
                                    <nav>
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link btn btn-dark" href="<c:url value='/Type?page=${currentPage - 1}'/>" style="color: white; background-color: black;">Previous</a>
                                                </li>
                                            </c:if>

                                            <c:forEach var="i" begin="1" end="${totalPages}">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="<c:url value='/Type?page=${i}'/>" 
                                                       style="color: ${i == currentPage ? 'white' : 'black'};
                                                       background-color: ${i == currentPage ? 'black' : 'white'};
                                                       border: 1px solid black;
                                                       border-radius: 6px;
                                                       box-shadow: none;
                                                       padding: 8px 16px;">
                                                        ${i}
                                                    </a>
                                                </li>
                                            </c:forEach>



                                            <c:if test="${currentPage < totalPages}">
                                                <li class=" page-item">
                                                    <a class="page-link btn btn-dark" href="<c:url value='/Type?page=${currentPage + 1}'/>" style="color: white; background-color: black;">Next</a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                    <br>
                    <a href="<c:url value='/Type?action=create'/>" class="btn btn-success">Create</a>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const searchInput = document.getElementById("searchInput");
                const tableRows = document.querySelectorAll("#typeTable tbody tr");

                searchInput.addEventListener("input", function () {
                    const filter = searchInput.value.trim().toLowerCase();

                    tableRows.forEach(row => {
                        if (row.cells.length >= 2) {
                            const typeName = row.cells[0].textContent.trim().toLowerCase();
                            const categoryName = row.cells[1].textContent.trim().toLowerCase();

                            row.style.display = (typeName.includes(filter) || categoryName.includes(filter)) ? "" : "none";
                        }
                    });
                });
            });


        </script>

    </body>
</html>
