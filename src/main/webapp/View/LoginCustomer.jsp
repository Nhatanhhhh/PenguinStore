<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>

    </head>
    <body style="background-color: #fff;">
        <div class="container" style="margin-top: 20px; box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px; border-radius: 14px;" data-aos="fade-up">
            <div class="row">
                <div class="image-container-1 col-md-6" data-aos="fade-right"></div>
                <div class="login-container col-md-6" data-aos="fade-left">
                    <h1 style="font-size: 35px">PENGUIN</h1>
                    <p style="text-align: center; font-size: 16px; margin-bottom: 20px;">Login to PENGUIN</p>

                    <% String successMessage = (String) session.getAttribute("successMessage");
                        String errorMessage = (String) session.getAttribute("errorMessage");

                        if (successMessage != null) {%>
                    <div class="alert alert-success alert-dismissible fade show text-center" role="alert" data-aos="zoom-in">
                        <%= successMessage%>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage");
                        }
                        if (errorMessage != null) {%>
                    <div class="alert alert-danger alert-dismissible fade show text-center" role="alert" style="<%= (errorMessage != null) ? "display:block;" : "display:none;"%>" data-aos="zoom-in">
                        <%= errorMessage%>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage");
                        }%>

                    <!-- Form -->
                    <form class="login100-form" action="<%= request.getContextPath()%>/Login" method="POST" data-aos="fade-up">
                        <input type="hidden" name="userType" value="customer">
                        <span class="txt1 p-b-11" style="font-size: 16px;">Username</span>
                        <div class="wrap-input100 validate-input" data-validate="Username is required">
                            <input class="input100" type="text" name="username">
                            <span class="focus-input100"></span>
                        </div>

                        <span class="txt1" style="font-size: 16px;">Password</span>
                        <div class="wrap-input100 validate-input" data-validate="Password is required">
                            <span class="btn-show-pass">
                                <i class="fa fa-eye"></i>
                            </span>
                            <input class="input100" type="password" name="password">
                            <span class="focus-input100"></span>
                        </div>

                        <div class="flex-sb-m w-full" style="margin: 20px 0;" data-aos="fade-in">
                            <div class="contact100-form-checkbox">
                                <input class="input-checkbox100" id="ckb1" type="checkbox" name="remember-me">
                                <label class="label-checkbox100" for="ckb1" style="font-size: 16px;">Remember me</label>
                            </div>
                        </div>

                        <div class="row" data-aos="fade-in">
                            <div class="col-md-6 d-flex justify-content-start">
                                <a href="<%= request.getContextPath()%>/ForgetPassword" class="text txt3" style="font-size: 16px;">Forgot Password?</a>
                            </div>
                            <div class="col-md-6 d-flex justify-content-end">
                                <span style="font-family: Raleway-Regular; font-size: 16px;color: #555555; line-height: 1.4;">If you don't have account! You can
                                    <a href="<%= request.getContextPath()%>/Register" style="font-size: 16px;" class="text txt3">Create Account</a>
                                </span>
                            </div>
                        </div>

                        <div class="container-login100-form-btn" style="margin-top: 20px;" data-aos="fade-up">
                            <div class="col-md-6 d-flex justify-content-start">
                                <a class="icon-google" href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/PenguinStore/GoogleLogin&response_type=code&client_id=481523146636-vh5s2vjv8fm9hb8dtgi9e3f66711192u.apps.googleusercontent.com&approval_prompt=force"><i class="fa-brands fa-google"></i></a>
                            </div>
                            <div class="col-md-6 justify-content-end">
                                <button class="login100-form-btn">Login</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/script.js"></script>
    </body>
</html>
