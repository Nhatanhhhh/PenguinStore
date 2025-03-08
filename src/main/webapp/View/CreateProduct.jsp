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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoeard.css"/>
        <style>
            .form-container {
                width: 500px;
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                text-align: left;
            }

            label {
                font-weight: bold;
                display: block;
                margin: 10px 0 5px;
            }

            input, select, textarea {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 16px;
            }

            textarea {
                resize: vertical;
            }

            .color-container {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .color-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                position: relative;
            }

            .color-box {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                cursor: pointer;
                border: 2px solid transparent;
                transition: border 0.3s ease-in-out;
            }

            .color-checkbox {
                display: none;
            }

            .color-checkbox:checked + .color-box {
                border: 3px solid #000;
            }


            .submit-btn {
                width: 100%;
                background: #28a745;
                color: white;
                border: none;
                padding: 10px;
                font-size: 18px;
                cursor: pointer;
                border-radius: 5px;
                margin-top: 15px;
            }

            .submit-btn:hover {
                background: #218838;
            }
            .size-container {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .size-container label {
                display: flex;
                align-items: center;
                gap: 5px;
                white-space: nowrap;
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
            .modal {
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
            }

            .modal-content button {
                margin: 10px;
                padding: 10px 15px;
                cursor: pointer;
            }
            #productImages {
                display: none;
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

        </style>
    </head>
    <body>
        <%@include file="Admin/HeaderAD.jsp"%>
        <div>
            <div class="row">
                <div class="col-md-3">
                    <%@include file="Admin/NavigationMenu.jsp"%>
                </div>
                <div class="form-container col-md-9">
                    <h2 style="text-align: center;">Create New Product</h2>
                    <form id="create-product-form" action="<c:url value="/ManageProduct?action=create"/>" method="POST" enctype="multipart/form-data" class="create-product-form">
                        <!-- Product Name -->
                        <label for="productName">Product Name:</label>
                        <input type="text" id="productName" name="productName" placeholder="Enter name of product..." required>

                        <!-- Description -->
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" rows="4" required placeholder="Enter description of product..."></textarea>

                        <!-- Price -->
                        <label for="price">Price:</label>
                        <input type="number" id="price" name="price" step="1" min="1" placeholder="Enter price of product (VND)..." required>

                        <!-- Select Category -->
                        <label for="category">Select Category:</label>
                        <select id="category" name="categoryId" required>
                            <option value="">-- Select Category --</option>
                            <option value="Top">Top</option>
                            <option value="Bottom">Bottom</option>
                            <option value="Accessory">Accessory</option>
                        </select>
                        <!-- Select Type  -->
                        <label for="type">Select Type:</label>
                        <select id="type" name="typeId" required disabled="">
                            <option value="">-- Select Type --</option>
                            <c:forEach var="type" items="${listType}">
                                <option value="${type.typeID}" data-category="${type.categoryName}">
                                    ${type.typeName}
                                </option>
                            </c:forEach>
                        </select>
                        <!-- Colors -->
                        <label>Select Colors:</label>
                        <div class="color-container">
                            <c:forEach var="color" items="${listColor}">
                                <div class="color-item">
                                    <!-- Checkbox -->
                                    <input class="color-checkbox" type="checkbox" id="color-${color.colorID}" name="colorIds" value="${color.colorID}">
                                    <label for="color-${color.colorID}" class="color-box" style="background-color: ${color.colorName};"></label>
                                </div>
                            </c:forEach>
                        </div>
                        <!-- Sizes -->
                        <label>Select Sizes:</label>
                        <div class="size-container">
                            <c:forEach var="size" items="${listSize}">
                                <label>
                                    <input type="checkbox" name="sizeIds" value="${size.sizeID}"> ${size.sizeName}
                                </label>
                            </c:forEach>
                        </div>
                        <!-- Upload Multiple Product Images -->
                        <label for="productImages" class="label-upload">+</label>
                        <input type="file" id="productImages" name="productImages" accept="image/*" multiple>

                        <input type="file" id="hiddenFileInput" name="selectedFiles" multiple style="display: none;">
                        <br><br>

                        <div id="previewContainer"></div>
                        <input type="submit" value="Create Product" class="submit-btn" style="width: 150px">
                    </form>
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
                const submitBtn = document.querySelector(".submit-btn");

                submitBtn.addEventListener("click", function (event) {
                    event.preventDefault(); // Ngăn form submit ngay lập tức

                    // Tạo modal động
                    const modal = document.createElement("div");
                    modal.classList.add("modal");
                    modal.innerHTML = `
            <div class="modal-content">
                <p>Please double check all information before creating product (Image, category, size, etc.)?</p>
                <button id="confirm-btn">Confirm</button>
                <button id="cancel-btn">Cancel</button>
            </div>
        `;
                    document.body.appendChild(modal);
                    modal.style.display = "flex";
                    document.getElementById("confirm-btn").addEventListener("click", function () {
                        modal.remove();
                        form.submit();
                    });
                    document.getElementById("cancel-btn").addEventListener("click", function () {
                        modal.remove();
                    });
                });
            });

        </script>

    </body>
</html>
