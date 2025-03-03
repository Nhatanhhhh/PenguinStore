<%-- 
    Document   : Inventory
    Created on : Feb 28, 2025, 6:52:46 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Inventory</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/styleViewProductDetail.css"/>
    </head>
    <body>
        <%@include file="Admin/HeaderAD.jsp"%>

        <div class="row">
            <div class="col-md-3">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-9">
                <div class="product-images" style="margin-top: 20px; margin-bottom: 30px">
                    <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                    <div class="thumbnail-container">
                        <c:forEach var="img" items="${imgList}">
                            <img src="Image/Product/${fn:replace(img, ' ', '')}" alt="Thumbnail">
                        </c:forEach>
                    </div>
                    <img src="Image/Product/${imgList[0]}" class="product-main-img" alt="Product Image">
                </div>
                <div >
                    <h2>${product.productName}</h2>
                    <p><strong>Description:</strong> ${product.description}</p>
                    <p><strong>Price:</strong> ${product.price}</p>
                    <p><strong>Type:</strong> ${product.typeName}</p>
                    <p><strong>Category:</strong> ${product.categoryName}</p>
                </div>
                <a href="" class="btn btn-primary btn-sm">Edit Product</a>
                <div class="container mt-4">
                    <h2>Product Detail</h2>
                    <table class="table table-bordered text-center">
                        <thead class="table-dark">
                            <tr>

                                <th>Color</th>
                                <th>Size</th>
                                <th>Quantity</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="variant" items="${productDetail}">
                            <tr>
                                <!-- Color -->
                                <td>
                                    <div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${variant.colorName}; margin: auto;"></div>
                                </td>
                                <!-- Size -->
                                <td>${variant.sizeName}</td>

                                <!-- Quantity -->
                                <td>${variant.stockQuantity}</td>

                                <!-- Status -->
                                <td>
                                    <span class="fw-bold ${variant.status ? 'text-success' : 'text-danger'}">
                                        ${variant.status ? 'In Stock' : 'Out of Stock'}
                                    </span>
                                </td>

                                <!-- Action -->
                                <td>
                                    <a href="<c:url value='/Restock?action=restock&id=${variant.proVariantID}'/>" class="btn btn-primary btn-sm">Restock</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${empty productDetail}">
                        <p class="text-center">Not have Product Detail!!!!</p>
                    </c:if>
                </div>
            </div>
        </div>
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
