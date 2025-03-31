/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Filters;

import DAOs.CustomerDAO;
import Models.Customer;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter to check if the user is logged in before allowing access to certain
 * pages.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            String username = null;
            String hashedPassword = null;

            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                } else if ("password".equals(cookie.getName())) {
                    hashedPassword = cookie.getValue();
                }
            }

            if (username != null && hashedPassword != null) {
                CustomerDAO customerDAO = new CustomerDAO();
                Customer user = customerDAO.getCustomerByUsernameAndPassword(username, hashedPassword);

                if (user != null) {
                    session = req.getSession(true);
                    session.setAttribute("user", user);
                    session.setAttribute("role", "CUSTOMER");
                    System.out.println("✅ Auto login từ cookie: " + username);
                }
            }
        }

        chain.doFilter(request, response);
    }
}
