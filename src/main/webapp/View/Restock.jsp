<%-- 
    Document   : Restock
    Created on : Mar 1, 2025, 2:56:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Restock Product</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            form {
                max-width: 400px;
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            label {
                font-weight: bold;
            }
            input[type="text"], input[type="number"] {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
            }
            input[type="submit"] {
                background-color: #28a745;
                color: white;
                padding: 10px;
                border: none;
                cursor: pointer;
                width: 100%;
            }
            input[type="submit"]:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body style="margin: 0;">


        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>

        <div class="row">
            <div class="col-md-2">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10">
                <%@include file="Admin/HeaderAD.jsp"%>

                <h2 class="text-center">Restock Product</h2>
                <div class="container d-flex justify-content-center align-items-center">
                    <form action="Restock" method="post">

                        <input type="text" id="proVariantID" name="proVariantID" value="${proVariantID}" style="display: none;" readonly required>
                        <br><br>

                        <div class="mb-3">
                            <label for="productName" class="form-label">Product Name:</label>
                            <input readonly type="text" class="form-control" id="productName" name="productName" value="${provariant.productName}" required>
                        </div>
                        <div class="mb-3">
                            <label for="sizeName" class="form-label">Size Name:</label>
                            <input readonly type="text" class="form-control" id="sizeName" name="sizeName" value="${provariant.sizeName}" required>
                        </div>
                        <div class="mb-3">
                            <label for="colorName" class="form-label">Color Name:</label>
                            <div style="width: 25px; height: 25px; border-radius: 50%; border: 2px solid gray; background-color: ${provariant.colorName}; margin: auto;"></div>
                        </div>
                        <label for="quantity">Quantity:</label>
                        <input type="number" name="quantity" required />

                        <label for="price">Cost:</label>
                        <input type="number" step="0.01" name="price" required />

                        <button type="submit">Restock</button>
                        <a href="javascript:history.back()" class="btn btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>

</html>
