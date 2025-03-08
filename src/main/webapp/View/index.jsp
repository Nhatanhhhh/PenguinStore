<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
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
        <div  class="container"  style="padding-bottom: 50px;">
            <div class="row">
                <img src="Image/Index/Background.png" class="" style="width: 100%; height: auto;" alt="Background">
            </div>
        </div>

        <div class="div" style="margin-left: 58px; margin-bottom: 50px; margin-right: 20px;">
            <div class="star-shooting-outline"></div>
            <div class="div2">
                <div
                    class="modern-style-is-a-blend-of-minimalism-and-personality-highlighting-your-unique-personality"
                    >
                    Modern style is a blend of minimalism and personality, highlighting your
                    unique personality
                </div>
                <div
                    class="fashion-is-not-just-about-clothes-it-s-also-about-how-you-tell-your-own-story"
                    >
                    Fashion is not just about clothes, it&#039;s also about how you tell your
                    own story
                    <br />
                </div>
                <span class="mdi mdi-star-shooting vector" style="font-size: 100px;"></span>
                <span class="mdi mdi-star-shooting vector2" style="font-size: 100px;"></span>
            </div>
            <img class="pexels-pixabay-157675-1" src="Image/Account/item12.jpg" />
            <img class="image" src="Image/Product/item7.jpg" />
        </div>

        <div class="section-1">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <img style="width: 380px; height: 380px;" src="Image/Product/window.png" />
                    </div>
                    <div class="col-md-6">
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



        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

    </body>
</html>
