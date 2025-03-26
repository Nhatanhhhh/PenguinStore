<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/custom.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProducts.css"/>

    </head>
    <body>
        <%@include file="Header.jsp"%>
        <p class="d-flex justify-content-center" style="color:red;">
            <%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : ""%>
        </p>

        <div class="container" style="padding-bottom: 50px;">
            <div class="row">
                <img src="Image/Index/Background.png" class="" style="width: 100%; height: auto;" alt="Background" data-aos="fade-up">
            </div>
        </div>
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3 justify-content-center" id="productList">
            <c:forEach var="product" items="${listProduct}">
                <div class="col d-flex justify-content-center mt-4">
                    <a href="Product?id=${product.productID}&action=detail" class="text-decoration-none text-dark">
                        <div class="card product-item text-center shadow-sm" style="width: 20rem;">
                            <c:if test="${not empty product.imgName}">
                                <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                                <c:set var="firstImg" value="${imgList[0]}" />
                                <img src="Image/Product/${firstImg}" alt="Product Image" class="card-img-top img-fluid" style="height: 220px; object-fit: cover;">
                            </c:if>
                            <div class="card-body">
                                <h5 class="card-title">${product.productName}</h5>
                                <p class="card-text text-muted">
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" groupingUsed="true"/> VND
                                </p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
        <div style="margin-left: 50px; margin-top: 50px;" class="d-flex justify-content-center">
            <a href="<c:url value='/Product'/>" class="button button-dark">View More</a>
        </div>
        <div class="div container-fluid" style="margin-left: 200px; margin-bottom: 50px; margin-right: 20px;">
            <div class="star-shooting-outline" data-aos="zoom-in"></div>
            <div class="div2" data-aos="fade-right">
                <div class="modern-style-is-a-blend-of-minimalism-and-personality-highlighting-your-unique-personality">
                    Modern style is a blend of minimalism and personality, highlighting your unique personality
                </div>
                <div class="fashion-is-not-just-about-clothes-it-s-also-about-how-you-tell-your-own-story">
                    Fashion is not just about clothes, it&#039;s also about how you tell your own story
                </div>
                <span class="mdi mdi-star-shooting vector" style="font-size: 100px;" data-aos="flip-left"></span>
                <span class="mdi mdi-star-shooting vector2" style="font-size: 100px;" data-aos="flip-right"></span>
            </div>
            <img class="pexels-pixabay-157675-1" src="Image/Account/item12.jpg" data-aos="fade-up"/>
            <img class="image" src="Image/Product/item7.jpg" data-aos="fade-up" data-aos-delay="200"/>
        </div>

        <div class="section-1">
            <div class="container">
                <div class="row">
                    <div class="col-md-6" data-aos="fade-left">
                        <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
                    </div>
                    <div class="col-md-6" data-aos="fade-right">
                        <div style="width: 300px; height: 80px; margin-top: 40px;">
                            <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                            <div style="margin-left: 50px; margin-top: 50px;">
                                <a href="/Product" class="button button-dark">New Products</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Lấy thông báo từ session
                var successMessage = "<%= session.getAttribute("successMessage") != null ? session.getAttribute("successMessage") : ""%>";
                var errorMessage = "<%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : ""%>";
                var showSweetAlert = "<%= session.getAttribute("showSweetAlert") != null ? session.getAttribute("showSweetAlert") : "false"%>";

                // Xóa session sau khi lấy dữ liệu
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
                } else {
                    console.error("SweetAlert2 is not loaded!");
                }
                const itemsPerPage = 12;
                const productList = document.getElementById("productList");
                const productItems = Array.from(productList.getElementsByClassName("product-item"));
                const paginationControls = document.getElementById("paginationControls");
                const scrollToTopBtn = document.getElementById("scrollToTopBtn");
                let currentPage = 1;
                function showPage(page) {
                    page = parseInt(page, 10);
                    const start = (page - 1) * itemsPerPage;
                    const end = start + itemsPerPage;

                    productItems.forEach((item, index) => {
                        item.style.display = (index >= start && index < end) ? "block" : "none";
                    });

                    updatePaginationControls(page);
                }

                function updatePaginationControls(page) {
                    page = parseInt(page, 10);
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
                checkboxes.forEach(checkbox => {
                    checkbox.addEventListener("change", function () {
                        filterForm.submit();
                    });
                });
            });
        </script>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>