/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Hàm này có thể để trống nếu không có logic cần thiết
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Kiểm tra session hiện tại
        HttpSession session = req.getSession(false);

        // Kiểm tra xem người dùng đã đăng nhập (session có tồn tại và có thuộc tính người dùng hoặc googleUser)
        if (session != null && (session.getAttribute("user") != null)) {
            // Nếu người dùng đã đăng nhập, cho phép tiếp tục request
            chain.doFilter(request, response);
        } else {
            // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
            res.sendRedirect("Login");
        }
    }

    @Override
    public void destroy() {
        // Hàm này có thể để trống nếu không có logic cần thiết
    }
}
