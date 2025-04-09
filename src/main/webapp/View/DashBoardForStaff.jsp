<%@page import="Models.Manager"%>
<%@page import="Models.Feedback"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard Staff</title>
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <!-- Add SweetAlert2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <style>
            #layoutSidenav {
                display: flex;
            }

            .col-md-10 {
                flex-grow: 1;
                max-width: calc(100% - 250px);
                padding-left: 0 !important;
                margin-left: 0 !important;
            }

            /* Table styling */
            #feedbackTable {
                width: 100%;
                margin-bottom: 1rem;
                background-color: transparent;
                border-collapse: collapse;
            }

            #feedbackTable thead {
                background-color: #343a40;
                color: white;
            }

            #feedbackTable th, 
            #feedbackTable td {
                padding: 0.75rem;
                vertical-align: middle;
                border: 1px solid #dee2e6;
                text-align: center;
            }

            #feedbackTable tbody tr:nth-child(even) {
                background-color: rgba(0, 0, 0, 0.05);
            }

            #feedbackTable tbody tr:hover {
                background-color: rgba(0, 0, 0, 0.075);
            }

            .text-success {
                color: green;
                font-weight: bold;
            }

            .text-danger {
                color: red;
                font-weight: bold;
            }

            .action-buttons {
                display: flex;
                gap: 5px;
                justify-content: center;
            }

            .btn-action {
                padding: 0.25rem 0.5rem;
                font-size: 0.8rem;
            }

            /* Card styling */
            .card-header {
                background-color: #343a40;
                color: white;
            }

            /* Ensure z-index for SweetAlert */
            .swal2-container {
                z-index: 99999 !important;
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
                                <div class="table-responsive">
                                    <table id="feedbackTable" class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Customer Name</th>
                                                <th>Product Name</th>
                                                <th>Comment</th>
                                                <th>Rating</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                                                if (feedbacks != null && !feedbacks.isEmpty()) {
                                                    for (Feedback fb : feedbacks) {
                                            %>
                                            <tr>
                                                <td><%= fb.getCustomerName()%></td>
                                                <td><%= fb.getProductName()%></td>
                                                <td><%= fb.getComment()%></td>
                                                <td><%= fb.getRating()%></td>
                                                <%
                                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                                %>
                                                <td><%= sdf.format(fb.getFeedbackCreateAt())%></td>
                                                <td class="<%= fb.isIsResolved() ? "text-success" : "text-danger"%>">
                                                    <%= fb.isIsResolved() ? "<i class='fa fa-check-circle text-success'></i> Resolved" : "<i class='fa fa-hourglass-half text-warning'></i> Pending"%>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <button type="button" class="btn btn-warning btn-sm btn-action delete-btn" 
                                                                data-feedback-id="<%= fb.getFeedbackID()%>">
                                                            Delete
                                                        </button>
                                                        <button type="button" class="btn btn-primary btn-sm btn-action reply-btn" 
                                                                data-feedback-id="<%= fb.getFeedbackID()%>">
                                                            Reply
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                } else {
                                            %>
                                            <tr>
                                                <td colspan="7" class="text-center">No feedback found.</td>
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
                </div>
            </div>
        </div>

        <!-- Include jQuery and SweetAlert2 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        
        <script>
            $(document).ready(function() {
                // Xử lý sự kiện Delete
                $('.delete-btn').click(function() {
                    const feedbackID = $(this).data('feedback-id');
                    const button = $(this);
                    
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Tạo form ẩn để gửi POST request
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '<%= request.getContextPath()%>/feedbackreply';
                            
                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'delete';
                            form.appendChild(actionInput);
                            
                            const idInput = document.createElement('input');
                            idInput.type = 'hidden';
                            idInput.name = 'feedbackID';
                            idInput.value = feedbackID;
                            form.appendChild(idInput);
                            
                            const redirectInput = document.createElement('input');
                            redirectInput.type = 'hidden';
                            redirectInput.name = 'redirectPage';
                            redirectInput.value = 'ViewListFeedback';
                            form.appendChild(redirectInput);
                            
                            document.body.appendChild(form);
                            form.submit();
                        }
                    });
                });
                
                // Xử lý sự kiện Reply
                $('.reply-btn').click(function() {
                    const feedbackID = $(this).data('feedback-id');
                    
                    Swal.fire({
                        title: 'Reply to Feedback',
                        input: 'textarea',
                        inputLabel: 'Enter your reply (at least 2 words)',
                        inputPlaceholder: 'Type your reply here...',
                        showCancelButton: true,
                        confirmButtonText: 'Send',
                        cancelButtonText: 'Cancel',
                        inputValidator: (value) => {
                            if (!value || value.trim().split(/\s+/).length < 2) {
                                return 'Reply must contain at least 2 words!';
                            }
                        }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const replyMessage = result.value.trim();
                            
                            // Tạo form ẩn để gửi POST request
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '<%= request.getContextPath()%>/feedbackreply';
                            
                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'reply';
                            form.appendChild(actionInput);
                            
                            const idInput = document.createElement('input');
                            idInput.type = 'hidden';
                            idInput.name = 'feedbackID';
                            idInput.value = feedbackID;
                            form.appendChild(idInput);
                            
                            const messageInput = document.createElement('input');
                            messageInput.type = 'hidden';
                            messageInput.name = 'replyMessage';
                            messageInput.value = replyMessage;
                            form.appendChild(messageInput);
                            
                            const redirectInput = document.createElement('input');
                            redirectInput.type = 'hidden';
                            redirectInput.name = 'redirectPage';
                            redirectInput.value = 'ViewListFeedback';
                            form.appendChild(redirectInput);
                            
                            document.body.appendChild(form);
                            form.submit();
                        }
                    });
                });
                
                // Hiển thị thông báo từ session nếu có
                <% if (request.getSession().getAttribute("message") != null) { %>
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: '<%= request.getSession().getAttribute("message") %>',
                        timer: 3000
                    });
                    <% request.getSession().removeAttribute("message"); %>
                <% } else if (request.getSession().getAttribute("error") != null) { %>
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: '<%= request.getSession().getAttribute("error") %>'
                    });
                    <% request.getSession().removeAttribute("error"); %>
                <% } %>
            });
        </script>
    </body>
</html>