/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.CustomerDAO;
import DAOs.ManagerDAO;
import DB.DBContext;
import Models.Customer;
import Models.Manager;
import static Utils.CookieUtils.setRememberMeCookies;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,20}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final int MIN_PASSWORD_LENGTH = 6;
    private static final int MAX_FAILED_ATTEMPTS = 3;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            request.getRequestDispatcher("/View/index.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("/View/LoginCustomer.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP POST request for user login.
     *
     * @param request The HTTP request containing login parameters.
     * @param response The HTTP response to redirect or send an error.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException If an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember-me");

        if (username != null) {
            username = username.replaceAll("\\s+", ""); 
        }

        if (password != null) {
            password = password.trim(); 
        }

        HttpSession session = request.getSession(true);
        Integer failedAttempts = (Integer) session.getAttribute("failedAttempts");
        if (failedAttempts == null) {
            failedAttempts = 0;
        }

        if (failedAttempts >= MAX_FAILED_ATTEMPTS) {
            session.setAttribute("errorMessage", "Too many failed attempts. Please reset your password.");
            session.setAttribute("showSweetAlert", true);
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        if (userType == null || (!userType.equalsIgnoreCase("customer") && !userType.equalsIgnoreCase("manager"))) {
            session.setAttribute("errorMessage", "Invalid user type.");
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        if (username == null || !USERNAME_PATTERN.matcher(username).matches() && !EMAIL_PATTERN.matcher(username).matches()) {
            session.setAttribute("errorMessage", "Invalid username format. Must be 3-20 characters and only contain letters, numbers, and underscores.");
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        if (password == null || password.length() < MIN_PASSWORD_LENGTH) {
            session.setAttribute("errorMessage", "Password must be at least " + MIN_PASSWORD_LENGTH + " characters long.");
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        String hashedPassword = DBContext.hashPasswordMD5(password);

        try {
            Object user = null;
            if ("customer".equalsIgnoreCase(userType)) {
                CustomerDAO customerDAO = new CustomerDAO();
                user = customerDAO.getCustomerByUsernameAndPassword(username, hashedPassword);
            } else if ("manager".equalsIgnoreCase(userType)) {
                ManagerDAO managerDAO = new ManagerDAO();
                user = managerDAO.getManagerByUsernameAndPassword(username, hashedPassword);
            }

            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("failedAttempts", 0);
                session.setAttribute("successMessage", "Login successful! Welcome to Penguin Store.");
                session.setAttribute("showSweetAlert", true);

                if (user instanceof Manager manager) {
                    session.setAttribute("role", manager.isRole() ? "ADMIN" : "STAFF");
                    response.sendRedirect(manager.isRole() ? "DashBoardForAdmin" : "DashBoardForStaff");
                } else {
                    session.setAttribute("role", "CUSTOMER");
                    response.sendRedirect(request.getContextPath());
                }

                // ✅ Thiết lập Cookie nếu người dùng chọn "Remember Me"
                if ("on".equals(rememberMe)) {
                    setRememberMeCookies(response, username, hashedPassword, rememberMe);
                }
            } else {
                failedAttempts++;
                session.setAttribute("failedAttempts", failedAttempts);
                session.setAttribute("errorMessage", "Incorrect username or password.");
                response.sendRedirect("customer".equalsIgnoreCase(userType) ? "View/LoginCustomer.jsp" : "View/LoginManager.jsp");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Login error", e);
            session.setAttribute("errorMessage", "An error occurred. Please try again.");
            response.sendRedirect("/PenguinStore");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
