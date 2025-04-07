<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List of Customer</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
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
                    <h2>List Customer</h2>
                    <table class="table table-bordered">
                        <thead class="table-dark">
                            <tr>

                                <th>Customer Name</th>

                                <th>Full name</th>
                                <th>Address</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>State</th>
                                <th>Zip</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${listCus}">
                                <tr>

                                    <td>${customer.customerName}</td>

                                    <td>${customer.fullName}</td>
                                    <td>${customer.address}</td>
                                    <td>${customer.email}</td>
                                    <td>${customer.phoneNumber}</td>
                                    <td>${customer.state}</td>
                                    <td>${customer.zip}</td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty listCus}">
                        <p class="text-center">Not have Customer!!!!</p>
                    </c:if>

                </div>
            </div>
        </div>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>