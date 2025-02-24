<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create Type</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
    </head>
    <body>
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-success text-white text-center">
                            <h3>Create Type</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <p class="text-danger text-center">${error}</p>
                            </c:if>
                            <form action="<c:url value='/Type?action=create'/>" method="post">
                                <div class="mb-3">
                                    <label for="typeName" class="form-label">Type Name:</label>
                                    <input type="text" class="form-control" id="typeName" name="typeName" required>
                                </div>

                                <div class="mb-3">
                                    <label for="categoryID" class="form-label">Category:</label>
                                    <select id="categoryID" name="categoryID" class="form-control">
                                        <option value="73CF5616-FF09-416F-BB82-23089053AC57">Bottom</option>
                                        <option value="030BAAB6-1E21-4AFE-BDBF-6DAA0D66C18C">Accessory</option>
                                        <option value="FAFB0BAB-DB01-4C7F-8444-BEDEB2578024">Top</option>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-success">Create</button>
                                <a href="<c:url value='/Type?action=list'/>" class="btn btn-secondary">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>