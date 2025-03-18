<%-- 
    Document   : ViewProductsAdmin
    Created on : Feb 26, 2025, 11:45:51 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Products Admin</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoard.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProductsAd.css"/>
        <style>
            .filter-form {
                display: flex;
                align-items: center;
                gap: 15px;
                background-color: #222;
                padding: 10px 20px;
                border-radius: 8px;
                color: white;
            }
            .filter-form label {
                font-weight: bold;
                color: white;
            }
            .filter-form select {
                padding: 6px 12px;
                border-radius: 5px;
                border: 1px solid #555;
                background-color: #333;
                color: white;
                cursor: pointer;
            }
            .filter-form select:focus {
                outline: none;
                border-color: #f39c12;
            }
            .filter-form button {
                padding: 8px 15px;
                background-color: #f39c12;
                border: none;
                color: black;
                font-weight: bold;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .filter-form button:hover {
                background-color: #e67e22;
            }
        </style>
    </head>
    <body>

        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <div class="body-product row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="container mb-5 col-md-10">
                <%@include file="Admin/HeaderAD.jsp"%>
                <div class="container">
                    <div class="container mb-3" style="margin-top: 20px">
                        <form action="<c:url value='/ManageProduct?action=filter'/>" method="POST" class="filter-form">
                            <label for="typeFilter">Filter by Type:</label>
                            <select name="selectedType" id="typeFilter">
                                <option value="">All Types</option>
                                <c:forEach var="type" items="${listType}">
                                    <option value="${type.typeName}">${type.typeName}</option>
                                </c:forEach>
                            </select>

                            <label for="stockFilter">Filter by Stock:</label>
                            <select name="stockFilter" id="stockFilter">
                                <option value="">All Stock</option>
                                <option value="below5">Variants below 5</option>
                                <option value="below10">Variants below 10</option>
                            </select>
                            <button type="submit">Filter</button>
                        </form>
                    </div>
                    <div id="productContainer">
                        <div class="row row-cols-1 row-cols-md-3 g-4" id="productList">
                            <c:forEach var="product" items="${listProduct}">
                                <c:set var="lowStockCount" value="0" />
                                <c:set var="outOfStockCount" value="0" />

                                <c:if test="${not empty productVariantsMap[product.productID]}">
                                    <c:forEach var="variant" items="${productVariantsMap[product.productID]}">
                                        <c:if test="${variant.stockQuantity <= 5}">
                                            <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                                        </c:if>
                                        <c:if test="${variant.stockQuantity <= 0}">
                                            <c:set var="outOfStockCount" value="${outOfStockCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>

                                <a href="<c:url value="ManageProduct?id=${product.productID}&action=inventory"/>" class="text-decoration-none product-item">
                                    <div class="col mt-3">
                                        <div class="card ${lowStockCount > 5 ? 'border border-danger border-3' : ''}" 
                                             style="${lowStockCount > 5 ? 'border-color: #dc3545 !important;' : ''}">

                                            <c:if test="${not empty product.imgName}">
                                                <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                                <c:set var="firstImg" value="${imgList[0]}" />
                                                <img src="Image/Product/${firstImg}" class="card-img-top" alt="Product Image">
                                            </c:if>
                                            <div class="card-body">
                                                <p class="card-title">${product.productName}</p>
                                                <p class="card-text text-muted">
                                                    <fmt:setLocale value="vi_VN"/>
                                                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> VND
                                                </p>
                                                <p class="fw-bold">
                                                    Is Sale:
                                                    <span class="${product.isSale ? 'text-success' : 'text-danger'}">
                                                        ${product.isSale ? 'Sale' : 'Not For Sale'}
                                                    </span>
                                                </p>
                                                <c:if test="${outOfStockCount <= 5 && not empty productVariantsMap[product.productID]}">
                                                    <div class="d-flex flex-wrap">
                                                        <c:forEach var="variant" items="${productVariantsMap[product.productID]}">
                                                            <c:if test="${variant.stockQuantity <= 5}">
                                                                <div class="border border-danger border-3 rounded p-2 m-1 text-center" 
                                                                     style="width: 100px; border-color: #dc3545 !important;">
                                                                    <div style="width: 20px; height: 20px; border-radius: 50%; background-color: ${variant.colorName}; margin: auto;"></div>
                                                                    <p class="mb-0 small">Size: ${variant.sizeName}</p>
                                                                    <p class="mb-0 small">Qty: ${variant.stockQuantity}</p>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                                <p class="card-text ${lowStockCount > 5 ? 'text-danger fw-bold' : 'text-muted'}">Click To Edit/Restock</p>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="d-flex justify-content-center mt-3" id="paginationControls"></div>
                </div>
                <c:if test="${empty listProduct}">
                    <p class="text-center text-danger mt-3">No products available.</p>
                </c:if>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const itemsPerPage = 12; // Số sản phẩm hiển thị trên mỗi trang
                const productList = document.getElementById("productList");
                const productItems = Array.from(productList.getElementsByClassName("product-item"));
                const paginationControls = document.getElementById("paginationControls");
                let currentPage = 1;

                function showPage(page) {
                    const start = (page - 1) * itemsPerPage;
                    const end = start + itemsPerPage;

                    productItems.forEach((item, index) => {
                        item.style.display = (index >= start && index < end) ? "block" : "none";
                    });

                    updatePaginationControls(page);
                }

                function updatePaginationControls(page) {
                    const totalPages = Math.ceil(productItems.length / itemsPerPage);
                    paginationControls.innerHTML = "";

                    for (let i = 1; i <= totalPages; i++) {
                        const button = document.createElement("button");
                        button.innerText = i;
                        button.className = "btn btn-sm " + (i === page ? "btn-dark text-white" : "btn-outline-dark") + " mx-1";
                        button.onclick = () => showPage(i);
                        paginationControls.appendChild(button);
                    }
                }

                showPage(currentPage);
            });
        </script>

    </body>
</html>
