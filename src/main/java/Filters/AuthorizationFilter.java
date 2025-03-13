/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filters;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

/**
 *
 * @author Nhat_Anh
 */
public class AuthorizationFilter implements Filter {

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        System.out.println("🚀 AuthorizationFilter chạy! Path: " + path + " | Role: " + role);

        // Kiểm tra nếu user chưa đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("🔴 Chưa đăng nhập, cho phép qua filter...");
            chain.doFilter(request, response);
            return;
        }

        // 🚨 Kiểm tra quyền truy cập
        if (path.startsWith(req.getContextPath() + "/DashBoardForAdmin") && !"ADMIN".equals(role)) {
            System.out.println("❌ Không có quyền truy cập Admin!");
            res.sendRedirect(req.getContextPath() + "/AccessDenied");
            return;
        } else if (path.startsWith(req.getContextPath() + "/DashBoardForStaff") && !("STAFF".equals(role) || "ADMIN".equals(role))) {
            System.out.println("❌ Không có quyền truy cập Staff!");
            res.sendRedirect(req.getContextPath() + "/AccessDenied");
            return;
        }

        System.out.println("✅ Quyền hợp lệ, tiếp tục request...");
        chain.doFilter(request, response);
    }

}
