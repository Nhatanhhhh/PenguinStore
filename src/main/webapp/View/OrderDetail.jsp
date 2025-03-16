<%@ page import="java.util.List, DTO.OrderDetailDTO" %>
<%
    List<OrderDetailDTO> orderDetails = (List<OrderDetailDTO>) request.getAttribute("orderDetails");
    String orderID = (String) request.getAttribute("orderID");
%>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Detail</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/odt.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h2 style="font-weight: bold; text-align: center;">Order Details - Order ID: <%= (orderID.length() >= 4) ? orderID.substring(0, 4) : orderID%></h2>
        <div class="order-container">
            <% for (OrderDetailDTO detail : orderDetails) {%>
            <div class="product">
                <img src="<%= request.getContextPath()%>/Image/Product/<%= detail.getImgName()%>" width="100" height="100" />
                <div class="product-details">
                    <strong><%= detail.getProductName()%></strong><br>
                    Color: <%= detail.getColorName()%><br>
                    Quantity: <%= detail.getQuantity()%>
                </div>
                <div class="price">$<%= detail.getUnitPrice()%></div>
            </div>
            <% }%>

            <div class="summary">
                <p>Order date: <strong><%= orderDetails.get(0).getDateOrder()%></strong></p>
                <p>Subtotal: <strong>$<%= orderDetails.get(0).getTotalAmount()%></strong></p>
                <p>Voucher Discount: <strong>$<%= orderDetails.get(0).getDiscountAmount()%></strong></p>
                <p>Total: <strong>$<%= orderDetails.get(0).getFinalAmount()%></strong></p>
            </div>

            <div class="progress-container">
                <h3>Order status: <%= orderDetails.get(0).getStatusOrderName()%></h3>

                <p>
                    <%
                        String statusOrder = orderDetails.get(0).getStatusOrderName();
                        String statusMessage = "";

                        switch (statusOrder) {
                            case "Pending processing":
                                statusMessage = "Your order is being processed by the store";
                                break;
                            case "Processed":
                                statusMessage = "Your order has been successfully processed, waiting for the shipping unit";
                                break;
                            case "Order Cancellation Request":
                                statusMessage = "Your cancellation request is being processed";
                                break;
                            case "Cancel order":
                                statusMessage = "Order cancellation request successful";
                                break;
                            case "Delivered to the carrier":
                                statusMessage = "Your order has been handed over to the shipping unit";
                                break;
                            case "Delivery failed":
                                statusMessage = "Your order has not been successfully delivered";
                                break;
                            case "Delivery successful":
                                statusMessage = "Your order has been successfully delivered.If satisfied, please ";
                                break;
                            default:
                                statusMessage = "Unknown order status";
                        }
                    %>
                    <%= statusMessage%>

                    <% if ("Delivery successful".equals(statusOrder)) {%>
                    <a href="<%= request.getContextPath()%>/ControllerFeedback?orderID=<%= orderID%>" class="review-link">Write a review</a>
                    <% }%>

                </p>

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

        </div>
        <div style="background-color: #F9FAFB;  padding: 40px 0px;">
            <div class="row">
                <div class="col-md-6 d-flex justify-content-center">
                    <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
                </div>
                <div class="col-md-6">
                    <div style="width: 300px; height: 80px; margin-top: 40px;">
                        <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                        <div style="margin-left: 50px; margin-top: 50px;">
                            <a href="#" class="button button-dark">New Products</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
<style>
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