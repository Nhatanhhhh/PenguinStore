<%@page import="Models.Size"%>
<%@page import="java.util.List, Models.Feedback, Models.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/feedback.css"/>

        <style>
            .rating {
                display: flex;
                justify-content: center;
                flex-direction: row-reverse; /* Sao từ trái sang phải */
                gap: 5px;
                font-size: 30px;
                cursor: pointer;
            }

            .rating input {
                display: none;
            }

            .rating label {
                color: #ccc;
                transition: color 0.3s, transform 0.2s;
                cursor: pointer;
            }

            .rating label:hover,
            .rating label:hover ~ label {
                color: gold;
                transform: scale(1.2);
            }

            .rating input:checked ~ label {
                color: gold;
            }


            .submit-btn {
                width: 100%;
                padding: 10px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                background-color: #000;
                color: white;
                cursor: not-allowed;
                opacity: 0.5;
                transition: opacity 0.3s, background-color 0.3s;
            }

            .submit-btn.active {
                opacity: 1;
                cursor: pointer;
                background-color: #198754;
            }

            .submit-btn.active:hover {
                background-color: #145c32;
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h1 class="text-center mb-4" style="font-size: 35px;">Feedback</h1>

        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType}">
                ${sessionScope.message}
            </div>
            <% session.removeAttribute("message");
                session.removeAttribute("messageType");%>
        </c:if>

        <div class="container mt-4 mb-4 pb-4">
            <c:choose>
                <c:when test="${not empty productList}">
                    <c:forEach var="product" items="${productList}">
                        <div class="card p-3 mb-3">
                            <div class="row">
                                <div class="col-md-2">
                                    <img src="<%= request.getContextPath()%>/Image/Product/${product.imgName}" 
                                         class="img-fluid rounded" alt="Product Image">
                                </div>
                                <div class="col-md-8">
                                    <h5><strong>${product.productName}</strong></h5>
                                    <p>Size: <strong>${product.sizeName}</strong></p>
                                    <p>Price: <strong>${product.price}</strong></p>
                                </div>
                            </div>
                        </div>

                        <!-- Form để submit đánh giá -->
                        <form action="<%= request.getContextPath()%>/CreateFeedback" method="POST" class="feedback-form">
                            <input type="hidden" name="productID" value="${product.productID}">
                            <input type="hidden" name="orderID" value="${product.orderID}">

                            <!-- Chọn số sao -->
                            <div class="text-center mb-3">
                                <label>Rate this product:</label>
                                <div class="rating">
                                    <input type="radio" name="rating-${product.productID}" id="star1-${product.productID}" value="1">
                                    <label for="star1-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star2-${product.productID}" value="2">
                                    <label for="star2-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star3-${product.productID}" value="3">
                                    <label for="star3-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star4-${product.productID}" value="4">
                                    <label for="star4-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star5-${product.productID}" value="5">
                                    <label for="star5-${product.productID}">★</label>
                                </div>
                            </div>

                            <!-- Nhập đánh giá -->
                            <div class="form-group">
                                <textarea id="review-${product.productID}" name="review" rows="4"
                                          class="form-control review-input" placeholder="Write your review here..."></textarea>
                            </div>

                            <button type="submit" class="submit-btn mt-3" disabled>Submit Feedback</button>
                        </form>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-center">No products found for this order.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let forms = document.querySelectorAll(".feedback-form");

                forms.forEach(form => {
                    let stars = form.querySelectorAll(".rating input");
                    let submitBtn = form.querySelector(".submit-btn");
                    let reviewInput = form.querySelector(".review-input");

                    function checkFormValidity() {
                        let selectedRating = form.querySelector(".rating input:checked");
                        let reviewText = reviewInput.value.trim();
                        let isValid = selectedRating && reviewText.length >= 10; // Ít nhất 10 ký tự để gửi

                        console.log("Checking form validity...");
                        console.log("Selected Rating: ", selectedRating ? selectedRating.value : "None");
                        console.log("Review Length: ", reviewText.length);

                        if (isValid) {
                            submitBtn.disabled = false;
                            submitBtn.classList.add("active");
                        } else {
                            submitBtn.disabled = true;
                            submitBtn.classList.remove("active");
                        }
                    }

                    stars.forEach(star => {
                        star.addEventListener("change", checkFormValidity);
                    });

                    reviewInput.addEventListener("input", checkFormValidity);

                    // ✅ Thêm console log và đảm bảo alert luôn hiển thị khi có lỗi
                    form.addEventListener("submit", function (event) {
                        let selectedRating = form.querySelector(".rating input:checked");
                        let reviewText = reviewInput.value.trim();

                        console.log("Submitting form...");
                        console.log("Selected Rating: ", selectedRating ? selectedRating.value : "None");
                        console.log("Review Length: ", reviewText.length);

                        if (!selectedRating || reviewText.length < 10) {
                            event.preventDefault();
                            alert("⚠️ Vui lòng chọn số sao và nhập ít nhất 10 ký tự trước khi gửi!");
                            return;
                        }
                    });
                });
            });
        </script>

    </body>
</html>
