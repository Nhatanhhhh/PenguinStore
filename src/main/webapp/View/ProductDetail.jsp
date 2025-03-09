<%-- 
    Document   : ProductDetail
    Created on : Feb 22, 2025, 6:35:04 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <style>
            .star {
                font-size: 20px;
                color: #ddd;
            }

            .star.checked {
                color: #FFD700;
            }

            .card {
                transition: transform 0.2s ease-in-out;
            }
            .card:hover {
                transform: scale(1.05);
            }

        </style>
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
                        <!-- Hiển thị trung bình số sao -->
                        <div class="text-left">
                            <p>
                                <strong>Average Rating:</strong>

                                <span class="stars">
                                    <c:set var="fullStars" value="${Math.floor(averageRating)}"/>
                                    <c:set var="decimalPart" value="${averageRating - fullStars}"/>

                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= fullStars}">
                                                <!-- Sao đầy đủ -->
                                                <i class="fa-solid fa-star" style="color: orange;"></i>
                                            </c:when>
                                            <c:when test="${i == fullStars + 1 && decimalPart >= 0.25}">
                                                <!-- Hiển thị sao nửa nếu phần thập phân >= 0.25 -->
                                                <i class="fa-solid fa-star-half-stroke" style="color: orange;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Sao rỗng -->
                                                <i class="fa-regular fa-star" style="color: gray;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                (${totalReviews} reviews)
                            </p>
                        </div>
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

                            <form action="Cart" method="post">
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

        <div class="container-fluid pt-5 pb-5 mt-5 pb-5" style="background-color: #F6F6F6">
            <h2 class="text-center mb-4">Latest Reviews</h2>



            <div class="row row-cols-1 row-cols-md-3 g-4">
                <c:choose>
                    <c:when test="${not empty feedbackList}">
                        <c:forEach var="feedback" items="${feedbackList}">
                            <div class="col">
                                <div class="card p-3 shadow-sm border-0 m-3">
                                    <div class="card-body">
                                        <div class="mb-2">
                                            <p><strong>Rating:</strong>
                                                <c:forEach var="i" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${i <= feedback.rating}">
                                                            <span class="star checked">★</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="star">☆</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </p>
                                        </div>
                                        <p class="card-text">"${feedback.comment}"</p>
                                        <p class="fw-bold mb-1">${feedback.customerName}</p>
                                        <p class="text-muted small"><i><fmt:formatDate value="${feedback.feedbackCreateAt}" pattern="yyyy-MM-dd"/></i></p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center w-100">No reviews yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>


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

</html>