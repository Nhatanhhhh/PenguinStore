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
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <!-- Add SweetAlert CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <style>
            .order-table {
                font-size: 0.9rem;
            }

            #orderTable thead {
                background-color: #04414d;
                color: white;
                position: sticky;
                top: 0;
            }

            #orderTable th {
                text-align: center;
                vertical-align: middle;
                padding: 12px 8px;
            }

            /* Status Colors */
            .status-pending {
                background-color: #fff3cd;
            }

            .status-processing {
                background-color: #cce5ff;
            }

            .status-cancelled {
                background-color: #f8d7da;
            }

            .status-delivered {
                background-color: #d4edda;
            }

            .status-cancellation-request {
                background-color: #fff3cd;
                font-weight: bold;
            }

            .table-container {
                max-height: 600px;
                overflow-y: auto;
            }

            /* Button Styling */
            .btn-action {
                margin: 2px;
                padding: 0.25rem 0.5rem;
                font-size: 0.8rem;
            }

            .action-buttons {
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
                justify-content: center;
            }

            /* Card Header */
            .card-header {
                background-color: #04414d;
                color: white;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .action-buttons {
                    flex-direction: column;
                }
            }
        </style>
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

                    <!-- Filter and search section -->
                    <div class="d-flex justify-content-between mb-3 flex-wrap">
                        <div class="mb-2">
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
                        <div class="mb-2">
                            <label for="searchBox">Search:</label>
                            <input type="text" id="searchBox" class="form-control d-inline-block w-auto" 
                                   onkeyup="searchOrders()" placeholder="Search by ID or name...">
                        </div>
                        <div class="mb-2">
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

                    <!-- Order list table -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-shopping-cart me-1"></i>
                            Order List
                        </div>
                        <div class="card-body">
                            <div class="table-container">
                                <table id="orderTable" class="table table-bordered text-center order-table">
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
                                            <td><%= order.getTotalAmount()%> VND</td>
                                            <td class="
                                                <% if (order.getOrderStatus().equals("Cancel order")) { %>
                                                status-cancelled
                                                <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) { %>
                                                status-cancellation-request
                                                <% } else if (order.getOrderStatus().equals("Delivery successful")) { %>
                                                status-delivered
                                                <% } else if (order.getOrderStatus().equals("Pending processing")) { %>
                                                status-pending
                                                <% } else if (order.getOrderStatus().equals("Processed") || order.getOrderStatus().equals("Delivered to the carrier")) { %>
                                                status-processing
                                                <% }%>
                                                ">
                                                <%= order.getOrderStatus()%>
                                            </td>
                                            <td>
                                                <% if (order.getOrderStatus().equals("Cancel order")) { %>
                                                <span class="text-danger fw-bold">Confirmed cancelled</span>
                                                <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) { %>
                                                <span class="text-warning fw-bold">Cancellation Request</span>
                                                <% } else if (order.getOrderStatus().equals("Delivery successful")) { %>
                                                <span class="text-success fw-bold">Order delivered</span>
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
                                                <div class="action-buttons">
                                                    <% if (order.getOrderStatus().equals("Cancel order")) {%>
                                                    <form action="<%= request.getContextPath()%>/OrderDetailAdmin" method="GET">
                                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                        <button type="submit" class="btn btn-info btn-action">Order Detail</button>
                                                    </form>
                                                    <% } else if (order.getOrderStatus().equals("Order Cancellation Request")) {%>
                                                    <button class="btn btn-danger btn-action" onclick="acceptCancel('<%= order.getOrderID()%>')">Accept Cancel</button>
                                                    <form action="<%= request.getContextPath()%>/OrderDetailAdmin" method="GET">
                                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                        <button type="submit" class="btn btn-info btn-action">Order Detail</button>
                                                    </form>
                                                    <% } else if (order.getOrderStatus().equals("Delivery successful")) {%>
                                                    <form action="<%= request.getContextPath()%>/OrderDetailAdmin" method="GET">
                                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                        <button type="submit" class="btn btn-info btn-action">Order Detail</button>
                                                    </form>
                                                    <% } else {%>
                                                    <button class="btn btn-primary btn-action" onclick="confirmUpdate('<%= order.getOrderID()%>', this)">Update</button>
                                                    <form action="<%= request.getContextPath()%>/OrderDetailAdmin" method="GET">
                                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                                        <button type="submit" class="btn btn-info btn-action">Order Detail</button>
                                                    </form>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                        <% }
                                        } else { %>
                                        <tr><td colspan="7" class="text-center">No orders found.</td></tr>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span id="paginationInfo"></span>
                                <nav>
                                    <ul class="pagination" id="paginationControls"></ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                                                        let selectedOrderId;
                                                        let selectedStatus;
                                                        let currentPage = 1;
                                                        let entriesPerPage = 10;

                                                        function showLoading() {
                                                            Swal.fire({
                                                                title: 'Processing...',
                                                                allowOutsideClick: false,
                                                                showConfirmButton: false,
                                                                willOpen: () => {
                                                                    Swal.showLoading();
                                                                }
                                                            });
                                                        }

                                                        function confirmUpdate(orderId, button) {
                                                            selectedOrderId = orderId;
                                                            let row = button.closest('tr');
                                                            let selectElement = row.querySelector('select');

                                                            if (!selectElement) {
                                                                Swal.fire('Error', 'Cannot update this status', 'error');
                                                                return;
                                                            }

                                                            selectedStatus = selectElement.value;

                                                            if (selectedStatus === "Delivery successful") {
                                                                Swal.fire({
                                                                    title: 'Confirm Delivery',
                                                                    html: 'Do you confirm <strong>that the delivery was successful</strong>?<br><span class="text-danger">This state is uneditable!</span>',
                                                                    icon: 'warning',
                                                                    showCancelButton: true,
                                                                    confirmButtonColor: '#28a745',
                                                                    cancelButtonColor: '#6c757d',
                                                                    confirmButtonText: 'Yes, confirm delivery!'
                                                                }).then((result) => {
                                                                    if (result.isConfirmed) {
                                                                        updateOrderStatus();
                                                                    }
                                                                });
                                                            } else {
                                                                Swal.fire({
                                                                    title: 'Confirm Update',
                                                                    text: 'Are you sure you want to update this order status to ' + selectedStatus + '?',
                                                                    icon: 'question',
                                                                    showCancelButton: true,
                                                                    confirmButtonColor: '#3085d6',
                                                                    cancelButtonColor: '#d33',
                                                                    confirmButtonText: 'Yes, update it!'
                                                                }).then((result) => {
                                                                    if (result.isConfirmed) {
                                                                        updateOrderStatus();
                                                                    }
                                                                });
                                                            }
                                                        }

                                                        function acceptCancel(orderId) {
                                                            Swal.fire({
                                                                title: 'Confirm Cancellation',
                                                                text: 'Are you sure you want to accept this cancellation request? This action cannot be undone.',
                                                                icon: 'warning',
                                                                showCancelButton: true,
                                                                confirmButtonColor: '#d33',
                                                                cancelButtonColor: '#3085d6',
                                                                confirmButtonText: 'Yes, cancel it!',
                                                                cancelButtonText: 'No, keep it'
                                                            }).then((result) => {
                                                                if (result.isConfirmed) {
                                                                    showLoading();
                                                                    fetch('<%= request.getContextPath()%>/OrderManagement', {
                                                                        method: 'POST',
                                                                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                        body: 'orderID=' + orderId + '&statusName=Cancel order'
                                                                    }).then(response => {
                                                                        Swal.close();
                                                                        if (response.ok) {
                                                                            return Swal.fire(
                                                                                    'Cancelled!',
                                                                                    'The order has been cancelled.',
                                                                                    'success'
                                                                                    );
                                                                        } else {
                                                                            throw new Error('Failed to cancel order');
                                                                        }
                                                                    }).then(() => {
                                                                        window.location.reload();
                                                                    }).catch(error => {
                                                                        console.error('Error:', error);
                                                                        Swal.fire(
                                                                                'Error!',
                                                                                'Failed to cancel the order.',
                                                                                'error'
                                                                                );
                                                                    });
                                                                }
                                                            });
                                                        }

                                                        function updateOrderStatus() {
                                                            showLoading();
                                                            fetch('<%= request.getContextPath()%>/OrderManagement', {
                                                                method: 'POST',
                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                body: 'orderID=' + selectedOrderId + '&statusName=' + encodeURIComponent(selectedStatus)
                                                            }).then(response => {
                                                                Swal.close();
                                                                if (response.ok) {
                                                                    return Swal.fire(
                                                                            'Updated!',
                                                                            'Order status has been updated.',
                                                                            'success'
                                                                            );
                                                                } else {
                                                                    throw new Error('Failed to update order');
                                                                }
                                                            }).then(() => {
                                                                window.location.reload();
                                                            }).catch(error => {
                                                                console.error('Error:', error);
                                                                Swal.fire(
                                                                        'Error!',
                                                                        'Failed to update order status.',
                                                                        'error'
                                                                        );
                                                            });
                                                        }

                                                        function filterOrders() {
                                                            let filter = document.getElementById("filterStatus").value.toLowerCase();
                                                            let filterText = document.getElementById("filterStatus").options[document.getElementById("filterStatus").selectedIndex].text;
                                                            let rows = document.querySelectorAll("#orderTable tbody tr");
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
                                                                if (!row.id.includes("notFoundRow")) {
                                                                    let status = row.cells[4].innerText.trim().toLowerCase();
                                                                    if (filter === "all" || status === statusMapping[filter]) {
                                                                        row.style.display = "";
                                                                        found = true;
                                                                    } else {
                                                                        row.style.display = "none";
                                                                    }
                                                                }
                                                            });

                                                            let notFoundRow = document.getElementById("notFoundRow");
                                                            if (notFoundRow) {
                                                                notFoundRow.remove();
                                                            }

                                                            if (!found) {
                                                                let tbody = document.querySelector("#orderTable tbody");
                                                                let tr = document.createElement("tr");
                                                                tr.id = "notFoundRow";
                                                                tr.innerHTML = `<td colspan="7" class="text-danger fw-bold">No orders found with status: ${filterText}</td>`;
                                                                tbody.appendChild(tr);
                                                            }
                                                        }

                                                        function searchOrders() {
                                                            let keyword = document.getElementById("searchBox").value.toLowerCase();
                                                            let rows = document.querySelectorAll("#orderTable tbody tr");

                                                            rows.forEach(row => {
                                                                if (!row.id.includes("notFoundRow")) {
                                                                    let rowText = row.innerText.toLowerCase();
                                                                    row.style.display = rowText.includes(keyword) ? "" : "none";
                                                                }
                                                            });
                                                        }

                                                        function updateEntries() {
                                                            entriesPerPage = parseInt(document.getElementById("entriesPerPage").value);
                                                            // You can implement pagination logic here if needed
                                                            // For now, we'll just reload to show all entries
                                                            window.location.reload();
                                                        }

                                                        // Initialize the table with default settings
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            filterOrders();
                                                        });
        </script>
    </body>
</html>