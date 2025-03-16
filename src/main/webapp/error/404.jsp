<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Page Not Found Error</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/error.css"/>
    </head>
    <body>
        <div data-aos="zoom-in-up" id="notfound">
		<div class="notfound">
			<div class="notfound-404">
				<h1>404</h1>
			</div>
			<h2>We are sorry, Page not found!</h2>
			<p>The page you are looking for might have been removed had its name changed or is temporarily unavailable.</p>
                        <a class="button button-dark" href="<%= request.getContextPath()%>"> Back To Homepage</a>
		</div>
	</div>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>