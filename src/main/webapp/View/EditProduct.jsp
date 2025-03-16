<%-- 
    Document   : EditProduct
    Created on : Mar 3, 2025, 8:00:24 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Product</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
    </head>
    <body>
        <%@include file="Admin/HeaderAD.jsp"%>
        <div class="row">
            <div class="col-md-3">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="container col-md-9">
               
            </div>
        </div>
    </body>
</html>