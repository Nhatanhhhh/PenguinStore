<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Edit Type</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/CSS/style.css"/>
    </head>
    <body>
        <%@include file="/View/HeaderAD.jsp"%>
        <div class="row">
            <div class="col-md-2">
                <%@include file="/View/NavigationMenu.jsp"%>
            </div>
            <div class="col-md-10">
                <div class="container mt-4">
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-warning text-white text-center">
                                    <h3>Edit Type Product</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${empty type}">
                                        <p class="text-danger text-center">Not found Type Product.</p>
                                        <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Back</a>
                                    </c:if>

                                    <c:if test="${not empty type}">
                                        <form action="<c:url value='/Type?action=edit'/>" method="Post">
                                            <input type="hidden" name="typeID" value="${type.typeID}">

                                            <div class="mb-3">
                                                <label for="typeName" class="form-label">Type Name:</label>
                                                <input type="text" class="form-control" id="typeName" name="typeName" value="${type.typeName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="categoryID" class="form-label">Category:</label>
                                                <select id="categoryID" name="categoryID" class="form-control">
                                                    <option value="73CF5616-FF09-416F-BB82-23089053AC57" ${type.categoryID eq '73CF5616-FF09-416F-BB82-23089053AC57' ? 'selected' : ''}>Bottom</option>
                                                    <option value="030BAAB6-1E21-4AFE-BDBF-6DAA0D66C18C" ${type.categoryID eq '030BAAB6-1E21-4AFE-BDBF-6DAA0D66C18C' ? 'selected' : ''}>Accessory</option>
                                                    <option value="FAFB0BAB-DB01-4C7F-8444-BEDEB2578024" ${type.categoryID eq 'FAFB0BAB-DB01-4C7F-8444-BEDEB2578024' ? 'selected' : ''}>Top</option>
                                                </select>
                                            </div>

                                            <button type="submit" class="btn btn-primary">Update</button>
                                            <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Cancel</a>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </body>
</html>