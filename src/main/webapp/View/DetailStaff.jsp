<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Staff Detail</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoard.css"/>
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
                    <h2>Staff Detail</h2>
                    <table class="table table-bordered">
                        <tr><th>Manager Name</th><td>${managerDetail.managerName}</td></tr>
                        <tr><th>Full Name</th><td>${managerDetail.fullName}</td></tr>
                        <tr><th>Email</th><td>${managerDetail.email}</td></tr>
                        <tr><th>Phone Number</th><td>${managerDetail.phoneNumber}</td></tr>
                        <tr><th>Address</th><td>${managerDetail.address}</td></tr>
                        <tr><th>Date of Birth</th><td>${managerDetail.dateOfBirth}</td></tr>
                    </table>
                    <a href="<c:url value='/Staff?action=list'/>" class="btn btn-secondary">Back to List</a>
                </div>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
