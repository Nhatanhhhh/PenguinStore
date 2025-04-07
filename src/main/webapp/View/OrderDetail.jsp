<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="java.util.List, DTO.OrderDetailDTO" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<OrderDetailDTO> orderDetails = (List<OrderDetailDTO>) request.getAttribute("orderDetails");
    String orderID = (String) request.getAttribute("orderID");
%>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Detail</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/odt.css"/>
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
                --success-color: #28a745;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
            }

            body {
                background-color: #f5f5f5;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: #333;
            }

            .order-detail-container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 2rem;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            }

            .order-header {
                text-align: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #eee;
            }

            .order-header h2 {
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 0.5rem;
            }

            .order-id {
                color: var(--secondary-color);
                font-weight: 600;
                background-color: #f0f8ff;
                padding: 0.3rem 0.8rem;
                border-radius: 20px;
                display: inline-block;
            }

            .product-list {
                margin-bottom: 2rem;
            }

            .product-card {
                display: flex;
                align-items: center;
                padding: 1.5rem;
                margin-bottom: 1rem;
                border-radius: 8px;
                background-color: white;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                transition: all 0.2s ease;
            }

            .product-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .product-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 1.5rem;
                border: 1px solid #eee;
            }

            .product-details {
                flex: 1;
            }

            .product-name {
                font-weight: 600;
                font-size: 1.1rem;
                margin-bottom: 0.5rem;
                color: var(--primary-color);
            }

            .product-attributes {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }

            .product-attributes span {
                display: flex;
                align-items: center;
            }

            .product-attributes i {
                margin-right: 0.3rem;
                color: var(--secondary-color);
            }

            .product-price {
                font-weight: 600;
                color: var(--primary-color);
                min-width: 120px;
                text-align: right;
                font-size: 1.1rem;
            }

            .order-summary {
                background-color: var(--light-gray);
                padding: 1.5rem;
                border-radius: 8px;
                margin-bottom: 2rem;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                padding: 0.5rem 0;
                border-bottom: 1px dashed #ddd;
            }

            .summary-row:last-child {
                border-bottom: none;
                font-weight: 700;
                font-size: 1.1rem;
                margin-top: 0.5rem;
                padding-top: 0.5rem;
                border-top: 1px solid #ddd;
            }

            .status-container {
                background-color: white;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
            }

            .status-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--primary-color);
                display: flex;
                align-items: center;
            }

            .status-title i {
                margin-right: 0.5rem;
                color: var(--secondary-color);
            }

            .status-message {
                padding: 1rem;
                border-left: 4px solid var(--secondary-color);
                background-color: #f8f9fa;
                margin-bottom: 1.5rem;
                border-radius: 0 4px 4px 0;
            }

            .review-link {
                color: var(--secondary-color);
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
            }

            .review-link:hover {
                color: var(--primary-color);
                text-decoration: underline;
            }

            .progress-tracker {
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: relative;
                margin: 2rem 0;
            }

            .progress-line {
                position: absolute;
                height: 3px;
                background-color: #e9ecef;
                top: 20px;
                left: 0;
                right: 0;
                z-index: 1;
            }

            .progress-completed {
                position: absolute;
                height: 3px;
                background-color: var(--success-color);
                top: 20px;
                left: 0;
                z-index: 2;
                transition: width 0.5s ease;
            }

            .progress-step {
                display: flex;
                flex-direction: column;
                align-items: center;
                z-index: 3;
            }

            .step-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 0.5rem;
                background-color: #e9ecef;
                color: #666;
                font-size: 1.2rem;
            }

            .step-label {
                font-size: 0.85rem;
                font-weight: 500;
                color: #666;
                text-align: center;
                max-width: 100px;
            }

            .completed .step-icon {
                background-color: var(--success-color);
                color: white;
            }

            .completed .step-label {
                color: var(--success-color);
                font-weight: 600;
            }

            .current .step-icon {
                background-color: var(--warning-color);
                color: white;
            }

            .current .step-label {
                color: var(--warning-color);
                font-weight: 600;
            }

            .failed .step-icon,
            .canceled .step-icon {
                background-color: var(--danger-color);
                color: white;
            }

            .failed .step-label,
            .canceled .step-label {
                color: var(--danger-color);
                font-weight: 600;
            }

            .cancellation-request .step-icon {
                background-color: var(--warning-color);
                color: white;
            }

            .cancellation-request .step-label {
                color: var(--warning-color);
                font-weight: 600;
            }

            .promo-section {
                background-color: #f9fafb;
                padding: 3rem 0;
                margin-top: 3rem;
            }

            .promo-content {
                display: flex;
                align-items: center;
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 2rem;
            }

            .promo-image {
                flex: 1;
                text-align: center;
            }

            .promo-image img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .promo-text {
                flex: 1;
                padding-left: 3rem;
            }

            .promo-text h2 {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 1.5rem;
            }

            .promo-btn {
                display: inline-block;
                padding: 0.8rem 2rem;
                background-color: var(--primary-color);
                color: white;
                border-radius: 30px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s;
                margin-top: 1.5rem;
            }

            .promo-btn:hover {
                background-color: #1a252f;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            @media (max-width: 768px) {
                .order-detail-container {
                    padding: 1rem;
                }

                .product-card {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .product-image {
                    margin-right: 0;
                    margin-bottom: 1rem;
                }

                .product-price {
                    text-align: left;
                    margin-top: 1rem;
                    width: 100%;
                }

                .promo-content {
                    flex-direction: column;
                }

                .promo-text {
                    padding-left: 0;
                    padding-top: 2rem;
                    text-align: center;
                }

                .progress-tracker {
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 1rem;
                }

                .progress-line, .progress-completed {
                    display: none;
                }
            }
        </style>
    </head>

    <body style="margin: 0;">
        <%@include file="Header.jsp"%>

        <div class="order-detail-container">
            <div class="order-header">
                <h2>Order Details</h2>
                <span class="order-id">Order #<%= (orderID.length() >= 8) ? orderID.substring(0, 8).toUpperCase() : orderID.toUpperCase()%></span>
            </div>

            <div class="product-list">
                <% for (OrderDetailDTO detail : orderDetails) {%>
                <div class="product-card">
                    <img src="<%= request.getContextPath()%>/Image/Product/<%= detail.getImgName()%>" 
                         alt="<%= detail.getProductName()%>" class="product-image">
                    <div class="product-details">
                        <h3 class="product-name"><%= detail.getProductName()%></h3>
                        <div class="product-attributes">
                            <% if (detail.getColorName() != null && !detail.getColorName().isEmpty()) {%>
                            <span><i class="fas fa-palette"></i> <%= detail.getColorName()%></span>
                            <% } %>

                            <% if (detail.getSizeName() != null && !detail.getSizeName().isEmpty()) {%>
                            <span><i class="fas fa-ruler-combined"></i> <%= detail.getSizeName()%></span>
                            <% }%>

                            <span><i class="fas fa-box-open"></i> Quantity: <%= detail.getQuantity()%></span>

                            <span><i class="fas fa-tag"></i> Unit Price: <fmt:formatNumber value="<%= detail.getUnitPrice()%>" pattern="#,###" /> ₫</span>
                        </div>
                    </div>
                    <div class="product-price">
                        <fmt:formatNumber value="<%= detail.getUnitPrice() * detail.getQuantity()%>" pattern="#,###" /> ₫
                    </div> 
                </div>
                <% }%>
            </div>

            <%
                // Lấy ngày từ OrderDetailDTO (chuỗi String)
                String orderDateStr = orderDetails.get(0).getDateOrder();

                // Chuyển đổi String thành Date
                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
                SimpleDateFormat outputFormat = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
                Date orderDate = null;
                String formattedDate = "N/A";

                try {
                    if (orderDateStr != null && !orderDateStr.isEmpty()) {
                        orderDate = inputFormat.parse(orderDateStr);
                        formattedDate = outputFormat.format(orderDate);
                    }
                } catch (Exception e) {
                    formattedDate = "Invalid Date";
                }
            %>

            <div class="order-summary">
                <div class="summary-row">
                    <span>Order Date:</span>
                    <span><strong><%= formattedDate%></strong></span>
                </div>
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span><strong><fmt:formatNumber value="<%= orderDetails.get(0).getTotalAmount()%>" pattern="#,###" /> ₫</strong></span>
                </div>
                <div class="summary-row">
                    <span>Discount:</span>
                    <span><strong>-<fmt:formatNumber value="<%= orderDetails.get(0).getDiscountAmount()%>" pattern="#,###" /> ₫</strong></span>
                </div>
                <div class="summary-row">
                    <span>Total:</span>
                    <span><strong><fmt:formatNumber value="<%= orderDetails.get(0).getFinalAmount()%>" pattern="#,###" /> ₫</strong></span>
                </div>
            </div>

            <div class="status-container">
                <h3 class="status-title"><i class="fas fa-info-circle"></i> Order Status</h3>

                <div class="status-message">
                    <%
                        String statusOrder = orderDetails.get(0).getStatusOrderName();
                        String statusMessage = "";
                        String iconClass = "fas fa-info-circle";

                        switch (statusOrder) {
                            case "Pending processing":
                                statusMessage = "Your order is being processed by the store";
                                iconClass = "fas fa-clock";
                                break;
                            case "Processed":
                                statusMessage = "Your order has been successfully processed, waiting for the shipping unit";
                                iconClass = "fas fa-check-circle";
                                break;
                            case "Order Cancellation Request":
                                statusMessage = "Your cancellation request is being processed";
                                iconClass = "fas fa-exclamation-circle";
                                break;
                            case "Cancel order":
                                statusMessage = "Order cancellation request successful";
                                iconClass = "fas fa-ban";
                                break;
                            case "Delivered to the carrier":
                                statusMessage = "Your order has been handed over to the shipping unit";
                                iconClass = "fas fa-truck";
                                break;
                            case "Delivery failed":
                                statusMessage = "Your order has not been successfully delivered";
                                iconClass = "fas fa-times-circle";
                                break;
                            case "Delivery successful":
                                statusMessage = "Your order has been successfully delivered. If satisfied, please ";
                                iconClass = "fas fa-check-circle";
                                break;
                            default:
                                statusMessage = "Unknown order status";
                        }
                    %>
                    <i class="<%= iconClass%>" style="margin-right: 0.5rem;"></i>
                    <strong><%= statusOrder%>:</strong> <%= statusMessage%>

                    <% if ("Delivery successful".equals(statusOrder)) {%>
                    <a href="<%= request.getContextPath()%>/Feedback?orderID=<%= orderID%>" class="review-link">write a review</a>
                    <% }%>
                </div>

                <div class="progress-tracker">
                    <%
                        String[] statusSteps = {
                            "Order Placed",
                            "Processing",
                            "Shipped",
                            "Delivered"
                        };

                        String[] stepIcons = {
                            "fas fa-shopping-cart",
                            "fas fa-cog",
                            "fas fa-truck",
                            "fas fa-check-circle"
                        };

                        int currentStep = -1;
                        boolean isCanceled = false;
                        boolean isFailed = false;
                        boolean isDelivered = false;
                        boolean isCancellationRequest = false;

                        switch (statusOrder) {
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

                    <div class="progress-line"></div>
                    <div class="progress-completed" style="width: <%= isCanceled || isFailed ? "100%" : (currentStep * 33.33) + "%"%>"></div>

                    <% if (isCanceled) { %>
                    <div class="progress-step canceled">
                        <div class="step-icon">
                            <i class="fas fa-ban"></i>
                        </div>
                        <span class="step-label">Order Cancelled</span>
                    </div>
                    <% } else if (isCancellationRequest) { %>
                    <div class="progress-step cancellation-request">
                        <div class="step-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <span class="step-label">Cancellation Requested</span>
                    </div>
                    <% } else {
                        for (int i = 0; i < statusSteps.length; i++) {
                            String stepClass = "";
                            if (i < currentStep) {
                                stepClass = "completed";
                            } else if (i == currentStep) {
                                stepClass = "current";
                            }

                            if (isFailed && i == statusSteps.length - 1) {
                                stepClass = "failed";
                            }
                    %>
                    <div class="progress-step <%= stepClass%>">
                        <div class="step-icon">
                            <i class="<%= stepIcons[i]%>"></i>
                        </div>
                        <span class="step-label"><%= statusSteps[i]%></span>
                    </div>
                    <% }
                    }%>
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