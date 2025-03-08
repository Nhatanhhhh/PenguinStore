<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Navigation Menu</title>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/navigation.css"/>
    </head>
    <body>
        <div class="sidebar">
            <h2>Manage</h2>
            <ul>
                <li>Type
                    <ul class="dropdown">
                        <li><a href="<c:url value='/Type?action=list'/>">View Types</a></li>
                        <li><a href="<c:url value='/Type?action=create'/>">Create Type</a></li>
                    </ul>
                </li>
                <li>Product
                    <ul class="dropdown">
                        <li><a href="<c:url value='/ManageProduct?action=view'/>">View Products</a></li>
                        <li><a href="<c:url value='/ManageProduct?action=create'/>">Create Product</a></li>
                    </ul>
                </li>
                <li>Staff
                    <ul class="dropdown">
                        <li><a href="<c:url value='/Staff?action=list'/>">View Staffs</a></li>
                        <li><a href="<c:url value='/Staff?action=create'/>">Create Account Staff</a></li>
                    </ul>
                </li>
                <li>Order
                    <ul class="dropdown">
                        <li><a href="#">View Orders</a></li>
                    </ul>
                </li>
                <li>Voucher
                    <ul class="dropdown">
                        <li><a href="<c:url value='/Voucher?action=view'/>">View Vouchers</a></li>
                        <li><a href="<c:url value='/Voucher?action=create'/>">Create Vouchers</a></li>
                    </ul>
                </li>
                <li>Feedback
                    <ul class="dropdown">
                        <li><a href="#">View Feedbacks</a></li>
                    </ul>
                </li>
                <li>Customer
                    <ul class="dropdown">
                         <li><a href="<c:url value='/Customer?action=list'/>">View Customer</a></li>
                    </ul>
                </li>
                
                
            </ul>

            <h2>Statistic</h2>
            <ul>
                <li><a href="#">Revenue</a></li>
                <li><a href="<c:url value='/Restock?action=restockHistory'/>">Restock History</a></li>
                <li><a href="#">Profit</a></li>
                <li><a href="#">Product</a></li>
            </ul>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </body>
</html>