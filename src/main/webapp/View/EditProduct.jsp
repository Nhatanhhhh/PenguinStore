<%-- 
    Document   : Inventory
    Created on : Feb 28, 2025, 6:52:46 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/styleViewProductDetail.css"/>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
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
            .sale-status-group select {
                font-size: 16px;
                padding: 8px 12px;
                border-radius: 6px;
                border: 2px solid #444;
                width: 150px;
                background-color: #222;
                font-weight: bold;
                cursor: pointer;
            }

            /* Mặc định màu chữ trắng */
            .sale-status-group select {
                color: white;
            }

            .sale-status-group.sale-active select {
                color: #1eff00;
            }

            .sale-status-group.sale-inactive select {
                color: #ff3b3b;
            }
            .thumbnail-container {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }

            .img-wrapper {
                position: relative;
                display: inline-block;
            }

            .thumbnail-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border: 1px solid #ccc;
                border-radius: 5px;
                cursor: pointer;
            }

            .remove-btn {
                position: absolute;
                top: -5px;
                right: -5px;
                background: red;
                color: white;
                border: none;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                font-size: 12px;
                cursor: pointer;
            }

            .label-upload {
                width: 150px;
                height: 150px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: black;
                font-size: 20px;
                cursor: pointer;
                border-radius: 10px;
                border: 2px solid black;
                margin-top: 10px;
            }

            .label-upload:hover {
                opacity: 0.8;
            }

            #layoutSidenav {
                display: flex;
                min-height: 100vh; /* Giữ chiều cao tự động */
            }
            #productImages {
                display: none;
            }
            #previewContainer {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: 10px;
            }

            .img-preview-container {
                position: relative;
                display: inline-block;
            }

            .preview-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border: 1px solid #ccc;
                border-radius: 5px;
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
            <div class="col-md-2 col-sm-12">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10 col-sm-12">
                <%@include file="Admin/HeaderAD.jsp"%>
                <h1 class="text-center" style="margin-top: 10px">Edit Product</h1>
                <div class="container p-3">
                    <h2>Product Images</h2>
                    <div class="container">
                        <div class="row justify-content-center align-items-start text-center">
                            <div class="col-md-7 col-sm-12">
                                <div class="product-images">
                                    <c:if test="${not empty listImg}">
                                        <img id="mainImage" src="Image/Product/${listImg[0].imgName}" class="product-main-img img-fluid" alt="Product Image">
                                    </c:if>
                                    <div class="thumbnail-container d-flex flex-wrap justify-content-center mt-3">
                                        <c:forEach var="img" items="${listImg}">
                                            <div class="img-wrapper position-relative m-2" data-img-id="${img.imgID}">
                                                <img src="Image/Product/${img.imgName}" alt="Thumbnail" class="thumbnail-img" onclick="viewImage(this)">
                                                <button class="remove-btn" onclick="deleteImage('${img.imgID}', this)">X</button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-5 col-sm-12">
                                <h3>Add New Images</h3>
                                <form action="<c:url value='/ManageProduct?action=updateImage&id=${product.productID}'/>" method="POST" enctype="multipart/form-data">
                                    <label for="productImages" class="label-upload">+</label>
                                    <input type="file" id="productImages" name="productImages" accept="image/*" multiple>
                                    <input type="file" id="hiddenFileInput" name="selectedFiles" multiple style="display: none;">
                                    <br><br>
                                    <div id="previewContainer"></div>
                                    <input type="submit" value="Update Image" class="btn btn-dark w-100 h-50">
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center mt-4">
                        <div class="col-lg-6 col-md-8 col-sm-12">
                            <div class="card p-4 shadow">
                                <h2 class="text-center">Product Information</h2>
                                <form id="editProductForm" action="<c:url value='/ManageProduct'/>" method="POST">
                                    <input type="hidden" name="action" value="updateProduct">
                                    <input type="hidden" name="productID" value="${product.productID}">

                                    <div class="form-group">
                                        <label for="productName"><strong>Product Name:</strong></label>
                                        <input type="text" id="productName" name="productName" value="${product.productName}" class="form-control" readonly required>
                                    </div>

                                    <div class="form-group">
                                        <label for="description"><strong>Description:</strong></label>
                                        <textarea id="description" name="description" rows="4" class="form-control" readonly required>${product.description}</textarea>
                                    </div>

                                    <div class="form-group">
                                        <label for="price"><strong>Price:</strong></label>
                                        <input type="number" id="price" name="price" step="1" min="1" value="${product.price}" class="form-control" readonly required>
                                    </div>

                                    <div class="form-group">
                                        <label for="category"><strong>Category:</strong></label>
                                        <input type="text" id="categoryName" name="categoryName" value="${product.categoryName}" class="form-control" readonly>
                                    </div>

                                    <div class="form-group">
                                        <label for="type"><strong>Type:</strong></label>
                                        <input type="text" id="typeName" name="typeName" value="${product.typeName}" class="form-control" readonly>
                                    </div>

                                    <div class="form-group text-center">
                                        <button type="button" id="editProductBtn" class="btn btn-primary btn-sm">Edit</button>
                                        <input type="submit" id="saveProductBtn" class="btn btn-success btn-sm" value="Save" style="display: none; width: 50px; height: 30px">
                                        <button type="button" id="cancelEditBtn" class="btn btn-secondary btn-sm" style="display: none; height: 30px; margin-top: 5px;">Cancel</button>
                                    </div>
                                </form>
                                <div class="form-group text-center">
                                    <label for="isSale"><strong>Sale Status:</strong></label>
                                    <select id="isSale" name="isSale" class="form-control d-inline-block w-auto">
                                        <option value="true" ${product.isSale ? 'selected' : ''}>On Sale</option>
                                        <option value="false" ${!product.isSale ? 'selected' : ''}>Not On Sale</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h2 class="mt-4 text-center">Product Variants</h2>
                    <div class="table-responsive">
                        <table class="table table-bordered table-sm text-center" style="max-width: 600px; margin: auto;">
                            <thead class="table-dark">
                                <tr>
                                    <th>Color</th>
                                        <c:if test="${not empty productDetail[0].sizeName}">
                                        <th>Size</th>
                                        </c:if>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="variant" items="${productDetail}">
                                    <tr>
                                        <td>
                                            <div style="width: 20px; height: 20px; border-radius: 50%; border: 1px solid gray; background-color: ${variant.colorName}; margin: auto;"></div>
                                        </td>
                                        <c:if test="${not empty variant.sizeName}">
                                            <td>${variant.sizeName}</td>
                                        </c:if>
                                        <td>${variant.stockQuantity}</td>
                                        <td>
                                            <select class="status-dropdown form-control form-control-sm" data-variant-id="${variant.proVariantID}">
                                                <option value="true" ${variant.status ? 'selected' : ''}>In Stock</option>
                                                <option value="false" ${!variant.status ? 'selected' : ''}>Out of Stock</option>
                                            </select>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                    </div>
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
                const isSaleDropdown = document.getElementById("isSale");
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
                    const priceInput = document.getElementById("price").value.trim();
                    const productNameInput = document.getElementById("productName").value.trim();
                    if (!/^\d+$/.test(priceInput) || priceInput === "") {
                        alert("Product price must be a positive integer and must not contain special characters!");
                        return;
                    }
                    inputs.forEach(input => input.removeAttribute("readonly"));
                    const formData = new FormData(form);
                    fetch("<c:url value='/ManageProduct'/>", {
                        method: "POST",
                        body: new URLSearchParams(formData)
                    })
                            .then(response => response.text())
                            .then(data => {
                                if (data.trim() === "DuplicateName") {
                                    alert("The product name already exists. Please choose a different name.");
                                } else if (data.trim() === "InvalidPrice") {
                                    alert("Product price must be a positive integer!");
                                } else if (data.trim() === "Success") {
                                    alert("Product updated successfully!");
                                    location.reload();
                                } else {
                                    alert("Error updating product. Please try again.");
                                }
                            })
                            .catch(error => {
                                console.error("Error updating product:", error);
                                alert("An error occurred while sending the request. Please try again!");
                            });
                });
                thumbnails.forEach(thumbnail => {
                    thumbnail.addEventListener("click", function () {
                        mainImage.src = this.src;

                        thumbnails.forEach(img => img.classList.remove("active"));

                        this.classList.add("active");
                    });
                });
                isSaleDropdown.addEventListener("change", function () {
                    let newStatus = this.value === "true";
                    let confirmation = confirm(`Are you sure you want to change the sale status to ${newStatus ? "On Sale" : "Not On Sale"}?`);

                    if (!confirmation) {
                        this.value = this.value === "true" ? "false" : "true";
                        return;
                    }

                    let formData = new URLSearchParams();
                    formData.append("productID", "${product.productID}");
                    formData.append("isSale", newStatus);
                    formData.append("action", "updateSaleStatus");

                    fetch("<c:url value='/ManageProduct'/>", {
                        method: "POST",
                        body: formData
                    })
                            .then(response => response.text())
                            .then(data => {
                                if (data.trim() === "Success") {
                                    alert("Sale status updated successfully!");
                                } else {
                                    alert("Failed to update sale status.");
                                    this.value = this.value === "true" ? "false" : "true"; // Khôi phục trạng thái nếu lỗi
                                }
                            })
                            .catch(error => {
                                console.error("Error updating sale status:", error);
                                this.value = this.value === "true" ? "false" : "true"; // Khôi phục trạng thái nếu lỗi
                            });
                });
                let priceInput = document.getElementById("price");
                let priceValue = parseFloat(priceInput.value);
                if (Number.isInteger(priceValue)) {
                    priceInput.value = priceValue;
                }
            });
            function deleteImage(imgID, btnElement) {
                if (confirm("Are you sure you want to delete this image?")) {
                    fetch("ManageProduct?action=deleteImage", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: "imgID=" + encodeURIComponent(imgID)
                    })
                            .then(response => response.text())
                            .then(result => {
                                if (result.trim() === "success") {
                                    // Xóa ảnh khỏi giao diện
                                    let imgWrapper = btnElement.closest(".img-wrapper");
                                    imgWrapper.remove();

                                    // Nếu ảnh bị xóa là ảnh đang hiển thị lớn, cập nhật ảnh lớn mới
                                    let mainImage = document.getElementById("mainImage");
                                    if (mainImage.src === imgWrapper.querySelector(".thumbnail-img").src) {
                                        let remainingImages = document.querySelectorAll(".thumbnail-container .thumbnail-img");
                                        if (remainingImages.length > 0) {
                                            mainImage.src = remainingImages[0].src; // Chọn ảnh đầu tiên còn lại
                                        } else {
                                            mainImage.src = ""; // Không còn ảnh nào
                                        }
                                    }
                                } else {
                                    alert("Failed to delete image.");
                                }
                            })
                            .catch(error => console.error("Error deleting image:", error));
                }
            }
            document.getElementById("productImages").addEventListener("change", function (event) {
                let files = event.target.files;
                let previewContainer = document.getElementById("previewContainer");
                let hiddenFileInput = document.getElementById("hiddenFileInput");

                let dataTransfer = new DataTransfer();

                Array.from(hiddenFileInput.files).forEach(file => dataTransfer.items.add(file));

                Array.from(files).forEach(file => {
                    if (file.type.startsWith("image/")) {
                        let reader = new FileReader();

                        reader.onload = function (e) {
                            let imgContainer = document.createElement("div");
                            imgContainer.classList.add("img-preview-container");

                            let img = document.createElement("img");
                            img.src = e.target.result;
                            img.classList.add("preview-image");

                            let removeBtn = document.createElement("button");
                            removeBtn.innerHTML = "X";
                            removeBtn.classList.add("remove-btn");

                            removeBtn.onclick = function () {
                                imgContainer.remove();

                                let newFileList = Array.from(dataTransfer.files).filter(f => f.name !== file.name);
                                let newDataTransfer = new DataTransfer();
                                newFileList.forEach(f => newDataTransfer.items.add(f));

                                hiddenFileInput.files = newDataTransfer.files;
                            };

                            imgContainer.appendChild(img);
                            imgContainer.appendChild(removeBtn);
                            previewContainer.appendChild(imgContainer);
                        };

                        reader.readAsDataURL(file);
                        dataTransfer.items.add(file);
                    } else {
                        alert("Only file image!");
                    }
                });

                hiddenFileInput.files = dataTransfer.files;

                event.target.value = "";
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
            document.getElementById("price").addEventListener("keypress", function (event) {
                if (!/[0-9]/.test(event.key)) {
                    event.preventDefault();
                }
            });
        </script>
    </body>
</html>