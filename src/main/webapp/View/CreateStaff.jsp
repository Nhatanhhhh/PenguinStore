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
        <style>
            :root {
                --primary-color: #84AF9A;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            .create-staff-container {
                max-width: 800px;
                margin: 30px auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                overflow: hidden;
            }

            .create-staff-header {
                background: var(--primary-color);
                color: white;
                padding: 20px;
                text-align: center;
            }

            .create-staff-title {
                font-size: 24px;
                font-weight: 600;
                margin: 0;
            }

            .create-staff-body {
                padding: 30px;
            }

            .form-label {
                font-weight: 600;
                color: var(--dark-gray);
                margin-bottom: 8px;
                display: block;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 16px;
                transition: all 0.3s;
                margin-bottom: 20px;
            }

            .form-control:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
                outline: none;
            }

            .btn-container {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
            }

            .btn-submit {
                background: var(--primary-color);
                color: white;
                border: none;
                padding: 12px 25px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-submit:hover {
                background: #1a252f;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .btn-cancel {
                background: white;
                color: var(--dark-gray);
                border: 1px solid #ddd;
                padding: 12px 25px;
                font-size: 16px;
                font-weight: 600;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-cancel:hover {
                background: #f8f9fa;
                border-color: #ccc;
            }

            .error-message {
                color: var(--accent-color);
                text-align: center;
                margin-bottom: 20px;
                padding: 10px;
                background: rgba(231, 76, 60, 0.1);
                border-radius: 5px;
                border-left: 4px solid var(--accent-color);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .create-staff-container {
                    margin: 15px;
                }

                .create-staff-body {
                    padding: 20px;
                }

                .btn-container {
                    flex-direction: column;
                }

                .btn-submit, .btn-cancel {
                    width: 100%;
                }
            }
        </style>
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
                    <div class="create-staff-container" style="width: 50vw;">
                        <div class="create-staff-header">
                            <h1 class="create-staff-title">Create New Staff</h1>
                        </div>
                        <div class="create-staff-body">
                            <c:if test="${not empty error}">
                                <div class="error-message">${error}</div>
                            </c:if>
                            <form action="<c:url value='/Staff?action=create'/>" method="post">
                                <div class="form-group">
                                    <label for="managerName" class="form-label">Staff Username</label>
                                    <input type="text" class="form-control" id="managerName" name="managerName" 
                                           placeholder="Enter staff username" required>
                                </div>

                                <div class="form-group">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Enter password" required>
                                </div>

                                <div class="form-group">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           placeholder="Enter full name" required>
                                </div>

                                <div class="form-group">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="Enter email address" required>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" 
                                           pattern="^0[0-9]{9}$"
                                           title="Phone number must start with 0 and contain 10 digits."
                                           placeholder="Enter phone number (e.g., 0987654321)" required>
                                </div>

                                <div class="form-group">
                                    <label for="address" class="form-label">Address</label>
                                    <input type="text" class="form-control" id="address" name="address" 
                                           placeholder="Enter address" required>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                </div>

                                <div class="btn-container">
                                    <a href="<c:url value='/Staff?action=list'/>" class="btn-cancel">Cancel</a>
                                    <button type="submit" class="btn-submit">Create Staff</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div><script>
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
    </body>
</html>