<%-- 
    Document   : Inventory
    Created on : Feb 28, 2025, 6:52:46 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Inventory</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProductDetail.css"/>
        <style>
            .form-group {
                margin-bottom: 15px;
            }
            input, textarea, select {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
            }

            #layoutSidenav {
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar Navigation */
            .col-md-2 {
                display: flex;
                flex-direction: column;
                flex-grow: 1;
                min-height: 100vh;
                padding-right: 0;
            }

            /* Content Section */
            .col-md-10 {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                padding-left: 0 !important;
                margin-left: 0 !important;
                padding-right: 0 !important;
            }
        </style>
    </head>
    <body>
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <div class="row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10">
                <%@include file="Admin/HeaderAD.jsp"%>
                <div class="container p-3">
                    <h2>Product Images</h2>
                    <c:set var="imgList" value="${fn:split(product.imgName, ',')}" />
                    <div class="product-images">
                        <div class="thumbnail-container">
                            <c:forEach var="img" items="${imgList}">
                                <img src="Image/Product/${fn:replace(img, ' ', '')}" alt="Thumbnail" >
                            </c:forEach>
                        </div>
                        <img src="Image/Product/${imgList[0]}" class="product-main-img" alt="Product Image" height="300px" width="300px" style="margin-left: 20px">
                    </div>
                    <h2>Product Information</h2>
                    <form id="editProductForm" action="<c:url value='/ManageProduct'/>" method="POST">
                        <input type="hidden" name="action" value="updateProduct">
                        <input type="hidden" name="productID" value="${product.productID}">
                        <div class="form-group">
                            <label for="productName"><strong>Product Name:</strong></label>
                            <input type="text" id="productName" name="productName" value="${product.productName}" readonly required>
                        </div>
                        <div class="form-group">
                            <label for="description"><strong>Description:</strong></label>
                            <textarea id="description" name="description" rows="4" readonly required>${product.description}</textarea>
                        </div>
                        <div class="form-group">
                            <label for="price"><strong>Price:</strong></label>
                            <input type="number" id="price" name="price" step="1" min="1" value="${product.price}" readonly required>
                        </div>
                        <div class="form-group">
                            <label for="category"><strong>Category:</strong> 
                                <input type="text" id="categoryName" name="categoryName" value="${product.categoryName}" readonly></label>

                        </div>
                        <div class="form-group">
                            <label for="type"><strong>Type:</strong>
                                <input type="text" id="typeName" name="typeName" value="${product.typeName}" readonly></label>

                        </div>
                        <button type="button" id="editProductBtn" class="btn btn-primary btn-sm">Edit</button>
                        <input type="submit" id="saveProductBtn" class="btn btn-success btn-sm" value="Save" style="display: none; width: 50px;">
                        <button type="button" id="cancelEditBtn" class="btn btn-secondary btn-sm" style="display: none;">Cancel</button>
                    </form>

                    <h2 class="mt-4">Product Variants</h2>
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
                                    <td>
                                        <div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${variant.colorName}; margin: auto;"></div>
                                    </td>
                                    <td>${variant.sizeName}</td>
                                    <td>${variant.stockQuantity}</td>
                                    <td>
                                        <select class="status-dropdown" data-variant-id="${variant.proVariantID}">
                                            <option value="true" ${variant.status ? 'selected' : ''}>In Stock</option>
                                            <option value="false" ${!variant.status ? 'selected' : ''}>Out of Stock</option>
                                        </select>
                                    </td>
                                    <td>
                                        <a href="<c:url value='/Restock?action=restock&id=${variant.proVariantID}'/>" class="btn btn-primary btn-sm">Restock</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </div>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const editButton = document.getElementById("editProductBtn");
                const saveButton = document.getElementById("saveProductBtn");
                const cancelButton = document.getElementById("cancelEditBtn");
                const form = document.getElementById("editProductForm");
                const inputs = document.querySelectorAll("#productName, #description, #price");
                const thumbnails = document.querySelectorAll(".thumbnail-container img");
                const mainImage = document.querySelector(".product-main-img");
                let originalValues = {};
                editButton.addEventListener("click", function () {
                    // Lưu giá trị ban đầu
                    inputs.forEach(input => {
                        originalValues[input.id] = input.value;
                        input.removeAttribute("readonly");
                    });
                    editButton.style.display = "none";
                    saveButton.style.display = "inline-block";
                    cancelButton.style.display = "inline-block";
                });
                cancelButton.addEventListener("click", function () {
                    // Khôi phục dữ liệu gốc
                    inputs.forEach(input => {
                        input.value = originalValues[input.id];
                        input.setAttribute("readonly", true);
                    });
                    editButton.style.display = "inline-block";
                    saveButton.style.display = "none";
                    cancelButton.style.display = "none";
                });
                form.addEventListener("submit", function (event) {
                    event.preventDefault();
                    inputs.forEach(input => input.removeAttribute("readonly"));
                    const formData = new FormData(form);
                    fetch("<c:url value='/ManageProduct'/>", {
                        method: "POST",
                        body: new URLSearchParams(formData)
                    })
                            .then(response => response.text())
                            .then(data => {
                                alert("Product updated successfully!");
                                location.reload();
                            })
                            .catch(error => console.error("Error updating product:", error));
                });
                thumbnails.forEach(thumbnail => {
                    thumbnail.addEventListener("click", function () {
                        mainImage.src = this.src;

                        thumbnails.forEach(img => img.classList.remove("active"));

                        this.classList.add("active");
                    });
                });
            });
            document.querySelectorAll(".status-dropdown").forEach(dropdown => {
                dropdown.addEventListener("change", function () {
                    let variantID = this.getAttribute("data-variant-id");
                    let status = this.value === "true";
                    let formData = new URLSearchParams();
                    formData.append("variantID", variantID);
                    formData.append("status", status);
                    formData.append("action", "updateVariantStatus");
                    fetch("<c:url value='/ManageProduct'/>", {
                        method: "POST",
                        body: formData
                    })
                            .then(response => response.text())
                            .then(data => {
                                console.log("Response:", data);
                                if (data.trim() === "Success") {
                                    alert("Status updated successfully!");
                                } else {
                                    alert("Failed to update status");
                                }
                            })
                            .catch(error => console.error("Error updating status:", error));
                });

            });
        </script>
    </body>
</html>
