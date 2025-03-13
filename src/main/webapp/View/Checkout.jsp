<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Models.CartItem, Models.Voucher" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PENGUIN Checkout</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/co.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <h1>PENGUIN Checkout</h1>
        <div class="container">
            <div class="form-section">
                <form action="OrderHistory" method="post">
                    <h2>Contact</h2>
                    <input type="email" name="email" placeholder="Email Address" required>

                    <h2>Delivery</h2>
                    <input type="text" name="fullName" placeholder="Full Name" required>
                    <input type="text" name="address" placeholder="Address" required>

                    <div style="display: flex; gap: 10px;">
                        <input type="text" name="zip" placeholder="Zip" style="width: 50%;" required>
                        <input type="text" name="state" placeholder="State" style="width: 50%;" required>
                    </div>

                    <input type="hidden" name="subtotal" id="hiddenSubtotal" value="0">
                    <input type="hidden" name="voucher" id="hiddenVoucher">
                    <input type="hidden" name="discount" id="hiddenDiscount">
                    <input type="hidden" name="total" id="hiddenTotal">

                    <button type="submit" id="payNow">Pay Now</button>
                </form>
            </div>
            <div class="summary-section">
                <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems"); %>
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <% double subtotal = 0; %>
                <% for (CartItem item : cartItems) {%>
                <% subtotal += item.getPrice() * item.getQuantity();%>
                <div class="product">
                    <img src="<%= request.getContextPath()%>/Image/Product/<%= item.getFirstImage()%>" 
                         alt="<%= item.getProductName()%>" width="80" height="80">
                    <div>
                        <h3><%= item.getProductName()%></h3>
                        <p>Color: <%= item.getColorName()%></p>
                        <p>Quantity: <%= item.getQuantity()%></p>
                        <p>Price: $<%= String.format("%.2f", item.getPrice() * item.getQuantity())%></p>
                    </div>
                </div>
                <% }%>
                <hr>
                <p>Subtotal: $<span id="subtotal"><%= String.format("%.2f", subtotal)%></span></p>
                <p>My Voucher <a href="#" id="viewVoucher">View</a></p>

                <div style="display: flex; gap: 10px;">
                    <input type="text" id="voucher" placeholder="Voucher code">
                    <button id="applyVoucher" style="display: none;">Apply</button>
                </div>

                <p>Voucher Discount: <span id="discount">$0</span></p>
                <p>Shipping: $40.00</p>
                <h3>Total: <span id="total">$<%= String.format("%.2f", subtotal + 40)%></span></h3>
                <% } else { %>
                <p>Your cart is empty!</p>
                <% }%>
            </div>
        </div>

        <!-- Modal Hi?n Th? Voucher -->
        <div id="voucherModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Available Vouchers</h2>
                <div id="voucherList">
                    <% List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers"); %>
                    <% if (vouchers != null && !vouchers.isEmpty()) { %>
                    <% for (Voucher voucher : vouchers) { %>
                    <div class="voucher-item" 
                         data-code="<%= voucher.getVoucherCode()%>" 
                         data-discount-per="<%= voucher.getDiscountPer()%>"
                         data-discount-amount="<%= voucher.getDiscountAmount()%>"
                         data-min-order="<%= voucher.getMinOrderValue()%>">
                        <strong><%= voucher.getVoucherCode()%></strong> - 
                        <%= voucher.getDiscountPer()%>% off (Max $<%= voucher.getDiscountAmount()%>) <br>
                        Min Order: $<%= voucher.getMinOrderValue()%>
                        <% if (voucher.isVoucherStatus()) { %>
                        <button class="useVoucher">Use</button>
                        <% } else { %>
                        <span style="color: red;">Expired</span>
                        <% } %>
                    </div>
                    <% } %>
                    <% } else { %>
                    <p>No available vouchers.</p>
                    <% } %>
                </div>
            </div>
        </div>
        <script>
            document.getElementById('viewVoucher').addEventListener('click', function (e) {
                e.preventDefault();
                document.getElementById('voucherModal').style.display = 'block';
            });

            document.querySelector('.close').addEventListener('click', function () {
                document.getElementById('voucherModal').style.display = 'none';
            });

            document.querySelectorAll('.useVoucher').forEach(button => {
                button.addEventListener('click', function () {
                    let voucherItem = this.closest('.voucher-item');
                    let code = voucherItem.getAttribute('data-code');
                    let discountPer = parseFloat(voucherItem.getAttribute('data-discount-per'));
                    let discountAmount = parseFloat(voucherItem.getAttribute('data-discount-amount'));
                    let minOrder = parseFloat(voucherItem.getAttribute('data-min-order'));

                    document.getElementById('voucher').value = code;
                    document.getElementById('applyVoucher').style.display = 'inline-block';

                    document.getElementById('applyVoucher').setAttribute('data-discount-per', discountPer);
                    document.getElementById('applyVoucher').setAttribute('data-discount-amount', discountAmount);
                    document.getElementById('applyVoucher').setAttribute('data-min-order', minOrder);

                    document.getElementById('voucherModal').style.display = 'none';
                });
            });

            document.getElementById('applyVoucher').addEventListener('click', function () {
                let subtotal = parseFloat(document.getElementById('subtotal').textContent);
                let discountPer = parseFloat(this.getAttribute('data-discount-per'));
                let discountAmount = parseFloat(this.getAttribute('data-discount-amount'));
                let minOrder = parseFloat(this.getAttribute('data-min-order'));

                let discount = 0;
                if (subtotal >= minOrder) {
                    discount = (subtotal * discountPer) / 100;
                    if (discount > discountAmount) {
                        discount = discountAmount;
                    }
                } else {
                    alert(`Your order must be at least $${minOrder} to apply this voucher.`);
                    return;
                }

                document.getElementById('discount').textContent = '$' + discount.toFixed(2);
                updateTotal();
            });

            function updateTotal() {
                let subtotal = parseFloat(document.getElementById('subtotal').textContent);
                let discount = parseFloat(document.getElementById('discount').textContent.replace('$', '')) || 0;
                let shipping = 40;
                let total = subtotal - discount + shipping;

                document.getElementById('total').textContent = '$' + total.toFixed(2);
            }
        </script>

        <%@include file="Footer.jsp"%>
    </body>
</html>

