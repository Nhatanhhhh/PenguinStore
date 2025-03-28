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
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
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
            .size-btn.selected {
                border: 2px solid #ffd700 !important;
                box-shadow: 0 0 5px rgba(255, 215, 0, 0.5);
            }

            .color-circle.selected {
                box-shadow: 0 0 0 2px #ffd700;
                border-radius: 50%;
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
                                                <i class="fa-solid fa-star" style="color: orange;"></i>
                                            </c:when>
                                            <c:when test="${i == fullStars + 1 && decimalPart >= 0.25}">
                                                <i class="fa-solid fa-star-half-stroke" style="color: orange;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-regular fa-star" style="color: gray;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                (${totalReviews} reviews)
                            </p>
                        </div>
                        <p class="card-text text-muted">
                            <strong>Price: </strong> 
                            <fmt:setLocale value="vi_VN"/>
                            <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> VND
                        </p>
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
                                        <span class="color-circle" style="background-color: ${variant.colorName};" data-color="${variant.colorName}"></span>
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
                                <input type="hidden" id="productID" name="productID" value="${product.productID}">
                                <input type="hidden" id="selectedSize" name="size">
                                <input type="hidden" id="selectedColor" name="color">
                                <input type="hidden" id="selectedVariantId" name="variantId">
                                <input type="hidden" id="quantity" name="quantity" value="1">
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
                const sizeButtons = document.querySelectorAll(".size-btn");
                const colorCircles = document.querySelectorAll(".color-circle");
                const quantityInput = document.getElementById("quantity");
                const selectedSizeInput = document.getElementById("selectedSize");
                const selectedColorInput = document.getElementById("selectedColor");
                const variantIdInput = document.getElementById("selectedVariantId");
                const productID = document.getElementById("productID").value;

                let selectedSize = null;
                let selectedColor = null;
                const hasSize = sizeButtons.length > 0; // Kiểm tra có size không

                // 🔹 Xử lý thay đổi ảnh sản phẩm
                thumbnails.forEach(thumbnail => {
                    thumbnail.addEventListener("click", function () {
                        mainImage.src = this.src;
                        thumbnails.forEach(img => img.classList.remove("active"));
                        this.classList.add("active");
                    });
                });

                // 🔹 Xử lý chọn size (nếu có)
                if (hasSize) {
                    sizeButtons.forEach(button => {
                        button.addEventListener("click", function () {
                            selectedSize = this.textContent.trim();
                            selectedSizeInput.value = selectedSize;
                            sizeButtons.forEach(btn => btn.classList.remove("selected"));
                            this.classList.add("selected");

                            console.log("🟢 Size selected:", selectedSize);
                            updateVariantId();
                        });
                    });
                }

                // 🔹 Xử lý chọn màu
                colorCircles.forEach(circle => {
                    circle.addEventListener("click", function () {
                        selectedColor = this.getAttribute("data-color");
                        selectedColorInput.value = selectedColor;
                        colorCircles.forEach(c => c.classList.remove("selected"));
                        this.classList.add("selected");

                        console.log("🔵 Color selected:", selectedColor);
                        updateVariantId();
                    });
                });



                // 🔹 Chọn mặc định giá trị đầu tiên
                if (hasSize) {
                    const firstSizeBtn = document.querySelector(".size-btn");
                    if (firstSizeBtn) {
                        firstSizeBtn.classList.add("selected");
                        selectedSizeInput.value = firstSizeBtn.textContent.trim();
                        selectedSize = firstSizeBtn.textContent.trim();
                    }
                }

                const firstColorCircle = document.querySelector(".color-circle");
                if (firstColorCircle) {
                    firstColorCircle.classList.add("selected");
                    selectedColorInput.value = firstColorCircle.getAttribute("data-color");
                    selectedColor = firstColorCircle.getAttribute("data-color");
                }

                updateVariantId();

                // 🔹 Tăng/Giảm số lượng
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
    </body>
</html>
