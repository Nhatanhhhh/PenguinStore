/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.VoucherDAO;
import Models.Voucher;
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

                // Kiểm tra discountPer phải từ 0 đến 100
                if (existingVoucher.getDiscountPer() < 0 || existingVoucher.getDiscountPer() > 100) {
                    request.setAttribute("errorMessage", "Discount Percentage must be between 0 - 100.");
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
                String voucherCode = request.getParameter("voucherCode");
                double discountPer = Double.parseDouble(request.getParameter("discountPer"));
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                double maxDiscountAmount = Double.parseDouble(request.getParameter("maxDiscountAmount"));
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                if (voucherCode == null || voucherCode.trim().isEmpty() || !voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Voucher Code cannot be blank or contain special characters.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (discountPer < 0 || discountPer > 100) {
                    request.setAttribute("errorMessage", "Discount Percentage must be between 0 - 100.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount Amount must be from 0 to 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (minOrderValue < 100000 || maxDiscountAmount < 0 || maxDiscountAmount > 200000) {
                    request.setAttribute("errorMessage", "Min Order Value must be >= 0 and Max Discount Amount must be between 0 and 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (maxDiscountAmount < discountAmount || maxDiscountAmount > discountAmount) {
                    request.setAttribute("errorMessage", "Discount Amount must be from 0 to 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid From cannot follow Valid Until.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                Voucher newVoucher = new Voucher(voucherCode, discountPer, discountAmount, minOrderValue, validFrom, validUntil, maxDiscountAmount);
                voucherDAO.create(newVoucher);

                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid input. Please check again.");
                request.getRequestDispatcher("Voucher?action=list").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Lỗi khi tạo voucher: " + e.getMessage());
                request.getRequestDispatcher("Voucher?action=list").forward(request, response);
            }
            break;

            case "edit":
    try {

                String voucherID = request.getParameter("voucherID");
                String voucherCode = request.getParameter("voucherCode");
                double discountPer = Double.parseDouble(request.getParameter("discountPer"));
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                double maxDiscountAmount = Double.parseDouble(request.getParameter("maxDiscountAmount"));

                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));
                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                if (voucherID == null || voucherID.trim().isEmpty()
                        || voucherCode == null || voucherCode.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Voucher ID and Voucher Code cannot be left blank.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (!voucherCode.matches("^[a-zA-Z0-9]+$")) {
                    request.setAttribute("errorMessage", "Voucher Code cannot be blank or contain special characters.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (discountPer < 0 || discountPer > 100) {
                    request.setAttribute("errorMessage", "Discount Percentage must be between 0 - 100.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (discountAmount < 0 || discountAmount > 200000) {
                    request.setAttribute("errorMessage", "Discount Amount must be from 0 to 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (minOrderValue < 0 || maxDiscountAmount < 0 || maxDiscountAmount > 200000) {
                    request.setAttribute("errorMessage", "Min Order Value must be >= 0 and Max Discount Amount must be between 0 and 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (maxDiscountAmount < discountAmount || maxDiscountAmount > discountAmount) {
                    request.setAttribute("errorMessage", "Discount Amount must be from 0 to 200000.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                if (validFrom.isAfter(validUntil)) {
                    request.setAttribute("errorMessage", "Valid From cannot follow Valid Until.");
                    request.getRequestDispatcher("Voucher?action=list").forward(request, response);
                    return;
                }

                Voucher updatedVoucher = new Voucher(voucherID, voucherCode, discountPer, discountAmount, minOrderValue, validFrom, validUntil, maxDiscountAmount, true);
                voucherDAO.update(updatedVoucher);
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid input. Please check again.");
                request.getRequestDispatcher("Voucher?action=list").forward(request, response);
            }
            break;

            case "send":
                String voucherID = request.getParameter("voucherID");
                String voucherSelection = request.getParameter("voucherSelection");

                Voucher voucher = voucherDAO.getOnlyById(voucherID);
                int checkStatus = voucherDAO.isStatusUsedVoucher(voucherID);
                LocalDate today = LocalDate.now();

                System.out.println("check: " + checkStatus);

                if (!voucherDAO.isVoucherSent(UUID.fromString(voucherID))
                        && checkStatus == 0) {
                    request.getRequestDispatcher("/Voucher?action=list").forward(request, response);
                } else {
                    if ("all".equals(voucherSelection)) {
                        voucherDAO.sendVoucherToAllCustomers(UUID.fromString(voucherID));
                        response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                    } else if ("withOrders".equals(voucherSelection)) {
                        voucherDAO.sendVoucherTo1OrderCustomers(UUID.fromString(voucherID));
                        response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                    }
                }

                break;
            default:
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
        }

    }

}
