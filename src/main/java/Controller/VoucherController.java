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
                String voucherID = request.getParameter("id");
                //System.out.println("Received voucherID: " + voucherID);
                //System.out.println("Query String: " + request.getQueryString());

                if (voucherID == null || voucherID.trim().isEmpty()) {
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }
                Voucher existingVoucher = voucherDAO.getOnlyById(voucherID);
                if (existingVoucher == null) {
                    request.getRequestDispatcher("View/ListVoucher.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("voucher", existingVoucher);
                request.getRequestDispatcher("View/EditVoucher.jsp").forward(request, response);
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

                //  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));

                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                // Create Voucher
                Voucher newVoucher = new Voucher(voucherCode, discountPer, discountAmount, minOrderValue, validFrom, validUntil, maxDiscountAmount);
                voucherDAO.create(newVoucher);

                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
            } catch (Exception e) {
                response.getWriter().println("Error when create voucher: " + e.getMessage());
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

                //  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDate validFrom = LocalDate.parse(request.getParameter("validFrom"));

                LocalDate validUntil = LocalDate.parse(request.getParameter("validUntil"));

                Voucher updatedVoucher = new Voucher(voucherID, voucherCode, discountPer, discountAmount, minOrderValue, validFrom, validUntil, maxDiscountAmount, true);
                voucherDAO.update(updatedVoucher);
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
            } catch (Exception e) {
                response.getWriter().println("Error when edit voucher: " + e.getMessage());
            }
            default:
                response.sendRedirect(request.getContextPath() + "/Voucher?action=list");
                break;
        }

    }

}