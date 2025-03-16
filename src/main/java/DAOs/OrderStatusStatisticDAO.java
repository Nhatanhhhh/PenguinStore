/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.OrderStatusStatistic;
import Models.TopOrderCustomer;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Thuan
 */
public class OrderStatusStatisticDAO extends DBContext{
    
    public List<OrderStatusStatistic> getByDay(){
        List<OrderStatusStatistic> list = new ArrayList<>();
        String query = "SELECT CAST(O.orderDate AS DATE) AS OrderDate, "
             + "COUNT(CASE WHEN S.statusName = 'Delivery successful' THEN 1 END) AS CompletedOrders, "
             + "COUNT(CASE WHEN S.statusName = 'Delivery failed' THEN 1 END) AS DeliveryFailed, "
             + "COUNT(CASE WHEN S.statusName = 'Cancel order' THEN 1 END) AS CanceledOrders "
             + "FROM dbo.[Order] O "
             + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
             + "WHERE S.statusName IN ('Delivery successful', 'Delivery failed', 'Cancel order') "
             + "AND CAST(O.orderDate AS DATE) = CAST(GETDATE() AS DATE) "
             + "GROUP BY CAST(O.orderDate AS DATE) "
             + "ORDER BY OrderDate";
        
         try ( ResultSet rs = execSelectQuery(query)) {

            while (rs.next()) {
                list.add(new OrderStatusStatistic(rs.getString("OrderDate")
                        , rs.getInt("CompletedOrders")
                        , rs.getInt("DeliveryFailed")
                        , rs.getInt("CanceledOrders")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<OrderStatusStatistic> getLastMonth() {
        List<OrderStatusStatistic> list = new ArrayList<>();
        String query = "SELECT FORMAT(O.orderDate, 'yyyy-MM') AS OrderMonth, " 
             + "COUNT(CASE WHEN S.statusName = 'Delivery successful' THEN 1 END) AS CompletedOrders, "
             + "COUNT(CASE WHEN S.statusName = 'Delivery failed' THEN 1 END) AS DeliveryFailed, "
             + "COUNT(CASE WHEN S.statusName = 'Cancel order' THEN 1 END) AS CanceledOrders "
             + "FROM dbo.[Order] O "
             + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
             + "WHERE S.statusName IN ('Delivery successful', 'Delivery failed', 'Cancel order') "
             + "AND O.orderDate >= DATEADD(MONTH, -1, GETDATE()) " 
             + "AND O.orderDate <= GETDATE() "
             + "GROUP BY FORMAT(O.orderDate, 'yyyy-MM') "
             + "ORDER BY OrderMonth DESC"; 

        try (ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                list.add(new OrderStatusStatistic(
                    rs.getString("OrderMonth"),
                    rs.getInt("CompletedOrders"),
                    rs.getInt("DeliveryFailed"),
                    rs.getInt("CanceledOrders")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    
    public List<OrderStatusStatistic> getLastYearToNow() {
        List<OrderStatusStatistic> list = new ArrayList<>();
        String query = "SELECT YEAR(O.orderDate) AS OrderYear, " 
             + "COUNT(CASE WHEN S.statusName = 'Delivery successful' THEN 1 END) AS CompletedOrders, "
             + "COUNT(CASE WHEN S.statusName = 'Delivery failed' THEN 1 END) AS DeliveryFailed, "
             + "COUNT(CASE WHEN S.statusName = 'Cancel order' THEN 1 END) AS CanceledOrders "
             + "FROM dbo.[Order] O "
             + "JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
             + "WHERE S.statusName IN ('Delivery successful', 'Delivery failed', 'Cancel order') "
             + "AND O.orderDate >= DATEADD(YEAR, -1, GETDATE()) " 
             + "AND O.orderDate <= GETDATE() " 
             + "GROUP BY YEAR(O.orderDate) "
             + "ORDER BY OrderYear DESC"; 

        try (ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                list.add(new OrderStatusStatistic(
                    rs.getString("OrderYear"),  // Trả về năm
                    rs.getInt("CompletedOrders"),
                    rs.getInt("DeliveryFailed"),
                    rs.getInt("CanceledOrders")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    
    public List<TopOrderCustomer> getTopCustomersByOrderType() {
        List<TopOrderCustomer> list = new ArrayList<>();
        String query = "WITH RankedOrders AS ("
                     + "    SELECT C.email, O.statusOID, S.statusName, "
                     + "           COUNT(O.orderID) AS orderCount, "
                     + "           RANK() OVER (PARTITION BY O.statusOID ORDER BY COUNT(O.orderID) DESC) AS rank "
                     + "    FROM dbo.[Order] O "
                     + "    JOIN dbo.Customer C ON O.customerID = C.customerID "
                     + "    JOIN dbo.StatusOrder S ON O.statusOID = S.statusOID "
                     + "    GROUP BY C.email, O.statusOID, S.statusName"
                     + ") "
                     + "SELECT email, statusName FROM RankedOrders WHERE rank <= 3;";

        try (ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                list.add(new TopOrderCustomer(
                    rs.getString("email"),
                    rs.getString("statusName")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
