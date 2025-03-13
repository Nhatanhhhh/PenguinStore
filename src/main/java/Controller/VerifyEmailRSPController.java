/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Service.EmailService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "VerifyEmailRSPController", urlPatterns = {"/VerifyEmailRSP", "/ResendCodeRSP"})
public class VerifyEmailRSPController extends HttpServlet {

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
            out.println("<title>Servlet VerifyEmailRSPController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyEmailRSPController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("View/VerifyEmailRSP.jsp").forward(request, response);
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
        String action = request.getServletPath();

        if ("/VerifyEmailRSP".equals(action)) {
            String verificationCode = request.getParameter("verificationCode");
            String sessionCode = (String) request.getSession().getAttribute("verificationCode");
            System.out.println("Verification code users enter: " + verificationCode);
            System.out.println("Authentication code in session: " + sessionCode);
            if (verificationCode != null && verificationCode.equals(sessionCode)) {
                response.sendRedirect("ResetPassword");
            } else {
                System.out.println("The authentication code is not correct or expired.");
                request.setAttribute("errorMessage", "The authentication code is not correct or expired.");
                request.getRequestDispatcher("Login").forward(request, response);
            }
        } else if ("/ResendCodeRSP".equals(action)) {
            // Gửi lại mã xác thực
            String email = (String) request.getSession().getAttribute("email");
            String newCode = generateVerificationCode();
            request.getSession().setAttribute("verificationCode", newCode);
            EmailService emailService = new EmailService();
            emailService.sendVerificationEmail(email, newCode);
            request.setAttribute("msg", "The new authentication code has been sent.");
            request.getRequestDispatcher("VerifyEmailRSP").forward(request, response);
        }
    }

    private String generateVerificationCode() {
        return String.valueOf((int) ((Math.random() * 900000) + 100000));
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
