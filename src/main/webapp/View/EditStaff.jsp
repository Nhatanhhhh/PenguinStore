<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Staff</title>
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
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-warning text-white text-center">
                                    <h3>Edit Staff</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${empty manager}">
                                        <p class="text-danger text-center">Staff not found.</p>
                                        <a href="<c:url value='/Staff?action=list'/>" class="btn btn-secondary">Back</a>
                                    </c:if>

                                    <c:if test="${not empty manager}">
                                        <form action="<c:url value='/Staff?action=edit'/>" method="Post">
                                            <input type="hidden" name="managerName" value="${manager.managerName}">

                                            <div class="mb-3">
                                                <label for="managerName" class="form-label">Staff Name:</label>
                                                <input type="text" class="form-control" id="managerName" name="staffName" value="${manager.managerName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="password" class="form-label">Password:</label>
                                                <input type="password" class="form-control" id="password" name="password" placeholder="Change Password" 
                                                       onfocus="this.type = 'password'; this.value = '';">
                                            </div>

                                            <div class="mb-3">
                                                <label for="fullName" class="form-label">Full Name:</label>
                                                <input type="text" class="form-control" id="fullName" name="fullName" value="${manager.fullName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email: </label>
                                                <input type="email" class="form-control" id="email" name="email" value="${manager.email}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="phoneNumber" class="form-label">Phone Number: </label>
                                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" 
                                                       value="${manager.phoneNumber}" 
                                                       pattern="^0[0-9]{9}$"
                                                       title="Phone number must start with 0 and have 10 digits." required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="address" class="form-label">Address:</label>
                                                <input type="text" class="form-control" id="address" name="address" value="${manager.address}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="dateOfBirth" class="form-label">Date of Birth: </label>
                                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" 
                                                       value="${manager.dateOfBirth}" 
                                                       required min="1900-01-01" max="<%= java.time.LocalDate.now().minusYears(18)%>">
                                            </div>

                                            <button type="submit" class="btn btn-primary">Update</button>
                                            <a href="<c:url value='/Staff?action=list'/>" class="btn btn-secondary">Cancel</a>
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
    </body>
</html>
