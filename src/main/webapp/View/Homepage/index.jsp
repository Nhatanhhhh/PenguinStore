<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="Assets/CSS/Guest/styles.css"/>
        
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <a href="<%= request.getContextPath() %>/error/404.jsp">Test 404 Page</a>

        
        
        <%@include file="Footer.jsp"%>
        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>
