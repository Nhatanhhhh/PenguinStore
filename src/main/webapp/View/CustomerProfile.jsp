<%@page import="Models.Customer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Profile</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customerprofile.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer user = (Customer) request.getAttribute("user");
        %>
        <div class="d-flex justify-content-center text-center align-items-center" style="margin: 20px 0; padding: 20px 0;">
            <h1 style="font-size: 35px;">Account</h1>
        </div>
        <div class="container">

            <div class="form">
                <div class="inputs">
                    <div class="username">
                        <div class="input">
                            <!-- Thay 'thegriffster11' bằng user.getUserName() -->
                            <div class="thegriffster-11">
                                <%= (user != null) ? user.getUserName() : "N/A"%>
                            </div>
                        </div>
                        <div class="username2">Username</div>
                    </div>
                    <div class="email">
                        <div class="input2">
                            <!-- Thay 'nanh@designdrops.io' bằng user.getEmail() -->
                            <div class="nanh-designdrops-io">
                                <%= (user != null) ? user.getEmail() : "N/A"%>
                            </div>
                        </div>
                        <div class="email2">Email</div>
                    </div>
                </div>
            </div>

            <div class="list">
                <div class="divider"></div>
                <div class="password"><a href="#">Password</a></div>
                <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                <div class="general"><a>General</a></div>
            </div>

            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-center align-items-center"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="view-your-username-and-manage-your-account">
                            View your username and manage your account
                        </div>
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span">
                                    <%= (user != null) ? user.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3">General</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div style="background-color: #F9FAFB;  padding: 40px 0px;">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
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
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
