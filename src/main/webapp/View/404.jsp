<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="../Assets/CSS/Guest/styles.css"/>
        
    </head>
    <body>
        <%@include file="/View/Homepage/Header.jsp"%>

        <div class="text-align-center">
            <div>
                <h1 style="color: red;"><b>404 Not Found</b></h1>
                <h2>The requested resource could not be found but may be available in the future.</h2>
            </div>	
        </div>
        

        <%@include file="/View/Homepage/Footer.jsp"%>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>