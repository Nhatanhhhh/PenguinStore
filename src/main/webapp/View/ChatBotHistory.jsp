<%@page import="Models.Manager"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="Models.ChatBotHistory"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>ChatBot History</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/Image/Account/penguin.png">
        <%@include file="/Assets/CSS/bootstrap.css.jsp"%>
        <%@include file="/Assets/CSS/icon.jsp"%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/Assets/CSS/Admin/DashBoard.css"/>
        <!-- Add SweetAlert CSS -->
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

            /* Enhanced Table Styling */
            #chatHistoryTable {
                font-size: 0.9rem;
            }

            #chatHistoryTable thead {
                background-color: #04414d;
                color: white;
                position: sticky;
                top: 0;
            }

            #chatHistoryTable th {
                text-align: center;
                vertical-align: middle;
                padding: 12px 8px;
            }

            /* Status Colors */
            .status-answered {
                background-color: #d4edda;
            }

            .status-unanswered {
                background-color: #fff3cd;
            }

            .table-container {
                max-height: 600px;
                overflow-y: auto;
            }

            /* Button Styling */
            .btn-action {
                margin: 2px;
                padding: 0.25rem 0.5rem;
                font-size: 0.8rem;
            }

            .action-buttons {
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
                justify-content: center;
            }

            /* Card Header */
            .card-header {
                background-color: #04414d;
                color: white;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .col-md-10 {
                    max-width: 100%;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .question-cell, .answer-cell {
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            }

            /* Đảm bảo các hàng ẩn không chiếm không gian */
            #chatHistoryTable tbody tr {
                display: table-row;
            }
            #chatHistoryTable tbody tr[style*="none"] {
                display: none;
            }

            .pagination {
                margin-bottom: 0;
            }
            .page-item.active .page-link {
                background-color: #04414d;
                border-color: #04414d;
            }
            .page-link {
                color: #04414d;
            }
        </style>
    </head>
    <body class="sb-nav-fixed">
        <%
            Manager manager = (Manager) session.getAttribute("user");
            String managerName = (manager != null) ? manager.getManagerName() : "Guest";
            String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
        %>

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 p-0">
                    <%@include file="Admin/NavigationMenu.jsp" %>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-0">
                    <%@include file="Admin/HeaderAD.jsp"%>

                    <div class="px-4">
                        <h2 class="mt-4 text-danger">ChatBot History</h2>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">Manage ChatBot Interactions</li>
                        </ol>

                        <!-- Filter and Search Section -->
                        <div class="d-flex justify-content-between mb-3 flex-wrap">
                            <div class="mb-2">
                                <label>Filter by status:</label>
                                <select id="filterStatus" class="form-select d-inline-block w-auto" onchange="filterHistory()">
                                    <option value="all">All</option>
                                    <option value="answered">Answered</option>
                                    <option value="unanswered">Unanswered</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <label for="searchBox">Search:</label>
                                <input type="text" id="searchBox" class="form-control d-inline-block w-auto" 
                                       onkeyup="searchHistory()" placeholder="Search by customer or question...">
                            </div>
                            <div class="mb-2">
                                <label>Show:</label>
                                <select id="entriesPerPage" class="form-select d-inline-block w-auto" onchange="updateEntries()">
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="25">25</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                </select>
                                <span> entries</span>
                            </div>
                        </div>

                        <!-- Chat History Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-comments me-1"></i>
                                ChatBot Interaction History
                            </div>
                            <div class="card-body">
                                <div class="table-container">
                                    <table id="chatHistoryTable" class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Customer</th>
                                                <th>Question</th>
                                                <th>Answer</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<ChatBotHistory> historyList = (List<ChatBotHistory>) request.getAttribute("historyList");
                                                if (historyList != null && !historyList.isEmpty()) {
                                                    for (ChatBotHistory history : historyList) {%>
                                            <tr>
                                                <td><%= history.getCustomerName() != null ? history.getCustomerName() : "Guest"%></td>
                                                <td class="question-cell"><%= history.getQuestion()%></td>
                                                <td class="answer-cell"><%= history.getAnswer() != null ? history.getAnswer() : "Not answered yet"%></td>
                                                <td><fmt:formatDate value="<%= history.getQuestionDate()%>" pattern="yyyy-MM-dd HH:mm" /></td>
                                                <td class="<%= history.isAnswered() ? "status-answered" : "status-unanswered"%>">
                                                    <%= history.isAnswered() ? "Answered" : "Unanswered"%>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <% if (!history.isAnswered()) {%>
                                                        <button class="btn btn-success btn-action" 
                                                                onclick="showAnswerModal('<%= history.getHistoryID()%>', '<%= history.getQuestion().replace("'", "\\'")%>')">
                                                            Answer
                                                        </button>
                                                        <% }%>
                                                        <button class="btn btn-danger btn-action" 
                                                                onclick="confirmDelete('<%= history.getHistoryID()%>')">
                                                            Delete
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <% }
                                            } else { %>
                                            <tr><td colspan="7" class="text-center">No chat history found.</td></tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span id="paginationInfo"></span>
                                    <nav>
                                        <ul class="pagination" id="paginationControls"></ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Answer Modal -->
        <div class="modal fade" id="answerModal" tabindex="-1" aria-labelledby="answerModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="answerModalLabel">Answer Question</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="answerForm" action="<%= request.getContextPath()%>/ChatBotHistory" method="POST">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="historyID" name="historyID" value="">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="questionText" class="form-label">Question:</label>
                                <textarea class="form-control" id="questionText" rows="3" readonly></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="answerText" class="form-label">Answer:</label>
                                <textarea class="form-control" id="answerText" name="answer" rows="5" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Save Answer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Include SweetAlert JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <jsp:include page="/Assets/CSS/bootstrap.js.jsp"/>
        <script src="<%= request.getContextPath()%>/Assets/Javascript/Admin/scripts.js"></script>

        <script>
                                                                    function showAnswerModal(historyID, question) {
                                                                        document.getElementById('historyID').value = historyID;
                                                                        document.getElementById('questionText').value = question;
                                                                        document.getElementById('answerText').value = '';

                                                                        var answerModal = new bootstrap.Modal(document.getElementById('answerModal'));
                                                                        answerModal.show();
                                                                    }

                                                                    function confirmDelete(historyID) {
                                                                        Swal.fire({
                                                                            title: 'Confirm Deletion',
                                                                            text: 'Are you sure you want to delete this chat history? This action cannot be undone.',
                                                                            icon: 'warning',
                                                                            showCancelButton: true,
                                                                            confirmButtonColor: '#d33',
                                                                            cancelButtonColor: '#3085d6',
                                                                            confirmButtonText: 'Yes, delete it!'
                                                                        }).then((result) => {
                                                                            if (result.isConfirmed) {
                                                                                // Tạo form ẩn để gửi POST request
                                                                                const form = document.createElement('form');
                                                                                form.method = 'POST';
                                                                                form.action = '<%= request.getContextPath()%>/ChatBotHistory';

                                                                                const actionInput = document.createElement('input');
                                                                                actionInput.type = 'hidden';
                                                                                actionInput.name = 'action';
                                                                                actionInput.value = 'delete';
                                                                                form.appendChild(actionInput);

                                                                                const idInput = document.createElement('input');
                                                                                idInput.type = 'hidden';
                                                                                idInput.name = 'historyID';
                                                                                idInput.value = historyID;
                                                                                form.appendChild(idInput);

                                                                                document.body.appendChild(form);
                                                                                form.submit();
                                                                            }
                                                                        });
                                                                    }

                                                                    function filterHistory() {
                                                                        let filter = document.getElementById("filterStatus").value.toLowerCase();
                                                                        let rows = document.querySelectorAll("#chatHistoryTable tbody tr");
                                                                        let found = false;

                                                                        rows.forEach(row => {
                                                                            if (!row.id.includes("notFoundRow")) {
                                                                                // Sửa thành cells[4] vì Status là cột thứ 5 (index 4)
                                                                                let statusCell = row.cells[4];
                                                                                let statusClass = statusCell.className;
                                                                                let statusText = statusCell.innerText.trim().toLowerCase();

                                                                                // Kiểm tra cả class và text để chắc chắn
                                                                                if (filter === "all" ||
                                                                                        (filter === "answered" && (statusClass.includes("status-answered") || statusText === "answered")) ||
                                                                                        (filter === "unanswered" && (statusClass.includes("status-unanswered") || statusText === "unanswered"))) {
                                                                                    row.style.display = "";
                                                                                    found = true;
                                                                                } else {
                                                                                    row.style.display = "none";
                                                                                }
                                                                            }
                                                                        });

                                                                        // Xóa dòng thông báo cũ nếu có
                                                                        let notFoundRow = document.getElementById("notFoundRow");
                                                                        if (notFoundRow) {
                                                                            notFoundRow.remove();
                                                                        }

                                                                        // Hiển thị thông báo nếu không tìm thấy
                                                                        if (!found && filter !== "all") {
                                                                            let tbody = document.querySelector("#chatHistoryTable tbody");
                                                                            let tr = document.createElement("tr");
                                                                            tr.id = "notFoundRow";
                                                                            tr.innerHTML = `<td colspan="6" class="text-center">No chat history found with status: ${filter}</td>`;
                                                                            tbody.appendChild(tr);
                                                                        }
                                                                    }

                                                                    function searchHistory() {
                                                                        let keyword = document.getElementById("searchBox").value.toLowerCase();
                                                                        let rows = document.querySelectorAll("#chatHistoryTable tbody tr");

                                                                        rows.forEach(row => {
                                                                            if (!row.id.includes("notFoundRow")) {
                                                                                let customer = row.cells[1].innerText.toLowerCase();
                                                                                let question = row.cells[2].innerText.toLowerCase();
                                                                                row.style.display = (customer.includes(keyword) || question.includes(keyword)) ? "" : "none";
                                                                            }
                                                                        });
                                                                    }

                                                                    function updateEntries() {
                                                                        let entriesPerPage = parseInt(document.getElementById("entriesPerPage").value);

                                                                        // Ẩn/hiện các hàng theo số lượng entriesPerPage
                                                                        let rows = document.querySelectorAll("#chatHistoryTable tbody tr:not(#notFoundRow)");
                                                                        rows.forEach((row, index) => {
                                                                            row.style.display = index < entriesPerPage ? "" : "none";
                                                                        });

                                                                        // Cập nhật thông tin phân trang
                                                                        updatePaginationInfo();
                                                                        const recordsPerPage = document.getElementById("entriesPerPage").value;
                                                                        window.location.href = "ChatBotHistory?page=1&recordsPerPage=" + recordsPerPage;
                                                                    }

                                                                    function updatePaginationInfo() {
                                                                        const entriesPerPage = parseInt(document.getElementById("entriesPerPage").value);
                                                                        const currentPage = <%= request.getAttribute("currentPage") != null ? request.getAttribute("currentPage") : 1%>;
                                                                        const totalRecords = <%= request.getAttribute("totalRecords") != null ? request.getAttribute("totalRecords") : 0%>;

                                                                        if (totalRecords === 0) {
                                                                            document.getElementById("paginationInfo").textContent = "Showing 0 to 0 of 0 entries";
                                                                        } else {
                                                                            const start = Math.min((currentPage - 1) * entriesPerPage + 1, totalRecords);
                                                                            const end = Math.min(currentPage * entriesPerPage, totalRecords);
                                                                            document.getElementById("paginationInfo").textContent =
                                                                                    `Showing ${startRecord} to ${endRecord} of ${totalRecords} entries`;
                                                                        }
                                                                    }

                                                                    function renderPaginationControls() {
                                                                        const paginationControls = document.getElementById("paginationControls");
                                                                        paginationControls.innerHTML = "";

                                                                        const currentPage = <%= request.getAttribute("currentPage")%>;
                                                                        const totalPages = <%= request.getAttribute("totalPages")%>;
                                                                        const recordsPerPage = document.getElementById("entriesPerPage").value;

                                                                        // Nút Previous
                                                                        if (currentPage > 1) {
                                                                            const prevLink = document.createElement("a");
                                                                            prevLink.className = "page-link";
                                                                            prevLink.href = "ChatBotHistory?page=" + (currentPage - 1) + "&recordsPerPage=" + recordsPerPage;
                                                                            prevLink.textContent = "Previous";

                                                                            const prevItem = document.createElement("li");
                                                                            prevItem.className = "page-item";
                                                                            prevItem.appendChild(prevLink);
                                                                            paginationControls.appendChild(prevItem);
                                                                        }

                                                                        // Các trang
                                                                        for (let i = 1; i <= totalPages; i++) {
                                                                            const pageLink = document.createElement("a");
                                                                            pageLink.className = "page-link";
                                                                            pageLink.href = "ChatBotHistory?page=" + i + "&recordsPerPage=" + recordsPerPage;
                                                                            pageLink.textContent = i;

                                                                            const pageItem = document.createElement("li");
                                                                            pageItem.className = "page-item" + (i === currentPage ? " active" : "");
                                                                            pageItem.appendChild(pageLink);
                                                                            paginationControls.appendChild(pageItem);
                                                                        }

                                                                        // Nút Next
                                                                        if (currentPage < totalPages) {
                                                                            const nextLink = document.createElement("a");
                                                                            nextLink.className = "page-link";
                                                                            nextLink.href = "ChatBotHistory?page=" + (currentPage + 1) + "&recordsPerPage=" + recordsPerPage;
                                                                            nextLink.textContent = "Next";

                                                                            const nextItem = document.createElement("li");
                                                                            nextItem.className = "page-item";
                                                                            nextItem.appendChild(nextLink);
                                                                            paginationControls.appendChild(nextItem);
                                                                        }
                                                                    }

                                                                    // Show success/error messages from session
            <% if (request.getSession().getAttribute("message") != null) {%>
                                                                    Swal.fire({
                                                                        icon: 'success',
                                                                        title: 'Success',
                                                                        text: '<%= request.getSession().getAttribute("message")%>',
                                                                        timer: 3000
                                                                    });
            <% request.getSession().removeAttribute("message"); %>
            <% } else if (request.getSession().getAttribute("error") != null) {%>
                                                                    Swal.fire({
                                                                        icon: 'error',
                                                                        title: 'Error',
                                                                        text: '<%= request.getSession().getAttribute("error")%>'
                                                                    });
            <% request.getSession().removeAttribute("error"); %>
            <% }%>

                                                                    // Initialize the table with default settings
                                                                    document.addEventListener('DOMContentLoaded', function () {
                                                                        filterHistory();
                                                                        updatePaginationInfo();
                                                                        renderPaginationControls(); // Thêm dòng này

                                                                        // Đặt giá trị dropdown theo recordsPerPage
                                                                        const recordsPerPage = <%= request.getAttribute("recordsPerPage") != null ? request.getAttribute("recordsPerPage") : 5%>;
                                                                        document.getElementById("entriesPerPage").value = recordsPerPage;
                                                                    });
        </script>
    </body>
</html>