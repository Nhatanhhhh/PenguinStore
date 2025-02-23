<%-- 
    Document   : ProductDetail
    Created on : Feb 22, 2025, 6:35:04 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ProductDetail</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="Assets/CSS/Guest/styles.css"/>
        <link rel="stylesheet" href="Assets/CSS/Guest/styleViewProductDetail.css"/>
    </head>
    <body>
        <%@include file="/View/Homepage/Header.jsp"%>
        <c:choose>
            <c:when test="${not empty productDetail and not empty productDetail[0].proVariantID}">
                <div class="product-container">
                    <div class="product-gallery">
                        <c:if test="${not empty product.imgName}">
                            <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                            <c:forEach var="img" items="${imgList}">
                                <img src="Image/Product/${img}" alt="Product Image" width="300">
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty product.imgName}">
                            <img src="image/Product/notimage.png" alt="No Image Available" width="300">
                        </c:if>
                    </div>

                    <div class="product-info">
                        <h1>${product.productName}</h1>
                        <p><strong>Description:</strong> ${product.description}</p>
                        <p class="price">$${product.price}</p>
                        <p><strong>Type:</strong> ${product.typeName}</p>
                        <p><strong>Category:</strong> ${product.categoryName}</p>

                        <c:set var="uniqueSizes" value="" />
                        <c:set var="uniqueColors" value="" />

                        <c:if test="${not empty productDetail}">
                            <c:set var="hasSize" value="false"/>
                            <c:set var="sizeSet" value="<%= new java.util.TreeSet<String>() %>" scope="request"/>

                            <c:forEach var="variant" items="${productDetail}">
                                <c:if test="${not empty variant.sizeName}">
                                    <c:set var="hasSize" value="true"/>
                                    <% ((java.util.TreeSet<String>) request.getAttribute("sizeSet")).add(pageContext.getAttribute("variant").getClass().getMethod("getSizeName").invoke(pageContext.getAttribute("variant")).toString()); %>
                                </c:if>
                            </c:forEach>

                            <c:if test="${hasSize}">
                                <div class="options">
                                    <label><strong>Size:</strong></label>
                                    <div class="size-options">
                                        <c:forEach var="size" items="${sizeSet}">
                                            <button class="size-btn">${size}</button>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </c:if>


                        <div class="options">
                            <label><strong>Color:</strong></label>
                            <div class="color-options">
                                <c:forEach var="variant" items="${productDetail}">
                                    <c:if test="${not fn:contains(uniqueColors, variant.colorName)}">
                                        <c:set var="uniqueColors" value="${uniqueColors},${variant.colorName}" />
                                        <span class="color-circle" style="background-color: ${variant.colorName};"></span>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="cart-container">
                            <div class="quantity">
                                <button type="button" onclick="decreaseQuantity()">-</button>
                                <input type="text" name="quantity" value="1" id="quantity">
                                <button type="button" onclick="increaseQuantity()">+</button>
                            </div>

                            <form action="AddToCartServlet" method="post">
                                <input type="hidden" name="variantId" id="selectedVariantId" value="${productDetail[0].proVariantID}">
                                <button type="submit" class="add-to-cart">Add to cart</button>
                            </form>
                        </div>

                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <p style="text-align: center; font-size: 18px; font-weight: bold; color: red;">Product not found</p>
            </c:otherwise>
        </c:choose>
        <%@include file="/View/Homepage/Footer.jsp"%>
    </body>

</html>
