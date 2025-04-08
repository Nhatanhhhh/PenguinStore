<%-- 
    Document   : ListVoucher
    Created on : Feb 24, 2025, 9:47:09 PM
    Author     : Do Van Luan - CE180457
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

                    <!-- Dropdown to filter vouchers -->
                    <div class="mb-3">
                        <label for="voucherFilter" class="form-label">Filter Vouchers:</label>
                        <select id="voucherFilter" class="form-select">
                            <option value="all">All Vouchers</option>
                            <option value="valid">Still Valid</option>
                            <option value="expired">Expired</option>
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
                                                <span style="color: red; font-weight: bold;">Expired</span>
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

        <!-- Modal to send voucher -->
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
                                <input class="form-check-input" type="radio" id="selectAllUsers" name="voucherSelection" value="all" onchange="toggleCustomerList()">
                                <label class="form-check-label" for="selectAllUsers">
                                    Send to All Customers
                                </label>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" id="selectSpecificUsers" name="voucherSelection" value="specific" onchange="toggleCustomerList()">
                                <label class="form-check-label" for="selectSpecificUsers">
                                    Send to Specific Customers
                                </label>
                            </div>

                            <!-- Customer list with radio buttons (to allow only one selection) -->
                            <div id="customerList" style="display: block; max-height: 300px; overflow-y: auto;">
                                <c:choose>
                                    <c:when test="${empty listCusVoucher}">
                                        <p>No customers found.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${listCusVoucher}" var="customer" varStatus="loop">
                                            <div class="form-check">
                                                <input class="form-check-input customer-checkbox" 
                                                       type="checkbox"  
                                                       name="selectedCustomers" 
                                                       value="${customer.email}"
                                                       id="customer_${loop.index}">
                                                <label class="form-check-label" for="customer_${loop.index}">
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
            // Filter voucher table
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

            // Open modal and set voucherID
            function openSendVoucherModal(voucherID) {
                document.getElementById("voucherID").value = voucherID;

                // Reset all selections
                document.getElementById('selectAllUsers').checked = false;
                document.getElementById('selectSpecificUsers').checked = false;
                document.getElementById('customerList').style.display = 'none';
                document.querySelectorAll('.customer-checkbox').forEach(checkbox => {
                    checkbox.checked = false;
                });

                // Open modal
                var modal = new bootstrap.Modal(document.getElementById('sendVoucherModal'));
                modal.show();
            }

            // Toggle customer list and ensure only one option is selected
            function toggleCustomerList() {
                const selectAllUsers = document.getElementById('selectAllUsers');
                const selectSpecificUsers = document.getElementById('selectSpecificUsers');
                const customerList = document.getElementById('customerList');

                // Show customer list when "Send to Specific Customer" is checked
                if (selectSpecificUsers.checked) {
                    customerList.style.display = 'block';
                    selectAllUsers.checked = false;
                } else if (selectAllUsers.checked) {
                    customerList.style.display = 'none';
                    selectSpecificUsers.checked = false;
                    document.querySelectorAll('.customer-checkbox').forEach(checkbox => {
                        checkbox.checked = false;
                    });
                } else {
                    customerList.style.display = 'none';
                }
            }
            // Attach onchange event to both checkboxes
            document.getElementById('selectAllUsers').addEventListener('change', toggleCustomerList);
            document.getElementById('selectSpecificUsers').addEventListener('change', toggleCustomerList);

            // Validate form before submission
            document.getElementById("sendVoucherForm").addEventListener("submit", function (event) {
                event.preventDefault();

                const selectAllUsers = document.getElementById('selectAllUsers');
                const selectSpecificUsers = document.getElementById('selectSpecificUsers');
                const customerCheckboxes = document.querySelectorAll('.customer-checkbox:checked');

                // Validation: Ensure at least one option is selected
                if (!selectAllUsers.checked && !selectSpecificUsers.checked) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Please select an option: Send to all customers or specific customers.',
                    });
                    return;
                }

                // Validation: If specific customer is selected, ensure at least one customer is chosen
                if (selectSpecificUsers.checked && customerCheckboxes.length === 0) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Please select at least one customer to send the voucher to.',
                    });
                    return;
                }

                // Confirm before sending
                Swal.fire({
                    title: 'Are you sure?',
                    text: "Do you want to send this voucher?",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, send it!',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        this.submit();
                    }
                });
            });

            // Display success/error messages using SweetAlert
            <c:if test="${not empty successMessage}">
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: '${successMessage}',
                confirmButtonText: 'OK'
            });
            </c:if>
            <c:if test="${not empty errorMessage}">
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '${errorMessage}',
                confirmButtonText: 'OK'
            });
            </c:if>

            $('#sendVoucherModal').on('hidden.bs.modal', function () {
                document.getElementById("sendVoucherForm").reset();
                document.getElementById('customerList').style.display = 'none';
                document.querySelectorAll('.customer-checkbox').forEach(checkbox => {
                    checkbox.checked = false;
                });
            });
        </script>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>