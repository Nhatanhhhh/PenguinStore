<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Edit Type</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
         <%@include file="../../Admin/HeaderAD.jsp"%>
        <%@include file="../../Admin/NavigationMenu.jsp"%>
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-warning text-white text-center">
                            <h3>Edit Type Product</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty type}">
                                <p class="text-danger text-center">Không tìm thấy loại sản phẩm.</p>
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
    </body>
</html>
