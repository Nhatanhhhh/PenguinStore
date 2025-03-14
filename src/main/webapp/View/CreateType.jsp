<%@page import="Models.Manager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Type</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
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
                    <h3 class="text-center">Create Type</h3>
                </div>
                <div class="container mt-6">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">${error}</div>
                    </c:if>
                    <form action="<c:url value='/Type?action=create'/>" method="post">
                        <div class="mb-3">
                            <label for="typeName" class="form-label">Type Name:</label>
                            <input type="text" class="form-control" id="typeName" name="typeName" required>
                        </div>

                        <div class="mb-3">
                            <label for="categoryID" class="form-label">Category:</label>
                            <select id="categoryID" name="categoryID" class="form-select" required>
                                <option value="">-- Select Category --</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.categoryID}">${category.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="text-center">
                            <button type="submit" class="btn btn-success">Create</button>
                            <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>