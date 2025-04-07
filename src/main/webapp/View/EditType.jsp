<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Edit Type</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <style>
            #layoutSidenav {
                display: flex;  /* Đảm bảo layout không bị lệch */
            }

            .col-md-10 {
                flex-grow: 1;
                max-width: calc(100% - 250px);  /* Tránh bị lệch */
                padding-left: 0 !important;
                margin-left: 0 !important;
            }

            /* Màu nền đậm như table-dark */
            #feedbackTable thead {
                background-color: #343a40 !important; /* Màu đen nhạt của Bootstrap */
                color: white !important; /* Chữ trắng */
            }

            /* Căn giữa nội dung trong các cột */
            #feedbackTable th {
                text-align: center !important;
                vertical-align: middle !important;
            }

            .text-success {
                color: green !important;
                font-weight: bold !important;
            }

            .text-danger {
                color: red !important;
                font-weight: bold !important;
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
                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-warning text-white text-center">
                                    <h3>Edit Type Product</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${empty type}">
                                        <p class="text-danger text-center">Not found Type Product.</p>
                                        <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Back</a>
                                    </c:if>

                                    <c:if test="${not empty type}">
                                        <form id="editForm" action="<c:url value='/Type?action=edit'/>" method="Post">
                                            <input type="hidden" name="typeID" value="${type.typeID}">

                                            <div class="mb-3">
                                                <label for="typeName" class="form-label">Type Name:</label>
                                                <input type="text" class="form-control" id="typeName" name="typeName" value="${type.typeName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="categoryID" class="form-label">Category:</label>
                                                <select id="categoryID" name="categoryID" class="form-control">
                                                    <c:forEach var="category" items="${categoryList}">
                                                        <option value="${category.categoryID}" ${type.categoryID eq category.categoryID ? 'selected' : ''}>
                                                            ${category.categoryName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>


                                            <button type="submit" class="btn btn-primary">Update</button>
                                            <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Cancel</a>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.getElementById("editForm").addEventListener("submit", function (event) {
                event.preventDefault();

                Swal.fire({
                    title: "Confirm Update",
                    text: "Are you sure you want to update this Type Product?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, update it!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        event.target.submit();
                    }
                });
            });
        </script>

    </body>
</html>