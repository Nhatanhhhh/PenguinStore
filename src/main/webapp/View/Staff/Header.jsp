<%-- 
    Document   : Header
    Created on : Mar 8, 2025, 12:32:38 AM
    Author     : Le Minh Loc CE180992
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Manager"%>
<%
    Manager manager = (Manager) session.getAttribute("user");
    String managerName = (manager != null) ? manager.getManagerName() : "Guest";
    String managerEmail = (manager != null) ? manager.getEmail() : "No Email";
%>

<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="#">Order Management</a>
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Navbar Right -->
    <ul class="navbar-nav ms-auto me-3">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle text-white" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user"></i> 
                <%= managerName %>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li class="dropdown-item-text text-muted"><%= managerEmail %></li>
                <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                <li><a class="dropdown-item" href="settings.jsp">Settings</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="logout.jsp">Logout</a></li>
            </ul>
        </li>
    </ul>
</nav>

