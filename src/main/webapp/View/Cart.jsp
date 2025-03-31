<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart | Penguin Fashion</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            .cart-page {
                padding: 3rem 0;
                background-color: #f9f9f9;
                min-height: 70vh;
            }

            .cart-container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.05);
                padding: 2rem;
            }

            .cart-title {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 2rem;
                text-align: center;
                position: relative;
                padding-bottom: 1rem;
            }

            .cart-title:after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 3px;
                background: var(--accent-color);
            }

            .cart-header {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr;
                gap: 1rem;
                padding: 1rem 0;
                border-bottom: 1px solid #eee;
                font-weight: 600;
                color: var(--dark-gray);
            }

            .cart-item {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr;
                gap: 1rem;
                padding: 1.5rem 0;
                border-bottom: 1px solid #eee;
                align-items: center;
            }

            .product-info {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .product-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 5px;
                border: 1px solid #eee;
            }

            .product-details {
                flex: 1;
            }

            .product-name {
                font-weight: 600;
                margin-bottom: 0.5rem;
                color: var(--primary-color);
            }

            .product-attributes {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 0.5rem;
            }

            .remove-btn {
                background: none;
                border: none;
                color: var(--accent-color);
                cursor: pointer;
                font-size: 0.9rem;
                padding: 0;
                text-decoration: underline;
            }

            .remove-btn:hover {
                color: #c0392b;
            }

            .price {
                font-weight: 600;
                color: var(--primary-color);
            }

            .quantity-control {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .quantity-btn {
                width: 30px;
                height: 30px;
                background: var(--light-gray);
                border: 1px solid #ddd;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 1rem;
                transition: all 0.2s;
            }

            .quantity-btn:hover {
                background: var(--secondary-color);
                color: white;
                border-color: var(--secondary-color);
            }

            .quantity-display {
                width: 40px;
                text-align: center;
                margin: 0 5px;
                font-weight: 600;
            }

            .item-total {
                font-weight: 600;
                color: var(--accent-color);
                text-align: right;
            }

            .cart-summary {
                margin-top: 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .subtotal {
                font-size: 1.2rem;
                font-weight: 600;
            }

            .subtotal-amount {
                color: var(--accent-color);
            }

            .cart-actions {
                display: flex;
                gap: 1rem;
            }

            .clear-cart-btn, .checkout-btn {
                padding: 0.8rem 1.5rem;
                border-radius: 4px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
            }

            .clear-cart-btn {
                background: white;
                border: 1px solid var(--accent-color);
                color: var(--accent-color);
            }

            .clear-cart-btn:hover {
                background: var(--accent-color);
                color: white;
            }

            .checkout-btn {
                background: var(--primary-color);
                color: white;
                border: none;
            }

            .checkout-btn:hover {
                background: #1a252f;
                transform: translateY(-2px);
            }

            .empty-cart {
                text-align: center;
                padding: 3rem 0;
            }

            .empty-cart-icon {
                font-size: 3rem;
                color: #ddd;
                margin-bottom: 1rem;
            }

            .empty-cart-message {
                font-size: 1.2rem;
                margin-bottom: 1.5rem;
                color: #666;
            }

            .shop-link {
                color: var(--secondary-color);
                font-weight: 600;
                text-decoration: none;
            }

            .shop-link:hover {
                text-decoration: underline;
            }

            .stock-info {
                font-size: 0.8rem;
                color: #666;
                margin-top: 5px;
            }
            @media (max-width: 768px) {
                .cart-header {
                    display: none;
                }

                .cart-item {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                    padding: 1.5rem 0;
                    position: relative;
                }

                .product-info {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .price, .quantity-control, .item-total {
                    text-align: left;
                }

                .item-total {
                    font-size: 1.1rem;
                }

                .cart-summary {
                    flex-direction: column;
                    gap: 1.5rem;
                    align-items: flex-start;
                }

                .cart-actions {
                    width: 100%;
                    flex-direction: column;
                }

                .clear-cart-btn, .checkout-btn {
                    width: 100%;
                }

                .stock-info {
                    text-align: left;
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>

        <main class="cart-page">
            <div class="cart-container">
                <h1 class="cart-title">Your Shopping Cart</h1>

                <%@ page import="java.util.List, Models.CartItem" %>
                <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems"); %>

                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <div class="cart-header">
                    <span>Product</span>
                    <span>Price</span>
                    <span class="text-center">Quantity</span>
                    <span>Total</span>
                </div>

                <% double subtotal = 0; %>
                <% for (CartItem item : cartItems) {%>
                <div class="cart-item">
                    <div class="product-info">
                        <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                             alt="<%= item.getProductName()%>" class="product-image">
                        <div class="product-details">
                            <h3 class="product-name"><%= item.getProductName()%></h3>
                            <% if (item.getColorName() != null && !item.getColorName().isEmpty()) {%>
                            <p class="product-attributes">Color: <%= item.getColorName()%></p>
                            <% } %>
                            <% if (item.getSizeName() != null && !item.getSizeName().isEmpty()) {%>
                            <p class="product-attributes">Size: <%= item.getSizeName()%></p>
                            <% }%>
                            <form action="<%= request.getContextPath()%>/Cart" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="cartID" value="<%= (item.getCartID() != null) ? item.getCartID() : ""%>">
                                <button type="submit" class="remove-btn">
                                    <i class="fas fa-trash-alt"></i> Remove
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="price">
                        <fmt:formatNumber value="<%= item.getPrice()%>" pattern="#,###"/> ₫
                    </div>

                    <div class="quantity-control">
                        <button class="quantity-btn" 
                                onclick="changeQuantity(-1, <%= item.getPrice()%>, '<%= item.getCartID()%>', ${stockQuantities[item.cartID]})">-</button>
                        <span class="quantity-display" id="quantity_<%= item.getCartID().replaceAll("\\s", "")%>"><%= item.getQuantity()%></span>
                        <button class="quantity-btn" 
                                onclick="changeQuantity(1, <%= item.getPrice()%>, '<%= item.getCartID()%>', ${stockQuantities[item.cartID]})">+</button>
                    </div>
                    <div class="stock-info">
                        <%
                            Map<String, Integer> stocks = (Map<String, Integer>) request.getAttribute("stockQuantities");
                            if (stocks != null && item != null) {
                                out.print("Stock: " + stocks.get(item.getCartID()));
                            } else {
                                out.print("Stock: N/A");
                            }
                        %>
                    </div>

                    <div class="item-total" id="total_<%= item.getCartID()%>">
                        <fmt:formatNumber value="<%= item.getPrice() * item.getQuantity()%>" pattern="#,###"/> ₫
                    </div>
                </div>
                <% subtotal += item.getPrice() * item.getQuantity(); %>
                <% }%>

                <div class="cart-summary">
                    <div class="subtotal">
                        Subtotal: <span class="subtotal-amount" id="subtotal" data-subtotal="<%= subtotal%>">
                            <fmt:formatNumber value="<%= subtotal%>" pattern="#,###"/> ₫
                        </span>
                    </div>

                    <div class="cart-actions">
                        <button type="button" class="clear-cart-btn" onclick="confirmClearCart()">
                            <i class="fas fa-broom"></i> Clear Cart
                        </button>


                        <form action="<%= request.getContextPath()%>/Checkout" method="post">
                            <button type="submit" class="checkout-btn">
                                <i class="fas fa-credit-card"></i> Proceed to Checkout
                            </button>
                        </form>
                    </div>
                </div>
                <% } else {%>
                <div class="empty-cart">
                    <div class="empty-cart-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <p class="empty-cart-message">Your cart is empty</p>
                    <a href="<%= request.getContextPath()%>/Product" class="shop-link">
                        <i class="fas fa-arrow-left"></i> Continue Shopping
                    </a>
                </div>
                <% }%>
            </div>
        </main>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
                            function changeQuantity(amount, price, cartID, stockQuantity) {
                                // Sử dụng cartID gốc thay vì cleanCartID để đồng bộ với server
                                let quantityElement = document.getElementById("quantity_" + cartID.replace(/\s/g, ''));
                                let totalElement = document.getElementById("total_" + cartID);
                                let currentQuantity = parseInt(quantityElement.innerText);
                                let newQuantity = currentQuantity + amount;

                                if (newQuantity < 1) {
                                    return;
                                }

                                // Kiểm tra stock quantity
                                if (newQuantity > stockQuantity) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Stock Limit',
                                        text: 'You cannot add more than ' + stockQuantity + ' items of this product.',
                                        confirmButtonColor: '#2c3e50'
                                    });
                                    return;
                                }

                                // Update UI tạm thời
                                quantityElement.innerText = newQuantity;
                                let newTotal = price * newQuantity;
                                totalElement.innerText = formatCurrency(newTotal);

                                // Gọi AJAX
                                $.ajax({
                                    url: "<%= request.getContextPath()%>/Cart",
                                    type: "POST",
                                    data: {
                                        action: 'update',
                                        cartID: cartID,
                                        quantity: newQuantity
                                    },
                                    dataType: 'json', // Thêm dòng này để đảm bảo nhận JSON
                                    success: function (data) {
                                        if (data.status === "success") {
                                            // Cập nhật subtotal từ dữ liệu server trả về
                                            document.getElementById('subtotal').innerText = formatCurrency(data.subtotal);
                                        } else {
                                            Swal.fire({
                                                icon: 'error',
                                                title: 'Error',
                                                text: data.message || 'Failed to update quantity',
                                                confirmButtonColor: '#2c3e50'
                                            });
                                            // Khôi phục giá trị cũ
                                            quantityElement.innerText = currentQuantity;
                                            totalElement.innerText = formatCurrency(price * currentQuantity);
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error',
                                            text: 'An error occurred while updating cart: ' + error,
                                            confirmButtonColor: '#2c3e50'
                                        });
                                        // Khôi phục giá trị cũ
                                        quantityElement.innerText = currentQuantity;
                                        totalElement.innerText = formatCurrency(price * currentQuantity);
                                    }
                                });
                            }

                            // Hàm định dạng tiền tệ
                            function formatCurrency(amount) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    maximumFractionDigits: 0
                                }).format(amount).replace('₫', '₫');
                            }

                            function confirmClearCart() {
                                Swal.fire({
                                    title: 'Are you sure?',
                                    text: "You won't be able to revert this! All items in your cart will be removed.",
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonColor: '#2c3e50',
                                    cancelButtonColor: '#d33',
                                    confirmButtonText: 'Yes, clear it!',
                                    cancelButtonText: 'Cancel'
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        // Nếu người dùng xác nhận, gửi request clear cart
                                        $.ajax({
                                            url: "<%= request.getContextPath()%>/Cart",
                                            type: "POST",
                                            data: {
                                                action: 'clear'
                                            },
                                            success: function (response) {
                                                // Reload trang sau khi clear thành công
                                                window.location.reload();
                                            },
                                            error: function (xhr, status, error) {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error',
                                                    text: 'An error occurred while clearing cart',
                                                    confirmButtonColor: '#2c3e50'
                                                });
                                            }
                                        });
                                    }
                                });
                            }
        </script>
    </body>
</html>