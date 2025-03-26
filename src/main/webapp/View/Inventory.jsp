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
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <style>


            .product-images {
                flex: 1;
                max-width: 400px; /* Định kích thước tối đa cho ảnh */

            }

            .thumbnail-container {
                display: flex;
                gap: 10px;
                justify-content: center;
                flex-wrap: wrap;
            }

            .img-wrapper {
                border: 1px solid #ddd;
                padding: 5px;
                border-radius: 5px;
            }

            .thumbnail-img {
                width: 80px;
                height: 80px;
                cursor: pointer;
                object-fit: cover;
            }

            .product-main-img {
                width: 300px;
                height: 300px;
                margin-top: 20px;
                border-radius: 8px;
                object-fit: cover;
            }

            .product-details {
                flex: 1;
                max-width: 400px;
                text-align: left;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                font-weight: bold;
                display: block;
            }

            .form-group p {
                margin: 5px 0 0;
                font-size: 16px;
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

            .sale-status-group select {
                color: white;
            }

            .sale-status-group.sale-active select {
                color: #1eff00;
            }

            .sale-status-group.sale-inactive select {
                color: #ff3b3b;
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
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-7">
                                <div class="product-images d-flex justify-content-between">
                                    <div class="thumbnail-container d-flex flex-column me-3">
                                        <c:forEach var="img" items="${listImg}">
                                            <div class="img-wrapper mb-2" data-img-id="${img.imgID}">
                                                <img src="Image/Product/${img.imgName}" alt="Thumbnail" class="thumbnail-img img-thumbnail" onclick="viewImage(this)">
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <c:if test="${not empty listImg}">
                                        <div class="main-image-container ms-auto">
                                            <img id="mainImage" src="Image/Product/${listImg[0].imgName}" class="product-main-img img-fluid" alt="Product Image">
                                        </div>
                                    </c:if>
                                </div>
                            </div>


                            <div class="col-md-5">
                                <div class="product-details p-3 border rounded shadow-sm">
                                    <h2 class="mb-3">Product Information</h2>
                                    <div class="form-group">
                                        <label><strong>Product Name:</strong></label>
                                        <p class="text-muted">${product.productName}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Description:</strong></label>
                                        <p class="text-muted">${product.description}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Price:</strong></label>
                                        <p class="text-muted">${product.price}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Category:</strong></label>
                                        <p class="text-muted">${product.categoryName}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Type:</strong></label>
                                        <p class="text-muted">${product.typeName}</p>
                                    </div>
                                    <div class="form-group sale-status-group">
                                        <label><strong>Sale Status:</strong></label>
                                        <p class="text-muted">${product.isSale ? 'On Sale' : 'Not On Sale'}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h2 class="mt-4">Product Variants</h2>
                    <table class="table table-bordered text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Color</th>
                                    <c:if test="${not empty productDetail[0].sizeName}">
                                    <th>Size</th>
                                    </c:if>
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
                                    <c:if test="${not empty variant.sizeName}">
                                        <td>${variant.sizeName}</td>
                                    </c:if>
                                    <td>${variant.stockQuantity}</td>
                                    <td class="${variant.status ? 'text-success' : 'text-danger'}">
                                        ${variant.status ? 'In Stock' : 'Out of Stock'}
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

        </script>
    </body>
</html>