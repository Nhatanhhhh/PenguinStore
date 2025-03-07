<%@page import="Models.Manager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Navigation</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/bootstrap.css">
    </head>
    <body>
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion" style="min-height: 100vh;">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Main</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/ListFeedbackForStaff">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                        Dashboard
                    </a>
                    <a class="nav-link" href="order-management.jsp">
                        <div class="sb-nav-link-icon"><i class="fas fa-shopping-cart"></i></div>
                        Order Management
                    </a>
                    <a class="nav-link" href="ListFeedbackForStaff">
                        <div class="sb-nav-link-icon"><i class="fas fa-comment-dots"></i></div>
                        Feedback
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                <strong><%= (manager != null) ? manager.getFullName() : "Anonymous"%></strong>
            </div>
        </nav>
    </body>
</html>
