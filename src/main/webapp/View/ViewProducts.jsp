<%-- 
    Document   : ViewProducts
    Created on : Feb 22, 2025, 1:56:41 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Products</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProducts.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <div class="body-product">
            <div class="filter-product">Filter Product</div>
            <div class="container mt-5 mb-5">
                <div class="container">
                    <nav class="back-homepage" style="text-align: center; font-size: 20px; margin-bottom: 20px;">
                        <a href="/PenguinStore/Homepage" style="text-decoration: none; color: gray;">Home </a> &gt;
                        <span style="color: lightgray;"> All Product</span>
                    </nav>
                    <div class="row row-cols-1 row-cols-md-3 g-4">
                        <c:forEach var="product" items="${listProduct}">
                            <a href="Product?id=${product.productID}" class="text-decoration-none">
                                <div class="col mt-3">
                                    <div class="card product-item">
                                        <c:if test="${not empty product.imgName}">
                                            <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                            <c:set var="firstImg" value="${imgList[0]}" />
                                            <img src="Image/Product/${firstImg}" class="card-img-top" alt="Product Image">
                                        </c:if>
                                        <div class="card-body">
                                            <p class="card-title">${product.productName}</p>
                                            <p class="card-text text-muted">$${product.price}</p>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
                <c:if test="${empty listProduct}">
                    <p class="text-center text-danger mt-3">No products available.</p>
                </c:if>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
    </body>
</html>