<%@page import="Models.Customer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
        <style>
            .form-control:focus {
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.5) !important;
                border-color: #000 !important;
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer customer = (Customer) request.getAttribute("user");
            if (customer == null) {
                customer = (Customer) session.getAttribute("user");
            }
        %>

        <h1 class="text-center mb-4" style="font-size: 35px;">Change Password</h1>
        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer.getFullName() != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Change Password</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            Your account
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                    <div class="password"><a style="font-weight: bold;">Password</a></div>
                    <div class="reply"><a href="">View Reply</a></div>
                </div>

                <div class="col-md-10">
                    <form class="form" action="ChangePassword" method="POST" id="passwordForm">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                <%= request.getAttribute("errorMessage")%>
                            </div>
                        </c:if>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success" role="alert">
                                <%= request.getAttribute("successMessage")%>
                            </div>
                        </c:if>

                        <div class="input-container form-group">
                            <label for="oldPassword" class="form-label pt-2">Enter the old password</label>
                            <div class="input-group">
                                <input type="password" class="form-control pt-2" id="oldPassword" name="oldPassword" placeholder="Enter the old password" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('oldPassword')">
                                    <i class="fa fa-eye" id="eye-oldPassword"></i>
                                </button>
                            </div>
                        </div>

                        <div class="input-container form-group">
                            <label for="newPassword" class="form-label pt-2">Enter the new password</label>
                            <div class="input-group">
                                <input type="password" class="form-control pt-2" id="newPassword" name="newPassword" placeholder="Enter the new password" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                    <i class="fa fa-eye" id="eye-newPassword"></i>
                                </button>
                            </div>
                        </div>

                        <div class="input-container form-group">
                            <label for="confirmPassword" class="form-label pt-2">Confirm the new password</label>
                            <div class="input-group">
                                <input type="password" class="form-control pt-2" id="confirmPassword" name="confirmPassword" placeholder="Confirm the new password" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                    <i class="fa fa-eye" id="eye-confirmPassword"></i>
                                </button>
                            </div>
                        </div>

                        <div class="d-flex justify-content-center mt-5">
                            <button type="button" class="button button-dark" data-toggle="modal" data-target="#confirmModal">
                                Update Your Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div style="background-color: #F9FAFB;  padding: 40px 0px;">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-6 d-flex justify-content-center">
                        <img style="width: 380px; height: 380px;" src="<%= request.getContextPath()%>/Image/Product/window.png" />
                    </div>
                    <div class="col-md-6">
                        <div style="width: 300px; height: 80px; margin-top: 40px;">
                            <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                            <div style="margin-left: 50px; margin-top: 50px;">
                                <a href="<%= request.getContextPath()%>/Product" class="button button-dark">New Products</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalLabel">Confirm Password Change</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to change your password?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-dark" id="confirmChange">Yes, Change</button>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            function confirmChangePassword() {
                return confirm("Are you sure you want to change your password?");
            }
            function togglePassword(fieldId) {
                let passwordField = document.getElementById(fieldId);
                let eyeIcon = document.getElementById("eye-" + fieldId);
                passwordField.type = passwordField.type === "password" ? "text" : "password";
                eyeIcon.classList.toggle("fa-eye");
                eyeIcon.classList.toggle("fa-eye-slash");
            }

            $(document).ready(function () {
                $('#confirmChange').click(function () {
                    $('#passwordForm').submit(); // Gửi form nếu người dùng đồng ý
                });
            });
        </script>
    </body>
</html>
