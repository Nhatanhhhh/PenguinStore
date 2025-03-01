<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Restock Product</title>
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
    <body>
        <%@include file="../View/HeaderAD.jsp"%>
        <%@include file="../View/NavigationMenu.jsp"%>

        <div class="container">
            <h2>Restock Product</h2>
            <form action="Restock" method="post">
                <input type="hidden" name="restockDate" value="<%= formattedDate %>">
                <label for="proVariantID">Product Variant ID:</label>
                <input type="text" id="proVariantID" name="proVariantID" value="${proVariantID}" readonly required><br><br>

                <label for="quantity">Quantity:</label>
                <input type="number" name="quantity" required />

                <label for="price">Cost:</label>
                <input type="number" step="0.01" name="price" required />

                <button type="submit">Restock</button>
                <a href="<c:url value='/'/>" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </body>

</html>
