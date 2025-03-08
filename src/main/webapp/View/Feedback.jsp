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
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h1 class="text-center mb-4" style="font-size: 35px;">Feedback</h1>

        <%-- Hiển thị thông báo nếu có --%>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert ${sessionScope.messageType == 'success' ? 'alert-success' : 'alert-danger'} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close" onclick="hideAlert()">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <%-- Chỉ xóa message sau khi hiển thị --%>
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
        </c:if>

        <div class="container mt-4 mb-4 pb-4">
            <c:choose>
                <c:when test="${not empty feedbackList}">
                    <c:forEach var="feedback" items="${feedbackList}">
                        <c:if test="${not empty feedback.productID}">
                            <c:set var="productKey" value="product_${feedback.productID}" />
                            <c:set var="sizeKey" value="size_${feedback.productID}" />
                            <c:set var="product" value="${requestScope[productKey]}" />
                            <c:set var="size" value="${requestScope[sizeKey]}" />
                        </c:if>

                        <div class="card p-3 mb-3">
                            <div class="row">
                                <div class="col-md-2">
                                    <img src="<%= request.getContextPath()%>/Image/Product/${product.imgName}" class="img-fluid" alt="Product Image">
                                </div>
                                <div class="col-md-8">
                                    <h5><strong>${product.productName}</strong></h5>
                                    <p>Size: ${size.sizeName}</p>
                                </div>
                                <div class="col-md-2 text-right">
                                    <h5><strong>$${product.price}</strong></h5>
                                </div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty feedback.comment}">
                                <!-- Nếu chưa có feedback, cho phép đánh giá -->
                                <form action="<%= request.getContextPath()%>/Feedback" method="POST">
                                    <input type="hidden" name="customerID" value="${customer.customerID}">
                                    <input type="hidden" name="productID" value="${feedback.productID}">
                                    <input type="hidden" name="orderID" value="${feedback.orderID}">

                                    <!-- Rating Section -->
                                    <div class="rating-section">
                                        <div class="rating-label">Product quality</div>
                                        <div class="star-rating">
                                            <input type="radio" name="rating" id="star5-${feedback.productID}" value="5">
                                            <label for="star5-${feedback.productID}" title="Great">★</label>
                                            <input type="radio" name="rating" id="star4-${feedback.productID}" value="4">
                                            <label for="star4-${feedback.productID}" title="Good">★</label>
                                            <input type="radio" name="rating" id="star3-${feedback.productID}" value="3">
                                            <label for="star3-${feedback.productID}" title="Medium">★</label>
                                            <input type="radio" name="rating" id="star2-${feedback.productID}" value="2">
                                            <label for="star2-${feedback.productID}" title="Bad">★</label>
                                            <input type="radio" name="rating" id="star1-${feedback.productID}" value="1">
                                            <label for="star1-${feedback.productID}" title="Very Bad">★</label>
                                        </div>
                                    </div>

                                    <!-- Feedback content -->
                                    <div class="input-group">
                                        <textarea id="review" name="review" rows="8" placeholder="Enter the evaluation content"
                                                  class="form-control" maxlength="500"></textarea>
                                    </div>

                                    <p id="error-message" style="color: red; display: none;">Your feedback must contain at least 2 valid sentences.</p>

                                    <div class="mt-3 text-right">
                                        <button type="submit" class="button button-dark" id="submit-btn" disabled>Submit Feedback</button>
                                    </div>

                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- Nếu đã có feedback, hiển thị rating và comment -->
                                <div class="mt-3">
                                    <h6><strong>Assess: </strong></h6>
                                    <div class="star-rating">
                                        <c:forEach var="i" begin="1" end="5">
                                            <c:choose>
                                                <c:when test="${i <= feedback.rating}">
                                                    <span class="star checked">★</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="star">★</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="mt-3">
                                    <h6><strong>Comment:</strong></h6>
                                    <p>${feedback.comment}</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-center">There are no feedback</p>
                </c:otherwise>
            </c:choose>
        </div>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <script>
            setTimeout(function () {
                let alert = document.querySelector('.alert');
                if (alert) {
                    alert.style.display = 'none';
                }
            }, 5000); // Ẩn sau 5 giây

            function hideAlert() {
                let alert = document.querySelector('.alert');
                if (alert) {
                    alert.style.display = 'none';
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                let textarea = document.getElementById("review");
                let submitBtn = document.getElementById("submit-btn");
                let errorMessage = document.getElementById("error-message");

                textarea.addEventListener("input", function () {
                    let feedback = textarea.value.trim();

                    // Tách câu dựa trên dấu câu kết thúc (. ! ?)
                    let sentences = feedback.split(/[.!?]/).map(sentence => sentence.trim()).filter(sentence => sentence.length > 0);

                    // Kiểm tra số lượng từ trong mỗi câu (mỗi câu ít nhất 2 từ)
                    let validSentences = sentences.filter(sentence => sentence.split(/\s+/).length >= 2);

                    // Ngăn chặn spam (không cho phép nhập lặp một ký tự quá nhiều lần như "aaaaaaa")
                    let spamPattern = /^([a-zA-Z])\1{2,}$/;
                    let isSpam = feedback.split(/\s+/).some(word => spamPattern.test(word));

                    // Điều kiện hợp lệ: ít nhất 1 câu, mỗi câu có ít nhất 2 từ, tổng số câu không quá 50, và không có spam
                    if (validSentences.length >= 1 && validSentences.length <= 50 && !isSpam) {
                        submitBtn.disabled = false;
                        errorMessage.style.display = "none";
                    } else {
                        submitBtn.disabled = true;
                        errorMessage.style.display = "block";
                        errorMessage.textContent = "Feedback must have at least 1 valid sentence with at least 2 words, and at most 50 sentences.";
                    }
                });
            });

        </script>

    </body>
</html>
