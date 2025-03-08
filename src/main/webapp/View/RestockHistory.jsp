<%-- 
    Document   : restockHistory
    Created on : Mar 1, 2025, 2:56:07 PM
    Author     : Do Van Luan - CE180457
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/restockstyles.css"/>
        <%@include file="Admin/HeaderAD.jsp"%>

        <div class="row">
            <div class="col-md-3">
                <%@include file="Admin/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-9">
                <h2 class="text-center">Restock History</h2>
                <div class="container">
                    <c:if test="${empty restockHistory}">
                        <p>Not data Restock.</p>
                    </c:if>

                    <c:if test="${not empty restockHistory}">
                        <table>
                            <tr>

                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Total Cost</th>
                                <th>Restock Date</th>
                            </tr>
                            <c:forEach var="restock" items="${restockHistory}">
                                <tr>

                                    <td>${restock.quantity}</td>
                                    <td>${restock.price}</td>
                                    <td>${restock.totalCost}</td>
                                    <td>${restock.restockDay}</td>
                                </tr>
                            </c:forEach>
                        </table>
                        <a href="javascript:history.back()" class="btn btn-secondary">Cancel</a>
                    </c:if>
                </div>

            </div>
        </div>
    </body>
</html>