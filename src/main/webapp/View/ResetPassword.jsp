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

                    <form action="<%= request.getContextPath()%>/ResetPassword" method="POST">
                        <div class="mb-3 input-container">
                            <label for="new-password" class="form-label">New Password</label>
                            <input type="password" class="form-control" id="new-password" name="new-password" placeholder="Enter new password" required>
                        </div>
                        <div class="mb-3 input-container">
                            <label for="confirm-password" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="confirm-password" name="confirm-password" placeholder="Confirm new password" required>
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
        <c:if test="${not empty successMessage}">
            <script>
                setTimeout(function () {
                window.location.href = '/;
                }, 5000); // Chuyển sau 5 giây

                document.addEventListener("DOMContentLoaded", function () {
                const password = document.getElementById("new-password");
                const confirmPassword = document.getElementById("confirm-password");
                const passwordStrength = document.createElement("div");
                passwordStrength.id = "passwordStrength";
                passwordStrength.style.marginTop = "5px";
                password.insertAdjacentElement("afterend", passwordStrength);
                const passwordError = document.createElement("div");
                passwordError.id = "passwordError";
                passwordError.style.color = "red";
                passwordError.style.display = "none";
                confirmPassword.insertAdjacentElement("afterend", passwordError);
                function validatePasswordStrength() {
                const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                if (password.value.length < 8) {
                passwordStrength.innerText = "⚠️ Password must be at least 8 characters long.";
                passwordStrength.style.color = "red";
                passwordStrength.style.display = "block";
                return false;
                } else if (!strongRegex.test(password.value)) {
                passwordStrength.innerText = "⚠️ Must contain uppercase, lowercase, number, and special character.";
                passwordStrength.style.color = "orange";
                passwordStrength.style.display = "block";
                return false;
                } else {
                passwordStrength.innerText = "✅ Strong password.";
                passwordStrength.style.color = "green";
                passwordStrength.style.display = "block";
                return true;
                }
                }

                function validatePasswordMatch() {
                if (password.value !== confirmPassword.value) {
                passwordError.innerText = "⚠️ Passwords do not match.";
                passwordError.style.display = "block";
                confirmPassword.classList.add("input-error");
                return false;
                } else {
                passwordError.style.display = "none";
                confirmPassword.classList.remove("input-error");
                return true;
                }
                }

                function validateForm(event) {
                if (!validatePasswordStrength() || !validatePasswordMatch()) {
                event.preventDefault();
                alert("Please fix password issues before submitting.");
                }
                }

                password.addEventListener("input", function () {
                validatePasswordStrength();
                validatePasswordMatch();
                });
                confirmPassword.addEventListener("input", validatePasswordMatch);
                document.querySelector("form").addEventListener("submit", validateForm);
                });

            </script>
        </c:if>
    </body>
</html>
