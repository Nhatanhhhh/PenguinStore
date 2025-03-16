/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.ResetPasswordDAO;
import Service.EmailService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class ForgetPasswordController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForgetPasswordController.class.getName());

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
            out.println("<title>Servlet ForgetPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgetPasswordController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/View/ForgetPassword.jsp").forward(request, response);
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

        LOGGER.log(Level.INFO, "Received password reset request");

        String email = request.getParameter("email");
        ResetPasswordDAO resetPasswordDAO = new ResetPasswordDAO();

        if (!isValidEmail(email)) {
            LOGGER.log(Level.WARNING, "Invalid email format: {0}", email);
            request.getSession().setAttribute("errorMessage", "Invalid email format! Please enter a valid email.");
            request.getRequestDispatcher("/View/ForgetPassword.jsp").forward(request, response);
            return;  // STOP execution here
        }

        try {
            boolean emailExists = resetPasswordDAO.checkEmailExists(email);

            if (!emailExists) {
                LOGGER.log(Level.WARNING, "Email does not exist: {0}", email);
                request.getSession().setAttribute("errorMessage", "Email does not exist in the system!");
                request.getRequestDispatcher("/View/ForgetPassword.jsp").forward(request, response);
                return;  // STOP execution here
            }

            // Generate and send verification code
            int verificationCode = generateVerificationCode();
            String verificationCodeStr = String.valueOf(verificationCode);
            EmailService emailService = new EmailService();

            boolean emailSent = emailService.sendVerificationEmail(email, verificationCodeStr);

            if (!emailSent) {
                LOGGER.log(Level.SEVERE, "Failed to send verification email to: {0}", email);
                request.getSession().setAttribute("errorMessage", "Failed to send verification email. Please try again later.");
                request.getRequestDispatcher("/View/ForgetPassword.jsp").forward(request, response);
                return;  // STOP execution here
            }

            // Store verification details in session
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("verificationCode", verificationCodeStr);

            LOGGER.log(Level.INFO, "Verification email sent successfully to: {0}", email);
            request.getSession().setAttribute("successMessage", "A verification code has been sent to your email!");
            response.sendRedirect("VerifyEmailRSP");  // Only redirect if no forward() has been executed

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing password reset request", e);
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/View/ForgetPassword.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailRegex);
    }

    private int generateVerificationCode() {
        return (int) (Math.random() * 900000) + 100000;
    }

    private void sendAlert(HttpServletResponse response, String title, String message, String icon) throws IOException {
        sendAlert(response, title, message, icon, null);
    }

    private void sendAlert(HttpServletResponse response, String title, String message, String icon, String redirectURL) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( var out = response.getWriter()) {
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("<script>");
            out.println("Swal.fire({");
            out.println("    title: '" + title + "',");
            out.println("    text: '" + message + "',");
            out.println("    icon: '" + icon + "',");
            out.println("    confirmButtonText: 'OK'");
            out.println("}).then((result) => {");

            if (redirectURL != null) {
                out.println("    if (result.isConfirmed) { window.location.href = '" + redirectURL + "'; }");
            }

            out.println("});");
            out.println("</script>");
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
