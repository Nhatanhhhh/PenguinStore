<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page isELIgnored="false"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Customer, Models.Manager"%>

<%
    if (session != null) {
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
            pageContext.setAttribute("userObj", customer != null ? customer : manager);
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <title>Header Example</title>

        <style>
            input[type="text"]:focus,
            input[type="search"]:focus {
                border-color: black !important;
                box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.25) !important;
                outline: none !important;
            }
            .nav-menu {
                display: flex;
                gap: 20px;
                position: relative;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: white;
                min-width: 150px;
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
                z-index: 1;
            }

            .dropdown-content a {
                color: black;
                padding: 10px;
                display: block;
                text-decoration: none;
            }

            .dropdown-content a:hover {
                background-color: #ddd;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }

        </style>
    </head>
    <body>
        <header class="header container-fuild row">
            <div class="logo col-md-3">
                <a href="<%= request.getContextPath()%>">
                    <span class="mdi mdi-penguin"></span>
                    <span>PENGUIN</span>
                </a>
            </div>
            <div class="search-bar col-md-5">
                <input type="text" id="searchInput" name="keysearch" placeholder="Enter name, type to search product..." autocomplete="off"/>
            </div>


            <!-- Nếu user chưa đăng nhập -->
            <c:if test="${sessionScope.userObj == null}">
                <div class="col-md-4 d-flex justify-content-end">
                    <a href="<%= request.getContextPath()%>/Register" class="button button-dark ml-2 mr-2">REGISTER</a>
                    <a href="<%= request.getContextPath()%>/Login" class="button button-dark ml-2 mr-2">LOGIN</a>
                </div>
            </c:if> 

            <!-- Nếu user đã đăng nhập -->
            <c:if test="${sessionScope.userObj != null}">
                <div class="header-icons col-md-4 d-flex justify-content-end">
                    <a href="<%= request.getContextPath()%>/Cart" class="icon cart-icon" style="margin: 0 15px;"><span class="mdi mdi-cart-outline button button-dark" style="border-radius: 4px;"></span></a>
                    <a href="<%= request.getContextPath()%>/ViewProfile" class="icon user-icon" style="margin: 0 15px;"><span class="mdi mdi-account button button-dark" style="border-radius: 4px;"></span></a>
                    <a href="<%= request.getContextPath()%>/Logout" class="button button-dark ml-2 mr-2">Logout</a>
                </div>
            </c:if>

        </header>
        <nav class="nav-menu">
            <a href="<c:url value='/Product'/>">Product</a>

            <c:forEach var="entry" items="${categoryMap}">
                <div class="dropdown">
                    <a class="menu-down" href="<c:url value='/Product?category=${entry.key}&action=detailType'/>">${entry.key} <span class="mdi mdi-menu-down-outline"></span></a>
                    <div class="dropdown-content">
                        <c:forEach var="type" items="${entry.value}">
                            <a href="<c:url value='/Product?type=${type.typeName}&action=detailType'/>">${type.typeName}</a>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </nav>
        <script>
            document.getElementById("searchInput").addEventListener("keypress", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    let keysearch = this.value.trim();
                    if (keysearch.length > 0) {
                        window.location.href = "Product?action=search&keysearch=" + encodeURIComponent(keysearch);
                    } else {
                        window.location.href = "Product?action=view";
                    }
                }
            });

        </script>
    </body>
</html>