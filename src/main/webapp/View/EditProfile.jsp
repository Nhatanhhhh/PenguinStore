<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Customer" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>

        <%                Customer customer = (Customer) session.getAttribute("user");
        %>
        <h1 class="text-center mb-4" style="font-size: 35px;">Edit Profile</h1>

        <!-- Error or Success Messages -->
        <%
            String message = (String) request.getAttribute("errorMessage");
            if (message != null) {
        %>
        <div class="alert alert-danger text-center"><%= message%></div>
        <%
            }
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <div class="alert alert-success text-center"><%= successMessage%></div>
        <%
            }
        %>

        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Edit Profile</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            Edit your profile
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="list col-md-2">
                    <div class="divider"></div>
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a style="font-weight: bold;">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                    <div class="password"><a href="#">Password</a></div>
                </div>

                <div class="col-md-10">
                    <form class="form" action="<%= request.getContextPath()%>/EditProfile" method="POST">
                        <!-- Full Name and Phone Number -->
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="<%= (customer != null) ? customer.getFullName() : ""%>" required>
                        </div>
                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" 
                                   value="<%= (customer != null && customer.getPhoneNumber() != null) ? customer.getPhoneNumber() : "" %>" required>
                        </div>

                        <!-- City and Zip Code -->
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="state">State</label>
                                <input type="text" class="form-control" id="state" name="state" 
                                       value="<%= (customer != null) ? customer.getState() : ""%>" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="zip">Zip Code</label>
                                <input type="text" class="form-control" id="zip" name="zip" 
                                       value="<%= (customer != null) ? customer.getZip() : ""%>" required>
                            </div>
                        </div>

                        <!-- Address -->
                        <div class="form-group">
                            <label for="address">Your Address</label>
                            <input type="text" class="form-control" id="address" name="address" 
                                   value="<%= (customer != null) ? customer.getAddress() : ""%>" required>
                        </div>

                        <!-- Submit Button -->
                        <div class="form-group text-center">
                            <button type="button" class="button button-dark" id="openModalBtn">Update Profile</button>
                        </div>
                    </form>
                </div>
            </div>


        </div>

        <div style="background-color: #F9FAFB;  padding: 40px 0px;">
            <div class="row">
                <div class="col-md-6 d-flex justify-content-center">
                    <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
                </div>
                <div class="col-md-6">
                    <div style="width: 300px; height: 80px; margin-top: 40px;">
                        <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                        <div style="margin-left: 50px; margin-top: 50px;">
                            <a href="#" class="button button-dark">New Products</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xác Nhận Cập Nhật -->
        <div class="modal fade" id="confirmUpdateModal" tabindex="-1" role="dialog" aria-labelledby="confirmUpdateLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmUpdateLabel">Confirmation update</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to update your profile information?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-success" id="confirmUpdateBtn">Confirm</button>
                    </div>
                </div>
            </div>
        </div>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var openModalBtn = document.getElementById("openModalBtn");
                var confirmUpdateBtn = document.getElementById("confirmUpdateBtn");

                // Khi nhấn "Update Profile", mở modal
                openModalBtn.addEventListener("click", function () {
                    $("#confirmUpdateModal").modal("show");
                });

                // Khi nhấn "Xác nhận" trong modal, gửi form
                confirmUpdateBtn.addEventListener("click", function () {
                    document.querySelector("form").submit();
                });
            });
        </script>
    </body>

</html>
