<%-- 
    Document   : OrderDetailStaff
    Created on : Mar 8, 2025, 11:25:57 AM
    Author     : Le Minh Loc CE180992
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="DTO.OrderDetailDTO" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Order Detail</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styles.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/odt.css"/>
    </head>
    <body class="ods-body">
        <%@include file="Staff/HeaderStaff.jsp" %>

        <div class="ods-order-container">
            <%                List<OrderDetailDTO> orderDetails = (List<OrderDetailDTO>) request.getAttribute("orderDetails");
                if (orderDetails != null && !orderDetails.isEmpty()) {
                    OrderDetailDTO firstDetail = orderDetails.get(0);
            %>
            <%
                String orderID = request.getParameter("orderID");
            %>
            <div class="ods-order-title">
                Order Details - Order ID: 
                <span>
                    <%= (orderID != null && orderID.length() >= 4) ? orderID.substring(0, 4) : "N/A"%>
                </span>
            </div>

            <div class="ods-customer-name">Full Name: <%= firstDetail.getFullName()%></div>

            <% for (OrderDetailDTO detail : orderDetails) {%>
            <div class="ods-product">
                <img src="<%= request.getContextPath()%>/Image/Product/<%= detail.getImgName()%>" width="100" height="100" />
                <div class="ods-product-details">
                    <div class="ods-product-name"><%= detail.getProductName()%></div>
                    <div>Color: <%= detail.getColorName()%></div>
                    <div>Size: <%= detail.getSizeName()%></div>
                    <div>Quantity: <%= detail.getQuantity()%></div>
                </div>
                <div class="ods-price">$<%= detail.getUnitPrice()%></div>
            </div>
            <% }%>

            <div class="ods-order-info">
                <div><span>Order date:</span> <span><strong><%= firstDetail.getDateOrder()%></strong></span></div>
                <div><span>Subtotal:</span> <span><strong>$<%= firstDetail.getTotalAmount()%></strong></span></div>
                <div><span>Voucher Discount:</span> <span><strong>$<%= firstDetail.getDiscountAmount()%></strong></span></div>
                <div><span>Total:</span> <span><strong>$<%= firstDetail.getFinalAmount()%></strong></span></div>
            </div>

            <div class="progress-container">
                <h3>Order status: <%= orderDetails.get(0).getStatusOrderName()%></h3>

                <p>
                    <%
                        String statusOrder = orderDetails.get(0).getStatusOrderName();
                        String statusMessage = "";

                        switch (statusOrder) {
                            case "Pending processing":
                                statusMessage = "This order is waiting to be processed.";
                                break;
                            case "Processed":
                                statusMessage = "This order has been processed and is waiting for the shipping unit.";
                                break;
                            case "Order Cancellation Request":
                                statusMessage = "The customer has requested to cancel this order. Please review the request.";
                                break;
                            case "Cancel order":
                                statusMessage = "This order has been successfully canceled.";
                                break;
                            case "Delivered to the carrier":
                                statusMessage = "The order has been handed over to the shipping unit.";
                                break;
                            case "Delivery failed":
                                statusMessage = "The delivery was unsuccessful. Please check and take appropriate action.";
                                break;
                            case "Delivery successful":
                                statusMessage = "The order has been successfully delivered.";
                                break;
                            default:
                                statusMessage = "Unknown order status.";
                        }
                    %>
                <div class="alert alert-info text-center fw-bold">
                    <%= statusMessage%>
                </div>

            </div>
            <div class="order-progress">
                <%
                    String[] statuses = {
                        "Order Placed",
                        "Processed",
                        "Order is Shipping"
                    };
                    String[] icons = {
                        "fa-file-alt",
                        "fa-cogs",
                        "fa-truck"
                    };

                    String currentStatus = orderDetails.get(0).getStatusOrderName();
                    int currentStep = -1;
                    boolean isCanceled = false;
                    boolean isFailed = false;
                    boolean isDelivered = false;
                    boolean isCancellationRequest = false;

                    switch (currentStatus) {
                        case "Pending processing":
                            currentStep = 0;
                            break;
                        case "Processed":
                            currentStep = 1;
                            break;
                        case "Delivered to the carrier":
                            currentStep = 2;
                            break;
                        case "Delivery successful":
                            currentStep = 3;
                            isDelivered = true;
                            break;
                        case "Delivery failed":
                            currentStep = 3;
                            isFailed = true;
                            break;
                        case "Order Cancellation Request":
                            isCancellationRequest = true;
                            break;
                        case "Cancel order":
                            isCanceled = true;
                            break;
                    }
                %>

                <div class="progress-container1">
                    <% if (isCanceled) { %>
                    <div class="progress-step canceled">
                        <i class="fa fa-ban"></i>
                        <p>Order Canceled</p>
                    </div>
                    <% } else if (isCancellationRequest) { %>
                    <div class="progress-step cancellation-request">
                        <i class="fa fa-clock"></i>
                        <p>Cancellation Request Processing</p>
                    </div>
                    <% } else { %>
                    <% for (int i = 0; i < statuses.length; i++) {%>
                    <div class="progress-step <%= (i <= currentStep) ? "completed" : ""%>">
                        <i class="fa <%= icons[i]%>"></i>
                        <p><%= statuses[i]%></p>
                    </div>
                    <% if (i < statuses.length - 1) {%>
                    <div class="progress-arrow <%= (i < currentStep) ? "completed" : ""%>">
                        <i class="fa fa-arrow-right"></i>
                    </div>
                    <% } %>
                    <% }%>

                    <div class="progress-arrow <%= (currentStep >= 3) ? "completed" : ""%>">
                        <i class="fa fa-arrow-right"></i>
                    </div>
                    <div class="progress-step <%= isDelivered ? "completed" : (isFailed ? "failed" : "")%>">
                        <i class="fa fa-box"></i>
                        <p><%= isDelivered ? "Delivery Successful" : "Delivery Failed"%></p>
                    </div>
                    <% }%>
                </div>
            </div>

            <% } else { %>
            <div class="ods-no-data">Không có d? li?u</div>
            <% }%>
        </div>

    </body>
</html>

<style>
    .ods-body {
        font-family: Arial, sans-serif;
        margin: 40px auto;
        max-width: 800px; /* T?ng max-width ?? gi?ng v?i .order-container */
        padding: 20px;
    }

    .ods-order-container {
        max-width: 800px;
        margin: auto;
    }

    .ods-order-title {
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .ods-customer-name {
        text-align: left;
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .ods-product {
        display: flex;
        align-items: center;
        justify-content: space-between; /* Gi?ng v?i .product */
        margin-bottom: 10px;
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
    }

    .ods-product img {
        width: 80px; /* ?i?u ch?nh l?i width gi?ng ph?n trên */
        height: auto;
        border-radius: 5px;
    }

    .ods-product-details {
        flex-grow: 1;
        margin-left: 10px;
    }

    .ods-product-name {
        font-weight: bold;
    }

    .ods-price {
        font-weight: bold;
        color: black;
    }

    .ods-order-info {
        text-align: right; /* Gi?ng v?i .summary */
        margin-top: 20px;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        background-color: #f9f9f9;
    }

    .ods-order-info div {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
    }

    .ods-order-status {
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        margin-top: 20px;
        padding: 10px;
        border-radius: 5px;
        background-color: #e8f5e9;
    }

    .ods-no-data {
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        color: red;
        margin-top: 20px;
    }
    .progress-container1 {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }
    .progress-step {
        display: flex;
        flex-direction: column;
        align-items: center;
        font-size: 14px;
        color: gray;
    }
    .progress-step i {
        font-size: 24px;
        color: gray;
    }
    .progress-step.completed i,
    .progress-step.completed p,
    .progress-arrow.completed i {
        color: green;
    }
    .progress-step.failed i,
    .progress-step.failed p {
        color: red;
    }
    .progress-step.canceled i,
    .progress-step.canceled p {
        color: red;
        font-weight: bold;
    }
    .progress-step.cancellation-request i,
    .progress-step.cancellation-request p {
        color: orange;
        font-weight: bold;
    }
    .progress-arrow {
        font-size: 20px;
        color: gray;
    }

    /* ??m b?o tr?ng thái ch?a thành công/th?t b?i v?n hi?n th? màu xám */
    .progress-step:not(.completed):not(.failed) i,
    .progress-step:not(.completed):not(.failed) p,
    .progress-arrow:not(.completed) i {
        color: gray;
    }

</style>