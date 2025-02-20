<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
    </head>
    <body style="background-color: #fff;">
        <div class="container" style="margin-top: 20px; box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px; border-radius: 14px;">
            <div class="row">
                <div class="image-container-1 col-md-6"></div>
                <div class="login-container col-md-6">
                    <h1 style="font-size: 35px">PENGUIN</h1>
                    <p style="text-align: center; font-size: 16px; margin-bottom: 20px;">Login to PENGUIN</p>

                    <% 
                        String successMessage = (String) session.getAttribute("successMessage");
                        String errorMessage = (String) session.getAttribute("errorMessage");

                        if (successMessage != null) { 
                    %>
                    <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
                        <%= successMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% 
                            session.removeAttribute("successMessage");
                        } 
                        if (errorMessage != null) { 
                    %>
                    <div class="alert alert-danger alert-dismissible fade show text-center" role="alert"
                         style="<%= (errorMessage != null) ? "display:block;" : "display:none;" %>">
                        <%= errorMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <%
                            session.removeAttribute("errorMessage");
                        } 
                    %>

                    <!-- Form -->
                    <form id="loginForm" action="<%= request.getContextPath() %>/Login" method="POST">
                        <input type="hidden" name="userType" value="customer">

                        <div class="txt_field">
                            <input id="username" name="username" type="text" required>
                            <label for="username">Username</label>
                        </div>

                        <div class="txt_field">
                            <input id="password" name="password" type="password" required>
                            <label for="password">Password</label>
                        </div>

                        <div class="checkbox row">
                            <input class="col-md-1" type="checkbox" id="rememberMe">
                            <label class="col-md-11" for="rememberMe">Remember Me</label>
                        </div>

                        <div class="d-flex justify-content-center">
                            <button type="submit" class="button button-dark" style="padding: 10px 100px; margin: 10px 0px; border-radius: 8px;">Login</button>
                        </div>

                        <div class="d-flex justify-content-center">
                            <a href="Register.jsp" class="button button-outline-primary" style="padding: 10px 75px; margin: 10px 0px; border-radius: 8px;">Register Now</a>
                        </div>

                        <div class="row">
                            <div class="col-md-6 d-flex justify-content-start">
                                <a class="icon-google" href="#"><i class="fa-brands fa-google"></i></a>
                            </div>
                            <div class="col-md-6 d-flex justify-content-end">
                                <a class="forgot-password" href="#">Forgot Password?</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath() %>/Assets/Javascript/script.js"></script>
    </body>
</html>
