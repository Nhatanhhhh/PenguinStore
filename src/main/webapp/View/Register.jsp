<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
    </head>
    <body style="background-color: #fff;">

        <div class="container" style="padding: 0; margin-top: 20px; border-radius: 15px; box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;">
            <div class="row">
                <div class="image-container-2 col-md-5"></div>

                <div class="register-container col-md-7"  style="margin: 10px;">
                    <h1 style=" font-size: 24px;">PENGUIN</h1>
                    <p style="text-align: center; font-size: 18px; margin-bottom: 20px;">Create Account</p>

                    <div class="d-flex justify-content-center align-items-center">
                        <form method="post">
                            <div class="row">
                                <div class=" txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="text" required>
                                    <label>Username</label>
                                    <span></span>
                                </div>
                                <div class=" txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="text" required>
                                    <label>Full Name</label>
                                    <span></span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="email" required>
                                    <label>Email Address</label>
                                    <span></span>
                                </div>
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="text" required>
                                    <label>Phone Number</label>
                                    <span></span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="text" required>
                                    <label>Address</label>
                                    <span></span>
                                </div>
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="text" required>
                                    <label>State</label>
                                    <span></span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="password" required>
                                    <label>Password</label>
                                    <span></span>
                                </div>
                                <div class="txt_field" style="margin-right: 4px; margin-left: 4px;">
                                    <input type="password" required>
                                    <label>Confirm Password</label>
                                    <span></span>
                                </div>
                            </div>


                            <div class="checkbox row" style="margin: 20px 0;">
                                <input class="col-md-1" type="checkbox" id="agree">
                                <label class="col-md-10" style="padding-left: 10px; padding-right: 0;" for="agree">Do you agree to the Terms and Conditions?</label>
                            </div>

                            <div class="d-flex justify-content-center">
                                <button type="submit" class="button button-dark" style="border-radius: 8px; font-size: 15px; padding: 10px 80px;">Create Account</button>
                            </div>

                            <div class="row" style="padding-bottom: 10px;">
                                <div class="d-flex justify-content-start mt-3 col-md-3">
                                    <a class="icon-google" href="#" style="font-size: 15px; width: 35px; height: 35px;"><i class="fa-brands fa-google"></i></a>
                                </div>

                                <div class="col-md-9 d-flex justify-content-end align-items-center">
                                    <a style="font-size: 14px;"  href="LoginCustomer.jsp">Already have an account? <b class="forgot-password">Login</b></a>
                                </div>
                            </div>

                        </form>
                    </div>

                </div>
            </div>

        </div>


        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>
