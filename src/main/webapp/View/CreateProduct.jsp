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
                border: 3px solid gray;
                transition: border 0.3s ease-in-out;
            }

            .color-checkbox {
                display: none;
            }

            .color-checkbox:checked + .color-box {
                border: 4px solid #000;
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

            #layoutSidenav {
                display: flex;
                min-height: 100vh; /* Giữ chiều cao tự động */
            }

            /* Sidebar Navigation */
            .col-md-2 {
                display: flex;
                flex-direction: column; /* Giúp navigation tự động mở rộng */
                flex-grow: 1;
                min-height: 100vh; /* Luôn chiếm toàn bộ chiều cao màn hình */
                padding-right: 0;
            }

            /* Content Section */
            .col-md-10 {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                padding-left: 0 !important;
                margin-left: 0 !important;
                padding-right: 0 !important; /* Đảm bảo padding right bằng 0 */
            }


            .content {
                flex-grow: 1;
                overflow: auto; /* Giữ nội dung cuộn khi cần */
                padding: 20px; /* Thêm khoảng cách cho đẹp */
            }

            #feedbackTable thead {
                background-color: #343a40 !important;
                color: white !important;
            }

            #feedbackTable th {
                text-align: center !important;
                vertical-align: middle !important;
            }

            .text-success {
                color: green !important;
                font-weight: bold !important;
            }

            .text-danger {
                color: red !important;
                font-weight: bold !important;
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
                <div class="col-md-2">
                    <%@include file="Admin/NavigationMenu.jsp"%>
                </div>
                <div class="form-container-fluid col-md-10">
                    <%@include file="Admin/HeaderAD.jsp"%>
                    <h2 style="text-align: center;">Create New Product</h2>
                    <div class="d-flex justify-content-center mt-4">
                        <form style="min-width: 50vw;" id="create-product-form" action="<c:url value="/ManageProduct?action=create"/>" method="POST" 
                              enctype="multipart/form-data" class="create-product-form">
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
                        errorMessage += "- Please enter at least one product image.\n";
                        isValid = false;
                    }
                    if (colorsChecked === 0) {
                        errorMessage += "- Please select at least one color of product.\n";
                        isValid = false;
                    }

                    if (category !== "Accessory" && sizesChecked === 0) {
                        errorMessage += "- Please select at leat one size of product.\n";
                        isValid = false;
                    }

                    // Nếu có lỗi, hiển thị alert và không submit form
                    if (!isValid) {
                        alert("Please check value of product:\n" + errorMessage);
                        return;
                    }

                    // Nếu dữ liệu hợp lệ, hiển thị modal xác nhận
                    const modal = document.createElement("div");
                    modal.classList.add("modal");
                    modal.style.position = "fixed";
                    modal.style.top = "0";
                    modal.style.left = "0";
                    modal.style.width = "100%";
                    modal.style.height = "100%";
                    modal.style.backgroundColor = "rgba(0,0,0,0.5)";
                    modal.style.display = "flex";
                    modal.style.alignItems = "center";
                    modal.style.justifyContent = "center";
                    modal.innerHTML = `
                <div class="modal-content" style="background: white; padding: 20px; border-radius: 8px; text-align: center;">
                    <p>Please double check all information before creating product.</p>
                    <button id="confirm-btn">Confirm</button>
                    <button id="cancel-btn">Cancel</button>
                </div>
            `;
                    document.body.appendChild(modal);

                    // Xác nhận submit form
                    document.getElementById("confirm-btn").addEventListener("click", function () {
                        modal.remove();
                        form.submit();
                    });

                    // Hủy bỏ modal
                    document.getElementById("cancel-btn").addEventListener("click", function () {
                        modal.remove();
                    });
                });
            });
        </script>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
