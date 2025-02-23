<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page isELIgnored="false"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Customer, Models.Manager"%>

<%
    Object user = session.getAttribute("user");

    Customer customer = null;
    Manager manager = null;

    if (user instanceof Customer) {
        customer = (Customer) user;
    } else if (user instanceof Manager) {
        manager = (Manager) user;
    }

    if (customer != null || manager != null) {
        session.setAttribute("userObj", customer != null ? customer : manager);
    }
%>



<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Header Example</title>

        <style>
            input[type="text"]:focus,
            input[type="search"]:focus {
                border-color: black !important;
                box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.25) !important;
                outline: none !important;
            }
        </style>
    </head>
    <body>
        <header class="header container-fuild row">
            <div class="logo col-md-3">
                <a href="<%= request.getContextPath() %>">
                    <span class="mdi mdi-penguin"></span>
                    <span>PENGUIN</span>
                </a>
            </div>
            <div class="search-bar col-md-5">
                <input type="text" placeholder=""/>
            </div>

            <!-- Nếu user đã đăng nhập -->
            <c:if test="${not empty userObj}">
                <div class="header-icons col-md-4 d-flex justify-content-end">
                    <a href="#" class="icon cart-icon"><span class="mdi mdi-cart-outline"></span></a>
                    <a href="#" class="icon user-icon"><span class="mdi mdi-account"></span></a>
                    <a href="<%= request.getContextPath() %>/Logout" class="logout-button">Logout</a>
                </div>
            </c:if>

            <!-- Nếu user chưa đăng nhập -->
            <c:if test="${empty userObj}">
                <div class="col-md-4 d-flex justify-content-end">
                    <a href="<%= request.getContextPath() %>/View/Register.jsp" class="button button-dark ml-2 mr-2">REGISTER</a>
                    <a href="<%= request.getContextPath() %>/View/LoginCustomer.jsp" class="button button-dark ml-2 mr-2">LOGIN</a>
                </div>
            </c:if>   
        </header>

        <nav class="nav-menu">
            <a href="#">Product</a>
            <a class="menu-down" href="#">Trousers <span class="mdi mdi-menu-down-outline"></span></a>
            <a class="menu-down" href="#">Accessories <span class="mdi mdi-menu-down-outline"></span></a>
            <a class="menu-down" href="#">New <span class="mdi mdi-menu-down-outline"></span></a>
        </nav>
    </body>
</html>
