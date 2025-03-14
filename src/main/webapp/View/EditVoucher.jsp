<%-- 
    Document   : EditVoucher
    Created on : Feb 25, 2025, 7:34:09 AM
    Author     : Do Van Luan - CE180457
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Edit Type</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
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
                                    <h3 class="text-center">Edit Type Product</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${empty voucher}">
                                        <p class="text-danger text-center">Not found Voucher.</p>
                                        <a href="<c:url value='/Voucher?action=list'/>" class="btn btn-secondary">Back</a>
                                    </c:if>

                                    <c:if test="${not empty voucher}">
                                        <form id="editForm" action="<c:url value='/Voucher?action=edit'/>" method="POST">
                                            <input type="hidden" name="voucherID" value="${voucher.voucherID}">

                                            <div class="mb-3">
                                                <label for="voucherCode" class="form-label">Voucher Code:</label>
                                                <input type="text" class="form-control" id="voucherCode" name="voucherCode" value="${voucher.voucherCode}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="discountPer" class="form-label">Discount Percentage (%):</label>
                                                <input type="number" class="form-control" id="discountPer" name="discountPer" value="${voucher.discountPer}" step="0.1" min="0" required>
                                            </div>

                                            <div class="mb-3">

                                                <label for="discountAmount" class="form-label">Discount Amount:</label>
                                                <input type="number" class="form-control" id="discountAmount" name="discountAmount" value="${voucher.discountAmount}" step="0.1" min="0" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="minOrderValue" class="form-label">Minimum Order Value:</label>
                                                <input type="number" class="form-control" id="minOrderValue" name="minOrderValue" value="${voucher.minOrderValue}" step="0.1" min="0" required>
                                            </div>

                                            <div class="mb-3">
                                                <label>Date created:</label>
                                                <input type="text" name="validFrom_display" value="${voucher.validFrom}" disabled> <br>
                                                <input type="hidden" class="form-control" id="validFrom" name="validFrom" value="${voucher.validFrom}">
                                            </div>

                                            <div class="mb-3">
                                                <label for="validUntil">Valid Until:</label>
                                                <input type="date" class="form-control" id="validUntil" name="validUntil" min="${voucher.validFrom}" value="${voucher.validUntil}" required><br>
                                            </div>

                                            <div class="mb-3">
                                                <label for="maxDiscountAmount" class="form-label">Maximum Discount Amount:</label>
                                                <input type="number" class="form-control" id="maxDiscountAmount" name="maxDiscountAmount" value="${voucher.maxDiscountAmount}" step="0.1" min="0" required>
                                            </div>

                                            <button type="submit" class="btn btn-primary">Update</button>
                                            <a href="<c:url value='/Voucher?action=list'/>" class="btn btn-secondary">Cancel</a>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            document.getElementById("editForm").addEventListener("submit", function (event) {
                event.preventDefault(); // Ngăn chặn gửi form ngay lập tức

                Swal.fire({
                    title: "Confirm Update",
                    text: "Are you sure you want to update this voucher?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, update it!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        event.target.submit(); // Gửi form khi xác nhận
                    }
                });
            });
        </script>

    </body>
</html>