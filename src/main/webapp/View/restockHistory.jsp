<%-- 
    Document   : restockHistory
    Created on : Mar 1, 2025, 2:56:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Restock History</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid black;
                padding: 10px;
                text-align: center;
            }
            th {
                background-color: lightgray;
            }
        </style>
    </head>
    <body>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/Admin/restockstyles.css"/>
        
        
        <%@include file="../View/HeaderAD.jsp"%>
        <%@include file="../View/NavigationMenu.jsp"%>
        <h2>Restock History</h2>

        <c:if test="${empty restockHistory}">
            <p>Not data Restock.</p>
        </c:if>

        <c:if test="${not empty restockHistory}">
            <table>
                <tr>
                    <th>Product Variant ID</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Total Cost</th>
                    <th>Restock Date</th>
                </tr>
                <c:forEach var="restock" items="${restockHistory}">
                    <tr>
                        <td>${restock.proVariantID}</td>
                        <td>${restock.quantity}</td>
                        <td>${restock.price}</td>
                        <td>${restock.totalCost}</td>
                        <td>${restock.restockDay}</td>
                    </tr>
                </c:forEach>
            </table>
            <a href="<c:url value='/'/>" class="btn btn-secondary">Cancel</a>
        </c:if>
    </body>
</html>
