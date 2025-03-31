/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filters;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

/**
 *
 * @author Nhat_Anh
 */
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        // Kiểm tra nếu người dùng chưa đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // Kiểm tra role của người dùng
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {
            System.out.println("❌ Không có quyền truy cập Admin!");
            res.sendRedirect(req.getContextPath() + "/AccessDenied");
            return;
        }

        System.out.println("✅ Quyền Admin hợp lệ, tiếp tục request...");
        chain.doFilter(request, response);
    }
    
}
