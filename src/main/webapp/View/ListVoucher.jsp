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
                                                <button class="btn btn-primary btn-sm" onclick="openSendVoucherModal('${voucher.voucherID}')">Send</button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="<c:url value='/Voucher?action=edit&id=${voucher.voucherID}'/>" 
                                                   class="btn btn-warning btn-sm" 
                                                   style="pointer-events: none; opacity: 0.6;">
                                                    Edit
                                                </a>

                                                <button class="btn btn-primary btn-sm" onclick="openSendVoucherModal('${voucher.voucherID}')">Send</button>
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


        <div class="modal fade" id="sendVoucherModal" tabindex="-1" aria-labelledby="sendVoucherModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="sendVoucherModalLabel">Send Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                        <form id="sendVoucherForm" action="<c:url value='/Voucher?action=send'/>" method="POST">
                            <input type="hidden" id="voucherID" name="voucherID">


                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" id="selectAllUsers" name="voucherSelection" value="all" checked>
                                <label class="form-check-label" for="selectAllUsers">
                                    Select all users
                                </label>
                            </div>


                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" id="usersWithOrders" name="voucherSelection" value="withOrders">
                                <label class="form-check-label" for="usersWithOrders">
                                    Users with at least 1 order
                                </label>
                            </div>


                            <button type="submit" class="btn btn-primary w-100">Send Voucher</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <script>
            function openSendVoucherModal(voucherID) {
                document.getElementById("voucherID").value = voucherID;

                var modalElement = document.getElementById('sendVoucherModal');
                if (modalElement) {
                    var modal = new bootstrap.Modal(modalElement);
                    modal.show();
                } else {
                    console.error("Không tìm thấy modal với ID");
                }
            }


        </script>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>