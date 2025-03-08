<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xác nhận Email</title>
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
    </body>
</html>
