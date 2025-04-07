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
                // Lấy các phần tử DOM một lần để tái sử dụng
                const editButton = document.getElementById("editProductBtn");
                const saveButton = document.getElementById("saveProductBtn");
                const cancelButton = document.getElementById("cancelEditBtn");
                const form = document.getElementById("editProductForm");
                const inputs = document.querySelectorAll("#productName, #description, #price");
                const thumbnails = document.querySelectorAll(".thumbnail-container img");
                const isSaleDropdown = document.getElementById("isSale");
                const mainImage = document.getElementById("mainImage");
                const productImagesInput = document.getElementById("productImages");
                const previewContainer = document.getElementById("previewContainer");
                const hiddenFileInput = document.getElementById("hiddenFileInput");
                const statusDropdowns = document.querySelectorAll(".status-dropdown");

                let originalValues = {};

                // Hàm bật/tắt chế độ chỉnh sửa
                function toggleEditMode(isEditing) {
                    inputs.forEach(input => {
                        originalValues[input.id] = originalValues[input.id] || input.value;
                        input.readOnly = !isEditing;
                    });
                    editButton.style.display = isEditing ? "none" : "inline-block";
                    saveButton.style.display = isEditing ? "inline-block" : "none";
                    cancelButton.style.display = isEditing ? "inline-block" : "none";
                }

                // Xử lý nút Edit
                editButton.addEventListener("click", () => toggleEditMode(true));

                // Xử lý nút Cancel
                cancelButton.addEventListener("click", () => {
                    inputs.forEach(input => input.value = originalValues[input.id]);
                    toggleEditMode(false);
                });

                // Xử lý submit form
                form.addEventListener("submit", function (event) {
                    event.preventDefault();
                    const price = document.getElementById("price").value.trim();
                    const productName = document.getElementById("productName").value.trim();

                    if (!/^\d+$/.test(price) || price === "" || parseInt(price) <= 0) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid Price',
                            text: 'Price must be a positive integer!'
                        });
                        return;
                    }

                    const formData = new FormData(form);
                    fetch("<c:url value='/ManageProduct'/>", {
                        method: "POST",
                        body: new URLSearchParams(formData)
                    })
                            .then(response => response.text())
                            .then(data => {
                                const trimmedData = data.trim();
                                if (trimmedData === "DuplicateName") {
                                    Swal.fire({icon: 'error', title: 'Duplicate Name', text: 'Product name already exists.'});
                                } else if (trimmedData === "InvalidPrice") {
                                    Swal.fire({icon: 'error', title: 'Invalid Price', text: 'Price must be a positive integer!'});
                                } else if (trimmedData === "Success") {
                                    Swal.fire({icon: 'success', title: 'Success!', text: 'Product updated successfully!', timer: 1500, showConfirmButton: false})
                                            .then(() => location.reload());
                                } else {
                                    Swal.fire({icon: 'error', title: 'Error', text: 'Error updating product.'});
                                }
                            })
                            .catch(error => {
                                console.error("Error:", error);
                                Swal.fire({icon: 'error', title: 'Error', text: 'Failed to send request. Please try again.'});
                            });
                });

                // Xử lý click thumbnail
                thumbnails.forEach(thumbnail => {
                    thumbnail.addEventListener("click", function () {
                        mainImage.src = this.src;
                        thumbnails.forEach(img => img.classList.remove("active"));
                        this.classList.add("active");
                    });
                });

                // Xử lý thay đổi trạng thái sale
                isSaleDropdown.addEventListener("change", function () {
                    const newStatus = this.value === "true";
                    Swal.fire({
                        title: 'Confirm Status Change',
                        text: `Are you sure you want to change the sale status to ${newStatus ? "On Sale" : "Not On Sale"}?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, change it!'
                    }).then(result => {
                        if (result.isConfirmed) {
                            const saleFormData = new URLSearchParams({
                                action: "updateSaleStatus",
                                productID: form.querySelector("[name='productID']").value,
                                isSale: newStatus
                            });
                            fetch("<c:url value='/ManageProduct'/>", {
                                method: "POST",
                                body: saleFormData
                            })
                                    .then(response => response.text())
                                    .then(data => {
                                        if (data.trim() === "Success") {
                                            Swal.fire({icon: 'success', title: 'Success!', text: 'Sale status updated!', timer: 1500, showConfirmButton: false});
                                        } else {
                                            this.value = newStatus ? "false" : "true";
                                            Swal.fire({icon: 'error', title: 'Error', text: 'Failed to update sale status.'});
                                        }
                                    })
                                    .catch(error => {
                                        this.value = newStatus ? "false" : "true";
                                        Swal.fire({icon: 'error', title: 'Error', text: 'Failed to send request.'});
                                    });
                        } else {
                            this.value = newStatus ? "false" : "true";
                        }
                    });
                });

                // Xử lý xóa ảnh
                window.deleteImage = function (imgID, btnElement) { // Đặt trong window để gọi từ HTML
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, delete it!'
                    }).then(result => {
                        if (result.isConfirmed) {
                            fetch("ManageProduct?action=deleteImage", {
                                method: "POST",
                                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                body: "imgID=" + encodeURIComponent(imgID)
                            })
                                    .then(response => response.text())
                                    .then(result => {
                                        if (result.trim() === "success") {
                                            const imgWrapper = btnElement.closest(".img-wrapper");
                                            imgWrapper.remove();
                                            if (mainImage.src === imgWrapper.querySelector(".thumbnail-img").src) {
                                                const remainingImages = document.querySelectorAll(".thumbnail-container .thumbnail-img");
                                                mainImage.src = remainingImages.length > 0 ? remainingImages[0].src : "";
                                            }
                                            Swal.fire({icon: 'success', title: 'Deleted!', text: 'Image deleted.', timer: 1500, showConfirmButton: false});
                                        } else {
                                            Swal.fire({icon: 'error', title: 'Error', text: 'Failed to delete image.'});
                                        }
                                    });
                        }
                    });
                };

                // Xử lý xem trước ảnh
                productImagesInput.addEventListener("change", function (event) {
                    const files = event.target.files;
                    const dataTransfer = new DataTransfer();
                    Array.from(hiddenFileInput.files).forEach(file => dataTransfer.items.add(file));

                    Array.from(files).forEach(file => {
                        if (file.type.startsWith("image/")) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const imgContainer = document.createElement("div");
                                imgContainer.classList.add("img-preview-container");
                                imgContainer.innerHTML = `
                        <img src="${e.target.result}" class="preview-image">
                        <button class="remove-btn">X</button>
                    `;
                                imgContainer.querySelector(".remove-btn").onclick = () => {
                                    imgContainer.remove();
                                    const newFileList = Array.from(dataTransfer.files).filter(f => f.name !== file.name);
                                    dataTransfer.files = newFileList;
                                    hiddenFileInput.files = dataTransfer.files;
                                };
                                previewContainer.appendChild(imgContainer);
                            };
                            reader.readAsDataURL(file);
                            dataTransfer.items.add(file);
                        } else {
                            Swal.fire({icon: 'error', title: 'Invalid File', text: 'Only image files are allowed!'});
                        }
                    });
                    hiddenFileInput.files = dataTransfer.files;
                    event.target.value = "";
                });

                // Xử lý thay đổi trạng thái biến thể
                statusDropdowns.forEach(dropdown => {
                    dropdown.addEventListener("change", function () {
                        const variantID = this.getAttribute("data-variant-id");
                        const status = this.value === "true";
                        const formData = new URLSearchParams({
                            variantID: variantID,
                            status: status,
                            action: "updateVariantStatus"
                        });

                        fetch("<c:url value='/ManageProduct'/>", {
                            method: "POST",
                            body: formData
                        })
                                .then(response => response.text())
                                .then(data => {
                                    if (data.trim() === "Success") {
                                        Swal.fire({icon: 'success', title: 'Success!', text: 'Status updated!', timer: 1500, showConfirmButton: false});
                                    } else {
                                        Swal.fire({icon: 'error', title: 'Error', text: 'Failed to update status.'});
                                    }
                                })
                                .catch(error => {
                                    Swal.fire({icon: 'error', title: 'Error', text: 'Failed to send request.'});
                                });
                    });
                });

                // Validation cho input price
                document.getElementById("price").addEventListener("input", function (event) {
                    this.value = this.value.replace(/[^0-9]/g, "");
                });
            });
        </script>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>