/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    private static final String SENDER_EMAIL = "swp391gr4@gmail.com";  // Use environment variables for security
    private static final String SENDER_PASSWORD = "fwsg wyht jzyi ybcc";  // Replace this with a secure method!

    /**
     * Sends a verification email to the user.
     *
     * @param recipientEmail The recipient's email address.
     * @param verificationCode The verification code to be sent.
     * @return true if email is sent successfully, false otherwise.
     */
    public boolean sendVerificationEmail(String recipientEmail, String verificationCode) throws UnsupportedEncodingException {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.mime.charset", "UTF-8");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "Penguin Store", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Your PenguinStore Verification Code", "UTF-8");

            // HTML Email Body
            String emailContent = "<html><body>"
                    + "<h2>Hello,</h2>"
                    + "<p>Please verify your account using the following code:</p>"
                    + "<h3 style='color:blue;'>" + verificationCode + "</h3>"
                    + "<p>If you did not request this, please ignore this email.</p>"
                    + "<br><p>Best regards,<br><strong>Penguin Store Team</strong></p>"
                    + "</body></html>";

            message.setContent(emailContent, "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.log(Level.INFO, "Verification email sent successfully to: {0}", recipientEmail);
            return true;
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send verification email to {0}: {1}", new Object[]{recipientEmail, e.getMessage()});
            return false;
        }
    }
}
