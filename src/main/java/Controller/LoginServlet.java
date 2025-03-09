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

/**
 * Servlet handling user login for both customers and managers.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

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

    /**
     * Handles the HTTP GET request (not used in login, redirects to the login
     * page).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // Encrypt the password
        String hashedPassword = DBContext.hashPasswordMD5(password);
        HttpSession session = request.getSession(true);

        try {
            Object user = null;

            if ("customer".equalsIgnoreCase(userType)) {
                CustomerDAO customerDAO = new CustomerDAO();
                user = customerDAO.getCustomerByUsernameAndPassword(username, hashedPassword);
            } else if ("manager".equalsIgnoreCase(userType)) {
                ManagerDAO managerDAO = new ManagerDAO();
                user = managerDAO.getManagerByUsernameAndPassword(username, hashedPassword);

                if (user == null) {
                    LOGGER.warning("Manager not found or incorrect password.");
                }
            }

            if (user != null) {
                session.setAttribute("user", user);

                if (user instanceof Manager) {
                    Manager manager = (Manager) user;
                    session.setAttribute("role", manager.isRole() ? "ADMIN" : "STAFF");
                    LOGGER.info("Login successful! Role: " + session.getAttribute("role"));
                    if (manager.isRole()) {
                        response.sendRedirect("DashBoardForAdmin");
                    } else {
                        response.sendRedirect("ListFeedbackForStaff");
                    }
                } else {
                    session.setAttribute("role", "CUSTOMER");
                    LOGGER.info("Login as CUSTOMER");
                    response.sendRedirect(request.getContextPath());
                }

                setRememberMeCookies(response, username, hashedPassword, rememberMe);
            } else {
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
        return "Handles login for customers and managers.";
    }
}
