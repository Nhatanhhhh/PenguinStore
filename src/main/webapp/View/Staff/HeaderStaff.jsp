<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Header</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/bootstrap.css">
        <style>
            /* Khi hover vào menu dropdown, đổi màu nền và màu chữ */
            .dropdown-menu .dropdown-item:hover {
                background-color: black !important; /* Màu nền đen */
                color: white !important; /* Màu chữ trắng */
            }

            /* Khi hover vào menu chính (tức là thẻ `<a>` dropdown-toggle), giữ nguyên màu */
            .nav-item.dropdown:hover .nav-link {
                color: black !important; /* Màu chữ đen */
            }

        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="ListFeedbackForStaff">
                    <i class="fas fa-user-tie"></i> Staff Panel
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="ListFeedbackForStaff"><i class="fas fa-comments"></i> Feedback</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="staffDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-user"></i> Account
                            </a>
                            <div class="dropdown-menu dropdown-menu-right animate-dropdown" aria-labelledby="staffDropdown">
                                <a class="dropdown-item text-danger" href="Logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </div>
                        </li>

                    </ul>
                </div>
            </div>
        </nav>
    </body>
</html>
