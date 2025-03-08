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

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/Register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/View/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        RegisterDAO registerDAO = new RegisterDAO();

        if (registerDAO.isUserExists(username)) {
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("fullName", fullName);
            request.getSession().setAttribute("msg", "The username has existed, please try again.");
            response.sendRedirect(request.getContextPath() + "/View/Register.jsp");
            return;
        } else if (registerDAO.isEmailExist(email)) {
            request.setAttribute("msg", "Email exists, please try again.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher("/View/Register.jsp").forward(request, response);
            return;
        }

        int verificationCode = (int) (Math.random() * 900000) + 100000;
        String verificationCodeStr = String.valueOf(verificationCode);
        EmailService emailService = new EmailService();
        emailService.sendVerificationEmail(email, verificationCodeStr);

        request.getSession().setAttribute("username", username);
        request.getSession().setAttribute("password", password);
        request.getSession().setAttribute("fullName", fullName);
        request.getSession().setAttribute("email", email);
        request.getSession().setAttribute("phone", phone);
        request.getSession().setAttribute("verificationCode", verificationCodeStr);

        response.sendRedirect("View/VerifyEmail.jsp");
    }
}
