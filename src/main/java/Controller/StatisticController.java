/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.OrderStatisticDAO;
import DAOs.RevenueDAO;
import Models.OrderStatistic;
import Models.RevenueStatistic;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Do Van Luan - CE180457
 */
@WebServlet(name = "StatisticController", urlPatterns = {"/Statistic"})
public class StatisticController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderStatisticDAO dao = new OrderStatisticDAO();
        RevenueDAO revenueDAO = new RevenueDAO();

        // Đảm bảo action không bị null, nếu null thì mặc định là "orderStatistic"
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "orderStatistic";
        }

        // Đảm bảo timeUnit không bị null, nếu null thì mặc định là "day"
        String timeUnit = request.getParameter("timeUnit");
        if (timeUnit == null || timeUnit.isEmpty()) {
            timeUnit = "day";
        }

        switch (action) {
            case "orderStatistic":
                List<OrderStatistic> statistics;
                if ("month".equals(timeUnit)) {
                    statistics = dao.getOrderStatisticsByMonth();
                } else {
                    statistics = dao.getOrderStatisticsByDay();
                }
                request.setAttribute("statistics", statistics);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/ViewOStatistic.jsp").forward(request, response);
                break;

            case "revenueStatistic":
                List<RevenueStatistic> revenuelist;
                if ("month".equals(timeUnit)) {
                    revenuelist = revenueDAO.getRevenueByMonth();
                } else if ("year".equals(timeUnit)) {
                    revenuelist = revenueDAO.getRevenueByYear();
                } else {
                    revenuelist = revenueDAO.getRevenueByDay();
                }

                request.setAttribute("revenuelist", revenuelist);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/RevenueStatistic.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Statistic?action=orderStatistic&timeUnit=day");
                break;
        }
    }

}
