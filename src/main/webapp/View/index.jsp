<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Penguin Store - Fashion for Everyone</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/custom.css"/>
        <style>
            :root {
                --primary: #000;
                --secondary: #e74c3c;
                --light: #f8f9fa;
                --dark: #212529;
                --accent: #3498db;
                --gray: #6c757d;
                --shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                --transition: all 0.3s ease;
                --border-radius: 12px;
            }
            
            body {
                font-family: 'Raleway', sans-serif;
                color: var(--dark);
                background-color: #f9f9f9;
            }
            
            /* Hero Section */
            
            /* Product Cards */
            .section-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 3rem;
                position: relative;
                display: inline-block;
            }
            
            .section-title:after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                width: 60px;
                height: 4px;
                background-color: var(--secondary);
            }
            
            .product-card {
                transition: var(--transition);
                border: none;
                border-radius: var(--border-radius);
                overflow: hidden;
                margin-bottom: 2rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                background: white;
            }
            
            .product-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            }
            
            .product-card img {
                height: 300px;
                object-fit: cover;
                width: 100%;
                transition: var(--transition);
            }
            
            .product-card:hover img {
                transform: scale(1.05);
            }
            
            .product-card .card-body {
                padding: 1.5rem;
            }
            
            .product-card .card-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 0.75rem;
                color: var(--primary);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            
            .product-card .card-text {
                font-size: 1.2rem;
                color: var(--secondary);
                font-weight: 700;
            }
            
            .product-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background-color: var(--secondary);
                color: white;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                z-index: 1;
            }
            
            /* Buttons */
            .btn-main {
                background-color: var(--primary);
                color: white;
                padding: 12px 32px;
                border-radius: 30px;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: var(--transition);
                border: 2px solid var(--primary);
                text-transform: uppercase;
            }
            
            .btn-main:hover {
                background-color: transparent;
                color: var(--primary);
                transform: translateY(-3px);
            }
            
            .btn-outline-main {
                background-color: transparent;
                color: var(--primary);
                border: 2px solid var(--primary);
                padding: 12px 32px;
                border-radius: 30px;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: var(--transition);
                text-transform: uppercase;
            }
            
            .btn-outline-main:hover {
                background-color: var(--primary);
                color: white;
                transform: translateY(-3px);
            }
            
            /* Inspiration Section */
            .inspiration-section {
                background: linear-gradient(135deg, #f5f7fa 0%, #e6e9f0 100%);
                padding: 100px 0;
                margin: 80px 0;
                position: relative;
            }
            
            .inspiration-content {
                background: white;
                border-radius: var(--border-radius);
                padding: 60px;
                position: relative;
                max-width: 850px;
                margin: 0 auto;
                box-shadow: var(--shadow);
            }
            
            .inspiration-quote {
                font-size: 1.8rem;
                line-height: 1.6;
                font-weight: 500;
                margin-bottom: 2rem;
                position: relative;
                text-align: center;
                color: var(--primary);
            }
            
            .star-icon {
                position: absolute;
                color: var(--secondary);
                font-size: 60px;
                opacity: 0.3;
            }
            
            .star-top {
                top: -30px;
                right: 30%;
            }
            
            .star-bottom {
                bottom: -30px;
                left: 30%;
            }
            
            .image-gallery {
                display: flex;
                gap: 30px;
                margin-top: 60px;
                justify-content: center;
            }
            
            .gallery-image {
                border-radius: var(--border-radius);
                width: 100%;
                max-width: 400px;
                height: 500px;
                object-fit: cover;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                transition: var(--transition);
            }
            
            .gallery-image:hover {
                transform: scale(1.03);
            }
            
            /* New Arrivals */
            .new-products-section {
                padding: 100px 0;
                background-color: white;
            }
            
            .new-products-content {
                background: linear-gradient(135deg, #f5f7fa 0%, #e6e9f0 100%);
                border-radius: var(--border-radius);
                padding: 60px;
                position: relative;
                overflow: hidden;
            }
            
            .new-products-image {
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
                transition: var(--transition);
            }
            
            .new-products-image:hover {
                transform: scale(1.02);
            }
            
            /* Features */
            .features-section {
                padding: 80px 0;
                background-color: var(--light);
            }
            
            .feature-box {
                text-align: center;
                padding: 30px;
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
                transition: var(--transition);
                height: 100%;
            }
            
            .feature-box:hover {
                transform: translateY(-10px);
            }
            
            .feature-icon {
                font-size: 3rem;
                color: var(--secondary);
                margin-bottom: 1.5rem;
            }
            
            .feature-title {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--primary);
            }
            
            /* Newsletter */
            .newsletter-section {
                padding: 80px 0;
                background-color: var(--primary);
                color: white;
            }
            
            .newsletter-form {
                max-width: 600px;
                margin: 0 auto;
            }
            
            .newsletter-input {
                border: none;
                border-radius: 30px;
                padding: 15px 25px;
                width: 100%;
                font-size: 1rem;
            }
            
            /* Responsive */
            @media (max-width: 992px) {
                .hero-title {
                    font-size: 2.5rem;
                }
                
                .hero-subtitle {
                    font-size: 1.2rem;
                }
                
                .inspiration-quote {
                    font-size: 1.5rem;
                }
                
                .image-gallery {
                    flex-direction: column;
                    align-items: center;
                }
                
                .gallery-image {
                    height: 400px;
                    max-width: 100%;
                }
            }
            
            @media (max-width: 768px) {
                .hero-content {
                    padding: 2rem;
                }
                
                .hero-title {
                    font-size: 2rem;
                }
                
                .hero-subtitle {
                    font-size: 1rem;
                }
                
                .section-title {
                    font-size: 2rem;
                }
                
                .inspiration-content {
                    padding: 40px 20px;
                }
                
                .inspiration-quote {
                    font-size: 1.2rem;
                }
                
                .new-products-content {
                    padding: 40px;
                }
            }
            
            @media (max-width: 576px) {
                .hero-title {
                    font-size: 1.8rem;
                }
                
                .section-title {
                    font-size: 1.8rem;
                }
                
                .product-card img {
                    height: 250px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger text-center animate__animated animate__fadeIn">
                ${sessionScope.errorMessage}
            </div>
        </c:if>

        <!-- Hero Section -->
        <section class="hero-section animate__animated animate__fadeIn d-flex justify-content-center">
            <img src="Image/Index/Background.png" style="width: 60vw;" class="hero-image" alt="Fashion Collection">
        </section>

        <!-- Featured Products -->
        <section id="featured-products" class="container py-5 animate__animated animate__fadeInUp">
            <h2 class="section-title text-center mb-5">Featured Products</h2>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="productList">
                <c:forEach var="product" items="${listProduct}">
                    <div class="col mt-5">
                        <div class="product-card h-100">
                            <c:if test="${not empty product.imgName}">
                                <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                <c:set var="firstImg" value="${imgList[0]}" />
                                <img src="Image/Product/${firstImg}" alt="${product.productName}" class="card-img-top">
                            </c:if>
                            <div class="card-body text-center">
                                <h5 class="card-title">${product.productName}</h5>
                                <p class="card-text">
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" groupingUsed="true"/> VND
                                </p>
                                <a href="Product?id=${product.productID}&action=detail" class="btn btn-outline-main">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div class="text-center mt-5">
                <a href="<c:url value='/Product'/>" class="btn btn-main">View All Products</a>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <div class="feature-box animate__animated animate__fadeInUp" data-wow-delay="0.1s">
                            <div class="feature-icon mdi mdi-truck-fast"></div>
                            <h3 class="feature-title">Free Shipping</h3>
                            <p>Free shipping on all orders over 500,000 VND</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-box animate__animated animate__fadeInUp" data-wow-delay="0.2s">
                            <div class="feature-icon mdi mdi-undo"></div>
                            <h3 class="feature-title">Easy Returns</h3>
                            <p>30-day return policy for all items</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-box animate__animated animate__fadeInUp" data-wow-delay="0.3s">
                            <div class="feature-icon mdi mdi-shield-check"></div>
                            <h3 class="feature-title">Secure Payment</h3>
                            <p>100% secure payment methods</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Inspiration Section -->
        <section class="inspiration-section animate__animated animate__fadeIn">
            <div class="container">
                <div class="inspiration-content">
                    <div class="inspiration-quote">
                        "Modern style is a blend of minimalism and personality, highlighting your unique personality"
                    </div>
                    <div class="inspiration-quote">
                        "Fashion is not just about clothes, it's also about how you tell your own story"
                    </div>
                    
                    <div class="image-gallery">
                        <img src="Image/Account/item12.jpg" class="gallery-image" alt="Fashion Inspiration 1">
                        <img src="Image/Product/item7.jpg" class="gallery-image" alt="Fashion Inspiration 2">
                    </div>
                </div>
            </div>
        </section>

        <!-- New Arrivals -->
        <section class="new-products-section">
            <div class="container">
                <div class="new-products-content">
                    <div class="row align-items-center">
                        <div class="col-lg-6 mb-4 mb-lg-0">
                            <img src="Image/Product/window.png" class="new-products-image img-fluid" alt="New Arrivals">
                        </div>
                        <div class="col-lg-6 text-center text-lg-start">
                            <h1 class="section-title mb-4">DON'T MISS OUR NEW PRODUCTS</h1>
                            <p class="lead mb-4">Discover our latest collection with fresh designs and premium quality materials.</p>
                            <a href="<%= request.getContextPath()%>/Product" class="btn btn-main">Explore New Arrivals</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Animation on scroll
                const animateElements = document.querySelectorAll('.animate__animated');
                
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const animation = entry.target.getAttribute('data-animation');
                            entry.target.classList.add('animate__fadeInUp');
                            observer.unobserve(entry.target);
                        }
                    });
                }, {
                    threshold: 0.1
                });
                
                animateElements.forEach(el => {
                    observer.observe(el);
                });
                
                // Handle messages from session
                const successMessage = "<%= session.getAttribute("successMessage") != null ? session.getAttribute("successMessage") : ""%>";
                const errorMessage = "<%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : ""%>";
                const showSweetAlert = "<%= session.getAttribute("showSweetAlert") != null ? session.getAttribute("showSweetAlert") : "false"%>";

                // Clear session after getting data
                <% session.removeAttribute("successMessage"); %>
                <% session.removeAttribute("errorMessage"); %>
                <% session.removeAttribute("showSweetAlert");%>

                if (typeof Swal !== "undefined") {
                    if (successMessage !== "") {
                        Swal.fire({
                            position: "top-end",
                            icon: "success",
                            title: successMessage,
                            showConfirmButton: false,
                            timer: 2000
                        });
                    }

                    if (errorMessage !== "" && showSweetAlert === "true") {
                        Swal.fire({
                            icon: 'error',
                            title: 'Login Failed',
                            text: errorMessage,
                            confirmButtonText: 'OK'
                        }).then(() => {
                            window.location.href = "<%= request.getContextPath()%>/View/LoginCustomer.jsp";
                        });
                    }
                }
                
                // Simple pagination
                const itemsPerPage = 12;
                const productList = document.getElementById("productList");
                const productItems = Array.from(productList.getElementsByClassName("product-card"));
                
                function showPage(page) {
                    const start = (page - 1) * itemsPerPage;
                    const end = start + itemsPerPage;

                    productItems.forEach((item, index) => {
                        item.style.display = (index >= start && index < end) ? "block" : "none";
                    });
                }
                
                showPage(1);
            });
        </script>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>