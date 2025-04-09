/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Controller.StatisticController;
import Models.RevenueStatistic;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBContext;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class RevenueDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(StatisticController.class.getName());

    public List<RevenueStatistic> getRevenueByDay() {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT CAST(O.orderDate AS DATE) AS OrderDate, SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "GROUP BY CAST(O.orderDate AS DATE) "
                + "ORDER BY OrderDate";

        try ( ResultSet rs = execSelectQuery(query)) {

            while (rs.next()) {
                list.add(new RevenueStatistic(rs.getString("OrderDate"), rs.getDouble("Revenue")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RevenueStatistic> getRevenueLastWeek() {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT CAST(O.orderDate AS DATE) AS OrderDate, SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "AND O.orderDate >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) " // Lấy 7 ngày gần nhất
                + "GROUP BY CAST(O.orderDate AS DATE) "
                + "ORDER BY OrderDate";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                list.add(new RevenueStatistic(rs.getString("OrderDate"), rs.getDouble("Revenue")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy doanh thu theo tháng
    public List<RevenueStatistic> getRevenueByMonth() {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT MONTH(O.orderDate) AS OrderMonth, COALESCE(SUM(O.totalAmount), 0) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "AND YEAR(O.orderDate) = YEAR(GETDATE()) " // Chỉ lấy dữ liệu trong năm hiện tại
                + "GROUP BY MONTH(O.orderDate) "
                + "ORDER BY OrderMonth ASC"; // Sắp xếp theo tháng tăng dần

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                list.add(new RevenueStatistic("Month " + rs.getInt("OrderMonth"), rs.getDouble("Revenue")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy doanh thu theo năm
    public List<RevenueStatistic> getRevenueByYear() {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT YEAR(O.orderDate) AS OrderYear, SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "GROUP BY YEAR(O.orderDate)";

        try ( ResultSet rs = execSelectQuery(query)) {

            while (rs.next()) {
                list.add(new RevenueStatistic("Year " + rs.getInt("OrderYear"), rs.getDouble("Revenue")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getWeeklyRevenue() {
        double totalRevenue = 0;
        String query = "SELECT SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "AND DATEPART(WEEK, O.orderDate) = DATEPART(WEEK, GETDATE()) "
                + "AND YEAR(O.orderDate) = YEAR(GETDATE())"; // Đảm bảo đúng năm

        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                totalRevenue = rs.getDouble("Revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalRevenue;
    }

    public List<RevenueStatistic> getRevenueByCustomRange(String startDate, String endDate) {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT CAST(O.orderDate AS DATE) AS OrderDate, SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "AND O.orderDate BETWEEN ? AND ? "
                + "GROUP BY CAST(O.orderDate AS DATE) "
                + "ORDER BY OrderDate";

        try ( Connection conn = getConn();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);

            System.out.println("[DEBUG] SQL Query: " + query);
            System.out.println("[DEBUG] Parameters - Start: " + startDate + ", End: " + endDate);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Date orderDate = rs.getDate("OrderDate");
                    String formattedDate = new SimpleDateFormat("yyyy-MM-dd").format(orderDate);
                    double revenue = rs.getDouble("Revenue");

                    // Debug từng dòng dữ liệu lấy được
                    System.out.println("[DEBUG] Fetching -> Time: " + formattedDate + ", Revenue: " + revenue);

                    // Chỉ thêm một lần
                    list.add(new RevenueStatistic(formattedDate, revenue));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("[DEBUG] Total revenue records fetched: " + list.size());
        return list;
    }

    public List<RevenueStatistic> getRevenueStatistic(String timeUnit) {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "";

        switch (timeUnit) {
            case "day":
                query = "SELECT CAST(O.orderDate AS DATE) AS timePeriod, "
                        + "SUM(O.totalAmount) AS revenue "
                        + "FROM dbo.[Order] O "
                        + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                        + "WHERE S.statusName = 'Delivery successful' "
                        + "GROUP BY CAST(O.orderDate AS DATE) "
                        + "ORDER BY timePeriod";
                break;

            case "month":
                query = "SELECT FORMAT(O.orderDate, 'yyyy-MM') AS timePeriod, "
                        + "SUM(O.totalAmount) AS revenue "
                        + "FROM dbo.[Order] O "
                        + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                        + "WHERE S.statusName = 'Delivery successful' "
                        + "GROUP BY FORMAT(O.orderDate, 'yyyy-MM') "
                        + "ORDER BY timePeriod";
                break;

            case "year":
                query = "SELECT YEAR(O.orderDate) AS timePeriod, "
                        + "SUM(O.totalAmount) AS revenue "
                        + "FROM dbo.[Order] O "
                        + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                        + "WHERE S.statusName = 'Delivery successful' "
                        + "GROUP BY YEAR(O.orderDate) "
                        + "ORDER BY timePeriod";
                break;

            default:
                throw new IllegalArgumentException("Invalid time unit: " + timeUnit);
        }

        try ( Connection conn = DBContext.getConn();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String timePeriod = rs.getString("timePeriod");
                double revenue = rs.getDouble("revenue");
                list.add(new RevenueStatistic(timePeriod, revenue));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting revenue statistics", e);
            throw new RuntimeException("Database error", e);
        }

        return list;
    }
}
