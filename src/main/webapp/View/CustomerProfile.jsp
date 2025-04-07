<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="Models.Customer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Profile | Penguin Fashion</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer customer = (Customer) request.getAttribute("user");
        %>

        <h1 class="text-center mb-4" style="font-size: 35px;">Account</h1>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% session.removeAttribute("message");
        session.removeAttribute("messageType");%>
        </c:if>



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
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Account</span>
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
                    <div class="general"><a style="font-weight: bold;">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                    <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
                    <div class="reply"><a href="<%= request.getContextPath()%>/ViewFeedbackCustomer">View Reply</a></div>
                </div>

                <div class="col-md-10">
                    <div class="form">
                        <div class="form-group">
                            <label class="font-weight-bold">Username</label>
                            <div class="form-control bg-light"><%= (customer != null) ? customer.getUserName() : "N/A"%></div>
                        </div>
                        <div class="form-group">
                            <label class="font-weight-bold">Email</label>
                            <div class="form-control bg-light"><%= (customer != null) ? customer.getEmail() : "N/A"%></div>
                        </div>
                    </div>
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

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>