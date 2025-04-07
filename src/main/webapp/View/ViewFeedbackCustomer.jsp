<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.ViewFeedbackCus"%>
<%@page import="Models.Customer" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reply List | Penguin Fashion</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/customer.css"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/editprofile.css"/>
    </head>
    <body>
        <%@include file="Header.jsp"%>
        <%            Customer customer = (Customer) request.getAttribute("user");
            if (customer == null) {
                customer = (Customer) session.getAttribute("user");
            }
        %>


        <h1 class="text-center mb-4" style="font-size: 35px;">Account</h1>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% session.removeAttribute("message");
                session.removeAttribute("messageType");%>
        </c:if>



        <div class="container mt-3">
            <div class="account-information">
                <div class="row">
                    <div class="col-md-2 d-flex justify-content-end"><span style="font-size: 55px;" class="mdi mdi-account-cog"></span></div>
                    <div class="col-md-10">
                        <div class="peter-griffin-general">
                            <span>
                                <!-- fullName + hiển thị 'General' -->
                                <span class="peter-griffin-general-span" style="font-weight: bold;">
                                    <%= (customer.getFullName() != null) ? customer.getFullName() : "Anonymous"%>
                                </span>
                                <span class="peter-griffin-general-span2">/</span>
                                <span class="peter-griffin-general-span3" style="font-weight: bold;">Feedback Reply</span>
                            </span>
                        </div>
                        <div class="view-your-username-and-manage-your-account">
                            Reply
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
                    <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
                    <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
                    <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
                    <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
                    <div class="reply"><a style="font-weight: bold;">View Reply</a></div>
                </div>

                <div class="col-md-10">
                    <!-- Nội dung bảng Feedback -->
                    <table class="table table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th>Manager Name</th>
                                <th>Comment Reply</th>
                                <th>Name Product</th>
                                <th>Reply Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<ViewFeedbackCus> viewFeedbackCus = (List<ViewFeedbackCus>) request.getAttribute("feedbackList");
                                if (viewFeedbackCus != null && !viewFeedbackCus.isEmpty()) {
                                    for (ViewFeedbackCus feedback : viewFeedbackCus) {
                            %>
                            <tr>
                                <td><%= feedback.getManagerNam()%></td>
                                <td><%= feedback.getComment()%></td>
                                <td><%= feedback.getProductName()%></td>
                                <td><%= feedback.getCreateAt()%></td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center">No feedback available</td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@include file="Footer.jsp"%>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
    </body>
</html>
