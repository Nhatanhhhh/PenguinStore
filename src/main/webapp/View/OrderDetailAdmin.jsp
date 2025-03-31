<%-- 
    Document   : OrderDetailStaff
    Created on : Mar 8, 2025, 11:25:57 AM
    Author     : Le Minh Loc CE180992
--%>
<%@page import="Models.Manager"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="DTO.OrderDetailDTO" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Order Detail | Penguin Fashion</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styles.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <style>
            .order-detail-container {
                background-color: #fff;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                margin: 20px auto;
                max-width: 900px;
            }

            .order-header {
                border-bottom: 1px solid #eee;
                padding-bottom: 1rem;
                margin-bottom: 1.5rem;
            }

            .order-title {
                font-size: 1.8rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .order-id {
                color: #4361ee;
                font-weight: 700;
            }

            .customer-info {
                background-color: #f8f9fa;
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
            }

            .customer-name {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .product-card {
                display: flex;
                align-items: center;
                padding: 1rem;
                border-bottom: 1px solid #eee;
                transition: all 0.2s ease;
            }

            .product-card:hover {
                background-color: #f8f9fa;
            }

            .product-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
                margin-right: 1rem;
            }

            .product-details {
                flex: 1;
            }

            .product-name {
                font-weight: 600;
                margin-bottom: 0.3rem;
            }

            .product-attributes {
                display: flex;
                gap: 1rem;
                color: #666;
                font-size: 0.9rem;
            }

            .product-price {
                font-weight: 600;
                color: #333;
                min-width: 120px;
                text-align: right;
            }

            .order-summary {
                background-color: #f8f9fa;
                padding: 1.5rem;
                border-radius: 8px;
                margin-top: 1.5rem;
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
            }

            .status-container {
                margin-top: 2rem;
                padding: 1.5rem;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .status-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: #333;
            }

            .status-message {
                padding: 1rem;
                border-left: 4px solid #4361ee;
                margin-bottom: 1.5rem;
                background-color: #f8f9fa;
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
                background-color: #4361ee;
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
            }

            .step-label {
                font-size: 0.85rem;
                font-weight: 500;
                color: #666;
                text-align: center;
                max-width: 100px;
            }

            .completed .step-icon {
                background-color: #4361ee;
                color: white;
            }

            .completed .step-label {
                color: #4361ee;
                font-weight: 600;
            }

            .current .step-icon {
                background-color: #f8961e;
                color: white;
            }

            .current .step-label {
                color: #f8961e;
                font-weight: 600;
            }

            .failed .step-icon,
            .canceled .step-icon {
                background-color: #f94144;
                color: white;
            }

            .failed .step-label,
            .canceled .step-label {
                color: #f94144;
                font-weight: 600;
            }

            .cancellation-request .step-icon {
                background-color: #f8961e;
                color: white;
            }

            .cancellation-request .step-label {
                color: #f8961e;
                font-weight: 600;
            }

            .no-data {
                text-align: center;
                padding: 3rem;
                color: #666;
            }

            @media (max-width: 768px) {
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
    <body>
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-2 p-0">
                    <%@include file="Admin/NavigationMenu.jsp" %>
                </div>
                <div class="col-md-10 p-0">
                    <%@include file="Admin/HeaderAD.jsp" %>

                    <div class="order-detail-container">
                        <%
                            List<OrderDetailDTO> orderDetails = (List<OrderDetailDTO>) request.getAttribute("orderDetails");
                            if (orderDetails != null && !orderDetails.isEmpty()) {
                                OrderDetailDTO firstDetail = orderDetails.get(0);
                                String orderID = request.getParameter("orderID");
                        %>

                        <div class="order-header">
                            <h1 class="order-title">Order Details <span class="order-id">#<%= (orderID != null && orderID.length() >= 4) ? orderID.substring(0, 8).toUpperCase() : "N/A"%></span></h1>
                            <div class="d-flex align-items-center text-muted">
                                <i class="bi bi-calendar me-2"></i>
                                <%
                                    String orderDateStr = firstDetail.getDateOrder();
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
                                <span><%= formattedDate%></span>
                            </div>
                        </div>

                        <div class="customer-info">
                            <h3 class="customer-name"><i class="bi bi-person me-2"></i><%= firstDetail.getFullName()%></h3>
                            <div class="d-flex flex-wrap gap-4 text-muted">
                                <div><i class="bi bi-envelope me-2"></i> <%= firstDetail.getEmail()%></div>
                                <div><i class="bi bi-telephone me-2"></i> <%= firstDetail.getPhoneNumber()%></div>
                            </div>
                        </div>

                        <h4 class="mb-3">Order Items</h4>
                        <% for (OrderDetailDTO detail : orderDetails) {%>
                        <div class="product-card">
                            <img src="<%= request.getContextPath()%>/Image/Product/<%= detail.getImgName()%>" 
                                 alt="<%= detail.getProductName()%>" class="product-image">
                            <div class="product-details">
                                <h5 class="product-name"><%= detail.getProductName()%></h5>
                                <div class="product-attributes">
                                    <span><i class="bi bi-palette me-1"></i> <%= detail.getColorName()%></span>
                                    <span><i class="bi bi-rulers me-1"></i> <%= detail.getSizeName()%></span>
                                    <span><i class="bi bi-box-seam me-1"></i> Qty: <%= detail.getQuantity()%></span>
                                </div>
                            </div>
                            <div class="product-price">
                                <fmt:formatNumber value="<%= detail.getUnitPrice() * detail.getQuantity()%>" pattern="#,###" /> ₫
                            </div>
                        </div>
                        <% }%>

                        <div class="order-summary">
                            <div class="summary-row">
                                <span>Subtotal:</span>
                                <span><fmt:formatNumber value="<%= firstDetail.getTotalAmount()%>" pattern="#,###" /> ₫</span>
                            </div>
                            <div class="summary-row">
                                <span>Discount:</span>
                                <span>-<fmt:formatNumber value="<%= firstDetail.getDiscountAmount()%>" pattern="#,###" /> ₫</span>
                            </div>
                            <div class="summary-row">
                                <span>Total:</span>
                                <span><strong><fmt:formatNumber value="<%= firstDetail.getFinalAmount()%>" pattern="#,###" /> ₫</strong></span>
                            </div>
                        </div>

                        <div class="status-container">
                            <h4 class="status-title">Order Status</h4>

                            <%
                                String statusOrder = firstDetail.getStatusOrderName();
                                String statusMessage = "";
                                String alertClass = "alert-info";

                                switch (statusOrder) {
                                    case "Pending processing":
                                        statusMessage = "This order is waiting to be processed.";
                                        alertClass = "alert-info";
                                        break;
                                    case "Processed":
                                        statusMessage = "This order has been processed and is waiting for the shipping unit.";
                                        alertClass = "alert-primary";
                                        break;
                                    case "Order Cancellation Request":
                                        statusMessage = "The customer has requested to cancel this order. Please review the request.";
                                        alertClass = "alert-warning";
                                        break;
                                    case "Cancel order":
                                        statusMessage = "This order has been successfully canceled.";
                                        alertClass = "alert-danger";
                                        break;
                                    case "Delivered to the carrier":
                                        statusMessage = "The order has been handed over to the shipping unit.";
                                        alertClass = "alert-primary";
                                        break;
                                    case "Delivery failed":
                                        statusMessage = "The delivery was unsuccessful. Please check and take appropriate action.";
                                        alertClass = "alert-danger";
                                        break;
                                    case "Delivery successful":
                                        statusMessage = "The order has been successfully delivered to the customer.";
                                        alertClass = "alert-success";
                                        break;
                                    default:
                                        statusMessage = "Unknown order status.";
                                }
                            %>

                            <div class="alert <%= alertClass%> status-message">
                                <h5 class="alert-heading"><%= statusOrder%></h5>
                                <p class="mb-0"><%= statusMessage%></p>
                            </div>

                            <%
                                String[] statusSteps = {
                                    "Order Placed",
                                    "Processing",
                                    "Shipped",
                                    "Delivered"
                                };

                                String[] stepIcons = {
                                    "bi-cart",
                                    "bi-gear",
                                    "bi-truck",
                                    "bi-check-circle"
                                };

                                int currentStep = 0;
                                boolean isCancelled = false;
                                boolean isFailed = false;
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
                                        break;
                                    case "Delivery failed":
                                        isFailed = true;
                                        currentStep = 2;
                                        break;
                                    case "Order Cancellation Request":
                                        isCancellationRequest = true;
                                        break;
                                    case "Cancel order":
                                        isCancelled = true;
                                        break;
                                }
                            %>

                            <div class="progress-tracker">
                                <div class="progress-line"></div>
                                <div class="progress-completed" style="width: <%= isCancelled || isFailed ? "100%" : (currentStep * 33.33) + "%"%>"></div>

                                <% if (isCancelled) { %>
                                <div class="progress-step canceled">
                                    <div class="step-icon">
                                        <i class="bi bi-x-circle"></i>
                                    </div>
                                    <span class="step-label">Order Cancelled</span>
                                </div>
                                <% } else if (isCancellationRequest) { %>
                                <div class="progress-step cancellation-request">
                                    <div class="step-icon">
                                        <i class="bi bi-exclamation-triangle"></i>
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
                                        <i class="bi <%= stepIcons[i]%>"></i>
                                    </div>
                                    <span class="step-label"><%= statusSteps[i]%></span>
                                </div>
                                <% }
                                    } %>
                            </div>
                        </div>

                        <% } else { %>
                        <div class="no-data">
                            <i class="bi bi-exclamation-circle" style="font-size: 3rem; color: #6c757d;"></i>
                            <h3 class="mt-3">No Order Data Found</h3>
                            <p class="text-muted">We couldn't find any details for this order.</p>
                        </div>
                        <% }%>
                    </div>

                </div>
            </div>
        </div>
        <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
    </body>
</html>