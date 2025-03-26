/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import Models.CartItem;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final String SENDER_EMAIL = "swp391gr4@gmail.com";  // Dùng biến môi trường thay vì hardcode
    private static final String SENDER_PASSWORD = "fwsg wyht jzyi ybcc"; // Dùng phương thức bảo mật hơn

    private Session getSession() {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.mime.charset", "UTF-8");

        return Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
    }

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

    public boolean sendInvoiceEmail(String toEmail, String orderID, List<CartItem> cartItems, double subtotal, double discount, double total) {
        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            String shortOrderID = orderID.substring(0, 4).toUpperCase();
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Order Confirmation - Order ID: " + shortOrderID);

            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>")
                    .append("<div style='text-align: center;'>")
                    .append("<h2 style='color: #4CAF50;'>Thank You for Your Purchase! 🎉</h2>")
                    .append("<p style='font-size: 16px;'>Your order has been confirmed. Below are your order details:</p>")
                    .append("</div>")
                    .append("<hr style='border: 1px solid #ddd;'>")
                    .append("<p><strong>Order ID:</strong> ").append(shortOrderID).append("</p>")
                    .append("<table style='width: 100%; border-collapse: collapse; margin-top: 15px;'>")
                    .append("<tr style='background-color: #f2f2f2;'>")
                    .append("<th style='padding: 10px; border: 1px solid #ddd;'>Product</th>")
                    .append("<th style='padding: 10px; border: 1px solid #ddd;'>Size</th>")
                    .append("<th style='padding: 10px; border: 1px solid #ddd;'>Color</th>")
                    .append("<th style='padding: 10px; border: 1px solid #ddd;'>Quantity</th>")
                    .append("<th style='padding: 10px; border: 1px solid #ddd;'>Price</th>")
                    .append("</tr>");

            for (CartItem item : cartItems) {
                emailContent.append("<tr>")
                        .append("<td style='padding: 10px; border: 1px solid #ddd;'>").append(item.getProductName()).append("</td>")
                        .append("<td style='padding: 10px; border: 1px solid #ddd;'>").append(item.getSizeName()).append("</td>")
                        .append("<td style='padding: 10px; border: 1px solid #ddd;'>").append(item.getColorName()).append("</td>")
                        .append("<td style='padding: 10px; border: 1px solid #ddd; text-align: center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>").append(String.format("%,.2f", item.getPrice() * item.getQuantity())).append(" ₫</td>")
                        .append("</tr>");
            }

            emailContent.append("</table>")
                    .append("<hr style='border: 1px solid #ddd;'>")
                    .append("<p><strong>Subtotal:</strong> ").append(String.format("%,.2f", subtotal)).append(" ₫</p>")
                    .append("<p><strong>Discount:</strong> -").append(String.format("%,.2f", discount)).append(" ₫</p>")
                    .append("<p><strong style='font-size: 18px;'>Total:</strong> <span style='color: #E44D26; font-size: 18px;'>").append(String.format("%,.2f", total)).append(" ₫</span></p>")
                    .append("<hr style='border: 1px solid #ddd;'>")
                    .append("<div style='text-align: center;'>")
                    .append("<p>📦 Your order will be shipped soon. Stay tuned!</p>")
                    .append("<p style='color: #777;'>If you have any questions, contact us at <a href='mailto:swp391gr4@gmail.com?subject=Feedback%20for%20order%20" + shortOrderID + "'>swp391gr4@gmail.com</a>.</p>")
                    .append("</div>")
                    .append("</div>");

            message.setContent(emailContent.toString(), "text/html; charset=utf-8");

            Transport.send(message);
            LOGGER.log(Level.INFO, "Invoice email sent successfully to: {0}", toEmail);
            return true;
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send invoice email to {0}: {1}", new Object[]{toEmail, e.getMessage()});
            return false;
        }
    }
}