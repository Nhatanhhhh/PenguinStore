<%@page import="Models.Feedback"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard - Staff</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Staff/styles.css"/>
        <style>
            #layoutSidenav {
                display: flex;  /* Đảm bảo layout không bị lệch */
            }

            .col-md-10 {
                flex-grow: 1;
                max-width: calc(100% - 250px);  /* Tránh bị lệch */
                padding-left: 0 !important;
                margin-left: 0 !important;
            }

            /* Màu nền đậm như table-dark */
            #feedbackTable thead {
                background-color: #343a40 !important; /* Màu đen nhạt của Bootstrap */
                color: white !important; /* Chữ trắng */
            }

            /* Căn giữa nội dung trong các cột */
            #feedbackTable th {
                text-align: center !important;
                vertical-align: middle !important;
            }

            .text-success {
                color: green !important;
                font-weight: bold !important;
            }

            .text-danger {
                color: red !important;
                font-weight: bold !important;
            }


        </style>
    </head>
    <body class="sb-nav-fixed">
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>
        
        
        
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
        
        
        
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar (Navigation) -->
                <div class="col-md-2 p-0">
                    <%@include file="Staff/NavigationStaff.jsp" %>
                </div>

                <!-- Content -->
                <div class="col-md-10 p-0">
                    <%@include file="Staff/HeaderStaff.jsp" %>

                    <div class="px-4">
                        <h1 class="mt-4">Dashboard</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">Dashboard</li>
                        </ol>

                        <!-- Hiển thị danh sách Feedback -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-comments me-1"></i>
                                Customer Feedback
                            </div>
                            <div class="card-body">
                                <table id="feedbackTable" class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Customer Name</th>
                                            <th>Product Name</th>
                                            <th>Comment</th>
                                            <th>Rating</th>
                                            <th>Date</th>
                                            <th>Viewed</th>
                                            <th>Resolved</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <%
                                            List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                                            if (feedbacks != null) {
                                                for (Feedback fb : feedbacks) {
                                        %>
                                        <tr>
                                            <td><%= fb.getCustomerName()%></td>
                                            <td><%= fb.getGetProductName()%></td>
                                            <td><%= fb.getComment()%></td>
                                            <td><%= fb.getRating()%></td>
                                            <%
                                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                            %>
                                            <td><%= sdf.format(fb.getFeedbackCreateAt())%></td>
                                            <td class="<%= fb.isIsViewed() ? "text-success" : "text-danger"%>">
                                                <%= fb.isIsViewed() ? "<i class='fa fa-eye text-success'></i> Viewed" : "<i class='fa fa-eye-slash text-danger'></i> Not Viewed"%>
                                            </td>
                                            <td class="<%= fb.isIsResolved() ? "text-success" : "text-danger"%>">
                                                <%= fb.isIsResolved() ? "<i class='fa fa-check-circle text-success'></i> Resolved" : "<i class='fa fa-hourglass-half text-warning'></i> Pending"%>
                                            </td>


                                            <td>
                                                <form action="feedbackreply" method="POST" style="display:inline;">
                                                    <input type="hidden" name="feedbackID" value="<%= fb.getFeedbackID() %>">
                                                    <button type="submit" name="action" value="delete" class="btn btn-warning btn-sm">Delete</button>
                                                </form>

                                                <button type="button" class="btn btn-primary btn-sm reply-btn" data-id="<%= fb.getFeedbackID() %>">
                                                    Reply
                                                </button>

                                              
                                                <div id="reply-box-<%= fb.getFeedbackID() %>" class="reply-box mt-2" style="display: none;">
                                                    <form action="feedbackreply" method="POST">
                                                        <input type="hidden" name="feedbackID" value="<%= fb.getFeedbackID() %>">
                                                        <textarea name="replyMessage" class="form-control" placeholder="Enter your reply"></textarea>
                                                        <button type="submit" name="action" value="reply" class="btn btn-success btn-sm mt-2">Send</button>
                                                    </form>
                                                </div>
                                                        
                                                        <script>
                                                            document.addEventListener("DOMContentLoaded", function () {
                                                                document.querySelectorAll(".reply-btn").forEach(button => {
                                                                    button.addEventListener("click", function () {
                                                                        let feedbackID = this.getAttribute("data-id");
                                                                        let replyBox = document.getElementById("reply-box-" + feedbackID);

                                                                        // Ẩn tất cả các ô reply khác trước khi hiển thị ô mới
                                                                        document.querySelectorAll(".reply-box").forEach(box => {
                                                                            if (box !== replyBox) box.style.display = "none";
                                                                        });

                                                                       
                                                                        replyBox.style.display = (replyBox.style.display === "none") ? "block" : "none";
                                                                    });
                                                                });
                                                            });
                                                            
                                                            
                                                        </script>

                                            </td>

                                        </tr>
                                        <% }
                                            }%>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div> <!-- End px-4 -->
                </div> <!-- End col-md-10 -->
            </div> <!-- End row -->
        </div>
        
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/Staff/scripts.js"></script>
    </body>
</html>