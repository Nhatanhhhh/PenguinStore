/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.ChangePasswordDAO;
import DAOs.ProductDAO;
import DAOs.TypeDAO;
import DB.DBContext;
import Models.Customer;
import Models.Type;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Thuan
 */
public class ChangePasswordController extends HttpServlet {

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
            out.println("<title>Servlet ChangePasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePasswordController at " + request.getContextPath() + "</h1>");
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
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        request.setAttribute("listProduct", productDAO.getProductCustomer());
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);
        request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        Customer currentUser = (Customer) session.getAttribute("user");

        // Check if the user is logged in
        if (currentUser == null) {
            response.sendRedirect("Login");
            return;
        }

        // Debugging: Print the current user's full name
        System.out.println("User Full Name: " + currentUser.getFullName());

        // Retrieve password fields from the request
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check for null input values
        if (oldPassword == null || newPassword == null || confirmPassword == null) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Hash the old password for comparison with the database
        String oldPasswordHash = DBContext.hashPasswordMD5(oldPassword);

        // Verify if the old password is correct
        ChangePasswordDAO changePQD = new ChangePasswordDAO();
        boolean isOldPasswordCorrect = false;
        try {
            isOldPasswordCorrect = changePQD.checkPassword(currentUser.getUserName(), oldPasswordHash);
        } catch (SQLException ex) {
            Logger.getLogger(ChangePasswordController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Error occurred while checking the password.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // If the old password is incorrect, return an error
        if (!isOldPasswordCorrect) {
            request.setAttribute("errorMessage", "The old password is incorrect.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", "The password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Check if the new password matches the confirmation password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "The confirmation password does not match.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Update the new password in the database
        try {
            String newPasswordHash = DBContext.hashPasswordMD5(newPassword);
            changePQD.updatePassword(currentUser.getUserName(), newPasswordHash);
        } catch (SQLException ex) {
            Logger.getLogger(ChangePasswordController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Error occurred while updating the password.");
            request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Redirect to success message after updating the password
        request.setAttribute("successMessage", "Your password has been successfully updated.");
        request.getRequestDispatcher("View/ChangePassword.jsp").forward(request, response);
    }

    /**
     * Validates the strength of the password.
     *
     * @param password The password to be validated
     * @return true if the password meets the criteria, otherwise false
     */
    private boolean isValidPassword(String password) {
        return password.length() >= 6
                && password.matches(".*[A-Z].*")
                && // At least one uppercase letter
                password.matches(".*[a-z].*")
                && // At least one lowercase letter
                password.matches(".*\\d.*")
                && // At least one digit
                password.matches(".*[!@#$%^&*(),.?\":{}|<>].*");  // At least one special character
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
