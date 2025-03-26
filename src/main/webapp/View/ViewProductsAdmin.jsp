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
            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
            }

            .page-btn {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                border: none;
                background-color: #343a40; /* Màu tối */
                color: white;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s, color 0.3s;
            }

            .page-btn:hover {
                background-color: #495057;
                color: white;
            }

            .page-btn.active {
                background-color: #f8f9fa;
                color: #343a40;
                font-weight: bold;
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
                    <table id="productTable" class="table table-bordered text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Image</th>
                                <th>Product Name</th>
                                <th>Price</th>
                                <th>Variants</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${listProduct}">
                                <c:set var="lowStockCount" value="0" />
                                <c:set var="outOfStockCount" value="0" />
                                <c:if test="${not empty productVariantsMap[product.productID]}">
                                    <c:forEach var="variant" items="${productVariantsMap[product.productID]}">
                                        <c:if test="${variant.stockQuantity <= 10}">
                                            <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                                        </c:if>
                                        <c:if test="${variant.stockQuantity <= 5}">
                                            <c:set var="outOfStockCount" value="${outOfStockCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>

                                <tr>
                                    <td>
                                        <c:if test="${not empty product.imgName}">
                                            <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                            <c:set var="firstImg" value="${imgList[0]}" />
                                            <img src="Image/Product/${firstImg}" class="img-thumbnail" style="width: 50px; height: 50px;" alt="Product Image">
                                        </c:if>
                                    </td>
                                    <td>${product.productName}</td>
                                    <td>
                                        <fmt:setLocale value="vi_VN"/>
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> VND
                                    </td>
                                    <td>
                                        <div class="d-flex flex-wrap justify-content-center">
                                            <c:choose>
                                                <c:when test="${outOfStockCount > 3}">
                                                    <p class="text-danger fw-bold">Restock Warning</p>
                                                </c:when>
                                                <c:when test="${lowStockCount > 3}">
                                                    <p class="text-warning fw-bold">Restock Warning</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-success fw-bold">Stock is Stable</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="${product.isSale ? 'text-success' : 'text-danger'}">
                                            ${product.isSale ? 'Sale' : 'Not For Sale'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<c:url value="ManageProduct?id=${product.productID}&action=edit"/>" class="btn btn-primary btn-sm" style="font-size: 12px;"><i class="fa-solid fa-pen-to-square"></i> Edit</a>
                                        <a href="<c:url value="ManageProduct?id=${product.productID}&action=inventory"/>" class="btn btn-warning btn-sm" style="font-size: 12px;">Inventory</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div id="paginationControls" class="d-flex justify-content-center mt-3"></div>

                </div>
                <c:if test="${empty listProduct}">
                    <p class="text-center text-danger mt-3">No products available.</p>
                </c:if>
            </div>
        </div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let table = document.getElementById("productTable");
                let tbody = table.getElementsByTagName("tbody")[0];
                let rows = tbody.getElementsByTagName("tr");
                let rowsPerPage = 10;
                let currentPage = 1;

                function displayTablePage(page) {
                    let start = (page - 1) * rowsPerPage;
                    let end = start + rowsPerPage;

                    for (let i = 0; i < rows.length; i++) {
                        rows[i].style.display = i >= start && i < end ? "" : "none";
                    }
                }

                function setupPagination() {
                    let paginationControls = document.getElementById("paginationControls");
                    paginationControls.innerHTML = "";

                    let totalPages = Math.ceil(rows.length / rowsPerPage);
                    if (totalPages <= 1)
                        return;

                    let pageInfo = document.createElement("div");
                    pageInfo.className = "pagination-container";

                    for (let i = 1; i <= totalPages; i++) {
                        let pageButton = document.createElement("button");
                        pageButton.innerText = i;
                        pageButton.className = "page-btn";
                        if (i === currentPage) {
                            pageButton.classList.add("active"); // Đánh dấu trang hiện tại
                        }
                        pageButton.addEventListener("click", function () {
                            currentPage = i;
                            updatePagination();
                        });
                        pageInfo.appendChild(pageButton);
                    }

                    paginationControls.appendChild(pageInfo);
                }

                function updatePagination() {
                    displayTablePage(currentPage);
                    setupPagination();
                }

                updatePagination();
            });
        </script>
    </body>
</html>