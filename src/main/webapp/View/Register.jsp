<%@page import="com.google.gson.Gson"%>
<%@page import="Models.Customer"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register | Penguin Fashion</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/register.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/chatbot.css"/>
    </head>
    <body style="background-color: #fff;">
        <%
            HttpSession sessionObj = request.getSession();
            String msg = (String) sessionObj.getAttribute("msg");
            sessionObj.removeAttribute("msg"); // Remove after displaying
            Customer user = (Customer) session.getAttribute("user");
            String userJson = "null";
            if (user != null) {
                userJson = new Gson().toJson(user);
            }
        %>
        <div class="container" style="padding: 0; margin-top: 20px; margin-bottom: 20px; border-radius: 15px; box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;">
            <div class="row">
                <div class="image-container-2 col-md-6" data-aos="fade-up-right" ></div>

                <div class="register-container col-md-6" data-aos="fade-up-left" style="margin: 10px;">
                    <h1 style=" font-size: 24px;">PENGUIN</h1>
                    <p style="text-align: center; font-size: 18px; margin-bottom: 20px;">Create Account</p>

                    <div class="d-flex justify-content-center align-items-center">
                        <form class="register100-form validate-form flex-sb flex-w" action="<%= request.getContextPath()%>/Register" method="POST" style="margin: 45px 0;">


                            <div class="row">
                                <!-- Username -->
                                <div class="col-md-6">
                                    <span class="txt1 col" style="font-size: 16px;">Username</span>
                                    <div class="wrap-input100 validate-input m-b-36" data-validate="Username is required">
                                        <input class="input100" type="text" name="username" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                </div>

                                <!-- Phone Number -->
                                <div class="col-md-6">
                                    <span class="txt1 col" style="font-size: 16px;">Phone Number</span>
                                    <div class="wrap-input100 validate-input m-b-36" data-validate="Phone number is required">
                                        <input id="phone" class="input100" type="tel" name="phone" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                    <div id="phoneError" class="text-danger mt-2" style="display: none; font-size: 14px;">
                                        Phone number must be 10-11 digits!
                                    </div>
                                </div>
                            </div>



                            <div class="row">
                                <!-- Email -->
                                <div class="col-md-12">
                                    <span class="txt1 col" style="font-size: 16px;">Email Address</span>
                                    <div class="wrap-input100 validate-input m-b-36" data-validate="Valid email is required">
                                        <input id="email" class="input100" type="email" name="email" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                    <div id="emailError" class="text-danger mt-2" style="display: none; font-size: 14px;">
                                        Invalid email format!
                                    </div>
                                </div>

                                <!-- Full Name -->
                                <div class="col-md-12">
                                    <span class="txt1 col" style="font-size: 16px;">Full Name</span>
                                    <div class="wrap-input100 validate-input m-b-36" data-validate="Full Name is required">
                                        <input class="input100" type="text" name="fullName" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <!-- Password -->
                                <div class="col-md-6">
                                    <span class="txt1 col" style="font-size: 16px;">Password</span>
                                    <div class="wrap-input100 validate-input m-b-12" data-validate="Password is required">
                                        <button type="button" class="btn-show-pass">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        <input id="password" class="input100" type="password" name="password" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                    <div id="passwordStrength" class="mt-2" style="display: none; font-size: 14px;"></div>
                                </div>


                                <!-- Confirm Password -->
                                <div class="col-md-6">
                                    <span class="txt1 col" style="font-size: 16px;">Confirm Password</span>
                                    <div class="wrap-input100 validate-input" data-validate="Confirm password is required">
                                        <button type="button" class="btn-show-pass">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        <input id="confirm_password" class="input100" type="password" name="confirm_password" onChange="onChange()" required>
                                        <span class="focus-input100"></span>
                                    </div>
                                    <div id="passwordError" class="mt-2" style="display: none; font-size: 14px;">
                                        Passwords do not match!
                                    </div>
                                </div>


                            </div>


                            <!-- Terms and Conditions -->
                            <div class="flex-sb-m w-full" style="margin: 20px 0;">
                                <div class="contact100-form-checkbox">
                                    <input class="input-checkbox100" id="ckb1" type="checkbox" name="agree" required>
                                    <label class="label-checkbox100" for="ckb1" style="font-size: 16px;">
                                        I agree to the Terms and Conditions
                                    </label>
                                </div>
                            </div>

                            <!-- Social Media & Register Button -->
                            <div class="container-login100-form-btn" style="margin-top: 20px;">
                                <div class="col-md-6 d-flex justify-content-start">
                                    <a class="icon-google" href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/PenguinStore/GoogleLogin&response_type=code&client_id=481523146636-vh5s2vjv8fm9hb8dtgi9e3f66711192u.apps.googleusercontent.com&approval_prompt=force"><i class="fa-brands fa-google"></i></a>
                                </div>
                                <div class="col-md-6 d-flex justify-content-end">
                                    <button class="login100-form-btn">
                                        Create Account
                                    </button>
                                </div>
                            </div>

                            <!-- Already have an account? -->
                            <div class="row" style="padding-top: 10px;">
                                <div class="col-md-12 d-flex justify-content-center">
                                    <span style="font-family: Raleway-Regular; font-size: 16px; color: #555555; line-height: 1.4;">
                                        Already have an account? 
                                        <a href="<%= request.getContextPath()%>/Login" class="text txt3">
                                            <b class="forgot-password text txt3" style="font-size: 16px;">Login</b>
                                        </a>
                                    </span>
                                </div>
                            </div>

                        </form>

                    </div>

                </div>
            </div>

        </div>

        <!-- ChatBOT -->
        <div class="chatbot-container">
            <button class="chatbot-toggler">
                <span class="material-symbols-outlined open-icon">mode_comment</span>
                <span class="material-symbols-outlined close-icon">close</span>
            </button>
            <div class="chatbot">
                <header>
                    <h2>PenguinBot</h2>
                    <span class="close-btn material-symbols-outlined">close</span>
                </header>
                <ul class="chatbox">
                    <li class="chat incoming">
                        <span class="mdi mdi-penguin"></span>
                        <p>Xin chào! Tôi là PenguinBot - trợ lý ảo của PenguinDB. Tôi có thể giúp gì cho bạn hôm nay?</p>
                    </li>
                </ul>
                <div class="chat-input">
                    <textarea placeholder="Nhập tin nhắn của bạn..." required></textarea>
                    <span class="material-symbols-outlined">send</span>
                </div>
            </div>
        </div>

        <!-- End ChatBOT -->

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                if (typeof Swal === "undefined") {
                    console.error("SweetAlert2 is not loaded. Check your network connection.");
                } else {
            <% if (msg != null) {%>
                    Swal.fire({
                        title: 'Oops!',
                        text: '<%= msg%>',
                        icon: 'error'
                    });
            <% }%>
                }
            });
            
            window.userSession = <%= userJson%>;
        </script>

        <script src="<%= request.getContextPath()%>/Assets/Javascript/chatbot.js" defer></script>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/register.js"></script>

    </body>
</html>