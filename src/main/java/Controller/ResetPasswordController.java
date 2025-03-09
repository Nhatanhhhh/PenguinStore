/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.ResetPasswordDAO;
import DB.DBContext;
import jakarta.servlet.RequestDispatcher;
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
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class ResetPasswordController extends HttpServlet {

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
            /* TODO output your page here. You may use the following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ResetPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetPasswordController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        RequestDispatcher dispatcher = request.getRequestDispatcher("View/ResetPassword.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("new-password");
        String confirmPassword = request.getParameter("confirm-password");
        ResetPasswordDAO rPD = new ResetPasswordDAO();
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");  // Retrieve email from session

        // Check if the new password length is at least 6 characters
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "The new password must have at least 6 characters.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        // Check if the password contains at least one uppercase, one lowercase letter, one number, and one special character
        if (!newPassword.matches(".*[A-Z].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*[a-z].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*\\d.*")) {
            request.setAttribute("errorMessage", "The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        // Check if the new password matches the confirmation password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "The confirmation password does not match.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        boolean isSuccess = false;
        try {
            // Encrypt the new password before updating
            String newPasswordHash = DBContext.hashPasswordMD5(newPassword);
            isSuccess = rPD.updatePasswordByEmail(email, newPasswordHash);
        } catch (Exception ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (isSuccess) {
            session.setAttribute("successMessage", "Password changed successfully.");  // Store in session instead of request
            response.sendRedirect("Login");  // Redirect instead of forward
        } else {
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
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
    }
}
