<%-- 
    Document   : OrderManagement
    Created on : Mar 7, 2025, 1:48:22 PM
    Author     : Le Minh Loc CE180992
--%>


<%@page import="Models.Order"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Order Management</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styles.css"/>
    </head>
    <body class="sb-nav-fixed">

        <%@include file="Staff/Header.jsp" %>
        <div id="layoutSidenav">
            <%@include file="Staff/Sidebar.jsp" %>
            <div id="layoutSidenav_content">
                <div class="container mt-4">
                    <h2 class="text-danger">Order Management</h2>

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
                    <div class="d-flex justify-content-between mb-3">
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

                    <table class="table table-bordered text-center">
                        <thead class="table-light">
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
                        <tbody id="orderTable">
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
                                    <span class="text-danger fw-bold">Confirmed order cancelled</span>
                                    <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) { %>
                                    <span class="text-warning fw-bold">Order Cancellation Request</span>
                                    <% } else if (order.getOrderStatus().equals("Delivery successful")) { %>
                                    <span class="text-success fw-bold">Order has been delivered successfully</span>
                                    <% } else {%>
                                    <select class="form-select">
                                        <option <%= order.getOrderStatus().equals("Pending processing") ? "selected" : ""%>>Pending processing</option>
                                        <option <%= order.getOrderStatus().equals("Processed") ? "selected" : ""%>>Processed</option>
                                        <option <%= order.getOrderStatus().equals("Delivered to the carrier") ? "selected" : ""%>>Delivered to the carrier</option>
                                        <option <%= order.getOrderStatus().equals("Delivery failed") ? "selected" : ""%>>Delivery failed</option>
                                        <option <%= order.getOrderStatus().equals("Delivery successful") ? "selected" : ""%>>Delivery successful</option>
                                    </select>
                                    <% } %>
                                </td>



                                <td>
                                    <% if (order.getOrderStatus().equals("Cancel order")) {%>
                                    <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-info">Order Detail</button>
                                    </form>
                                    <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) {%>
                                    <button class="btn btn-danger" onclick="acceptCancel('<%= order.getOrderID()%>')">Accept Cancel</button>
                                    <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-info">Order Detail</button>
                                    </form>
                                    <% } else if (order.getOrderStatus().equals("Delivery successful")) {%>
                                    <!-- Không hi?n th? nút Update -->
                                    <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-info">Order Detail</button>
                                    </form>
                                    <% } else {%>
                                    <button class="btn btn-primary" onclick="confirmUpdate('<%= order.getOrderID()%>', this)">Update</button>
                                    <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-info">Order Detail</button>
                                    </form>
                                    <% } %>
                                </td>


                            </tr>
                            <%     }
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
            <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
<script>
    let selectedOrderId;
    let selectedStatus;

    function confirmUpdate(orderId, button) {
        selectedOrderId = orderId;
        let row = button.closest('tr');
        selectedStatus = row.querySelector('select').value;

        let modal = new bootstrap.Modal(document.getElementById('confirmModal'));
        modal.show();
    }

    document.getElementById('confirmUpdateBtn').addEventListener('click', function () {
        fetch('<%= request.getContextPath()%>/OrderManagement', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'orderID=' + selectedOrderId + '&statusName=' + encodeURIComponent(selectedStatus)  // ?úng tham s?
        })
                .then(response => response.text()).then(data => {
            alert('Order status updated successfully');
            window.location.reload();
        }).catch(error => console.error('Error:', error));

        let modal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
        modal.hide();
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
</script>
