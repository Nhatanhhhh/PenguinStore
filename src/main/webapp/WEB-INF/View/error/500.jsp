<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Internal Server Error</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="Assets/CSS/Guest/styles.css"/>
        
    </head>
    <body>
        <%@include file="/View/Homepage/Header.jsp"%>
        <div class="text-align-center">

            <div>
                <h1 style="color: red;"><b>500 Internal Server Error</b></h1>
                <h2>A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.</h2>

            </div>	
        </div>

        <%@include file="/View/Homepage/Footer.jsp"%>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>