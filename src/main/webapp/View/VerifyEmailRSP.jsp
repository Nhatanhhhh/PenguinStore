<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Verify Email RSP</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/verifyEmail.css">
    </head>
    <body>
        <div class="container" style="display: flex; justify-content: center; align-items: center; height: 80vh;">
            <div class="verify-box row">
                <%
                    HttpSession sessionObj = request.getSession();
                    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
                    String successMessage = (String) sessionObj.getAttribute("successMessage");

                    sessionObj.removeAttribute("errorMessage");
                    sessionObj.removeAttribute("successMessage");
                %>
                <!-- Hình ảnh bên trái -->
                <div class="image-container col-md-6"></div>

                <!-- Nội dung bên phải -->
                <div class="verify-content col-md-6">
                    <h1>PENGUIN</h1>
                    <p>Enter The Confirmation Code</p>

                    <c:if test="${not empty msg}">
                        <div class="error">${msg}</div>
                    </c:if>

                    <!-- Form nhập mã xác nhận -->
                    <form action="<%= request.getContextPath()%>/VerifyEmailRSP" method="POST">
                        <div class="input-group">
                            <input type="text" name="verificationCode" placeholder="Confirmation Code" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Recover Account</button>
                    </form>

                    <!-- Link gửi lại mã -->
                    <form action="<%= request.getContextPath()%>/ResendCodeRSP" method="POST">
                        <button type="submit" class="btn btn-link">Didn’t receive Confirmation Code? Resend Now</button>
                    </form>

                    <p style="margin-top: 20px; font-size: 12px; color: #777;">PENGUIN Terms & Conditions</p>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

            <% if (errorMessage != null) {%>
                    console.log("❌ Error Message Detected: <%= errorMessage%>");
                    Swal.fire({
                        title: "Error",
                        text: "<%= errorMessage%>",
                        icon: "error",
                        confirmButtonText: "OK",
                        timer: 2500
                    });
            <% } %>

            <% if (successMessage != null) {%>
                    console.log("✅ Success Message Detected: <%= successMessage%>");
                    Swal.fire({
                        title: "Success",
                        text: "<%= successMessage%>",
                        icon: "success",
                        confirmButtonText: "OK",
                        timer: 2500
                    });
            <% }%>
            });
        </script>
        
        
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
