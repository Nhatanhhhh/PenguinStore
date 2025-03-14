<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Page</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/resetpassword.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
    </head>
    <body>
        <div class="container">
            <div class="row d-flex justify-content-center">
                <div class="image-container-3 col-md-4">
                </div>
                <div class="password-update-container col-md-4">
                    <h2>Password Update</h2>

                    <!-- Hiển thị thông báo lỗi -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            <%= request.getAttribute("errorMessage")%>
                        </div>
                    </c:if>

                    <!-- Hiển thị thông báo thành công -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert">
                            <%= request.getAttribute("successMessage")%>
                        </div>
                    </c:if>

                    <form action="<%= request.getContextPath()%>/ResetPassword" method="POST" id="passwordForm">
                        <div class="mb-3 input-container">
                            <label for="new-password" class="form-label">New Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="new-password" name="new-password" placeholder="Enter new password" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('new-password')">
                                    <i class="fa fa-eye" id="eye-new-password"></i>
                                </button>
                            </div>
                        </div>
                        <div class="mb-3 input-container">
                            <label for="confirm-password" class="form-label">Confirm Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirm-password" name="confirm-password" placeholder="Confirm new password" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirm-password')">
                                    <i class="fa fa-eye" id="eye-confirm-password"></i>
                                </button>
                            </div>
                        </div>
                        <div class="buttons">
                            <button type="submit" class="btn btn-outline-dark">Update Password</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

        <script>
            function confirmChangePassword() {
                let newPassword = document.getElementById("new-password").value;
                let confirmPassword = document.getElementById("confirm-password").value;
                if (newPassword.length < 6) {
                    alert("Password must be at least 6 characters long.");
                    return false;
                }
                if (newPassword !== confirmPassword) {
                    alert("Passwords do not match.");
                    return false;
                }
                return true;
            }
        </script>
        <script>
            function togglePassword(fieldId) {
                let passwordField = document.getElementById(fieldId);
                let eyeIcon = document.getElementById("eye-" + fieldId);
                passwordField.type = passwordField.type === "password" ? "text" : "password";
                eyeIcon.classList.toggle("fa-eye");
                eyeIcon.classList.toggle("fa-eye-slash");
            }

            document.getElementById("toggleSwitch").addEventListener("change", function () {
                let form = document.getElementById("passwordForm");
                let inputs = form.querySelectorAll("input");
                let button = form.querySelector("button[type='submit']");
                let isEnabled = this.checked;
                inputs.forEach(input => input.disabled = !isEnabled);
                button.disabled = !isEnabled;
            });
        </script>

    </body>
</html>