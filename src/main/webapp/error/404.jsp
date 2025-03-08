<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Page Not Found Error</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/Guest/style.css"/>
    </head>
    <body>
        <section class="py-3 py-md-5 min-vh-100 d-flex justify-content-center align-items-center">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="text-center">
                            <h2 class="d-flex justify-content-center align-items-center gap-2 mb-4">
                                <span class="display-1 fw-bold">4</span>
                                <i class="bi bi-exclamation-circle-fill text-danger display-2"></i>
                                <span class="display-1 fw-bold bsb-flip-h">4</span>
                            </h2>
                            <h3 class="h2 mb-2">Oops! You're lost.</h3>
                            <p class="mb-5">The page you are looking for was not found.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script>
            <%@include file="/Assets/CSS/bootstrap.js.jsp"%>
        </script>
    </body>
</html>