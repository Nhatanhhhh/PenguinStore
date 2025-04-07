<%@page import="com.google.gson.Gson"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Products | Penguin Fashion</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProducts.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/chatbot.css"/>
        <style>
            .scroll-to-top {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 40px;
                height: 40px;
                background-color: rgba(0, 0, 0, 0.7);
                color: white;
                border: none;
                border-radius: 50%;
                font-size: 20px;
                cursor: pointer;
                display: none;
                justify-content: center;
                align-items: center;
                transition: opacity 0.3s, transform 0.3s;
            }

            .scroll-to-top:hover {
                background-color: black;
            }
            #sortBy {
                background-color: white;
                color: black;
                border: 2px solid black;
                padding: 8px 12px;
                font-size: 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease-in-out;
            }

            #sortBy:hover {
                background-color: black;
                color: white;
            }

            #sortBy:focus {
                outline: none;
                border-color: black;
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
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
                                                  > 0 - 200.000 VND</label>

                                    <label><input type="checkbox" name="priceFilter" value="200000-500000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '200000-500000')}">checked</c:if>
                                            > 200.000 VND - 500.000 VND</label>

                                    <label><input type="checkbox" name="priceFilter" value="500000-1000000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '500000-1000000')}">checked</c:if>
                                            > 500.000 VND - 1.000.000 VND</label>

                                    <label><input type="checkbox" name="priceFilter" value=">1000000" class="filter-checkbox"
                                        <c:if test="${not empty selectedPrices and fn:contains(selectedPrices, '>1000000')}">checked</c:if>
                                            > Greater than 1.000.000 VND</label>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="container mt-5 mb-5 col-md-9">
                        <div class="container-fluid">
                        <c:if test="${param.action ne 'detailType' && param.action ne 'search'}">
                            <form id="sortForm" action="<c:url value='/Product?action=sort'/>" method="POST">
                                <select name="sortBy" id="sortBy">
                                    <option value="">Sort by</option>
                                    <option value=" ORDER BY p.price ASC" ${param.sortBy eq ' ORDER BY p.price ASC' ? 'selected' : ''}>Price: Low to High</option>
                                    <option value=" ORDER BY p.price DESC" ${param.sortBy eq ' ORDER BY p.price DESC' ? 'selected' : ''}>Price: High to Low</option>
                                    <option value=" ORDER BY p.dateCreate DESC" ${param.sortBy eq ' ORDER BY p.dateCreate DESC' ? 'selected' : ''}>Newest</option>
                                    <option value=" ORDER BY p.dateCreate ASC" ${param.sortBy eq ' ORDER BY p.dateCreate ASC' ? 'selected' : ''}>Oldest</option>
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
                        </c:if>
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
                                            <p class="card-text text-muted">
                                                <fmt:setLocale value="vi_VN"/>
                                                <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" groupingUsed="true"/> VND
                                            </p>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                        <div id="paginationControls" class="mt-3 d-flex justify-content-center"></div>
                        <c:if test="${empty listProduct}">
                            <p class="text-center text-danger mt-3">No products available.</p>
                        </c:if>
                    </div>
                </div>
            </div>


        </div>
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
        <button id="scrollToTopBtn" class="scroll-to-top">
            ↑
        </button>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const checkboxes = document.querySelectorAll(".filter-checkbox");
                const filterForm = document.getElementById("filterForm");
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
            document.getElementById("sortBy").addEventListener("change", function () {
                document.getElementById("sortForm").submit();
            });
            window.addEventListener("scroll", function () {
                if (window.scrollY > 100) {
                    scrollToTopBtn.style.display = "flex";
                } else {
                    scrollToTopBtn.style.display = "none";
                }
            });
            scrollToTopBtn.addEventListener("click", function () {
                window.scrollTo({top: 0, behavior: "smooth"});
            });

            window.userSession = <%= userJson%>;
        </script>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/chatbot.js" defer></script>
    </body>
</html>