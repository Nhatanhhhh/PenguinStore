<%-- 
    Document   : ProductDetail
    Created on : Feb 22, 2025, 6:35:04 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@page import="com.google.gson.Gson"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${product.productName} | Penguin Fashion</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/chatbot.css"/>
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: #333;
                background-color: #f9f9f9;
            }

            .product-container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 2rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
            }

            .product-images {
                position: relative;
            }

            .thumbnail-container {
                display: flex;
                gap: 10px;
                margin-top: 1rem;
                overflow-x: auto;
                padding-bottom: 10px;
            }

            .thumbnail-container img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border: 1px solid #ddd;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .thumbnail-container img:hover {
                border-color: var(--secondary-color);
                transform: scale(1.05);
            }

            .product-main-img {
                width: 100%;
                max-height: 500px;
                object-fit: contain;
                border-radius: 8px;
            }

            .product-info h1 {
                font-size: 2.2rem;
                font-weight: 700;
                margin-bottom: 1rem;
                color: var(--primary-color);
            }

            .price {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--accent-color);
                margin: 1rem 0;
            }

            .options {
                margin: 1.5rem 0;
            }

            .options label {
                display: block;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .size-options {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .size-btn {
                padding: 0.5rem 1rem;
                border: 1px solid #ddd;
                background: white;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .size-btn:hover, .size-btn.selected {
                border-color: var(--secondary-color);
                background: var(--secondary-color);
                color: white;
            }

            .color-options {
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
            }

            .color-circle {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                cursor: pointer;
                border: 2px solid var(--secondary-color);
                transition: all 0.2s ease;
            }

            .color-circle:hover, .color-circle.selected {
                transform: scale(1.1);
                box-shadow: 0 0 0 2px var(--secondary-color);
            }

            .cart-container {
                margin: 2rem 0;
                padding: 1.5rem;
                background: var(--light-gray);
                border-radius: 8px;
            }

            .quantity {
                display: flex;
                align-items: center;
                margin-bottom: 1rem;
            }

            .quantity button {
                width: 40px;
                height: 40px;
                background: var(--primary-color);
                color: white;
                border: none;
                font-size: 1.2rem;
                cursor: pointer;
                transition: background 0.2s ease;
            }

            .quantity button:hover {
                background: var(--secondary-color);
            }

            .quantity input {
                width: 60px;
                height: 40px;
                text-align: center;
                margin: 0 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 1rem;
            }

            .add-to-cart {
                width: 100%;
                padding: 12px;
                background: var(--accent-color);
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .add-to-cart:hover {
                background: #c0392b;
                transform: translateY(-2px);
            }

            .add-to-cart:disabled {
                background: #ccc;
                cursor: not-allowed;
                transform: none;
            }

            .stock-info {
                font-size: 0.9rem;
                color: #666;
                margin-top: 0.5rem;
            }

            .in-stock {
                color: #27ae60;
                font-weight: 600;
            }

            .out-of-stock {
                color: #e74c3c;
                font-weight: 600;
            }

            .reviews-section {
                background: var(--light-gray);
                padding: 3rem 0;
                margin-top: 3rem;
            }

            .review-card {
                background: white;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                height: 100%;
            }

            .rating-stars {
                color: #f39c12;
                font-size: 1.2rem;
                margin-bottom: 0.5rem;
            }

            .review-meta {
                font-size: 0.9rem;
                color: #666;
                margin-top: 1rem;
            }

            .no-reviews {
                text-align: center;
                padding: 2rem;
                color: #666;
            }

            @media (max-width: 768px) {
                .product-container {
                    padding: 1rem;
                }

                .product-info h1 {
                    font-size: 1.8rem;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%  Customer user = (Customer) session.getAttribute("user");
            String userJson = "null";
            if (user != null) {
                userJson = new Gson().toJson(user);
            }
        %>
        <script>
            document.getElementById('addToCartForm').addEventListener('submit', function (e) {
                e.preventDefault();

                const form = this;
                const formData = new FormData(form);
                const productId = document.getElementById('productID').value;

                fetch(form.action, {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.text())
                        .then(result => {
                            if (result === 'login_required') {
                                window.location.href = 'Login';
                            } else {
                                // Display SweetAlert message
                                let message = '';
                                let icon = 'success';

                                if (result === 'success') {
                                    message = 'Successfully added to the cart';
                                } else if (result.startsWith('not_enough_stock:')) {
                                    message = 'Only ' + result.split(':')[1] + ' items left in stock';
                                    icon = 'error';
                                } else {
                                    message = 'An error occurred: ' + result;
                                    icon = 'error';
                                }

                                Swal.fire({
                                    icon: icon,
                                    title: icon === 'success' ? 'Success!' : 'Error!',
                                    text: message,
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then(() => {
                                    // After showing the message, redirect to the product detail page
                                    window.location.href = 'Product?id=' + productId + '&action=detail';
                                });
                            }
                        })
                        .catch(error => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'An error occurred while adding to the cart',
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => {
                                window.location.href = 'Product?id=' + productId + '&action=detail';
                            });
                        });
            });

        </script>

        <main class="container">
            <c:choose>
                <c:when test="${not empty productDetail and not empty productDetail[0].proVariantID}">
                    <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                    <div class="row product-container">
                        <div class="col-md-6 product-images">
                            <img src="Image/Product/${imgList[0]}" class="product-main-img" alt="${product.productName}" id="mainImage">
                            <div class="thumbnail-container">
                                <c:forEach var="img" items="${imgList}">
                                    <img src="Image/Product/${fn:replace(img, ' ', '')}" alt="Thumbnail" onclick="changeMainImage(this)">
                                </c:forEach>
                            </div>
                        </div>

                        <div class="col-md-6 product-info">
                            <h1>${product.productName}</h1>

                            <div class="rating mb-3">
                                <span class="rating-stars">
                                    <c:set var="fullStars" value="${Math.floor(averageRating)}"/>
                                    <c:set var="decimalPart" value="${averageRating - fullStars}"/>
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= fullStars}">
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:when test="${i == fullStars + 1 && decimalPart >= 0.25}">
                                                <i class="fas fa-star-half-alt"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                <span class="ms-2">(${totalReviews} reviews)</span>
                            </div>

                            <div class="price">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${product.price}" type="currency"/>
                            </div>

                            <p class="text-muted mb-4">${product.description}</p>

                            <div class="details mb-4">
                                <p><strong>Type:</strong> ${product.typeName}</p>
                                <p><strong>Category:</strong> ${product.categoryName}</p>
                            </div>

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
                                                <button class="size-btn" data-size="${size}">${size}</button>
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
                                            <span class="color-circle" style="background-color: ${variant.colorName};" data-color="${variant.colorName}" title="${variant.colorName}"></span>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="cart-container">
                                <div class="quantity">
                                    <button type="button" onclick="decreaseQuantity()">-</button>
                                    <input type="text" id="quantity-display" value="1" pattern="[0-9]*" inputmode="numeric">
                                    <button type="button" onclick="increaseQuantity()">+</button>
                                </div>

                                <div class="stock-info">
                                    <strong>Availability:</strong> 
                                    <span id="stock-display" class="${stockQuantity > 0 ? 'in-stock' : 'out-of-stock'}">
                                        ${stockQuantity > 0 ? stockQuantity : 'Out of stock'}
                                    </span>
                                </div>


                                <form action="AddToCartServlet" method="post" id="addToCartForm">
                                    <input type="hidden" id="productID" name="productID" value="${product.productID}">
                                    <input type="hidden" id="selectedSize" name="size">
                                    <input type="hidden" id="selectedColor" name="color">
                                    <input type="hidden" id="selectedVariantId" name="selectedVariantId">
                                    <input type="hidden" id="quantity" name="quantity" value="1">
                                    <button type="submit" class="add-to-cart" disabled>Select options to add to cart</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger text-center my-5">
                        <h4>Product not found</h4>
                        <p>The product you're looking for doesn't exist or is no longer available.</p>
                        <a href="Product?action=view" class="btn btn-primary mt-3">Continue Shopping</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <section class="reviews-section">
            <div class="container">
                <h2 class="text-center mb-5">Customer Reviews</h2>
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:choose>
                        <c:when test="${not empty feedbackList}">
                            <c:forEach var="feedback" items="${feedbackList}">
                                <div class="col">
                                    <div class="review-card">
                                        <div class="rating-stars">
                                            <c:forEach var="i" begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${i <= feedback.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <p class="card-text">"${feedback.comment}"</p>
                                        <div class="review-meta">
                                            <strong>${feedback.customerName}</strong>
                                            <div><fmt:formatDate value="${feedback.feedbackCreateAt}" pattern="MMMM d, yyyy"/></div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="no-reviews">
                                    <i class="far fa-comment-dots fa-3x mb-3"></i>
                                    <h4>No reviews yet</h4>
                                    <p>Be the first to review this product!</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- ChatBOT -->
        <div class="chatbot-container">
            <button class="chatbot-toggler">
                <span class="material-symbols-outlined open-icon">mode_comment</span>
                <span class="material-symbols-outlined close-icon">close</span>
            </button>
            <div class="chatbot">
                <header>
                    <h2>PenguinBot</h2>
                    <span class="close-btn material-symbols-outlined">close</span>
                </header>
                <ul class="chatbox">
                    <li class="chat incoming">
                        <span class="mdi mdi-penguin"></span>
                        <p>Xin chào! Tôi là PenguinBot - trợ lý ảo của PenguinDB. Tôi có thể giúp gì cho bạn hôm nay?</p>
                    </li>
                </ul>
                <div class="chat-input">
                    <textarea placeholder="Nhập tin nhắn của bạn..." required></textarea>
                    <span class="material-symbols-outlined">send</span>
                </div>
            </div>
        </div>

        <!-- End ChatBOT -->

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Main image switcher
                function changeMainImage(thumb) {
                    document.getElementById('mainImage').src = thumb.src;
                }

                // Initialize quantity controls
                const quantityInput = document.getElementById("quantity-display");
                const stockDisplay = document.getElementById("stock-display");
                // Quantity control functions
                window.increaseQuantity = function () {
                    let currentValue = parseInt(quantityInput.value) || 1;
                    const maxStock = parseInt(stockDisplay.textContent) || 1;
                    if (currentValue < maxStock) {
                        currentValue++;
                        quantityInput.value = currentValue;
                        document.getElementById("quantity").value = currentValue;
                    }
                };
                window.decreaseQuantity = function () {
                    let currentValue = parseInt(quantityInput.value) || 1;
                    if (currentValue > 1) {
                        currentValue--;
                        quantityInput.value = currentValue;
                        document.getElementById("quantity").value = currentValue;
                    }
                };
                // Input validation
                quantityInput.addEventListener("input", function () {
                    const maxStock = parseInt(stockDisplay.textContent) || 1;
                    // Remove non-numeric characters
                    this.value = this.value.replace(/[^0-9]/g, '');
                    // Ensure value is at least 1
                    if (this.value === '' || parseInt(this.value) < 1) {
                        this.value = 1;
                    }

                    // Ensure value doesn't exceed stock
                    if (parseInt(this.value) > maxStock) {
                        this.value = maxStock;
                    }

                    // Update hidden quantity field
                    document.getElementById("quantity").value = this.value;
                });
                quantityInput.addEventListener("blur", function () {
                    if (this.value === '') {
                        this.value = 1;
                        document.getElementById("quantity").value = 1;
                    }
                });
                // Product variant selection
                const sizeButtons = document.querySelectorAll(".size-btn");
                const colorCircles = document.querySelectorAll(".color-circle");
                const selectedSizeInput = document.getElementById("selectedSize");
                const selectedColorInput = document.getElementById("selectedColor");
                const variantIdInput = document.getElementById("selectedVariantId");
                const addToCartBtn = document.querySelector(".add-to-cart");
                let selectedSize = null;
                let selectedColor = null;
                sizeButtons.forEach(button => {
                    button.addEventListener("click", function () {
                        selectedSize = this.getAttribute("data-size");
                        selectedSizeInput.value = selectedSize;
                        sizeButtons.forEach(btn => btn.classList.remove("selected"));
                        this.classList.add("selected");
                        updateVariantId();
                    });
                });

                colorCircles.forEach(circle => {
                    circle.addEventListener("click", function () {
                        selectedColor = this.getAttribute("data-color");
                        selectedColorInput.value = selectedColor;
                        colorCircles.forEach(c => c.classList.remove("selected"));
                        this.classList.add("selected");
                        updateVariantId();
                    });
                });


            });
            // Update stock display
            function updateStockDisplay(variantId) {
                if (!variantId || variantId === "null") {
                    // Show total stock when no variant is selected
                    document.getElementById("stock-display").textContent = "${totalStock}";
                    return;
                }

                fetch('<%= request.getContextPath()%>/AddToCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        action: "getStock",
                        variantId: variantId
                    })
                })
                        .then(response => response.text())
                        .then(stock => {
                            if (stock && stock !== "null") {
                                stockDisplay.textContent = stock;
                                // Adjust quantity if it exceeds new stock
                                const currentQty = parseInt(quantityInput.value) || 1;
                                if (currentQty > parseInt(stock)) {
                                    quantityInput.value = stock;
                                    document.getElementById("quantity").value = stock;
                                }
                            }
                        })
                        .catch(error => {
                            console.error("Error fetching stock:", error);
                        });
            }

            // Update variant ID và stock quantity
            // Update variant ID và stock quantity
            function updateVariantId() {
                const productID = document.getElementById("productID").value;
                const size = document.getElementById("selectedSize").value;
                const color = document.getElementById("selectedColor").value;
                const addToCartBtn = document.querySelector(".add-to-cart");
                const variantIdInput = document.getElementById("selectedVariantId");
                const stockDisplay = document.getElementById("stock-display");

                // Kiểm tra đã chọn đủ thông tin chưa
                if (!productID || !color) {
                    addToCartBtn.disabled = true;
                    addToCartBtn.textContent = "Please select color";
                    stockDisplay.textContent = "${totalStock}";
                    stockDisplay.className = "${totalStock > 0 ? 'in-stock' : 'out-of-stock'}";
                    variantIdInput.value = "";
                    return;
                }

                variantIdInput.value = "loading...";
                addToCartBtn.disabled = true;
                addToCartBtn.textContent = "Checking availability...";

                fetch('AddToCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: new URLSearchParams({
                        action: "getVariant",
                        productID: productID,
                        size: size || "",
                        color: color
                    })
                })
                        .then(response => {
                            const contentType = response.headers.get('content-type');
                            if (contentType && contentType.includes('text/html')) {
                                throw new Error('login_required');
                            }
                            return response.text();
                        })
                        .then(variantId => {
                            if (!variantId || variantId === "null") {
                                throw new Error('variant_not_found');
                            }
                            variantIdInput.value = variantId;
                            addToCartBtn.disabled = false;
                            addToCartBtn.textContent = "Add to cart";
                            updateStockDisplay(variantId);
                        })
                        .catch(error => {
                            console.error("Error:", error);
                            if (error.message === 'login_required') {
                                window.location.href = 'Login';
                            } else {
                                variantIdInput.value = "";
                                addToCartBtn.disabled = true;
                                addToCartBtn.textContent = "Option not available";
                                stockDisplay.textContent = "0";
                                stockDisplay.className = "out-of-stock";
                            }
                        });
            }

            // Update stock display
            function updateStockDisplay(variantId) {
                if (!variantId || variantId === "null") {
                    document.getElementById("stock-display").textContent = "${totalStock}";
                    document.getElementById("cart-quantity-display").textContent = "";
                    return;
                }

                // Get stock quantity
                fetch('AddToCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: new URLSearchParams({
                        action: "getStock",
                        variantId: variantId
                    })
                })
                        .then(response => response.text())
                        .then(stock => {
                            if (!stock || stock === "null") {
                                throw new Error('stock_not_found');
                            }

                            document.getElementById("stock-display").textContent = stock;
                            document.getElementById("stock-display").className = parseInt(stock) > 0 ? "in-stock" : "out-of-stock";

                            // Get current cart quantity for logged-in users
                            if (${not empty sessionScope.user}) {
                                fetch('AddToCartServlet', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: new URLSearchParams({
                                        action: "getCartQuantity",
                                        variantId: variantId
                                    })
                                })
                                        .then(response => response.text())
                                        .then(cartQty => {
                                            const cartDisplay = document.getElementById("cart-quantity-display");
                                            if (cartQty > 0) {
                                                cartDisplay.textContent = `(You have ${cartQty} in cart)`;
                                            } else {
                                                cartDisplay.textContent = "";
                                            }
                                        });
                            }
                        })
                        .catch(error => {
                            console.error("Error fetching stock:", error);
                            document.getElementById("stock-display").textContent = "Error";
                            document.getElementById("stock-display").className = "out-of-stock";
                        });
            }

            // Update stock display
            function updateStockDisplay(variantId) {
                if (!variantId || variantId === "null") {
                    // Show total stock when no variant is selected
                    document.getElementById("stock-display").textContent = "${totalStock}";
                    document.getElementById("cart-quantity-display").textContent = "";
                    return;
                }

                // Get stock quantity
                fetch('<%= request.getContextPath()%>/AddToCartServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        action: "getStock",
                        variantId: variantId
                    })
                })
                        .then(response => response.text())
                        .then(stock => {
                            if (stock && stock !== "null") {
                                document.getElementById("stock-display").textContent = stock;

                                // Get current cart quantity for logged-in users
                                if (${not empty sessionScope.user}) {
                                    fetch('<%= request.getContextPath()%>/AddToCartServlet', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                        },
                                        body: new URLSearchParams({
                                            action: "getCartQuantity",
                                            variantId: variantId
                                        })
                                    })
                                            .then(response => response.text())
                                            .then(cartQty => {
                                                const cartDisplay = document.getElementById("cart-quantity-display");
                                                if (cartQty > 0) {
                                                    cartDisplay.textContent = `(You have ${cartQty} in cart)`;
                                                } else {
                                                    cartDisplay.textContent = "";
                                                }
                                            });
                                }
                            }
                        });
            }

            window.userSession = <%= userJson%>;
        </script>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/chatbot.js" defer></script>
    </body>
</html>