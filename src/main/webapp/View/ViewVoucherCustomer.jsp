<%@page import="java.util.List" %>
<%@page import="Models.Voucher" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Customer" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.temporal.ChronoUnit" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Voucher Customer</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>

        <%                Customer customer = (Customer) session.getAttribute("user");
        %>
        <h1 class="text-center mb-4" style="font-size: 35px;">Your Voucher</h1>

        <!-- Error or Success Messages -->
        <%
            String message = (String) request.getAttribute("errorMessage");
            if (message != null) {
        %>
        <div class="alert alert-danger text-center"><%= message%></div>
        <%
            }
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <div class="alert alert-success text-center"><%= successMessage%></div>
        <%
            }
        %>

        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">View Voucher</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            View your voucher
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="list col-md-2">
                    <div class="divider"></div>
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a style="font-weight: bold;">Voucher</a></div>
                    <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                    <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
                    <div class="reply"><a href="<%= request.getContextPath()%>/ViewFeedbackCustomer">View Reply</a></div>
                </div>

                <div class="col-md-10">
                    <div class="container">
                        <table class="table table-bordered">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Voucher Code</th>
                                    <th>Discount Amount</th>
                                    <th>Valid Until</th>
                                    <th>Use Voucher</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                                    LocalDate today = LocalDate.now(); // Obtenir la date actuelle

                                    if (vouchers != null && !vouchers.isEmpty()) {
                                        for (Voucher voucher : vouchers) {
                                            LocalDate validUntil = voucher.getValidUntil();
                                            boolean isExpired = validUntil.isBefore(today);
                                %>
                                <tr>
                                    <td><%= voucher.getVoucherCode()%></td>
                                    <td><fmt:formatNumber value="<%= voucher.getDiscountAmount()%>" pattern="#,###" /> VND</td>
                                    <td>
                                        <% if (isExpired) { %>
                                        <span style="color: red; font-weight: bold;">Expired</span>
                                        <% } else {%>
                                        <%= voucher.getValidUntil()%>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (isExpired) { %>
                                        <button class="btn btn-danger" disabled>Expired</button>
                                        <% } else {%>
                                        <a href="#" class="d-flex button button-two justify-content-center" onclick="confirmUseVoucher('<%= voucher.getVoucherCode()%>')">Use</a>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="4" class="text-center">No vouchers available</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>


        </div>

        <div style="background-color: #F9FAFB;  padding: 40px 0px;">
            <div class="row">
                <div class="col-md-6 d-flex justify-content-center">
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

        <!-- Modal xác nhận sử dụng voucher -->
        <div class="modal fade" id="confirmUseVoucherModal" tabindex="-1" role="dialog" aria-labelledby="confirmUseVoucherLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmUseVoucherLabel">Confirm Voucher Usage</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to use this voucher?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-success" id="confirmUseVoucherBtn">Yes, Use It</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script>
            let selectedVoucher = "";

            function confirmUseVoucher(voucherCode) {
                selectedVoucher = voucherCode; // Lưu mã voucher
                document.getElementById("confirmUseVoucherBtn").setAttribute("data-voucher", voucherCode); // Gán mã voucher vào thuộc tính
                $("#confirmUseVoucherModal").modal("show"); // Hiển thị modal
            }

            document.getElementById("confirmUseVoucherBtn").addEventListener("click", function () {
                let voucherCode = this.getAttribute("data-voucher"); // Lấy mã voucher từ thuộc tính
                if (voucherCode) {
                    // Chuyển hướng đến Checkout với mã voucher
                    window.location.href = "<%= request.getContextPath()%>/Checkout?voucher=" + encodeURIComponent(voucherCode);
                }
            });
        </script>
    </body>
</html>