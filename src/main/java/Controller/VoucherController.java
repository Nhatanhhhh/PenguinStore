/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.VoucherDAO;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Objects;
import java.util.UUID;

/**
 *
 * @author Do Van Luan - CE180457
 */
@WebServlet(name = "VoucherController", urlPatterns = {"/Voucher"})
public class VoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        VoucherDAO voucherDAO = new VoucherDAO();

        if (Objects.isNull(action)) {
            action = "list"; // Default to listing types
        }
        switch (action) {
            case "list":
                ArrayList<Voucher> voucherList = voucherDAO.getAll();
                request.setAttribute("voucherList", voucherList);
                request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                break;

            case "edit":
    try {
                String voucherID = request.getParameter("id");

                // Kiểm tra voucherID có hợp lệ không
                if (voucherID == null || voucherID.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Invalid voucher id.");
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }

                // Lấy voucher từ database
                Voucher existingVoucher = voucherDAO.getOnlyById(voucherID);

                // Kiểm tra nếu voucher không tồn tại
                if (existingVoucher == null) {
                    request.setAttribute("errorMessage", "Voucher does not exist.");
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }

                // Kiểm tra discountAmount phải >= 0
                if (existingVoucher.getDiscountAmount() < 0) {
                    request.setAttribute("errorMessage", "Discount Amount must be greater than or equal to 0.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                // Chuyển đến trang chỉnh sửa với dữ liệu voucher
                request.setAttribute("voucher", existingVoucher);
                request.getRequestDispatcher("View/EditVoucher.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error when editing voucher: " + e.getMessage());
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

        if (Objects.isNull(action)) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                ArrayList<Voucher> voucherList = voucherDAO.getAll();
                request.setAttribute("voucherList", voucherList);
                request.getRequestDispatcher("/View/ListVoucher.jsp").forward(request, response);
                break;

            case "create":
    try {
                String voucherCode = request.getParameter("voucherCode").trim();
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                if (voucherCode.isEmpty() || !voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Voucher Code cannot be blank or contain special characters.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (voucherDAO.isVoucherCodeExists(voucherCode)) {
                    request.setAttribute("errorMessage", "Voucher Code already exists. Please choose another one.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount Amount must be between 0 and 200000.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (minOrderValue < 100000) {
                    request.setAttribute("errorMessage", "Minimum Order Value must be >= 100000.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid From cannot be after Valid Until.");
                    request.getRequestDispatcher("Voucher?action=create").forward(request, response);
                    return;
                }

                // Tạo voucher mới
                Voucher newVoucher = new Voucher(voucherCode, discountAmount, minOrderValue, validFrom, validUntil);
                int result = voucherDAO.create(newVoucher);

                if (result > 0) {
                    request.setAttribute("successMessage", "Voucher created successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to create voucher. Please try again.");
                }

                request.getRequestDispatcher("Voucher?action=list").forward(request, response);

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid input. Please check again.");
                request.getRequestDispatcher("Voucher?action=create").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error creating voucher: " + e.getMessage());
                request.getRequestDispatcher("Voucher?action=create").forward(request, response);
            }
            break;

            case "checkDuplicate":
                String codeToCheck = request.getParameter("voucherCode");
                boolean exists = voucherDAO.isVoucherCodeExists(codeToCheck);
                response.getWriter().write(exists ? "exists" : "available");
                break;

            case "edit":
    try {
                String voucherID = request.getParameter("voucherID");
                String voucherCode = request.getParameter("voucherCode").trim();

                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));

                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                
                if (voucherID == null || voucherID.trim().isEmpty()
                        || voucherCode == null || voucherCode.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Voucher ID and Voucher Code cannot be left blank.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (!voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Voucher Code cannot contain special characters.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount Amount must be from 0 to 200000.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (minOrderValue < 0) {
                    request.setAttribute("errorMessage", "Min Order Value must be >= 0.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid From cannot follow Valid Until.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                
                if (voucherDAO.isVoucherCodeExistsForUpdate(voucherCode, voucherID)) {
                    request.setAttribute("errorMessage", "Voucher Code already exists. Please choose another one.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                    return;
                }

                
                Voucher updatedVoucher = new Voucher(voucherID, voucherCode, discountAmount, minOrderValue, validFrom, validUntil, true);
                int result = voucherDAO.update(updatedVoucher);

                if (result > 0) {
                    
                    request.setAttribute("successMessage", "Voucher updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                } else {
                    
                    request.setAttribute("errorMessage", "Failed to update voucher. Please try again.");
                    request.getRequestDispatcher("Voucher?action=edit&id=" + voucherID).forward(request, response);
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid input. Please check again.");
                request.getRequestDispatcher("Voucher?action=edit&id=" + request.getParameter("voucherID")).forward(request, response);
            }
            break;

            case "send":
    try {
                String voucherID = request.getParameter("voucherID");
                String voucherSelection = request.getParameter("voucherSelection");

                Voucher voucher = voucherDAO.getOnlyById(voucherID);
                if (voucher == null) {
                    request.setAttribute("errorMessage", "Voucher không tồn tại.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                // Kiểm tra voucher có còn hiệu lực không
                LocalDate today = LocalDate.now();
                if (voucher.getValidUntil().isBefore(today)) {
                    request.setAttribute("errorMessage", "Voucher đã hết hạn.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                EmailService emailService = new EmailService();
                ArrayList<String> customerEmails;

                if ("all".equals(voucherSelection)) {
                    customerEmails = voucherDAO.getAllCustomerEmails();
                } else if ("withOrders".equals(voucherSelection)) {
                    customerEmails = voucherDAO.getCustomersWithOrders();
                } else {
                    request.setAttribute("errorMessage", "Lựa chọn không hợp lệ.");
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                    return;
                }

                int successCount = 0;
                int failedCount = 0;
                ArrayList<String> failedEmails = new ArrayList<>();

                for (String email : customerEmails) {
                    boolean isSent = emailService.sendVoucherEmail(
                            email,
                            voucher.getVoucherCode(),
                            voucher.getDiscountAmount(),
                            voucher.getMinOrderValue()
                    );

                    if (isSent) {
                        // Insert voucher vào bảng UsedVoucher
                        boolean isInserted = voucherDAO.insertUsedVoucher(UUID.fromString(voucherID), email);
                        if (isInserted) {
                            successCount++;
                        } else {
                            failedCount++;
                            failedEmails.add(email);
                        }
                    } else {
                        failedCount++;
                        failedEmails.add(email);
                    }
                }

                request.setAttribute("successMessage", "Đã gửi voucher đến " + successCount + " khách hàng thành công.");
                if (failedCount > 0) {
                    request.setAttribute("errorMessage", "Không thể gửi voucher đến " + failedCount + " khách hàng: " + String.join(", ", failedEmails));
                }
                request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Lỗi khi gửi voucher: " + e.getMessage());
                request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
            }
            break;

            default:
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
        }

    }

}
