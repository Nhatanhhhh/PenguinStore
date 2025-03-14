<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Voucher</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
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
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-warning text-white text-center">
                                    <h2>Create Voucher</h2>

                                    <%
                                        LocalDate now = LocalDate.now();
                                        String formattedDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                    %>


                                    <div class="card-body">
                                        <c:if test="${not empty error}">
                                            <p class="text-danger text-center">${error}</p>
                                        </c:if>
                                        <form action="<c:url value='/Voucher?action=create'/>" method="post">
                                            <label>Date created:</label>
                                            <input type="text" name="validFrom_display" value="<%= formattedDate%>" disabled> <br>
                                            <input type="hidden" name="validFrom" value="<%= formattedDate%>">

                                            <label for="voucherCode">Voucher Code:</label>
                                            <input type="text" id="voucherCode" name="voucherCode" required><br>

                                            <label for="discountPer">Discount Percentage (%):</label>
                                            <input type="number" id="discountPer" name="discountPer" step="0.1" min="0" value="0" required><br>

                                            <label for="discountAmount">Discount Amount:</label>
                                            <input type="number" id="discountAmount" name="discountAmount" step="0.1" min="0" value="0" required><br>

                                            <label for="minOrderValue">Minimum Order Value:</label>
                                            <input type="number" id="minOrderValue" name="minOrderValue" step="0.1" min="0" value="0" required><br>

                                            <label for="validUntil">Valid Until:</label>
                                            <input type="date" id="validUntil" name="validUntil" min="<%= formattedDate%>" required><br>

                                            <label for="maxDiscountAmount">Maximum Discount Amount:</label>
                                            <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" step="0.1" min="0" value="0" required><br>

                                            <button type="submit">Create Voucher</button>
                                            <a href="<c:url value='/Voucher?action=list'/>" class="btn btn-secondary">Cancel</a>
                                        </form>
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
