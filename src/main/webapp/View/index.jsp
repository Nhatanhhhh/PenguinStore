<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/custom.css"/>

    </head>
    <body>
        <%@include file="Header.jsp"%>
        <p class="d-flex justify-content-center" style="color:red;">
            <%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : ""%>
        </p>

        <div class="container" style="padding-bottom: 50px;">
            <div class="row">
                <img src="Image/Index/Background.png" class="" style="width: 100%; height: auto;" alt="Background" data-aos="fade-up">
            </div>
        </div>

        <div class="div" style="margin-left: 58px; margin-bottom: 50px; margin-right: 20px;">
            <div class="star-shooting-outline" data-aos="zoom-in"></div>
            <div class="div2" data-aos="fade-right">
                <div class="modern-style-is-a-blend-of-minimalism-and-personality-highlighting-your-unique-personality">
                    Modern style is a blend of minimalism and personality, highlighting your unique personality
                </div>
                <div class="fashion-is-not-just-about-clothes-it-s-also-about-how-you-tell-your-own-story">
                    Fashion is not just about clothes, it&#039;s also about how you tell your own story
                </div>
                <span class="mdi mdi-star-shooting vector" style="font-size: 100px;" data-aos="flip-left"></span>
                <span class="mdi mdi-star-shooting vector2" style="font-size: 100px;" data-aos="flip-right"></span>
            </div>
            <img class="pexels-pixabay-157675-1" src="Image/Account/item12.jpg" data-aos="fade-up"/>
            <img class="image" src="Image/Product/item7.jpg" data-aos="fade-up" data-aos-delay="200"/>
        </div>

        <div class="section-1">
            <div class="container">
                <div class="row">
                    <div class="col-md-6" data-aos="fade-left">
                        <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
                    </div>
                    <div class="col-md-6" data-aos="fade-right">
                        <div style="width: 300px; height: 80px; margin-top: 40px;">
                            <h1 style="font-size: 40px; text-align: left;">DON'T FORGET OUR NEW PRODUCTS</h1>
                            <div style="margin-left: 50px; margin-top: 50px;">
                                <a href="#" class="button button-dark">New Products</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Lấy thông báo từ session
                var successMessage = "<%= session.getAttribute("successMessage") != null ? session.getAttribute("successMessage") : ""%>";
                var errorMessage = "<%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : ""%>";
                var showSweetAlert = "<%= session.getAttribute("showSweetAlert") != null ? session.getAttribute("showSweetAlert") : "false"%>";

                // Xóa session sau khi lấy dữ liệu
            <% session.removeAttribute("successMessage"); %>
            <% session.removeAttribute("errorMessage"); %>
            <% session.removeAttribute("showSweetAlert");%>

                if (typeof Swal !== "undefined") {
                    if (successMessage !== "") {
                        Swal.fire({
                            position: "top-end",
                            icon: "success",
                            title: successMessage,
                            showConfirmButton: false,
                            timer: 2000
                        });
                    }

                    if (errorMessage !== "" && showSweetAlert === "true") {
                        Swal.fire({
                            icon: 'error',
                            title: 'Login Failed',
                            text: errorMessage,
                            confirmButtonText: 'OK'
                        }).then(() => {
                            window.location.href = "<%= request.getContextPath()%>/View/LoginCustomer.jsp";
                        });
                    }
                } else {
                    console.error("SweetAlert2 is not loaded!");
                }
            });
        </script>


        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>