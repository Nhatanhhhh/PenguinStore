package Controller;

import DAOs.CustomerDAO;
import DAOs.VoucherDAO;
import DTO.ShowCusVoucher;
import Models.Voucher;
import Service.EmailService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;
import java.util.UUID;

@WebServlet(name = "VoucherController", urlPatterns = {"/Voucher"})
public class VoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherDAO voucherDAO = new VoucherDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        if (Objects.isNull(action)) {
            action = "list";
        }
        switch (action) {
            case "list":
                ArrayList<Voucher> voucherList = voucherDAO.getAll();
                ArrayList<ShowCusVoucher> listCusVoucher = customerDAO.getListCusVoucher(); // Lấy danh sách khách hàng
                request.setAttribute("voucherList", voucherList);
                request.setAttribute("listCusVoucher", listCusVoucher); // Set danh sách khách hàng vào request
                request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                break;

            case "edit":
                try {
                String voucherID = request.getParameter("id");
                if (voucherID == null || voucherID.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Invalid voucher id.");
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }

                Voucher existingVoucher = voucherDAO.getOnlyById(voucherID);
                if (existingVoucher == null) {
                    request.setAttribute("errorMessage", "Voucher does not exist.");
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }

                if (existingVoucher.getDiscountAmount() < 0) {
                    request.setAttribute("errorMessage", "Discount Amount must be ≥ 0.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                request.setAttribute("voucher", existingVoucher);
                request.getRequestDispatcher("View/EditVoucher.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error editing voucher: " + e.getMessage());
                request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
            }
            break;

            case "create":
                request.getRequestDispatcher("View/CreateVoucher.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherDAO voucherDAO = new VoucherDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        if (Objects.isNull(action)) {
            action = "list";
        }

        switch (action) {
            case "list":
                ArrayList<Voucher> voucherList = voucherDAO.getAll();
                ArrayList<ShowCusVoucher> listCusVoucher = customerDAO.getListCusVoucher();
                request.setAttribute("voucherList", voucherList);
                request.setAttribute("listCusVoucher", listCusVoucher);
                request.getRequestDispatcher("/View/ListVoucher.jsp").forward(request, response);
                break;

            case "create":
                try {
                String voucherCode = request.getParameter("voucherCode").trim();
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                // Validation
                if (voucherCode.isEmpty() || !voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Invalid voucher code format.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (voucherDAO.isVoucherCodeExists(voucherCode)) {
                    request.setAttribute("errorMessage", "Voucher code already exists.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount must be 0-200,000₫.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (minOrderValue < 100000) {
                    request.setAttribute("errorMessage", "Min order value ≥100,000₫.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid dates are invalid.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                Voucher newVoucher = new Voucher(voucherCode, discountAmount, minOrderValue,
                        validFrom, validUntil);
                int result = voucherDAO.create(newVoucher);

                if (result > 0) {
                    request.setAttribute("successMessage", "Voucher created successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to create voucher.");
                }
                request.getRequestDispatcher("Voucher?action=list").forward(request, response);

            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error: " + e.getMessage());
                request.getRequestDispatcher("Voucher?action=create").forward(request, response);
            }
            break;

            case "edit":
                try {
                String voucherID = request.getParameter("voucherID");
                String voucherCode = request.getParameter("voucherCode").trim();
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));
                boolean voucherStatus = Boolean.parseBoolean(request.getParameter("voucherStatus"));

                // Validation
                if (voucherID == null || voucherID.trim().isEmpty()
                        || voucherCode == null || voucherCode.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Required fields are missing.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (!voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Invalid voucher code format.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (voucherDAO.isVoucherCodeExistsForUpdate(voucherCode, voucherID)) {
                    request.setAttribute("errorMessage", "Voucher code already exists.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount must be 0-200,000₫.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (minOrderValue < 0) {
                    request.setAttribute("errorMessage", "Min order value must be ≥0.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid dates are invalid.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                Voucher updatedVoucher = new Voucher(voucherID, voucherCode, discountAmount,
                        minOrderValue, validFrom, validUntil, voucherStatus);
                int result = voucherDAO.update(updatedVoucher);

                if (result > 0) {
                    request.setAttribute("successMessage", "Voucher updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                } else {
                    request.setAttribute("errorMessage", "Failed to update voucher.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                }

            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error: " + e.getMessage());
                request.getRequestDispatcher("Voucher?action=edit&id=" + request.getParameter("voucherID")).forward(request, response);
            }
            break;

            case "send":
                try {
                String voucherID = request.getParameter("voucherID");
                String voucherSelection = request.getParameter("voucherSelection");

                Voucher voucher = voucherDAO.getOnlyById(voucherID);
                if (voucher == null) {
                    request.setAttribute("errorMessage", "Voucher not found.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                if (voucher.getValidUntil().isBefore(LocalDate.now())) {
                    request.setAttribute("errorMessage", "Voucher has expired.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                EmailService emailService = new EmailService();
                ArrayList<String> customerEmails;

                if ("all".equals(voucherSelection)) {
                    customerEmails = voucherDAO.getAllCustomerEmails();
                } else {
                    String[] selectedCustomers = request.getParameterValues("selectedCustomers");
                    customerEmails = new ArrayList<>();
                    if (selectedCustomers != null) {
                        customerEmails.addAll(Arrays.asList(selectedCustomers));
                    }
                }

                if (customerEmails.isEmpty()) {
                    request.setAttribute("errorMessage", "No customers selected.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                int successCount = 0;
                ArrayList<String> failedEmails = new ArrayList<>();
                ArrayList<String> alreadySentEmails = new ArrayList<>();

                UUID voucherUUID = UUID.fromString(voucherID);

                for (String email : customerEmails) {
                    // Kiểm tra xem voucher đã được gửi cho email này chưa
                    if (voucherDAO.isVoucherSentToCustomer(voucherUUID, email)) {
                        alreadySentEmails.add(email);
                        continue;
                    }

                    // Gửi email
                    boolean isSent = emailService.sendVoucherEmail(
                            email,
                            voucher.getVoucherCode(),
                            voucher.getDiscountAmount(),
                            voucher.getMinOrderValue(),
                            voucher.getValidFrom(),
                            voucher.getValidUntil()
                    );

                    if (isSent) {
                        // Lưu vào bảng UsedVoucher
                        boolean isSaved = voucherDAO.insertUsedVoucher(voucherUUID, email);
                        if (isSaved) {
                            successCount++;
                        } else {
                            failedEmails.add(email + " (Failed to save to UsedVoucher)");
                        }
                    } else {
                        failedEmails.add(email + " (Failed to send email)");
                    }
                }

                // Thiết lập thông báo
                if (successCount > 0) {
                    request.setAttribute("successMessage", "Sent to " + successCount + " customers successfully.");
                }
                StringBuilder errorMessage = new StringBuilder();
                if (!failedEmails.isEmpty()) {
                    errorMessage.append("Failed to send to ").append(failedEmails.size()).append(" customers: ").append(failedEmails.toString()).append(". ");
                }
                if (!alreadySentEmails.isEmpty()) {
                    errorMessage.append("Voucher already sent to ").append(alreadySentEmails.size()).append(" customers: ").append(alreadySentEmails.toString()).append(".");
                }
                if (errorMessage.length() > 0) {
                    request.setAttribute("errorMessage", errorMessage.toString());
                }

                request.getRequestDispatcher("/Voucher?action=list").forward(request, response);

            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error sending vouchers: " + e.getMessage());
                request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
            }
            break;

            default:
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
        }
    }
}
