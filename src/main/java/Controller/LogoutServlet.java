package Controller;

import com.nimbusds.jose.shaded.json.JSONObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.nimbusds.jose.shaded.json.JSONObject;

/**
 * Servlet handling user logout with enhanced security and logging.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

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
        response.setContentType("application/json;charset=UTF-8");
        JSONObject jsonResponse = new JSONObject();
        try ( PrintWriter out = response.getWriter()) {
            jsonResponse.put("message", "Logout endpoint reached");
            out.print(jsonResponse.toString());
            out.flush();
        }
    }

    /**
     * Handles the HTTP GET request for user logout.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Processing user logout request.");

        HttpSession session = request.getSession(false);
        if (session != null) {
            LOGGER.log(Level.INFO, "Invalidating user session: {0}", session.getId());
            session.invalidate();
        }
        
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName()) || "password".equals(cookie.getName()) || "remember".equals(cookie.getName()) || "auth_token".equals(cookie.getName())) {
                    LOGGER.log(Level.INFO, "Removing cookie: {0}", cookie.getName());
                    cookie.setValue(null);
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    cookie.setHttpOnly(true);
                    cookie.setSecure(true);
                    response.addCookie(cookie);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/Login?logoutSuccess=true");
    }

    /**
     * Handles the HTTP POST request for logout, supports JSON response.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Processing POST logout request.");
        response.setContentType("application/json;charset=UTF-8");
        JSONObject jsonResponse = new JSONObject();

        try ( PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                LOGGER.log(Level.INFO, "Invalidating session via POST: {0}", session.getId());
                session.invalidate();
            }
            jsonResponse.put("status", "success");
            jsonResponse.put("message", "User logged out successfully.");
            out.print(jsonResponse.toString());
            out.flush();
        }
    }

    /**
     * Handles HTTP DELETE requests for logout (RESTful API compatibility).
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Processing DELETE logout request.");
        doPost(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles user logout by invalidating session and clearing cookies with enhanced security and logging.";
    }
}
