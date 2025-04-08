<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Voucher</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoard.css"/>

        <script>
            $(document).ready(function () {
                $("#discountAmount").on("input", function () {
                    $("#maxDiscountAmount").val($(this).val());
                });
            });
        </script>
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
                    <%-- Hiển thị thông báo lỗi --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <%-- Hiển thị thông báo thành công --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                </div>
                <div class="container d-flex justify-content-center align-items-center">
                    <form action="<c:url value='/Voucher?action=create'/>" method="post" 
                          class="w-50 p-4 border rounded shadow-lg bg-light"> 

                        <div class="mb-3">
                            <label class="form-label">Date Created:</label>
                            <input type="text" class="form-control" value="<%= formattedDate%>" disabled>
                            <input type="hidden" name="validFrom" value="<%= formattedDate%>">
                        </div>

                        <div class="mb-3">
                            <label for="voucherCode" class="form-label">Voucher Code:</label>
                            <input type="text" class="form-control" id="voucherCode" name="voucherCode" required>
                            <div id="voucherCodeFeedback" class="invalid-feedback"></div>
                        </div>


                        <div class="mb-3">

                            <input type="hidden" class="form-control" id="discountPer" name="discountPer" step="1" min="0" value="0" required>
                        </div>

                        <div class="mb-3">
                            <label for="discountAmount" class="form-label">Discount Amount:</label>
                            <input type="number" class="form-control" id="discountAmount" name="discountAmount" step="1000" min="0" value="0" required>
                        </div>



                        <div class="mb-3">
                            <label for="minOrderValue" class="form-label">Minimum Order Value:</label>
                            <input type="number" class="form-control" id="minOrderValue" name="minOrderValue" step="1000" min="0" value="0" required>
                        </div>

                        <div class="mb-3">
                            <label for="validUntil" class="form-label">Valid Until:</label>
                            <input type="date" class="form-control" id="validUntil" name="validUntil" min="<%= formattedDate%>" required>
                        </div>

                        <div class="mb-3">

                            <input type="hidden" class="form-control" id="maxDiscountAmount" name="maxDiscountAmount" min="discountAmount" step="1000" value="discountAmount" readonly>
                        </div>

                        <br>
                        <div class="text-center">
                            <button type="submit" class="btn btn-warning" id="submitBtn" disabled>Create Voucher</button>
                            <a href="<c:url value='/Voucher?action=list'/>" class="btn btn-secondary">Cancel</a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            $(document).ready(function () {
                function validateForm() {
                    let isValid = true;

                    // Kiểm tra nếu có bất kỳ trường nào có class "is-invalid"
                    $(".form-control").each(function () {
                        if ($(this).hasClass("is-invalid")) {
                            isValid = false;
                        }
                    });

                    // Nếu form không hợp lệ, disable nút submit
                    $("#submitBtn").prop("disabled", !isValid);
                }

                // Kiểm tra trùng mã voucher
                $("#voucherCode").on("blur", function () {
                    var voucherCode = $(this).val();
                    if (voucherCode.length > 0) {
                        $.ajax({
                            url: "Voucher?action=checkDuplicate",
                            type: "POST",
                            data: {voucherCode: voucherCode},
                            success: function (response) {
                                if (response === "exists") {
                                    $("#voucherCode").addClass("is-invalid");
                                    $("#voucherCodeFeedback").text("Voucher Code already exists.");
                                } else {
                                    $("#voucherCode").removeClass("is-invalid");
                                    $("#voucherCodeFeedback").text("");
                                }
                                validateForm(); // Kiểm tra form sau khi AJAX chạy
                            }
                        });
                    }
                });

                // Kiểm tra lỗi trên các input khác
                $(".form-control").on("input", function () {
                    if ($(this).val().trim() === "") {
                        $(this).addClass("is-invalid");
                    } else {
                        $(this).removeClass("is-invalid");
                    }
                    validateForm();
                });

                // Kiểm tra form ngay khi trang load
                validateForm();
            });

        </script>

    </body>
</html>