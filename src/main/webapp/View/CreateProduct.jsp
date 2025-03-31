<%-- 
    Document   : CreateProduct
    Created on : Feb 24, 2025, 9:32:57 PM
    Author     : Huynh Cong Nghiem - CE181351
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Product</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            .form-container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }

            .form-title {
                color: var(--primary-color);
                text-align: center;
                margin-bottom: 30px;
                font-weight: 600;
                position: relative;
                padding-bottom: 15px;
            }

            .form-title:after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background: var(--accent-color);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                font-weight: 600;
                color: var(--dark-gray);
                margin-bottom: 8px;
                display: block;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 16px;
                transition: all 0.3s;
            }

            .form-control:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
                outline: none;
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .color-container, .size-container {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 10px;
            }

            .color-item {
                position: relative;
            }

            .color-checkbox {
                position: absolute;
                opacity: 0;
            }

            .color-label {
                display: block;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                cursor: pointer;
                border: 3px solid #ddd;
                transition: all 0.2s;
            }

            .color-checkbox:checked + .color-label {
                border-color: var(--primary-color);
                transform: scale(1.1);
            }

            .size-label {
                display: flex;
                align-items: center;
                padding: 8px 15px;
                background: var(--light-gray);
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.2s;
            }

            .size-checkbox {
                margin-right: 8px;
            }

            .size-label:hover, .size-checkbox:checked + .size-label {
                background: var(--secondary-color);
                color: white;
            }

            .image-upload-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                margin: 20px 0;
            }

            .upload-label {
                width: 150px;
                height: 150px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background: var(--light-gray);
                border: 2px dashed #ccc;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .upload-label:hover {
                border-color: var(--secondary-color);
                background: rgba(52, 152, 219, 0.05);
            }

            .upload-icon {
                font-size: 40px;
                color: var(--secondary-color);
                margin-bottom: 10px;
            }

            .upload-text {
                font-size: 14px;
                color: var(--dark-gray);
                text-align: center;
            }

            #previewContainer {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 20px;
            }

            .preview-item {
                position: relative;
                width: 120px;
                height: 120px;
            }

            .preview-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #eee;
            }

            .remove-btn {
                position: absolute;
                top: -8px;
                right: -8px;
                width: 25px;
                height: 25px;
                background: var(--accent-color);
                color: white;
                border: none;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 12px;
                transition: all 0.2s;
            }

            .remove-btn:hover {
                transform: scale(1.1);
            }

            .submit-btn {
                background: var(--primary-color);
                color: white;
                border: none;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s;
                display: block;
                margin: 30px auto 0;
                width: 200px;
                text-align: center;
            }

            .submit-btn:hover {
                background: #1a252f;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            .modal-content {
                background: white;
                padding: 30px;
                border-radius: 10px;
                max-width: 500px;
                width: 90%;
                text-align: center;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .modal-title {
                font-size: 20px;
                margin-bottom: 20px;
                color: var(--primary-color);
            }

            .modal-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 20px;
            }

            .modal-btn {
                padding: 10px 25px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.2s;
            }

            .confirm-btn {
                background: var(--primary-color);
                color: white;
                border: none;
            }

            .confirm-btn:hover {
                background: #1a252f;
            }

            .cancel-btn {
                background: white;
                color: var(--dark-gray);
                border: 1px solid #ddd;
            }

            .cancel-btn:hover {
                background: #f8f9fa;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .form-container {
                    padding: 20px;
                }

                .color-container, .size-container {
                    gap: 10px;
                }

                .color-label {
                    width: 35px;
                    height: 35px;
                }

                .size-label {
                    padding: 6px 12px;
                    font-size: 14px;
                }
            }
        </style>
    </head>
    <body>
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <div>
            <div class="row">
                <div class="col-md-2" style="padding: 0;">
                    <%@include file="Admin/NavigationMenu.jsp"%>
                </div>
                <div class="col-md-10" style="padding: 0;">
                    <%@include file="Admin/HeaderAD.jsp"%>
                    <div class="container py-5">
                        <div class="form-container">
                            <h2 class="form-title">Create New Product</h2>
                            <form id="create-product-form" action="<c:url value="/ManageProduct?action=create"/>" method="POST" 
                                  enctype="multipart/form-data">
                                <!-- Product Name -->
                                <div class="form-group">
                                    <label for="productName" class="form-label">Product Name</label>
                                    <input type="text" id="productName" name="productName" class="form-control" 
                                           placeholder="Enter product name" required>
                                </div>

                                <!-- Description -->
                                <div class="form-group">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea id="description" name="description" class="form-control" 
                                              rows="4" required placeholder="Enter product description"></textarea>
                                </div>

                                <!-- Price -->
                                <div class="form-group">
                                    <label for="price" class="form-label">Price (VND)</label>
                                    <input type="number" id="price" name="price" class="form-control" 
                                           step="1" min="1" placeholder="Enter product price" required>
                                </div>

                                <!-- Select Category -->
                                <div class="form-group">
                                    <label for="category" class="form-label">Category</label>
                                    <select id="category" name="categoryId" class="form-control" required style="height: 50px;">
                                        <option value="">-- Select Category --</option>
                                        <option value="Top">Top</option>
                                        <option value="Bottom">Bottom</option>
                                        <option value="Accessory">Accessory</option>
                                    </select>
                                </div>

                                <!-- Select Type -->
                                <div class="form-group">
                                    <label for="type" class="form-label">Type</label>
                                    <select id="type" name="typeId" class="form-control" required disabled style="height: 50px;">
                                        <option value="">-- Select Type --</option>
                                        <c:forEach var="type" items="${listType}">
                                            <option value="${type.typeID}" data-category="${type.categoryName}">
                                                ${type.typeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Colors -->
                                <div class="form-group">
                                    <label class="form-label">Colors</label>
                                    <div class="color-container">
                                        <c:forEach var="color" items="${listColor}">
                                            <div class="color-item">
                                                <input class="color-checkbox" type="checkbox" id="color-${color.colorID}" 
                                                       name="colorIds" value="${color.colorID}">
                                                <label for="color-${color.colorID}" class="color-label" 
                                                       style="background-color: ${color.colorName};"></label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Sizes -->
                                <div class="form-group">
                                    <label class="form-label">Sizes</label>
                                    <div class="size-container">
                                        <c:forEach var="size" items="${listSize}">
                                            <input type="checkbox" id="size-${size.sizeID}" name="sizeIds" 
                                                   value="${size.sizeID}" class="size-checkbox">
                                            <label for="size-${size.sizeID}" class="size-label">${size.sizeName}</label>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Image Upload -->
                                <div class="form-group">
                                    <label class="form-label">Product Images</label>
                                    <div class="image-upload-container">
                                        <label for="productImages" class="upload-label">
                                            <i class="fas fa-cloud-upload-alt upload-icon"></i>
                                            <span class="upload-text">Click to upload images</span>
                                        </label>
                                        <input type="file" id="productImages" name="productImages" accept="image/*" multiple style="display: none;">
                                        <input type="file" id="hiddenFileInput" name="selectedFiles" multiple style="display: none;">
                                    </div>
                                    <div id="previewContainer"></div>
                                </div>

                                <button type="submit" class="submit-btn">Create Product</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
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
                            let previewItem = document.createElement("div");
                            previewItem.classList.add("preview-item");

                            let img = document.createElement("img");
                            img.src = e.target.result;
                            img.classList.add("preview-image");

                            let removeBtn = document.createElement("button");
                            removeBtn.innerHTML = "×";
                            removeBtn.classList.add("remove-btn");

                            removeBtn.onclick = function () {
                                previewItem.remove();

                                let newFileList = Array.from(dataTransfer.files).filter(f => f.name !== file.name);
                                let newDataTransfer = new DataTransfer();
                                newFileList.forEach(f => newDataTransfer.items.add(f));

                                hiddenFileInput.files = newDataTransfer.files;
                            };

                            previewItem.appendChild(img);
                            previewItem.appendChild(removeBtn);
                            previewContainer.appendChild(previewItem);
                        };

                        reader.readAsDataURL(file);
                        dataTransfer.items.add(file);
                    } else {
                        alert("Only image files are allowed!");
                    }
                });

                hiddenFileInput.files = dataTransfer.files;
                event.target.value = "";
            });

            document.getElementById("category").addEventListener("change", function () {
                let selectedCategory = this.value;
                let typeDropdown = document.getElementById("type");
                let typeOptions = typeDropdown.getElementsByTagName("option");

                if (selectedCategory) {
                    typeDropdown.disabled = false;
                } else {
                    typeDropdown.disabled = true;
                    typeDropdown.value = "";
                    return;
                }

                typeDropdown.value = "";
                for (let i = 1; i < typeOptions.length; i++) {
                    let option = typeOptions[i];
                    let optionCategory = option.getAttribute("data-category");

                    if (optionCategory === selectedCategory) {
                        option.style.display = "block";
                    } else {
                        option.style.display = "none";
                    }
                }
            });

            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("create-product-form");
                const submitBtn = form.querySelector(".submit-btn");

                submitBtn.addEventListener("click", function (event) {
                    event.preventDefault();

                    // Kiểm tra dữ liệu nhập vào
                    let isValid = true;
                    let errorMessage = "";

                    let productName = document.getElementById("productName").value.trim();
                    let description = document.getElementById("description").value.trim();
                    let price = document.getElementById("price").value.trim();
                    let category = document.getElementById("category").value;
                    let type = document.getElementById("type").value;
                    let images = document.getElementById("hiddenFileInput").files.length;
                    let colorsChecked = document.querySelectorAll(".color-checkbox:checked").length;
                    let sizesChecked = document.querySelectorAll("input[name='sizeIds']:checked").length;

                    if (!productName) {
                        errorMessage += "- Product name can't be blank.\n";
                        isValid = false;
                    }
                    if (!description) {
                        errorMessage += "- Description of product can't be blank.\n";
                        isValid = false;
                    }
                    if (!price || isNaN(price) || price <= 0) {
                        errorMessage += "- Price must be greater than 0 and must be an integer.\n";
                        isValid = false;
                    }
                    if (!category) {
                        errorMessage += "- Please choose category of product.\n";
                        isValid = false;
                    }
                    if (!type) {
                        errorMessage += "- Please choose type of product.\n";
                        isValid = false;
                    }
                    if (images === 0) {
                        errorMessage += "- Please upload at least one product image.\n";
                        isValid = false;
                    }
                    if (colorsChecked === 0) {
                        errorMessage += "- Please select at least one color.\n";
                        isValid = false;
                    }

                    if (category !== "Accessory" && sizesChecked === 0) {
                        errorMessage += "- Please select at least one size.\n";
                        isValid = false;
                    }

                    if (!isValid) {
                        alert("Please check the following:\n" + errorMessage);
                        return;
                    }

                    // Hiển thị modal xác nhận
                    const modal = document.createElement("div");
                    modal.classList.add("modal");
                    modal.innerHTML = `
                        <div class="modal-content">
                            <h3 class="modal-title">Confirm Product Creation</h3>
                            <p>Please review all information before creating the product.</p>
                            <div class="modal-buttons">
                                <button class="modal-btn confirm-btn">Confirm</button>
                                <button class="modal-btn cancel-btn">Cancel</button>
                            </div>
                        </div>
                    `;
                    document.body.appendChild(modal);

                    document.querySelector(".confirm-btn").addEventListener("click", function () {
                        modal.remove();
                        form.submit();
                    });

                    document.querySelector(".cancel-btn").addEventListener("click", function () {
                        modal.remove();
                    });
                });
            });
        </script>

        
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>