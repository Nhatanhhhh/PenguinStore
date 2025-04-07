<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <title>Forget PassWord | Penguin Fashion</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/forgetpassword.css"/>
    </head>
    <body>
        <div class="bg-light py-3 py-md-5">
            <div class="container">
                <div class="row justify-content-md-center">
                    <div class="col-12 col-md-11 col-lg-8 col-xl-7 col-xxl-6">
                        <div class="bg-white p-4 p-md-5 rounded shadow-sm">
                            <div class="row gy-3 mb-5">
                                <div class="col-12">
                                    <h2 class="fs-6 fw-normal text-center text-secondary m-0 px-md-5" style="font-size: 24px;">Provide the email address associated with your account to recover your password.</h2>
                                </div>
                            </div>
                            <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    if (typeof Swal === "undefined") {
                                        console.error("SweetAlert2 is not loaded. Check your network connection or CDN.");
                                    } else {
                                <%
                                    HttpSession sessionObj = request.getSession();
                                    String errorMessage = (String) sessionObj.getAttribute("errorMessage");
                                    String successMessage = (String) sessionObj.getAttribute("successMessage");

                                    // Remove attributes after displaying alerts
                                    sessionObj.removeAttribute("errorMessage");
                                    sessionObj.removeAttribute("successMessage");
                                %>

                                <% if (errorMessage != null) {%>
                                        Swal.fire({
                                            title: "Error",
                                            text: "<%= errorMessage%>",
                                            icon: "error",
                                            confirmButtonText: "OK",
                                            timer: 2500
                                        });
                                <% } %>

                                <% if (successMessage != null) {%>
                                        Swal.fire({
                                            title: "Success",
                                            text: "<%= successMessage%>",
                                            icon: "success",
                                            confirmButtonText: "OK",
                                            timer: 2500
                                        });
                                <% }%>
                                    }
                                });
                            </script>

                            <form action="<%= request.getContextPath()%>/ForgetPassword" method="POST">
                                <div class="row gy-3 gy-md-4 overflow-hidden">
                                    <div class="col-12">
                                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input type="email" class="form-control input100 validate-input" name="email" id="email" required>
                                        </div>
                                    </div>
                                    <div class="col-12 pt-4">
                                        <div class="d-flex justify-content-center">
                                            <button class="btn btn-outline-dark btn-lg" type="submit">Reset Password</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                            <div class="row">
                                <div class="col-12">
                                    <hr class="mt-5 mb-4 border-secondary-subtle">
                                    <div class="d-flex gap-4 justify-content-center">
                                        <div class="row">
                                            <div class="col-md-6"><a href="<%= request.getContextPath()%>/Login" class="link-secondary text-decoration-none">Log In</a></div>
                                            <div class="col-md-6"><a href="<%= request.getContextPath()%>/Register" class="link-secondary text-decoration-none">Register</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/forgetpassword.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </body>
</html>