package Controller;

import DAOs.RegisterDAO;
import Models.Customer;
import Utils.CookieUtils;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "GoogleLogin", urlPatterns = {"/GoogleLogin"})
public class GoogleLoginController extends HttpServlet {

    private static final String CLIENT_ID = "481523146636-vh5s2vjv8fm9hb8dtgi9e3f66711192u.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:9999/PenguinStore/GoogleLogin";
    private final JsonFactory jsonFactory = GsonFactory.getDefaultInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cross-Origin-Opener-Policy", "same-origin-allow-popups");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        String code = request.getParameter("code");

        if (code != null && !code.isEmpty()) {
            try {
                GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                        new NetHttpTransport(),
                        jsonFactory,
                        "https://oauth2.googleapis.com/token",
                        CLIENT_ID,
                        CLIENT_SECRET,
                        code,
                        REDIRECT_URI
                ).execute();

                GoogleIdToken idToken = tokenResponse.parseIdToken();
                GoogleIdToken.Payload payload = idToken.getPayload();

                String email = payload.getEmail();
                String name = ((String) payload.get("name")).trim().replaceAll("\\s+", "_");  // Remove spaces
                String googleID = payload.getSubject();
                String accessToken = tokenResponse.getAccessToken().trim(); // Trim spaces

                RegisterDAO registerDAO = new RegisterDAO();

                if (!registerDAO.isEmailExist(email)) {
                    registerDAO.registerUserGoogle(email, name, email, googleID, accessToken);
                }

                Customer customer = registerDAO.getUserByEmail(email);
                if (customer != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", customer);
                    session.setAttribute("role", "CUSTOMER");

                    // ✅ Store login info in cookies (sanitize values)
                    CookieUtils.setCookie(response, "username", name, 7 * 24 * 60 * 60); // 7 days
                    CookieUtils.setCookie(response, "email", email, 7 * 24 * 60 * 60);
                    CookieUtils.setCookie(response, "accessToken", accessToken, 7 * 24 * 60 * 60);

                    session.setAttribute("successMessage", "Google Login successful! Welcome to Penguin Store.");
                    session.setAttribute("showSweetAlert", true);

                    response.sendRedirect(request.getContextPath() + "/");
                } else {
                    clearCookies(response);
                    request.setAttribute("errorMessage", "Cannot authenticate user. Please try again.");
                    request.getRequestDispatcher("View/LoginCustomer.jsp").forward(request, response);
                }

            } catch (SQLException ex) {
                Logger.getLogger(GoogleLoginController.class.getName()).log(Level.SEVERE, null, ex);
                clearCookies(response);
                request.setAttribute("errorMessage", "Database connection error. Please try again later.");
                request.getRequestDispatcher("View/LoginCustomer.jsp").forward(request, response);
            }

        } else {
            clearCookies(response);

            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    new NetHttpTransport(),
                    jsonFactory,
                    CLIENT_ID,
                    CLIENT_SECRET,
                    Collections.singletonList("email")
            ).setAccessType("offline")
                    .setApprovalPrompt("force")
                    .build();

            String authorizationUrl = flow.newAuthorizationUrl().setRedirectUri(REDIRECT_URI).build();
            response.sendRedirect(authorizationUrl);
        }
    }

    private void clearCookies(HttpServletResponse response) {
        CookieUtils.deleteCookie(response, "username");
        CookieUtils.deleteCookie(response, "email");
        CookieUtils.deleteCookie(response, "accessToken");
    }
}
