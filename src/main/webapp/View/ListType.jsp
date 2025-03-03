<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List of Types</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
    </head>
    <body>
        <%@include file="Admin/HeaderAD.jsp"%>

        <div class="row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>

            </div>
            <div class="col-md-10">
                <div class="container mt-4">
                    <h2>List Type</h2>
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
                        <p class="text-center">Not have Type!!!!</p>
                    </c:if>
                    <a href="<c:url value='/Type?action=create'/>" class="btn btn-success">Create</a>
                </div>
            </div>
        </div>


    </body>
</html>