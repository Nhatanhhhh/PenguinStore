<%-- 
    Document   : ListVoucher
    Created on : Feb 24, 2025, 9:47:09 PM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
                    <h2 class="text-center">List Voucher</h2>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert">
                            ${successMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Dropdown lọc voucher -->
                    <div class="mb-3">
                        <label for="voucherFilter" class="form-label">Filter Vouchers:</label>
                        <select id="voucherFilter" class="form-select">
                            <option value="all">All Voucher</option>
                            <option value="valid">Still Valid</option>
                            <option value="expired">Expire</option>
                        </select>
                    </div>

                    <table class="table table-bordered" id="voucherTable">
                        <thead class="table-dark">
                            <tr>
                                <th>Voucher Code</th>
                                <th>Discount Amount</th>
                                <th>Minimum Order Value</th>
                                <th>Date Created</th>
                                <th>Valid Until</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="voucher" items="${voucherList}">
                                <tr class="${voucher.voucherStatus ? 'valid' : 'expired'}">
                                    <td>${voucher.voucherCode}</td>
                                    <td><fmt:formatNumber value="${voucher.discountAmount}" pattern="#,###" /> VND</td>
                                    <td><fmt:formatNumber value="${voucher.minOrderValue}" pattern="#,###" /> VND</td>
                                    <td>${voucher.validFrom}</td>
                                    <td>${voucher.validUntil}</td>
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
                                                <button class="btn btn-primary btn-sm" 
                                                        style="pointer-events: none; opacity: 0.6;" 
                                                        onclick="openSendVoucherModal('${voucher.voucherID}')">Send</button>
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

        <!-- Modal gửi voucher -->
        <div class="modal fade" id="sendVoucherModal" tabindex="-1" aria-labelledby="sendVoucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="sendVoucherModalLabel">Send Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="sendVoucherForm" action="<c:url value='/Voucher?action=send'/>" method="POST">
                            <input type="hidden" id="voucherID" name="voucherID">

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="selectAllUsers" name="voucherSelection" value="all" checked onchange="toggleCustomerList()">
                                <label class="form-check-label" for="selectAllUsers">
                                    Select all Customer
                                </label>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="selectSpecificUsers" name="voucherSelection" value="specific" onchange="toggleCustomerList()">
                                <label class="form-check-label" for="selectSpecificUsers">
                                    Select specific Customer
                                </label>
                            </div>

                            <!-- Danh sách customer với checkbox -->
                            <div id="customerList" style="display: none; max-height: 300px; overflow-y: auto;">
                                <c:choose>
                                    <c:when test="${empty listCusVoucher}">
                                        <p>No customers found.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${listCusVoucher}" var="customer">
                                            <div class="form-check">
                                                <input class="form-check-input customer-checkbox" 
                                                       type="checkbox" 
                                                       name="selectedCustomers" 
                                                       value="${customer.email}"
                                                       id="customer_${customer.email}">
                                                <label class="form-check-label" for="customer_${customer.email}">
                                                    ${customer.customerName} (${customer.email})
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mt-3">Send Voucher</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Lọc bảng voucher
            document.getElementById("voucherFilter").addEventListener("change", function () {
                let filterValue = this.value;
                let rows = document.querySelectorAll("#voucherTable tbody tr");

                rows.forEach(row => {
                    if (filterValue === "all") {
                        row.style.display = "";
                    } else if (filterValue === "valid" && row.classList.contains("valid")) {
                        row.style.display = "";
                    } else if (filterValue === "expired" && row.classList.contains("expired")) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            });

            // Mở modal và gán voucherID
            function openSendVoucherModal(voucherID) {
                document.getElementById("voucherID").value = voucherID;

                // Mở modal
                var modal = new bootstrap.Modal(document.getElementById('sendVoucherModal'));
                modal.show();
            }

            // Toggle danh sách khách hàng và đảm bảo chỉ chọn 1 trong 2 checkbox
            function toggleCustomerList() {
                const selectAllUsers = document.getElementById('selectAllUsers');
                const selectSpecificUsers = document.getElementById('selectSpecificUsers');
                const customerList = document.getElementById('customerList');

                // Đảm bảo chỉ 1 trong 2 checkbox được chọn
                if (selectAllUsers.checked && selectSpecificUsers.checked) {
                    if (this === selectAllUsers) {
                        selectSpecificUsers.checked = false;
                    } else {
                        selectAllUsers.checked = false;
                    }
                }

                // Hiển thị danh sách khách hàng khi chọn "Select specific users"
                if (selectSpecificUsers.checked) {
                    customerList.style.display = 'block';
                } else {
                    customerList.style.display = 'none';
                    document.querySelectorAll('.customer-checkbox').forEach(checkbox => {
                        checkbox.checked = false;
                    });
                }
            }

            // Gán sự kiện onchange cho cả hai checkbox
            document.getElementById('selectAllUsers').addEventListener('change', toggleCustomerList);
            document.getElementById('selectSpecificUsers').addEventListener('change', toggleCustomerList);

            // Xác nhận trước khi gửi
            document.getElementById("sendVoucherForm").addEventListener("submit", function (event) {
                event.preventDefault();
                let confirmation = confirm("Are you sure you want to send this voucher?");
                if (confirmation) {
                    this.submit();
                }
            });
        </script>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>