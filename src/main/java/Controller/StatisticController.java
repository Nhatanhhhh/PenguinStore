/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.OrderStatisticDAO;
import DAOs.ProductDAO;
import DAOs.RevenueDAO;
import DAOs.StatisticProductDAO;
import Models.OrderStatistic;
import Models.Product;
import Models.RevenueStatistic;
import Models.StatisticProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
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
        StatisticProductDAO productDAO = new StatisticProductDAO();
        ProductDAO pronameDAO = new ProductDAO();

        String action = request.getParameter("action");
        String timeUnit = request.getParameter("timeUnit");

        if (action == null || action.isEmpty()) {
            action = "orderStatistic"; // Default action
        }

        if (timeUnit == null || (!timeUnit.equals("day") && !timeUnit.equals("month") && !timeUnit.equals("year") && !timeUnit.equals("week") && (!timeUnit.equals("custom")))) {
            timeUnit = "day";
        }

        switch (action) {
            case "orderStatistic":
                List<OrderStatistic> statistics;
                if ("month".equals(timeUnit)) {
                    statistics = dao.getOrderStatisticsByMonth();
                } else if ("year".equals(timeUnit)) {
                    statistics = dao.getOrderStatisticsByYear();
                } else {
                    statistics = dao.getOrderStatisticsByDay();
                }
                request.setAttribute("statistics", statistics);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/ViewOStatistic.jsp").forward(request, response);
                break;

            case "revenueStatistic":
                List<RevenueStatistic> revenueList;
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");

                switch (timeUnit) {
                    case "day":
                        revenueList = revenueDAO.getRevenueByDay();

                        break;
                    case "month":
                        revenueList = revenueDAO.getRevenueByMonth();

                        break;
                    case "year":
                        revenueList = revenueDAO.getRevenueByYear();

                        break;
                    case "week":
                        revenueList = revenueDAO.getRevenueLastWeek();

                        break;
                    case "custom":
                        // Kiểm tra nếu startDate hoặc endDate bị null
                        if (startDate == null || startDate.isEmpty()) {
                            startDate = "2025-01-01"; // Ngày mặc định
                        }
                        if (endDate == null || endDate.isEmpty()) {
                            endDate = LocalDate.now().toString(); // Lấy ngày hiện tại
                        }
                        revenueList = revenueDAO.getRevenueByCustomRange(startDate, endDate);
                        break;
                    default:
                        revenueList = revenueDAO.getRevenueLastWeek();
                        break;
                }

                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("revenuelist", revenueList);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/RevenueStatistic.jsp").forward(request, response);
                break;

            case "productStatistic":
                List<StatisticProduct> productStatistics = productDAO.getAll();
                List<StatisticProduct> bestSellingProducts = productDAO.getBestSellingProducts();
                ArrayList<Product> productList = pronameDAO.readAll();
                request.setAttribute("productList", productList);
                request.setAttribute("productStatistics", productStatistics);
                request.setAttribute("bestSellingProducts", bestSellingProducts);

                request.getRequestDispatcher("/View/ProductStatistic.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Statistic?action=orderStatistic&timeUnit=day");
                break;
        }
    }
}
