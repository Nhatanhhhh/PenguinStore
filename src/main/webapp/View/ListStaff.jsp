<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List of Staff</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
    </head>
    <body>
        <%@include file="Admin/HeaderAD.jsp"%>

        <div class="row">
            <div class="col-md-3">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-9">
                <div class="container mt-4">
                    <h2>List Staff</h2>
                    <table class="table table-bordered">
                        <thead class="table-dark">
                            <tr>

                                <th>Staff Name</th>

                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="manager" items="${managerList}">
                            <tr>

                                <td>${manager.managerName}</td>

                                <td>${manager.email}</td>
                                <td>
                                    <a href="<c:url value='/Staff?action=edit&id=${manager.managerName}'/>" class="btn btn-warning btn-sm">Edit</a>
                                    <a href="<c:url value='/Staff?action=detail&id=${manager.managerName}'/>" class="btn btn-info btn-sm">Detail</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty managerList}">
                        <p class="text-center">Not have Type!!!!</p>
                    </c:if>
                    <a href="<c:url value='/Staff?action=create'/>" class="btn btn-success">Create</a>
                </div>
            </div>
        </div>


    </body>
</html>