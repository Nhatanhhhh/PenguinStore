package Controller;

import DAOs.RegisterDAO;
import Models.Customer;
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
                String name = (String) payload.get("name");
                String googleID = payload.getSubject();
                String accessToken = tokenResponse.getAccessToken();

                RegisterDAO registerDAO = new RegisterDAO();

                if (!registerDAO.isEmailExist(email)) {
                    registerDAO.registerUserGoogle(
                            email, name, email, googleID, accessToken
                    );
                }

                Customer customer = registerDAO.getUserByEmail(email);
                if (customer != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", customer);
                    session.setAttribute("role", "CUSTOMER");
                    response.sendRedirect("/PenguinStore");
                } else {
                    request.setAttribute("errorMessage", "Can not authenticate users. Please try again.");
                    request.getRequestDispatcher("View/LoginCustomer.jsp").forward(request, response);
                    return;
                }

            } catch (SQLException ex) {
                Logger.getLogger(GoogleLoginController.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("errorMessage", "Database connection error. Please try again later.");
                request.getRequestDispatcher("View/LoginCustomer.jsp").forward(request, response);
                return;
            }

            response.sendRedirect("/PenguinStore");
        } else {
            request.getSession().invalidate();

            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    cookie.setValue(null);
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addHeader("Set-Cookie", cookie.getName() + "=; Path=" + cookie.getPath()
                            + "; Max-Age=0; SameSite=None; Secure");
                }
            }

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
}