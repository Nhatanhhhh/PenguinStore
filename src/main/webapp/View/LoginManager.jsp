<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login DashBoard</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/util.css"/>
    </head>
    <body>
        <div class="limiter">
            <div class="container-login100" style="background-image: url('<%= request.getContextPath() %>/Image/Index/bg-01.jpg');">
                <div class="wrap-login100 p-t-30 p-b-50">
                    <span class="login100-form-title p-b-41">
                        Account Login
                    </span>
                    <form class="login100-form validate-form p-b-33 p-t-5" action="<%= request.getContextPath() %>/Login" method="POST">
                        <input type="hidden" name="userType" value="manager">

                        <div class="wrap-input100 validate-input" data-validate = "Enter username">
                            <input class="input100" type="text" name="username" placeholder="User name">
                            <span class="focus-input100" data-placeholder="&#xe82a;"></span>
                        </div>

                        <div class="wrap-input100 validate-input" data-validate="Enter password">
                            <input class="input100" type="password" name="password" placeholder="Password">
                            <span class="focus-input100" data-placeholder="&#xe80f;"></span>
                        </div>

                        <div class="container-login100-form-btn m-t-32">
                            <button type="submit" class="login100-form-btn">
                                Login
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <div id="dropDownSelect1"></div>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <script src="<%= request.getContextPath() %>/Assets/Javascript/script.js"></script>

    </body>
</html>
