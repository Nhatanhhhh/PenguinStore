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
            /* TODO output your page here. You may use following sample code. */
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
        String email = (String) session.getAttribute("email");  // Lấy email từ session

        // Kiểm tra độ dài mật khẩu mới phải >= 6 ký tự
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "The new password must have at least 6 characters.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu phải chứa ít nhất một chữ hoa, một chữ thư�?ng, một số và một ký tự đặc biệt
        if (!newPassword.matches(".*[A-Z].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one capital, regular, number and 1 special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*[a-z].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one capital, regular, number and 1 special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*\\d.*")) {
            request.setAttribute("errorMessage", "The password must contain at least one capital, regular, number and 1 special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }
        if (!newPassword.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            request.setAttribute("errorMessage", "The password must contain at least one capital, regular, number and 1 special character.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        // Kiểm tra xem mật khẩu mới có khớp với xác nhận mật khẩu không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Confirm the password without matching.");
            request.getRequestDispatcher("ResetPassword").forward(request, response);
            return;
        }

        boolean isSuccess = false;
        try {
            // Mã hóa mật khẩu mới trước khi cập nhật
            String newPasswordHash = DBContext.hashPasswordMD5(newPassword);
            isSuccess = rPD.updatePasswordByEmail(email, newPasswordHash);
        } catch (Exception ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (isSuccess) {
            session.setAttribute("successMessage", "Change the password successfully.");  // Lưu vào session thay vì request
            response.sendRedirect("Login");  // Chuyển hướng thay vì forward
        } else {
            request.setAttribute("errorMessage", "Error occurs. Please try again.");
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
    }// </editor-fold>

}
