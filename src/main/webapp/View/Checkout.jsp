<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Models.CartItem, Models.Voucher, Models.Customer" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>PENGUIN Checkout</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #000;
                --secondary-color: #3498db;
                --accent-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            body {
                background-color: #f5f5f5;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .checkout-container {
                max-width: 1200px;
                margin: 30px auto;
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                gap: 30px;
            }

            .form-section {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .summary-section {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                align-self: flex-start;
                position: sticky;
                top: 20px;
            }

            h1 {
                color: var(--primary-color);
                text-align: center;
                margin-bottom: 30px;
                font-weight: 700;
            }

            h2 {
                color: var(--primary-color);
                font-size: 1.5rem;
                margin: 20px 0 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }

            input, select {
                width: 100%;
                padding: 12px 15px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
                transition: all 0.3s;
            }

            input:focus, select:focus {
                border-color: var(--secondary-color);
                outline: none;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            .form-row {
                display: flex;
                gap: 15px;
            }

            .form-row > * {
                flex: 1;
            }

            .product {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }

            .product img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 5px;
                border: 1px solid #eee;
            }

            .product-info {
                flex: 1;
            }

            .product-name {
                font-weight: 600;
                margin-bottom: 5px;
                color: var(--primary-color);
            }

            .product-attr {
                font-size: 14px;
                color: #666;
                margin-bottom: 5px;
            }

            .price-row {
                display: flex;
                justify-content: space-between;
                margin: 10px 0;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }

            .total-row {
                font-size: 18px;
                font-weight: 600;
                margin: 20px 0;
            }

            .voucher-section {
                display: flex;
                gap: 10px;
                margin: 20px 0;
            }

            .voucher-input {
                flex: 1;
            }

            .btn-apply {
                background: var(--accent-color);
                color: white;
                border: none;
                padding: 0 20px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-apply:hover {
                background: #c0392b;
            }

            .payment-methods {
                margin: 25px 0;
            }

            .payment-method {
                display: flex;
                align-items: center;
                padding: 15px;
                margin-bottom: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .payment-method:hover {
                border-color: var(--secondary-color);
            }

            .payment-method.selected {
                border-color: var(--secondary-color);
                background-color: rgba(52, 152, 219, 0.05);
            }

            .payment-method input {
                margin: 0 10px 0 0;
                width: auto;
            }

            .payment-icon {
                margin-right: 10px;
                font-size: 24px;
                color: var(--primary-color);
            }

            .btn-checkout {
                width: 100%;
                padding: 15px;
                background: var(--primary-color);
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 20px;
            }

            .btn-checkout:hover {
                background: #1a252f;
                transform: translateY(-2px);
            }

            .btn-voucher {
                background: var(--secondary-color);
                color: white;
                padding: 8px 15px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin-top: 10px;
            }

            .btn-voucher:hover {
                background: #2980b9;
                color: white;
            }

            @media (max-width: 768px) {
                .checkout-container {
                    grid-template-columns: 1fr;
                }

                .summary-section {
                    position: static;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="Header.jsp"%>

        <div class="container">
            <h1>PENGUIN Checkout</h1>

            <div class="checkout-container">
                <div class="form-section">
                    <form id="checkoutForm" action="<%= request.getContextPath()%>/Payment" method="post">
                        <h2>Contact Information</h2>
                        <% Customer customer = (Customer) request.getAttribute("customer");%>
                        <input type="email" name="email" placeholder="Email Address" required 
                               value="<%= (customer != null) ? customer.getEmail() : ""%>" readonly  style="background: #f8f9fa;">

                        <h2>Shipping Address</h2>
                        <div class="form-row">
                            <input type="text" name="fullName" placeholder="Full Name" required 
                                   value="<%= (customer != null) ? customer.getFullName() : ""%>" readonly style="background: #f8f9fa;">
                            <input type="text" name="phoneNumber" placeholder="Phone Number" required 
                                   value="<%= (customer != null) ? customer.getPhoneNumber() : ""%>" readonly style="background: #f8f9fa;">
                        </div>
                        <input type="text" name="address" placeholder="Address" required 
                               value="<%= (customer != null) ? customer.getAddress() : ""%>" readonly style="background: #f8f9fa;">
                        <div class="form-row">
                            <input type="text" name="zip" placeholder="Zip Code" required 
                                   value="<%= (customer != null) ? customer.getZip() : ""%>" readonly style="background: #f8f9fa;">
                            <input type="text" name="state" placeholder="State/Province" required 
                                   value="<%= (customer != null) ? customer.getState() : ""%>" readonly style="background: #f8f9fa;">
                        </div>

                        <h2>Payment Method</h2>
                        <div class="payment-methods">
                            <label for="codRadio" class="payment-method selected" id="codMethod">
                                <input type="radio" id="codRadio" name="paymentMethod" value="cod" checked>
                                <i class="fas fa-money-bill-wave payment-icon"></i>
                                <span>Cash on Delivery (COD)</span>
                            </label>

                            <label for="vnpayRadio" class="payment-method" id="vnpayMethod">
                                <input type="radio" id="vnpayRadio" name="paymentMethod" value="vnpay">
                                <i class="fas fa-credit-card payment-icon"></i>
                                <span>VNPay (Credit/Debit Card)</span>
                            </label>
                        </div>

                        <%-- Input hidden để gửi giá trị --%>
                        <input type="hidden" id="hiddenSubtotal" name="subtotal" value="0">
                        <input type="hidden" id="hiddenDiscount" name="discount" value="0">
                        <input type="hidden" id="hiddenTotal" name="total" value="0">
                        <input type="hidden" id="hiddenVoucher" name="voucher" value="">

                        <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems"); %>
                        <% if (cartItems != null && !cartItems.isEmpty()) { %>
                        <% for (CartItem item : cartItems) {%>
                        <input type="hidden" name="productID" value="<%= item.getProductID()%>">
                        <input type="hidden" name="quantity" value="<%= item.getQuantity()%>">
                        <input type="hidden" name="sizeName" value="<%= item.getSizeName() != null ? item.getSizeName() : ""%>">
                        <input type="hidden" name="colorName" value="<%= item.getColorName() != null ? item.getColorName() : ""%>">
                        <% } %>
                        <% } %>

                        <button type="submit" class="btn-checkout" id="payNow">Place Order</button>
                    </form>
                </div>

                <div class="summary-section">
                    <h2>Order Summary</h2>

                    <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <% double subtotal = 0; %>
                    <% for (CartItem item : cartItems) {%>
                    <% subtotal += item.getPrice() * item.getQuantity();%>
                    <div class="product">
                        <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                             alt="<%= item.getProductName()%>">
                        <div class="product-info">
                            <h3 class="product-name"><%= item.getProductName()%></h3>
                            <% if (item.getColorName() != null && !item.getColorName().isEmpty()) {%>
                            <p class="product-attr">Color: <%= item.getColorName()%></p>
                            <% } %>
                            <% if (item.getSizeName() != null && !item.getSizeName().isEmpty()) {%>
                            <p class="product-attr">Size: <%= item.getSizeName()%></p>
                            <% }%>
                            <p class="product-attr">Quantity: <%= item.getQuantity()%></p>
                            <p class="product-attr">Price: <fmt:formatNumber value="<%= item.getPrice() * item.getQuantity()%>" pattern="#,###" /> ₫</p>
                        </div>
                    </div>
                    <% }%>

                    <div class="price-row">
                        <span>Subtotal:</span>
                        <span id="subtotal"><fmt:formatNumber value="<%= subtotal%>" pattern="#,###" /> ₫</span>
                    </div>

                    <div class="voucher-section">
                        <input type="text" id="voucher" placeholder="Voucher code" class="voucher-input">
                        <button type="button" id="applyVoucher" class="btn-apply" style="height: 56px;">Apply</button>
                    </div>

                    <div class="price-row">
                        <span>Discount:</span>
                        <span id="discount">0 ₫</span>
                    </div>

                    <div class="price-row">
                        <span>Shipping:</span>
                        <span>40,000 ₫</span>
                    </div>

                    <div class="total-row">
                        <span>Total:</span>
                        <span id="total"><fmt:formatNumber value="<%= subtotal + 40000%>" pattern="#,###" /> ₫</span>
                    </div>

                    <a href="<%= request.getContextPath()%>/VVCustomer" class="btn-voucher">
                        <i class="fas fa-tag"></i> View Available Vouchers
                    </a>
                    <% } else { %>
                    <p>Your cart is empty!</p>
                    <% }%>
                </div>
            </div>
        </div>

        <%@include file="Footer.jsp"%>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var discount = 0;
                var shippingFee = 40000;

                // Xử lý chọn phương thức thanh toán
                $('.payment-method').click(function () {
                    $('.payment-method').removeClass('selected');
                    $(this).addClass('selected');
                    $(this).find('input').prop('checked', true);
                });

                function updateTotal() {
                    let subtotal = 0;
                    let subtotalElement = document.getElementById("subtotal");
                    if (subtotalElement) {
                        subtotal = parseInt(subtotalElement.innerText.replace(/[^\d]/g, '')) || 0;
                    }

                    let total = subtotal + shippingFee - discount;

                    // Update display
                    let totalElement = document.getElementById("total");
                    if (totalElement) {
                        totalElement.innerText = total.toLocaleString('vi-VN') + " ₫";
                    }

                    let discountElement = document.getElementById("discount");
                    if (discountElement) {
                        discountElement.innerText = discount.toLocaleString('vi-VN') + " ₫";
                    }

                    // Cập nhật các trường ẩn
                    document.getElementById("hiddenSubtotal").value = subtotal;
                    document.getElementById("hiddenDiscount").value = discount;
                    document.getElementById("hiddenTotal").value = total;
                }

                // Áp dụng voucher
                document.getElementById("applyVoucher").addEventListener("click", function () {
                    let voucherCode = document.getElementById("voucher").value.trim();
                    let subtotal = parseInt(document.getElementById("subtotal").innerText.replace(/[^\d]/g, '')) || 0;
                    if (!voucherCode) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Please enter a voucher code!',
                            confirmButtonColor: '#2c3e50'
                        });
                        return;
                    }

                    $.ajax({
                        url: "<%= request.getContextPath()%>/UseVoucher",
                        type: "GET",
                        data: {
                            voucherCode: voucherCode,
                            subtotal: subtotal
                        },
                        dataType: "json",
                        success: function (response) {
                            if (response.status === "error") {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: response.message,
                                    confirmButtonColor: '#2c3e50'
                                });
                                discount = 0;
                            } else {
                                discount = response.discount;
                                document.getElementById("hiddenVoucher").value = voucherCode;
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Voucher Applied',
                                    text: response.message,
                                    confirmButtonColor: '#2c3e50'
                                });
                            }
                            updateTotal();
                        },
                        error: function () {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'An error occurred while checking voucher!',
                                confirmButtonColor: '#2c3e50'
                            });
                        }
                    });
                });

                const codMethod = document.getElementById('codMethod');
                const vnpayMethod = document.getElementById('vnpayMethod');
                const codRadio = document.getElementById('codRadio');
                const vnpayRadio = document.getElementById('vnpayRadio');

                // Xử lý click và focus
                function updatePaymentSelection(selectedMethod) {
                    // Reset tất cả
                    codMethod.classList.remove('selected');
                    vnpayMethod.classList.remove('selected');

                    // Thiết lập cái được chọn
                    selectedMethod.classList.add('selected');

                    // Cập nhật radio button
                    if (selectedMethod === codMethod) {
                        codRadio.checked = true;
                        codRadio.focus();
                    } else {
                        vnpayRadio.checked = true;
                        vnpayRadio.focus();
                    }
                }

                // Xử lý sự kiện click
                codMethod.addEventListener('click', function () {
                    updatePaymentSelection(codMethod);
                });

                vnpayMethod.addEventListener('click', function () {
                    updatePaymentSelection(vnpayMethod);
                });

                // Xử lý sự kiện keyboard
                codRadio.addEventListener('focus', function () {
                    updatePaymentSelection(codMethod);
                });

                vnpayRadio.addEventListener('focus', function () {
                    updatePaymentSelection(vnpayMethod);
                });

                // Xử lý submit form - Phiên bản đã sửa
                document.getElementById('checkoutForm').addEventListener('submit', function (e) {
                    e.preventDefault();

                    // Kiểm tra phương thức thanh toán
                    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                    console.log("Phương thức thanh toán đã chọn:", paymentMethod);

                    // Cập nhật tổng tiền
                    updateTotal();

                    if (paymentMethod === 'vnpay') {
                        // Tạo form ẩn cho VNPay
                        const vnpayForm = document.createElement('form');
                        vnpayForm.method = 'POST';
                        vnpayForm.action = '<%= request.getContextPath()%>/VNPayPayment'; // Đảm bảo đường dẫn đúng

                        // Thêm các tham số bắt buộc
                        addHiddenField(vnpayForm, 'amount', document.getElementById("hiddenTotal").value);
                        addHiddenField(vnpayForm, 'customerId', "<%= customer != null ? customer.getCustomerID() : ""%>");

                        // Thêm thông tin giỏ hàng
            <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <% for (CartItem item : cartItems) {%>
                        addHiddenField(vnpayForm, 'productID', '<%= item.getProductID()%>');
                        addHiddenField(vnpayForm, 'quantity', '<%= item.getQuantity()%>');
            <% } %>
            <% }%>

                        // Thêm voucher nếu có
                        const voucherValue = document.getElementById("hiddenVoucher").value;
                        if (voucherValue) {
                            addHiddenField(vnpayForm, 'voucher', voucherValue);
                        }

                        // Submit form
                        document.body.appendChild(vnpayForm);
                        vnpayForm.submit();

                    } else {
                        // Gửi form COD bình thường
                        this.submit();
                    }
                });

                // Hàm helper thêm trường ẩn
                function addHiddenField(form, name, value) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = name;
                    input.value = value;
                    form.appendChild(input);
                }

                // Tự động điền voucher nếu có trên URL
                let params = new URLSearchParams(window.location.search);
                let voucherCode = params.get("voucher");
                if (voucherCode) {
                    document.getElementById("voucher").value = voucherCode;
                }

                // Cập nhật tổng tiền ban đầu
                updateTotal();
            });
        </script>
    </body>
</html>