<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List of Types</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
    </head>
    <body>
        <%@include file="../../Admin/HeaderAD.jsp"%>
        <%@include file="../../Admin/NavigationMenu.jsp"%>

        <div class="container mt-4">
            <h2>Danh sách Type</h2>
            <table class="table table-bordered">
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
            <c:if test="${empty typeList}">
                <p class="text-center">Không có loại sản phẩm nào.</p>
            </c:if>
            <a href="<c:url value='/Type?action=create'/>" class="btn btn-success">Thêm mới</a>
        </div>
    </body>
</html>
