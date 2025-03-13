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
                            <h3>Create Staff</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <p class="text-danger text-center">${error}</p>
                            </c:if>
                            <form action="<c:url value='/Staff?action=create'/>" method="post">
                                            <div class="mb-3">
                                                <label for="managerName" class="form-label">Staff Name:</label>
                                                <input type="text" class="form-control" id="managerName" name="managerName" required>
                                            </div>

                                           <div class="mb-3">
                                                <label for="password" class="form-label">Password:</label>
                                                <input type="password" class="form-control" id="password" name="password">
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="fullName" class="form-label">Full Name:</label>
                                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                                            </div>
                                            
                                             <div class="mb-3">
                                                <label for="email" class="form-label">Email: </label>
                                                <input type="email" class="form-control" id="email" name="email" required>
                                            </div>
                                            
                                           <div class="mb-3">
                                                <label for="phoneNumber" class="form-label">Phone Number: </label>
                                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" 
                                                      
                                                       pattern="^0[0-9]{9}$"
                                                       title="Số điện thoại phải bắt đầu bằng số 0 và có 10 chữ số." required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="address" class="form-label">Address:</label>
                                                <input type="text" class="form-control" id="address" name="address" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="dateOfBirth" class="form-label">Date of Birth: </label>
                                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"  required>
                                            </div>

                                <button type="submit" class="btn btn-success">Create</button>
                                <a href="<c:url value='/Staff?action=list'/>" class="btn btn-secondary">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>