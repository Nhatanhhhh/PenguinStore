<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="Models.Manager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Staff</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/CSS/Admin/DashBoard.css"/>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let today = new Date();
                let minAgeDate = new Date();
                minAgeDate.setFullYear(today.getFullYear() - 18);

                let todayString = today.toISOString().split("T")[0];
                let minAgeString = minAgeDate.toISOString().split("T")[0];

                document.getElementById("dateOfBirth").setAttribute("max", todayString);

                document.querySelector("form").addEventListener("submit", function (event) {
                    let dob = new Date(document.getElementById("dateOfBirth").value);

                    if (dob > today) {
                        alert("Date of birth cannot be in the future!");
                        event.preventDefault();
                    }

                    if (dob > minAgeDate) {
                        alert("Staff must be at least 18 years old!");
                        event.preventDefault();
                    }
                });
            });
        </script>
    </head>
    <body>
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        <%
            LocalDate now = LocalDate.now();
            String formattedDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        %>
        <div>
            <div class="row">
                
                <div class="col-md-2">
                    <%@include file="Admin/NavigationMenu.jsp"%>
                </div>
                <div class="col-md-10">
                    <%@include file="Admin/HeaderAD.jsp"%>
                    <div class="card p-4">
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
                                    <input type="password" class="form-control" id="password" name="password" required>
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
                                           title="Phone number must start with 0 and contain 10 digits." required>
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Address:</label>
                                    <input type="text" class="form-control" id="address" name="address" required>
                                </div>
                                <div class="mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth: </label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
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