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

        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3">
                    <form id="filterForm" method="POST" action="<%= request.getContextPath()%>/Product?action=filter">
                        <div class="filter-product">
                            <h2>Filters</h2>

                            <!-- Category Filters -->
                            <c:forEach var="entry" items="${categoryMap}">
                                <h3>${entry.key}</h3>
                                <div class="filter-group">
                                    <c:forEach var="type" items="${entry.value}">
                                        <label>
                                            <input type="checkbox" name="typeFilter" value="${type.typeName}" 
                                                   class="filter-checkbox"
                                                   <c:if test="${not empty selectedTypes and fn:contains(selectedTypes, type.typeName)}">checked</c:if>
                                                   > ${type.typeName}
                                        </label>
                                    </c:forEach>
                                </div>
                            </c:forEach>

                            <!-- Price Filters -->
                            <h3>Price Range</h3>
                            <div class="filter-group">
                                <label><input type="checkbox" name="priceFilter" value="0-200000" class="filter-checkbox"
                                              <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '0-200000')}">checked</c:if>
                                                  > 0đ - 200.000đ</label>

                                    <label><input type="checkbox" name="priceFilter" value="200000-500000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '200000-500000')}">checked</c:if>
                                            > 200.000đ - 500.000đ</label>

                                    <label><input type="checkbox" name="priceFilter" value="500000-1000000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '500000-1000000')}">checked</c:if>
                                            > 500.000đ - 1.000.000đ</label>

                                    <label><input type="checkbox" name="priceFilter" value=">1000000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '>1000000')}">checked</c:if>
                                            > Greater than 1.000.000đ</label>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- DANH SÁCH SẢN PHẨM -->
                    <div class="container mt-5 mb-5 col-md-9">
                        <div class="container-fluid">
                            <form id="sortForm" action="<c:url value='/Product?action=sort'/>" method="POST">
                            <select name="sortBy" id="sortBy">
                                <option value="">Sort by</option>
                                <option value=" ORDER BY p.price ASC">Price: Low to High</option>
                                <option value=" ORDER BY p.price DESC">Price: High to Low</option>
                                <option value=" ORDER BY p.dateCreate DESC">Newest</option>
                                <option value=" ORDER BY p.dateCreate ASC">Oldest</option>
                            </select>
                            <c:forEach var="type" items="${selectedTypes}">
                                <input type="hidden" name="typeFilter" value="${type}" />
                            </c:forEach>
                            <c:forEach var="price" items="${selectedPrices}">
                                <input type="hidden" name="priceFilter" value="${price}" />
                            </c:forEach>
                            <input type="hidden" name="typeDetail" value="${typeDetail}" />
                            <input type="hidden" name="categoryDetail" value="${categoryDetail}" />
                        </form>
                        <nav class="back-homepage" style="text-align: center; font-size: 20px; margin-bottom: 20px;">
                            <a href="/PenguinStore" style="text-decoration: none; color: gray;">Home </a> &gt;
                            <span style="color: gray;"> All Product</span>
                        </nav>
                        <div class="row row-cols-3 justify-content-start" id="productList">
                            <c:forEach var="product" items="${listProduct}">
                                <a href="Product?id=${product.productID}&action=detail">
                                    <div class="card product-item mt-3">
                                        <c:if test="${not empty product.imgName}">
                                            <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                            <c:set var="firstImg" value="${imgList[0]}" />
                                            <img src="Image/Product/${firstImg}" alt="Product Image">
                                        </c:if>
                                        <div class="card-body">
                                            <p class="card-title">${product.productName}</p>
                                            <p class="card-text text-muted">${product.price} VND</p>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <c:if test="${empty listProduct}">
                            <p class="text-center text-danger mt-3">No products available.</p>
                        </c:if>
                    </div>
                </div>
            </div>


        </div>
        <%@include file="Footer.jsp"%>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const checkboxes = document.querySelectorAll(".filter-checkbox");
                const filterForm = document.getElementById("filterForm");

                checkboxes.forEach(checkbox => {
                    checkbox.addEventListener("change", function () {
                        filterForm.submit();
                    });
                });
            });
            document.getElementById("sortBy").addEventListener("change", function () {
                document.getElementById("sortForm").submit();
            });
        </script>

        
    </body>
</html>
