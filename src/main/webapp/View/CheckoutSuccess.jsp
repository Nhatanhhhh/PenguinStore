<%--
    Document   : CheckoutSuccess
    Created on : Mar 2, 2025, 3:29:05 PM
    Author     : Loc_LM
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Successful | Penguin Fashion</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <style>
            :root {
                --primary-color: #4361ee;
                --secondary-color: #3f37c9;
                --success-color: #4cc9f0;
                --light-color: #f8f9fa;
                --dark-color: #212529;
            }

            body {
                background-color: #f5f7ff;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .success-container {
                max-width: 650px;
                margin: 80px auto;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                background-color: white;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .success-container::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 8px;
                background: linear-gradient(90deg, var(--primary-color), var(--success-color));
            }

            .success-icon {
                width: 100px;
                height: 100px;
                background-color: #e6f7ff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 25px;
                color: var(--success-color);
                font-size: 50px;
                border: 5px solid #d1f2ff;
            }

            .success-container h2 {
                color: var(--primary-color);
                margin-bottom: 15px;
                font-size: 2.2rem;
                font-weight: 700;
            }

            .success-container p {
                font-size: 1.1rem;
                color: #555;
                margin-bottom: 20px;
                line-height: 1.6;
            }

            .order-card {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                margin: 25px 0;
                border-left: 4px solid var(--primary-color);
            }

            .order-id {
                font-weight: 700;
                color: var(--primary-color);
                font-size: 1.3rem;
                letter-spacing: 1px;
            }

            .order-detail {
                margin-top: 10px;
                color: #6c757d;
                font-size: 0.9rem;
            }

            .button-group {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 30px;
                flex-wrap: wrap;
            }

            .btn-custom {
                padding: 12px 25px;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 160px;
                border: none;
            }

            .btn-primary-custom {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-primary-custom:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            }

            .btn-outline-custom {
                background-color: white;
                color: var(--primary-color);
                border: 2px solid var(--primary-color);
            }

            .btn-outline-custom:hover {
                background-color: #f0f3ff;
                transform: translateY(-2px);
            }

            .confetti {
                position: absolute;
                width: 10px;
                height: 10px;
                background-color: var(--success-color);
                opacity: 0;
            }

            @media (max-width: 768px) {
                .success-container {
                    margin: 40px 20px;
                    padding: 30px 20px;
                }

                .button-group {
                    flex-direction: column;
                    gap: 10px;
                }

                .btn-custom {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            String orderID = request.getParameter("orderID");
        %>
        <div class="container">
            <div class="success-container">
                <div class="success-icon">
                    <i class="bi bi-check-circle-fill"></i>
                </div>
                <h2>Order Confirmed!</h2>
                <p>Thank you for shopping with Penguin Fashion. Your order has been successfully placed and is being processed.</p>

                <div class="order-card">
                    <div>Order Number</div>
                    <div class="order-id">
                        <%= orderID != null ? "PENGUIN-" + orderID.substring(0, 8).toUpperCase() : "N/A"%>
                    </div>
                    <div class="order-detail">
                        A confirmation email has been sent to your registered email address
                    </div>
                </div>

                <div class="button-group">
                    <a href="<%= request.getContextPath()%>/Product" class="btn-custom btn-primary-custom">
                        <i class="bi bi-house-door me-2"></i> Continue Shopping
                    </a>
                    <a href="<%= request.getContextPath()%>/OrderHistory" class="btn-custom btn-outline-custom">
                        <i class="bi bi-receipt me-2"></i> View Order Details
                    </a>
                </div>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>

        <script>
            // Simple confetti effect
            document.addEventListener('DOMContentLoaded', function () {
                const colors = ['#4361ee', '#3f37c9', '#4cc9f0', '#4895ef', '#560bad'];
                const container = document.querySelector('.success-container');

                for (let i = 0; i < 50; i++) {
                    const confetti = document.createElement('div');
                    confetti.classList.add('confetti');
                    confetti.style.left = Math.random() * 100 + '%';
                    confetti.style.top = -10 + 'px';
                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    confetti.style.width = Math.random() * 8 + 5 + 'px';
                    confetti.style.height = confetti.style.width;
                    container.appendChild(confetti);

                    const animationDuration = Math.random() * 3 + 2;

                    confetti.animate([
                        {transform: 'translateY(0) rotate(0deg)', opacity: 1},
                        {transform: `translateY(${Math.random() * 300 + 100}px) rotate(${Math.random() * 360}deg)`, opacity: 0}
                    ], {
                        duration: animationDuration * 1000,
                        delay: Math.random() * 2000,
                        easing: 'cubic-bezier(0.1, 0.8, 0.3, 1)'
                    });
                }
            });
        </script>
    </body>
</html>