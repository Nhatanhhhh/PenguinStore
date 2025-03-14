/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.RevenueStatistic;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBContext;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class RevenueDAO extends DBContext {

    // Lấy doanh thu theo ngày
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

    // Lấy doanh thu theo tháng
    public List<RevenueStatistic> getRevenueByMonth() {
        List<RevenueStatistic> list = new ArrayList<>();
        String query = "SELECT MONTH(O.orderDate) AS OrderMonth, SUM(O.totalAmount) AS Revenue "
                + "FROM dbo.[Order] O "
                + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                + "WHERE S.statusName = 'Delivery successful' "
                + "GROUP BY MONTH(O.orderDate)";

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
}
