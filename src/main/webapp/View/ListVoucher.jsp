<%-- 
    Document   : ListVoucher
    Created on : Feb 24, 2025, 9:47:09 PM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>List Voucher</title>
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
                    <h2>List Voucher</h2>
                    <table class="table table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Voucher Code</th>
                                <th>Discount Percentage</th>
                                <th>Discount Amount</th>
                                <th>Minimum Order Value</th>
                                <th>Date Created</th>
                                <th>Valid Until</th>
                                <th>Maximum Discount Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="voucher" items="${voucherList}">
                                <tr>
                                    <td>${voucher.voucherCode}</td>
                                    <td>${voucher.discountPer}</td>
                                    <td>${voucher.discountAmount}</td>
                                    <td>${voucher.minOrderValue}</td>
                                    <td>${voucher.validFrom}</td>
                                    <td>${voucher.validUntil}</td>
                                    <td>${voucher.maxDiscountAmount}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${voucher.voucherStatus}">
                                                <span style="color: green; font-weight: bold;">Still Valid</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: red; font-weight: bold;">Expire</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${voucher.voucherStatus}">
                                                <a href="<c:url value='/Voucher?action=edit&id=${voucher.voucherID}'/>" class="btn btn-warning btn-sm">Edit</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="<c:url value='/Voucher?action=edit&id=${voucher.voucherID}'/>" 
                                                   class="btn btn-warning btn-sm" 
                                                   style="pointer-events: none; opacity: 0.6;">
                                                    Edit
                                                </a>

                                            </c:otherwise>
                                        </c:choose>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <a href="<c:url value='/Voucher?action=create'/>" class="btn btn-success">Create</a>
                </div>
            </div>
        </div>


    </body>
</html>