<%-- 
    Document   : OrderHistory
    Created on : Feb 22, 2025, 1:15:53 AM
    Author     : PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, Models.Order, Models.Customer" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null)
        orders = new ArrayList<Order>();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order History</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <style>
            .order {
                border-bottom: 1px solid #E5E5E5;
                padding: 20px 0;
            }

            .order-info p {
                margin: 5px 0;
                font-size: 16px;
            }

            .status {
                font-size: 14px;
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 5px;
            }

            .delivered {
                background-color: #E1FCEF;
                color: #198754;
            }

            .in-process {
                background-color: #FFF4E5;
                color: #D97706;
            }

            .btn-container {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .btn-view {
                background-color: #000;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
            }

            .btn-view:hover {
                background-color: #333;
            }

            .btn-review {
                background-color: white;
                color: black;
                border: 1px solid black;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
                cursor: pointer;
                transition: background-color 0.3s, color 0.3s;
            }

            .btn-review:hover {
                background-color: #f0f0f0;
                color: black;
            }

            .btn-recancel {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .btn-recancel:hover {
                background-color: #0056b3;
            }

            .btn-cancel {
                background-color: #FF4D4D;
                color: white;
                border: none;
                padding: 8px 14px;
                border-radius: 5px;
                width: 100%;
                text-align: center;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .btn-cancel:hover {
                background-color: #E60000;
            }

        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer customer = (Customer) session.getAttribute("user");
        %>

        <h1 class="text-center mb-4" style="font-size: 35px;">My Order</h1>

        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Order</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            View your Order
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="list col-md-2">
                    <div class="divider"></div>
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="orderhistory"><a style="font-weight: bold;">Order</a></div>
                    <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
                    <div class="divider"></div>
                </div>

                <div class="col-md-10">
                    <% for (Order order : orders) {%>
                    <div class="order row" data-status="<%= order.getStatusName()%>">
                        <div class="col-md-10">
                            <div class="order-info">
                                <p><strong>OrderID:</strong> <%= (order.getOrderID().length() >= 4) ? order.getOrderID().substring(0, 4) : order.getOrderID()%></p>
                                <p><strong>Voucher code:</strong> <%= order.getVoucherName()%></p>
                                <p><strong>Order date:</strong> <%= order.getOrderDate()%></p>
                                <span class="status <%= order.getStatusName().toLowerCase().replace(" ", "-")%>">
                                    <%= order.getStatusName()%>
                                </span> Your product has been <%= order.getStatusName().toLowerCase()%>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="btn-container">
                                <form action="<%= request.getContextPath()%>/OrderDetail" method="GET">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <button type="submit" class="btn btn-view">View Order</button>
                                </form>
                                <% if ("Delivery successful".equals(order.getStatusName())) { %>
                                <button class="btn btn-review">Write A Review</button>
                                <% } else if ("Order Cancellation Request".equals(order.getStatusName())) {%>
                                <form action="<%= request.getContextPath()%>/OrderHistory" method="POST">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <input type="hidden" name="newStatus" value="Pending processing">
                                    <button type="submit" class="btn btn-recancel">ReCancel</button>
                                </form>
                                <% } else {%>
                                <form action="<%= request.getContextPath()%>/OrderHistory" method="POST">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                    <input type="hidden" name="newStatus" value="Order Cancellation Request">
                                    <button type="submit" class="btn btn-cancel">Cancel Order</button>
                                </form>

                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% }%>
                </div>
            </div>
        </div>
        <!-- Modal Confirm -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalLabel">Confirm Action</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="confirmMessage">Are you sure you want to proceed?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                        <button type="button" class="btn btn-danger" id="confirmAction">Yes</button>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
<script>
    let status = order.getAttribute("data-status").trim();
    document.addEventListener("DOMContentLoaded", function () {
        let selectedForm = null;

        document.querySelectorAll(".btn-cancel, .btn-recancel").forEach(button => {
            button.addEventListener("click", function (event) {
                event.preventDefault(); // Ngăn chặn submit ngay lập tức
                selectedForm = this.closest("form");

                let actionType = this.classList.contains("btn-cancel") ? "Cancel" : "ReCancel";
                document.getElementById("confirmMessage").textContent = `Are you sure you want to ${actionType} this order?`;

                let modal = new bootstrap.Modal(document.getElementById("confirmModal"));
                modal.show();
            });
        });

        document.getElementById("confirmAction").addEventListener("click", function () {
            if (selectedForm) {
                selectedForm.submit();
            }
        });
    });
</script>