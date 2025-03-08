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

        <%@include file="Staff/Header.jsp" %> <!-- Nhúng Header -->
        <div id="layoutSidenav">
            <%@include file="Staff/Sidebar.jsp" %> <!-- Nhúng Sidebar -->
            <div id="layoutSidenav_content">
                <div class="container mt-4">
                    <h2 class="text-danger">Order Management</h2>

                    <div class="d-flex justify-content-between mb-3">
                        <div>
                            <label>Filter by order status:</label>
                            <select id="filterStatus" class="form-select d-inline-block w-auto">
                                <option value="all">All</option>
                                <option value="pending-processing">Pending processing</option>
                                <option value="processed">Processed</option>
                                <option value="order-cancellation-request">Order Cancellation Request</option>
                                <option value="cancel-order">Cancel order</option>
                                <option value="delivered-to-carrier">Delivered to the carrier</option>
                                <option value="delivery-failed">Delivery failed</option>
                                <option value="delivery-successful">Delivery successful</option>
                            </select>
                            <button class="btn btn-primary" onclick="filterOrders()">Filter</button>
                        </div>
                        <div>
                            <label for="searchBox">Search:</label>
                            <input type="text" id="searchBox" class="form-control d-inline-block w-auto" onkeyup="searchOrders()">
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
                                    <select class="form-select">
                                        <option <%= order.getOrderStatus().equals("Pending processing") ? "selected" : ""%>>Pending processing</option>
                                        <option <%= order.getOrderStatus().equals("Processed") ? "selected" : ""%>>Processed</option>
                                        <option <%= order.getOrderStatus().equals("Order Cancellation Request") ? "selected" : ""%>>Order Cancellation Request</option>
                                        <option <%= order.getOrderStatus().equals("Cancel order") ? "selected" : ""%>>Cancel order</option>
                                        <option <%= order.getOrderStatus().equals("Delivered to the carrier") ? "selected" : ""%>>Delivered to the carrier</option>
                                        <option <%= order.getOrderStatus().equals("Delivery failed") ? "selected" : ""%>>Delivery failed</option>
                                        <option <%= order.getOrderStatus().equals("Delivery successful") ? "selected" : ""%>>Delivery successful</option>
                                    </select>
                                </td>
                                <td>
                                    <button class="btn btn-primary" onclick="confirmUpdate('<%= order.getOrderID()%>', this)">Update</button>
                                    <form action="<%= request.getContextPath()%>/OrderDetailStaff" method="GET">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-info">View Details</button>
                                    </form>

                                </td>
                            </tr>
                            <%     }
                            } else { %>
                            <tr><td colspan="7">No orders found.</td></tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>

                <!-- Modal -->
                <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="confirmModalLabel">Confirm Update</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to update the order status?
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" id="confirmUpdateBtn">Confirm</button>
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
        let filter = document.getElementById("filterStatus").value.toLowerCase(); // Chuy?n v? ch? th??ng
        let rows = document.querySelectorAll("#orderTable tr");

        rows.forEach(row => {
            let status = row.cells[4].innerText.trim().toLowerCase(); // Chuy?n v? ch? th??ng

            // Mapping l?i các giá tr? trong <option> thành giá tr? hi?n th? trong b?ng
            let statusMapping = {
                "pending-processing": "pending processing",
                "processed": "processed",
                "order-cancellation-request": "order cancellation request",
                "cancel-order": "cancel order",
                "delivered-to-carrier": "delivered to the carrier",
                "delivery-failed": "delivery failed",
                "delivery-successful": "delivery successful"
            };

            // N?u ch?n "all" ho?c status trùng kh?p thì hi?n th?
            row.style.display = (filter === "all" || status === statusMapping[filter]) ? "" : "none";
        });
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
