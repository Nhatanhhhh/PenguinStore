/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.RegisterDAO;
import Service.EmailService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
@WebServlet(name = "RegisterController", urlPatterns = {"/Register"})
public class RegisterController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterController.class.getName());

    // Regular expressions for validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\d{10,11}$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$"); // At least 8 chars, 1 uppercase, 1 number, 1 special char

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/View/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.log(Level.INFO, "Processing user registration request.");

        // Retrieve parameters
        String username = request.getParameter("username").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirm_password").trim();

        HttpSession session = request.getSession();
        RegisterDAO registerDAO = new RegisterDAO();

        // ✅ Step 1: Validate User Input
        if (username.isEmpty() || fullName.isEmpty() || email.isEmpty() || phone.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("msg", "All fields are required!");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            session.setAttribute("msg", "Invalid email format!");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        if (!PHONE_PATTERN.matcher(phone).matches()) {
            session.setAttribute("msg", "Phone number must be 10-11 digits!");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            session.setAttribute("msg", "Password must have at least 8 characters, including one uppercase letter, one number, and one special character.");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        if (!password.equals(confirmPassword)) {
            session.setAttribute("msg", "Passwords do not match!");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        // ✅ Step 2: Check if Username or Email Already Exists
        if (registerDAO.isUserExists(username)) {
            session.setAttribute("msg", "The username has already been taken. Please choose another.");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        if (registerDAO.isEmailExist(email)) {
            session.setAttribute("msg", "This email is already registered. Please use a different one.");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        // ✅ Step 3: Generate Verification Code and Send Email
        int verificationCode = (int) (Math.random() * 900000) + 100000;
        String verificationCodeStr = String.valueOf(verificationCode);
        EmailService emailService = new EmailService();

        try {
            boolean emailSent = emailService.sendVerificationEmail(email, verificationCodeStr);

            if (!emailSent) {
                session.setAttribute("msg", "Failed to send verification email. Please try again.");
                response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
                return;
            }

            LOGGER.log(Level.INFO, "Verification code sent successfully to: {0}", email);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending verification email", e);
            session.setAttribute("msg", "An error occurred while sending the verification email.");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        }

        // ✅ Step 4: Store Data in Session for Verification
        session.setAttribute("username", username);
        session.setAttribute("fullName", fullName);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        session.setAttribute("password", password);
        session.setAttribute("verificationCode", verificationCodeStr);

        // ✅ Step 5: Redirect to Email Verification Page
        response.sendRedirect(request.getContextPath() + "/View/VerifyEmail.jsp");
    }
}
