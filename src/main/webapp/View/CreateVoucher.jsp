<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Voucher</title>
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
        <%
            LocalDate now = LocalDate.now();
            String formattedDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        %>
        <div class="row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10">
                <%@include file="Admin/HeaderAD.jsp"%>
                <div class="container mt-4"> 
                    <h3 class="text-center">Create Voucher</h3>
                </div>
                <div class="container mt-6">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">${error}</div>
                    </c:if>
                    <form action="<c:url value='/Voucher?action=create'/>" method="post">
                        <div>
                            <label class="form-label">Date Created:</label>
                            <input type="text" class="form-control" value="<%= formattedDate%>" disabled>
                            <input type="hidden" name="validFrom" value="<%= formattedDate%>">
                        </div>

                        <div >
                            <label for="voucherCode" class="form-label">Voucher Code:</label>
                            <input type="text" class="form-control" id="voucherCode" name="voucherCode" required>
                        </div>

                        <div >
                            <div >
                                <div >
                                    <label for="discountPer" class="form-label">Discount Percentage (%):</label>
                                    <input type="number" class="form-control" id="discountPer" name="discountPer" step="0.1" min="0" value="0" required>
                                </div>
                            </div>
                            <div >
                                <div >
                                    <label for="discountAmount" class="form-label">Discount Amount:</label>
                                    <input type="number" class="form-control" id="discountAmount" name="discountAmount" step="0.1" min="0" value="0" required>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label for="minOrderValue" class="form-label">Minimum Order Value:</label>
                            <input type="number" class="form-control" id="minOrderValue" name="minOrderValue" step="0.1" min="0" value="0" required>
                        </div>

                        <div>
                            <label for="validUntil" class="form-label">Valid Until:</label>
                            <input type="date" class="form-control" id="validUntil" name="validUntil" min="<%= formattedDate%>" required>
                        </div>

                        <div>
                            <label for="maxDiscountAmount" class="form-label">Maximum Discount Amount:</label>
                            <input type="number" class="form-control" id="maxDiscountAmount" name="maxDiscountAmount" step="0.1" min="0" value="0" required>
                        </div>

                        <br>
                        <div class="text-center">
                            <button type="submit" class="btn btn-warning">Create Voucher</button>
                            <a href="<c:url value='/Voucher?action=list'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>