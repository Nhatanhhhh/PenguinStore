<%@page import="Models.Size"%>
<%@page import="java.util.List, Models.Feedback, Models.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback | Penguin Fashion</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/feedback.css"/>

        <style>
            /* Styles for the star rating system */
            .rating {
                display: flex;
                justify-content: center;
                flex-direction: row-reverse; /* Reverse the order of stars */
                gap: 5px;
                font-size: 30px;
                cursor: pointer;
            }

            .rating input {
                display: none; /* Hide the radio buttons */
            }

            .rating label {
                color: #ccc; /* Default star color */
                transition: color 0.3s, transform 0.2s;
                cursor: pointer;
            }

            .rating label:hover,
            .rating label:hover ~ label {
                color: gold; /* Change color on hover */
                transform: scale(1.2); /* Scale stars on hover */
            }

            .rating input:checked ~ label {
                color: gold; /* Change color for selected stars */
            }

            /* Styles for the submit button */
            .submit-btn {
                width: 100%;
                padding: 10px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                background-color: #000;
                color: white;
                cursor: not-allowed; /* Disable cursor by default */
                opacity: 0.5;
                transition: opacity 0.3s, background-color 0.3s;
            }

            .submit-btn.active {
                opacity: 1;
                cursor: pointer;
                background-color: #198754; /* Green color for active button */
            }

            .submit-btn.active:hover {
                background-color: #145c32; /* Darker green on hover */
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h1 class="text-center mb-4" style="font-size: 35px;">Feedback</h1>

        <!-- Display SweetAlert2 messages if any -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
            <% if (session.getAttribute("message") != null) {%>
                Swal.fire({
                    icon: "<%= session.getAttribute("messageType")%>", // "success" or "error"
                    title: "<%= session.getAttribute("message")%>",
                    confirmButtonText: "OK",
                    timer: 2500
                });
            <% session.removeAttribute("message");
                session.removeAttribute("messageType"); %>
            <% }%>
            });
        </script>

        <!-- Main container for feedback form -->
        <div class="container mt-4 mb-4 pb-4">
            <c:choose>
                <c:when test="${not empty productList}">
                    <!-- Loop through each product in the productList -->
                    <c:forEach var="product" items="${productList}">
                        <div class="card p-3 mb-3 mt-3">
                            <div class="row">
                                <div class="col-md-2">
                                    <!-- Display product image -->
                                    <img src="<%= request.getContextPath()%>/Image/Product/${product.imgName}" 
                                         class="img-fluid rounded" alt="Product Image">
                                </div>
                                <div class="col-md-8">
                                    <!-- Display product details -->
                                    <h5><strong>${product.productName}</strong></h5>
                                    <p>Size: <strong>${product.sizeName}</strong></p>
                                    <p>Price: <strong>${product.price}</strong></p>
                                </div>
                            </div>
                        </div>

                        <!-- Form to submit feedback for each product -->
                        <form action="<%= request.getContextPath()%>/CreateFeedback" method="POST" class="feedback-form">
                            <input type="hidden" name="productID" value="${product.productID}">
                            <input type="hidden" name="orderID" value="${product.orderID}">

                            <!-- Star rating system -->
                            <div class="text-center mb-3">
                                <label>Rate this product:</label>
                                <div class="rating">
                                    <input type="radio" name="rating-${product.productID}" id="star5-${product.productID}" value="5">
                                    <label for="star5-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star4-${product.productID}" value="4">
                                    <label for="star4-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star3-${product.productID}" value="3">
                                    <label for="star3-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star2-${product.productID}" value="2">
                                    <label for="star2-${product.productID}">★</label>

                                    <input type="radio" name="rating-${product.productID}" id="star1-${product.productID}" value="1">
                                    <label for="star1-${product.productID}">★</label>
                                </div>
                            </div>

                            <!-- Textarea for review comment -->
                            <div class="form-group">
                                <textarea id="review-${product.productID}" name="review" rows="4"
                                          class="form-control review-input" placeholder="Write your review here..."></textarea>
                            </div>

                            <!-- Submit button (disabled by default) -->
                            <button type="submit" class="submit-btn mt-3" disabled>Submit Feedback</button>
                        </form>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Display message if no products are found -->
                    <p class="text-center">No products found for this order.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <!-- JavaScript to handle form validation and submission -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let forms = document.querySelectorAll(".feedback-form");

                forms.forEach(form => {
                    let stars = form.querySelectorAll(".rating input");
                    let submitBtn = form.querySelector(".submit-btn");
                    let reviewInput = form.querySelector(".review-input");

                    // Function to check if the form is valid
                    function checkFormValidity() {
                        let selectedRating = form.querySelector(".rating input:checked");
                        let reviewText = reviewInput.value.trim();
                        let isValid = selectedRating && reviewText.length >= 10; // At least 10 characters required

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

                    // Add event listeners for star rating and review input
                    stars.forEach(star => {
                        star.addEventListener("change", checkFormValidity);
                    });

                    reviewInput.addEventListener("input", checkFormValidity);

                    // Handle form submission
                    form.addEventListener("submit", function (event) {
                        let selectedRating = form.querySelector(".rating input:checked");
                        let reviewText = reviewInput.value.trim();

                        console.log("Submitting form...");
                        console.log("Selected Rating: ", selectedRating ? selectedRating.value : "None");
                        console.log("Review Length: ", reviewText.length);

                        if (!selectedRating || reviewText.length < 10) {
                            event.preventDefault();
                            alert("⚠️ Please select a rating and enter at least 10 characters before submitting!");
                            return;
                        }
                    });
                });
            });
        </script>
    </body>
</html>