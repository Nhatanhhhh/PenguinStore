/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "VerifyEmailController", urlPatterns = {"/VerifyEmail", "/ResendCodes"})
public class VerifyEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        request.getRequestDispatcher("/View/VerifyEmail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        if ("/VerifyEmail".equals(action)) {
            String verificationCode = request.getParameter("verificationCode");
            String sessionCode = (String) request.getSession().getAttribute("verificationCode");
            System.out.println("Mã xác thực người dùng nhập: " + verificationCode);
            System.out.println("Mã xác thực trong session: " + sessionCode);
            if (verificationCode != null && verificationCode.equals(sessionCode)) {

                String username = (String) request.getSession().getAttribute("username");
                String password = (String) request.getSession().getAttribute("password");
                String fullName = (String) request.getSession().getAttribute("fullName");
                String email = (String) request.getSession().getAttribute("email");
                String phone = (String) request.getSession().getAttribute("phone");

                RegisterDAO registerDAO = new RegisterDAO();
                String hashedPassword = DBContext.hashPasswordMD5(password);
                String result = registerDAO.registerUser(username, hashedPassword, fullName, email, phone);
                if ("SUCCESS".equals(result)) {
                    request.setAttribute("successMessage", "Successful authentication, you can log in!");
                    response.sendRedirect("View/LoginCustomer.jsp");
                } else {
                    request.setAttribute("errorMessage", "Successful registration, please try again!");
                    request.getRequestDispatcher("View/VerifyEmail.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "The authentication code is not correct or expired!");
                request.getRequestDispatcher("View/VerifyEmail.jsp").forward(request, response);
            }
        } else if ("/ResendCodes".equals(action)) {
            String email = (String) request.getSession().getAttribute("email");
            String newCode = generateVerificationCode();
            request.getSession().setAttribute("verificationCode", newCode);
            EmailService emailService = new EmailService();
            emailService.sendVerificationEmail(email, newCode);
            request.setAttribute("msg", "The new authentication code has been sent!");
            request.getRequestDispatcher("View/VerifyEmail.jsp").forward(request, response);
        }
    }

    private String generateVerificationCode() {
        return String.valueOf((int) ((Math.random() * 900000) + 100000));
    }
}
