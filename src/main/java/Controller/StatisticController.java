/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.OrderStatisticDAO;
import DAOs.OrderStatusStatisticDAO;
import DAOs.RevenueDAO;
import DAOs.StatisticProductDAO;
import Models.OrderStatistic;
import Models.OrderStatusStatistic;
import Models.RevenueStatistic;
import Models.StatisticProduct;
import Models.TopOrderCustomer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        OrderStatusStatisticDAO orderStatusStatisticDAO = new OrderStatusStatisticDAO();

        String action = request.getParameter("action");
        String timeUnit = request.getParameter("timeUnit");

        if (action == null || action.isEmpty()) {
            action = "orderStatistic"; // Default action
        }

        if (timeUnit == null || (!timeUnit.equals("day") && !timeUnit.equals("month") && !timeUnit.equals("year"))) {
            timeUnit = "day"; // Default to daily statistics
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
                switch (timeUnit) {
                    case "month":
                        revenuelist = revenueDAO.getRevenueByMonth();
                        break;
                    case "year":
                        revenuelist = revenueDAO.getRevenueByYear();
                        break;
                    default:
                        revenuelist = revenueDAO.getRevenueByDay();
                        break;
                }
                request.setAttribute("revenuelist", revenuelist);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/RevenueStatistic.jsp").forward(request, response);
                break;

            case "orderStatusStatistic":

                List<OrderStatusStatistic> orderstatusList = switch (timeUnit) {
                    case "month" ->
                        orderStatusStatisticDAO.getLastMonth();
                    case "year" ->
                        orderStatusStatisticDAO.getLastYearToNow();
                    default ->
                        orderStatusStatisticDAO.getByDay();
                };

                orderstatusList.forEach(System.out::println); // Debug log

                List<TopOrderCustomer> topCustomers = orderStatusStatisticDAO.getTopCustomersByOrderType();

                request.setAttribute("topCustomersCompleted", extractEmails(topCustomers, "Delivery successful"));
                request.setAttribute("topCustomersFailed", extractEmails(topCustomers, "Delivery failed"));
                request.setAttribute("topCustomersCanceled", extractEmails(topCustomers, "Cancel order"));

                request.setAttribute("statistics", orderstatusList);
                request.setAttribute("timeUnit", timeUnit);
                request.setAttribute("topCustomers", topCustomers);

                request.getRequestDispatcher("/View/ViewOrderStatusStatistic.jsp").forward(request, response);
                break;

            case "productStatistic":
                List<StatisticProduct> productStatistics = productDAO.getAll(); // Thống kê nhập - xuất
                List<StatisticProduct> bestSellingProducts = productDAO.getBestSellingProducts(); // Sản phẩm bán chạy nhất

                request.setAttribute("productStatistics", productStatistics);
                request.setAttribute("bestSellingProducts", bestSellingProducts);

                request.getRequestDispatcher("/View/ProductStatistic.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Statistic?action=orderStatistic&timeUnit=day");
                break;
        }
    }

    private List<String> extractEmails(List<TopOrderCustomer> customers, String status) {
        return customers.stream()
                .filter(c -> c.getStatusName().equals(status))
                .map(TopOrderCustomer::getEmail)
                .toList();
    }

}
