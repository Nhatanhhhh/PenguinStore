<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.ViewFeedbackCus"%>
<%@page import="Models.Customer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Feedback List</title>
    <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
    <%@include file="/Assets/CSS/icon.jsp"%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/base.css"/>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/style.css"/>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/feedback.css"/>
</head>
<body>
    <%@include file="Header.jsp"%>
    
       <%            Customer customer = (Customer) request.getAttribute("user");
            if (customer == null) {
                customer = (Customer) session.getAttribute("user");
            }
        %>

    
    <div class="container mt-5">
    <h1 class="text-center mb-4" style="font-size: 35px;">Feedback Reply</h1>
    
    <div class="row">
        <!-- Menu Sidebar -->
        <div class="list col-md-2">
            <div class="divider"></div>
            <div class="general"><a href="<%= request.getContextPath()%>/ViewProfile">General</a></div>
            <div class="edit-profile"><a href="<%= request.getContextPath()%>/EditProfile">Edit Profile</a></div>
            <div class="voucher"><a href="<%= request.getContextPath()%>/VVCustomer">Voucher</a></div>
            <div class="order"><a href="<%= request.getContextPath()%>/OrderHistory">Order</a></div>
            <div class="password"><a href="<%= request.getContextPath()%>/ChangePassword">Password</a></div>
            <div class="ViewFeedbackCustomer"><a style="font-weight: bold;">Feedback</a></div>
        </div>

        <!-- Nội dung bảng Feedback -->
        <div class="col-md-10">
            <div class="table-responsive">
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
                            <td><%= feedback.getProductName() %></td>
                            <td><%= feedback.getCreateAt()%></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="4" class="text-center">No feedback available</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

    
    <%@include file="Footer.jsp"%>
    <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
</body>
</html>
