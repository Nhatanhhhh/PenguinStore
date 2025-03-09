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
 * Filter to check if the user is logged in before allowing access to certain
 * pages.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Check the current session
        HttpSession session = req.getSession(false);

        // Verify if the user is logged in (session exists and contains a user attribute)
        if (session != null && session.getAttribute("user") != null) {
            // If the user is logged in, allow the request to proceed
            chain.doFilter(request, response);
        } else {
            // If not logged in, redirect to the login page
            res.sendRedirect("/PenguinStore");
        }
    }
}
