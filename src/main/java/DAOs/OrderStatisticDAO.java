package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Models.OrderStatistic;
import DB.DBContext;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class OrderStatisticDAO extends DBContext {

    public List<OrderStatistic> getOrderStatisticsByDay() {
        List<OrderStatistic> list = new ArrayList<>();
        String sql = "SELECT CONVERT(DATE, orderDate) AS orderDate, COUNT(*) AS orderCount "
                + "FROM [Order] "
                + "GROUP BY CONVERT(DATE, orderDate) "
                + "ORDER BY orderDate";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                list.add(new OrderStatistic(rs.getString("orderDate"), rs.getInt("orderCount")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderStatistic> getOrderStatisticsByMonth() {
        List<OrderStatistic> list = new ArrayList<>();
        String sql = "SELECT FORMAT(orderDate, 'yyyy-MM') AS orderMonth, COUNT(*) AS orderCount "
                + "FROM [Order] "
                + "GROUP BY FORMAT(orderDate, 'yyyy-MM') "
                + "ORDER BY orderMonth";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                list.add(new OrderStatistic(rs.getString("orderMonth"), rs.getInt("orderCount")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderStatistic> getOrderStatisticsByYear() {
        List<OrderStatistic> list = new ArrayList<>();
        String sql = "SELECT YEAR(orderDate) AS orderYear, COUNT(*) AS orderCount "
                + "FROM [Order] "
                + "GROUP BY YEAR(orderDate) "
                + "ORDER BY orderYear";

        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                list.add(new OrderStatistic(rs.getString("orderYear"), rs.getInt("orderCount")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTodayOrderCount() {
        int totalOrders = 0;
        String sql = "SELECT COUNT(*) AS orderCount FROM [Order] WHERE CAST(orderDate AS DATE) = CAST(GETDATE() AS DATE)";

        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                totalOrders = rs.getInt("orderCount");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalOrders;
    }

}
