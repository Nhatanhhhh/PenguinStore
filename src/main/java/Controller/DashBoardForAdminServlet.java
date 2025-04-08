/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAOs.OrderStatisticDAO;
import DAOs.RevenueDAO;
import DAOs.RestockDAO;
import DAOs.StatisticProductDAO;
import Models.OrderStatistic;
import Models.RevenueStatistic;
import Models.StatisticProduct;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class DashBoardForAdminServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderStatisticDAO dao = new OrderStatisticDAO();
        RevenueDAO revenueDAO = new RevenueDAO();
        StatisticProductDAO productDAO = new StatisticProductDAO();
        RestockDAO restockDAO = new RestockDAO();
        String timeUnit = request.getParameter("timeUnit");

        if (timeUnit == null || (!timeUnit.equals("day") && !timeUnit.equals("month") && !timeUnit.equals("year"))) {
            timeUnit = "day"; // Default to daily statistics
        }
        int todayOrders = dao.getTodayOrderCount();
        request.setAttribute("todayOrders", todayOrders);

        double todayRevenue = revenueDAO.getWeeklyRevenue();
        request.setAttribute("todayRevenue", todayRevenue);

        int todayRestockQuantity = restockDAO.getTodayRestockQuantity();
        request.setAttribute("todayRestockQuantity", todayRestockQuantity);

        ArrayList<StatisticProduct> weeklySales = productDAO.getWeeklySales();
        request.setAttribute("weeklySales", weeklySales);

        request.getRequestDispatcher("/View/DashBoardForAdmin.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}