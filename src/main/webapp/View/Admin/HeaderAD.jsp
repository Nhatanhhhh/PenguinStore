<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Header Example</title>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/style.css"/>
    </head>
    <body>
        <header class="header row">
            <div class="logo col-md-3">
                <span class="mdi mdi-penguin"></span>
                <span>PENGUIN</span>
            </div>
            <div class="search-bar col-md-5 d-flex justify-content-center">
                <input type="text" placeholder="" />
            </div>
            <div class="header-icons col-md-4 d-flex justify-content-end">
                <a href="" class="icon user-icon"><i class="fa-solid fa-user-tie"></i></a>
                <a href="${pageContext.request.contextPath}/Logout" class="logout-button">Logout</a>
            </div>

        </header>
    </body>
</html>
