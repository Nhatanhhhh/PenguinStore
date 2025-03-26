<%-- 
    Document   : AdminOrder
    Created on : Mar 15, 2025, 1:40:03 AM
    Author     : Le Minh Loc CE180992
--%>
<%@page import="Models.Manager"%>
<%@page import="Models.Order"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Order Management</title>
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
                <h2 class="mt-4 text-danger">Order Management</h2>
                <div class="px-4">
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Manage Orders</li>
                    </ol>

                    <!-- Bộ lọc và tìm kiếm -->
                    <div class="d-flex justify-content-between mb-3">
                        <div>
                            <label>Filter by order status:</label>
                            <select id="filterStatus" class="form-select d-inline-block w-auto" onchange="filterOrders()">
                                <option value="all">All</option>
                                <option value="pending-processing">Pending processing</option>
                                <option value="processed">Processed</option>
                                <option value="order-cancellation-request">Order Cancellation Request</option>
                                <option value="cancel-order">Cancel order</option>
                                <option value="delivered-to-carrier">Delivered to the carrier</option>
                                <option value="delivery-failed">Delivery failed</option>
                                <option value="delivery-successful">Delivery successful</option>
                            </select>

                        </div>
                        <div>
                            <label for="searchBox">Search:</label>
                            <input type="text" id="searchBox" class="form-control d-inline-block w-auto" onkeyup="searchOrders()">
                        </div>
                    </div>
                    `   <div class="d-flex justify-content-between mb-3">
                        <div>
                            <label>Show:</label>
                            <select id="entriesPerPage" class="form-select d-inline-block w-auto" onchange="updateEntries()">
                                <option value="10">10</option>
                                <option value="25">25</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select>
                            <span> entries</span>
                        </div>
                    </div>
                    <!-- Bảng danh sách đơn hàng -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-shopping-cart me-1"></i>
                            Order List
                        </div>
                        <div class="card-body">
                            <table id="orderTable" class="table table-bordered text-center">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Order Date</th>
                                        <th>Total Amount</th>
                                        <th>Order Status</th>
                                        <th>Update Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                                        if (orderList != null) {
                                            for (Order order : orderList) {%>
                                    <tr>
                                        <td><%= (order.getOrderID().length() >= 4) ? order.getOrderID().substring(0, 4) : order.getOrderID()%></td>
                                        <td><%= order.getFullName()%></td>
                                        <td><%= order.getOrderDate()%></td>
                                        <td>$<%= order.getTotalAmount()%></td>
                                        <td><%= order.getOrderStatus()%></td>
                                        <td>
                                            <% if (order.getOrderStatus().equals("Cancel order")) { %>
                                            <span class="text-danger fw-bold">Confirmed cancelled</span>
                                            <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) { %>
                                            <span class="text-warning fw-bold">Cancellation Request</span>
                                            <% } else if (order.getOrderStatus().equals("Delivery successful")) { %>
                                            <span class="text-success fw-bold">Order delivered </span>
                                            <% } else {%>
                                            <select class="form-select">
                                                <option <%= order.getOrderStatus().equals("Pending processing") ? "selected" : ""%>>Pending processing</option>
                                                <option <%= order.getOrderStatus().equals("Processed") ? "selected" : ""%>>Processed</option>
                                                <option <%= order.getOrderStatus().equals("Delivered to the carrier") ? "selected" : ""%>>Delivered to the carrier</option>
                                                <option <%= order.getOrderStatus().equals("Delivery failed") ? "selected" : ""%>>Delivery failed</option>
                                                <option <%= order.getOrderStatus().equals("Delivery successful") ? "selected" : ""%>>Delivery successful</option>
                                            </select>
                                            <% }%>
                                        </td>


                                        <td>
                                            <% if (order.getOrderStatus().equals("Cancel order")) {%>
                                            <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                                <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                <button type="submit" class="btn btn-info m-2">Order Detail</button>
                                            </form>
                                            <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) {%>
                                            <button class="btn btn-danger" onclick="acceptCancel('<%= order.getOrderID()%>')">Accept Cancel</button>
                                            <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                                <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                <button type="submit" class="btn btn-info m-2">Order Detail</button>
                                            </form>
                                            <% } else if (order.getOrderStatus().equals("Delivery successful")) {%>
                                            <!-- Không hi?n th? nút Update -->
                                            <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                                <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                <button type="submit" class="btn btn-info m-2">Order Detail</button>
                                            </form>
                                            <% } else {%>
                                            <button class="btn btn-primary" onclick="confirmUpdate('<%= order.getOrderID()%>', this)">Update</button>
                                            <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                                <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                <button type="submit" class="btn btn-info m-2">Order Detail</button>
                                            </form>
                                            <% } %>
                                        </td>


                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr><td colspan="7">No orders found.</td></tr>
                                    <% }%>
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span id="paginationInfo"></span>
                                <nav>
                                    <ul class="pagination" id="paginationControls"></ul>
                                </nav>
                            </div>
                            <div class="modal fade" id="confirmModal" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Confirm Update</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            Are you sure you want to update this order status?
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                            <button type="button" class="btn btn-primary" id="confirmUpdateBtn">Update</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal fade" id="confirmDeliveryModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm Delivery</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Do you confirm <strong>That the delivery was successful</strong>? <br> 
                        <span class="text-danger">This state is uneditable!</span>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-success" id="confirmDeliveryBtn">Confirm</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<script>
    let selectedOrderId;
    let selectedStatus;

    function confirmUpdate(orderId, button) {
        selectedOrderId = orderId;
        let row = button.closest('tr');
        selectedStatus = row.querySelector('select').value;

        if (selectedStatus === "Delivery successful") {
            let modal = new bootstrap.Modal(document.getElementById('confirmDeliveryModal'));
            modal.show();
        } else {
            let modal = new bootstrap.Modal(document.getElementById('confirmModal'));
            modal.show();
        }
    }

    document.getElementById('confirmDeliveryBtn').addEventListener('click', function () {
        updateOrderStatus();
    });

    document.getElementById('confirmUpdateBtn').addEventListener('click', function () {
        updateOrderStatus();
    });

    function filterOrders() {
        let filter = document.getElementById("filterStatus").value.toLowerCase();
        let filterText = document.getElementById("filterStatus").options[document.getElementById("filterStatus").selectedIndex].text;
        let rows = document.querySelectorAll("#orderTable tr");
        let found = false;

        let statusMapping = {
            "pending-processing": "pending processing",
            "processed": "processed",
            "order-cancellation-request": "order cancellation request",
            "cancel-order": "cancel order",
            "delivered-to-carrier": "delivered to the carrier",
            "delivery-failed": "delivery failed",
            "delivery-successful": "delivery successful"
        };

        rows.forEach(row => {
            if (row.id !== "notFoundRow") {  // ??m b?o không x? lý dòng "Not found"
                let status = row.cells[4].innerText.trim().toLowerCase();
                if (filter === "all" || status === statusMapping[filter]) {
                    row.style.display = "";
                    found = true; // N?u có ít nh?t 1 dòng h?p l?, không hi?n th? "Not found"
                } else {
                    row.style.display = "none";
                }
            }
        });

        // Xóa dòng "Not found" n?u có d? li?u h?p l?
        let notFoundRow = document.getElementById("notFoundRow");
        if (notFoundRow) {
            notFoundRow.remove();
        }

        // N?u không tìm th?y k?t qu?, thêm dòng "Not found" v?i tr?ng thái ?ã filter
        if (!found) {
            let tbody = document.getElementById("orderTable");
            let tr = document.createElement("tr");
            tr.id = "notFoundRow";
            tr.innerHTML = `<td colspan="7" class="text-danger fw-bold">The status you are looking for was NOT FOUND. ${filterText}</td>`;
            tbody.appendChild(tr);
        }
    }
    function acceptCancel(orderId) {
        fetch('<%= request.getContextPath()%>/OrderManagement', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'orderID=' + orderId + '&statusName=Cancel order'
        }).then(response => response.text()).then(data => {
            alert('Order has been cancelled.');
            window.location.reload();
        }).catch(error => console.error('Error:', error));
    }


    function searchOrders() {
        let keyword = document.getElementById("searchBox").value.toLowerCase();
        let rows = document.querySelectorAll("#orderTable tr");
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(keyword) ? "" : "none";
        });
    }




    function updateOrderStatus() {
        fetch('<%= request.getContextPath()%>/OrderManagement', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'orderID=' + selectedOrderId + '&statusName=' + encodeURIComponent(selectedStatus)
        }).then(response => response.text()).then(data => {
            alert('Order status updated successfully');
            window.location.reload();
        }).catch(error => console.error('Error:', error));

        let deliveryModal = bootstrap.Modal.getInstance(document.getElementById('confirmDeliveryModal'));
        let normalModal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
        if (deliveryModal)
            deliveryModal.hide();
        if (normalModal)
            normalModal.hide();
    }

</script>