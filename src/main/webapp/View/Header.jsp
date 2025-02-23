<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Header Example</title>

        <link rel="stylesheet" href="Assets/CSS/Guest/styles.css"/>
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
                <button class="icon cart-icon"><span class="mdi mdi-cart-outline"></span></button>
                <button class="icon user-icon"><span class="mdi mdi-account"></span></button>
                <button class="logout-button">Logout</button>
            </div>

        </header>
        <nav class="nav-menu">
            <a href="#">Product</a>
            <a class="menu-down" href="#">Trousers <span class="mdi mdi-menu-down-outline"></span></a>
            <a class="menu-down" href="#">Accessories <span class="mdi mdi-menu-down-outline"></span></a>
            <a class="menu-down" href="#">New <span class="mdi mdi-menu-down-outline"></span></a>
        </nav>
    </body>
</html>