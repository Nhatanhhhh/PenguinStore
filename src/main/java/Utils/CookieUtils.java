package Utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class CookieUtils {

    public static void setRememberMeCookies(HttpServletResponse response, String username, String hashedPassword, String rememberMe) {
        int expiry = "on".equals(rememberMe) ? 24 * 60 * 60 : 0; // 1 day or remove immediately

        Cookie userCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", hashedPassword);
        Cookie rememberCookie = new Cookie("remember", rememberMe);

        userCookie.setMaxAge(expiry);
        passwordCookie.setMaxAge(expiry);
        rememberCookie.setMaxAge(expiry);

        userCookie.setHttpOnly(true);
        passwordCookie.setHttpOnly(true);
        rememberCookie.setHttpOnly(true);

        userCookie.setSecure(true);
        passwordCookie.setSecure(true);
        rememberCookie.setSecure(true);

        response.addCookie(userCookie);
        response.addCookie(passwordCookie);
        response.addCookie(rememberCookie);
    }

    /**
     * Set a secure, HTTP-only cookie with a specific expiration time.
     */
    public static void setCookie(HttpServletResponse response, String name, String value, int expiry) {
        try {
            if (value == null) {
                value = "";
            }
            // ✅ Trim spaces and URL encode the value to prevent invalid characters
            String encodedValue = URLEncoder.encode(value.trim(), StandardCharsets.UTF_8.toString());

            Cookie cookie = new Cookie(name, encodedValue);
            cookie.setMaxAge(expiry);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setSecure(true);
            response.addCookie(cookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Delete a cookie by setting its max age to 0.
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        response.addCookie(cookie);
    }
}
