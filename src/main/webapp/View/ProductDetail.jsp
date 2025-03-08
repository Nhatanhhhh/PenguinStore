<%-- 
    Document   : ProductDetail
    Created on : Feb 22, 2025, 6:35:04 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Detail</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProductDetail.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <c:choose>
            <c:when test="${not empty productDetail and not empty productDetail[0].proVariantID}">
                <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                <div class="product-container">
                    <div class="product-images">
                        <div class="thumbnail-container">
                            <c:forEach var="img" items="${imgList}">
                                <img src="Image/Product/${fn:replace(img, ' ', '')}" alt="Thumbnail">
                            </c:forEach>
                        </div>
                        <img src="Image/Product/${imgList[0]}" class="product-main-img" alt="Product Image">
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
                            <c:set var="sizeSet" value="<%= new java.util.TreeSet<String>()%>" scope="request"/>

                            <c:forEach var="variant" items="${productDetail}">
                                <c:if test="${not empty variant.sizeName}">
                                    <c:set var="hasSize" value="true"/>
                                    <% ((java.util.TreeSet<String>) request.getAttribute("sizeSet")).add(pageContext.getAttribute("variant").getClass().getMethod("getSizeName").invoke(pageContext.getAttribute("variant")).toString());%>
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
                                <input type="hidden" name="productID" value="${product.productID}">
                                <input type="hidden" name="variantId" id="selectedVariantId" value="${productDetail[0].proVariantID}">
                                <input type="hidden" name="quantity" id="cartQuantity" value="1">
                                <button type="submit" class="add-to-cart">Add to cart</button>
                            </form>
                        </div>
                                
                        <c:if test="${not empty message}">
                            <div class="after-cart">
                                <div class="cart-success">
                                    <p>✅ Product has been added to your cart!</p>
                                </div>
                                <div>
                                    <a href="Cart" class="btn btn-primary">🛒 View Cart</a>
                                    <a href="Checkout" class="btn btn-success">💳 Checkout</a>
                                    <a href="Product" class="btn btn-warning">💳 Continue Shopping</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>



            </c:when>
            <c:otherwise>
                <p style="text-align: center; font-size: 18px; font-weight: bold; color: red;">Product not found</p>
            </c:otherwise>
        </c:choose>
        <%@include file="Footer.jsp"%>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const thumbnails = document.querySelectorAll(".thumbnail-container img");
                const mainImage = document.querySelector(".product-main-img");

                thumbnails.forEach(thumbnail => {
                    thumbnail.addEventListener("click", function () {
                        mainImage.src = this.src;

                        thumbnails.forEach(img => img.classList.remove("active"));

                        this.classList.add("active");
                    });
                });
            });

        </script>




    </body>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const sizeButtons = document.querySelectorAll(".size-btn");
            const colorCircles = document.querySelectorAll(".color-circle");
            const quantityInput = document.getElementById("quantity");
            const variantIdInput = document.getElementById("selectedVariantId");

            let selectedSize = "";
            let selectedColor = "";

            // Khi chọn size
            sizeButtons.forEach(button => {
                button.addEventListener("click", function () {
                    selectedSize = this.textContent.trim();
                    sizeButtons.forEach(btn => btn.classList.remove("selected"));
                    this.classList.add("selected");
                    updateVariantId();
                });
            });

            // Khi chọn màu
            colorCircles.forEach(circle => {
                circle.addEventListener("click", function () {
                    selectedColor = this.style.backgroundColor;
                    colorCircles.forEach(c => c.classList.remove("selected"));
                    this.classList.add("selected");
                    updateVariantId();
                });
            });

            // Hàm cập nhật variantId
            function updateVariantId() {
                fetch(`GetVariantIDServlet?size=${selectedSize}&color=${selectedColor}`)
                        .then(response => response.text())
                        .then(variantId => {
                            variantIdInput.value = variantId; // Cập nhật hidden input
                        });
            }

            // Nút tăng/giảm số lượng
            document.querySelector(".quantity button:first-child").addEventListener("click", function () {
                if (parseInt(quantityInput.value) > 1) {
                    quantityInput.value = parseInt(quantityInput.value) - 1;
                }
            });

            document.querySelector(".quantity button:last-child").addEventListener("click", function () {
                quantityInput.value = parseInt(quantityInput.value) + 1;
            });
        });
    </script>

</html>

