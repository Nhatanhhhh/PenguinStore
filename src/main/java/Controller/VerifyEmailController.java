package Controller;

import DAOs.RegisterDAO;
import DB.DBContext;
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

/**
 * Servlet handling email verification and resending verification codes.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "VerifyEmailController", urlPatterns = {"/VerifyEmail", "/ResendCode"})
public class VerifyEmailController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(VerifyEmailController.class.getName());

    /**
     * Handles HTTP GET requests by displaying the verification page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("View/VerifyEmail.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST requests for verifying email and resending verification
     * codes.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get action type
        String action = request.getServletPath();
        LOGGER.log(Level.INFO, "Received POST request: {0}", action);

        // Get session
        HttpSession session = request.getSession();

        if ("/VerifyEmail".equals(action)) {
            verifyOtp(request, response, session);
        } else if ("/ResendCode".equals(action)) {
            resendVerificationCode(request, response, session);
        } else {
            LOGGER.log(Level.WARNING, "Invalid request action: {0}", action);
            session.setAttribute("errorMessage", "Invalid request.");
            response.sendRedirect("View/VerifyEmail.jsp");
        }
    }

    /**
     * Verifies the OTP entered by the user.
     */
    private void verifyOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException, ServletException {

        // Retrieve user input and session-stored OTP
        String verificationCode = request.getParameter("verificationCode");
        String sessionCode = (String) session.getAttribute("verificationCode");

        LOGGER.log(Level.INFO, "User-entered OTP: {0}", verificationCode);
        LOGGER.log(Level.INFO, "Stored session OTP: {0}", sessionCode);

        // Validate OTP presence
        if (verificationCode == null || verificationCode.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "User submitted empty OTP.");
            session.setAttribute("errorMessage", "OTP cannot be empty.");
            response.sendRedirect("View/VerifyEmail.jsp");
            return;
        }

        // Validate OTP correctness
        if (sessionCode != null && verificationCode.equals(sessionCode)) {
            LOGGER.log(Level.INFO, "OTP verification successful! Proceeding with registration.");

            // Retrieve stored user details
            String username = (String) session.getAttribute("username");
            String password = (String) session.getAttribute("password");
            String fullName = (String) session.getAttribute("fullName");
            String email = (String) session.getAttribute("email");
            String phone = (String) session.getAttribute("phone");

            // Ensure all required attributes exist
            if (username == null || password == null || fullName == null || email == null || phone == null) {
                LOGGER.log(Level.SEVERE, "Missing session attributes. Registration cannot proceed.");
                session.setAttribute("errorMessage", "Session expired. Please register again.");
                response.sendRedirect("View/Register.jsp");
                return;
            }

            // Encrypt password before storing
            String hashedPassword = DBContext.hashPasswordMD5(password);

            // Register user
            RegisterDAO registerDAO = new RegisterDAO();
            String result = registerDAO.registerUser(username, hashedPassword, fullName, email, phone);

            if ("SUCCESS".equals(result)) {
                LOGGER.log(Level.INFO, "User registration successful.");
                session.setAttribute("successMessage", "Successful authentication, you can log in!");
                response.sendRedirect("Login");
            } else {
                LOGGER.log(Level.SEVERE, "User registration failed: {0}", result);
                session.setAttribute("errorMessage", "Registration failed. Please try again.");
                response.sendRedirect("View/VerifyEmail.jsp");
            }
        } else {
            LOGGER.log(Level.WARNING, "OTP verification failed. Incorrect or expired.");
            session.setAttribute("errorMessage", "The authentication code is incorrect or expired.");
            response.sendRedirect("View/VerifyEmail.jsp");
        }
    }

    /**
     * Resends a new verification code to the user.
     */
    private void resendVerificationCode(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException, ServletException {

        // Retrieve user email
        String email = (String) session.getAttribute("email");

        // Check if email exists
        if (email == null || email.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "No email found in session. Cannot resend OTP.");
            session.setAttribute("errorMessage", "Session expired. Please register again.");
            response.sendRedirect("View/Register.jsp");
            return;
        }

        try {
            // Generate new OTP
            String newCode = generateVerificationCode();
            session.setAttribute("verificationCode", newCode);

            // Send verification email
            EmailService emailService = new EmailService();
            boolean emailSent = emailService.sendVerificationEmail(email, newCode);

            if (emailSent) {
                LOGGER.log(Level.INFO, "New OTP sent successfully to {0}", email);
                session.setAttribute("successMessage", "A new verification code has been sent.");
            } else {
                LOGGER.log(Level.SEVERE, "Failed to send verification email to {0}", email);
                session.setAttribute("errorMessage", "Failed to send verification email. Please try again.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error while resending verification code", e);
            session.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        }

        response.sendRedirect("View/VerifyEmail.jsp");
    }

    /**
     * Generates a 6-digit verification code.
     */
    private String generateVerificationCode() {
        return String.valueOf((int) ((Math.random() * 900000) + 100000));
    }
}
