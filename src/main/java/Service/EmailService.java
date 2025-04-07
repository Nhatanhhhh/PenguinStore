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
import java.time.LocalDate;
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
    private static final String COMPANY_NAME = "Penguin Store";
    private static final String PRIMARY_COLOR = "#2a5885";
    private static final String SECONDARY_COLOR = "#e44d26";

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

    public boolean sendInvoiceEmail(String toEmail, String orderID, List<CartItem> cartItems, double subtotal, double discount, double total) throws UnsupportedEncodingException {
        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "Penguin Store comfirm Order", "UTF-8"));
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
                        .append("<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>").append(String.format("%,.0f", item.getPrice() * item.getQuantity())).append(" ₫</td>")
                        .append("</tr>");
            }

            emailContent.append("</table>")
                    .append("<hr style='border: 1px solid #ddd;'>")
                    .append("<p><strong>Subtotal:</strong> ").append(String.format("%,.0f", subtotal)).append(" ₫</p>")
                    .append("<p><strong>Discount:</strong> -").append(String.format("%,.0f", discount)).append(" ₫</p>")
                    .append("<p><strong style='font-size: 18px;'>Total:</strong> <span style='color: #E44D26; font-size: 18px;'>").append(String.format("%,.0f", total)).append(" ₫</span></p>")
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

    public boolean sendVoucherEmail(String recipientEmail, String voucherCode,
            double discountAmount, double minOrderValue, LocalDate validFrom,
            LocalDate validUntil) {
        String subject = "🎁 Your Exclusive Discount Voucher from " + COMPANY_NAME + "!";

        String voucherDetails = "<div style='background:#f8f9fa;padding:15px;border-radius:5px;margin-bottom:20px;'>"
                + "<h3 style='color:" + PRIMARY_COLOR + ";margin-top:0;'>Voucher Code: "
                + "<span style='color:" + SECONDARY_COLOR + ";'>" + voucherCode + "</span></h3>"
                + "<ul style='list-style-type:none;padding:0;margin:0;'>"
                + "<li style='margin-bottom:8px;'><strong>Discount Amount:</strong> " + formatCurrency(discountAmount) + "</li>"
                + "<li style='margin-bottom:8px;'><strong>Minimum Order:</strong> " + formatCurrency(minOrderValue) + "</li>"
                + "<li style='margin-bottom:8px;'><strong>Valid From:</strong> " + validFrom.toString() + "</li>"
                + "<li><strong>Valid Until:</strong> " + validUntil.toString() + "</li>"
                + "</ul></div>";

        String content = buildEmailTemplate(
                "Discount Voucher",
                "<h2 style='color:" + PRIMARY_COLOR + ";'>🎉 Congratulations!</h2>"
                + "<p>You've received an exclusive discount voucher from " + COMPANY_NAME + "!</p>"
                + voucherDetails
                + "<p style='text-align:center;'>"
                + "<a href='https://yourstore.com' style='background:" + SECONDARY_COLOR + ";color:white;"
                + "padding:10px 20px;text-decoration:none;border-radius:5px;display:inline-block;'>"
                + "Shop Now</a></p>"
        );

        return sendEmail(recipientEmail, subject, content);
    }

    private String buildEmailTemplate(String title, String bodyContent) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }"
                + ".container { max-width: 600px; margin: 0 auto; padding: 20px; }"
                + ".header { background: " + PRIMARY_COLOR + "; padding: 20px; text-align: center; }"
                + ".header h1 { color: white; margin: 0; }"
                + ".content { padding: 20px; }"
                + ".footer { text-align: center; padding: 20px; font-size: 12px; color: #777; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'>"
                + "<h1>" + COMPANY_NAME + "</h1>"
                + "</div>"
                + "<div class='content'>"
                + "<h2 style='color: " + PRIMARY_COLOR + "; margin-top: 0;'>" + title + "</h2>"
                + bodyContent
                + "</div>"
                + "<div class='footer'>"
                + "<p>© " + LocalDate.now().getYear() + " " + COMPANY_NAME + ". All rights reserved.</p>"
                + "<p>If you have any questions, contact us at support@yourstore.com</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }

    private boolean sendEmail(String recipientEmail, String subject, String content) {
        try {
            Session session = getSession();
            MimeMessage message = new MimeMessage(session);

            message.setFrom(new InternetAddress(SENDER_EMAIL, COMPANY_NAME, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.log(Level.INFO, "Email sent to: {0}", recipientEmail);
            return true;
        } catch (MessagingException | UnsupportedEncodingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send email to {0}: {1}",
                    new Object[]{recipientEmail, e.getMessage()});
            return false;
        }
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
}
