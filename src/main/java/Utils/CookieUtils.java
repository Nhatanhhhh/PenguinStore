package Utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtils {

    public static void setRememberMeCookies(HttpServletResponse response, String username, String hashedPassword, String rememberMe) {
        Cookie userCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", hashedPassword);
        Cookie rememberCookie = new Cookie("remember", rememberMe);

        int expiry = (rememberMe != null) ? 24 * 60 * 60 : 0; // 1 day or remove immediately
        userCookie.setMaxAge(expiry);
        passwordCookie.setMaxAge(expiry);
        rememberCookie.setMaxAge(expiry);

        response.addCookie(userCookie);
        response.addCookie(passwordCookie);
        response.addCookie(rememberCookie);
    }
}
