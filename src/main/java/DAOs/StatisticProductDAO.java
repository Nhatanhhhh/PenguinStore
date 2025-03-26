
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import DB.DBContext;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import Models.StatisticProduct;
import java.sql.PreparedStatement;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class StatisticProductDAO extends DBContext {

    public ArrayList<StatisticProduct> getAll() {
        ArrayList<StatisticProduct> statistics = new ArrayList<>();
        String query = "SELECT "
                + "COALESCE(s.timePeriod, r.timePeriod) AS timePeriod, "
                + "p.productName, sz.sizeName, c.colorName, "
                + "ISNULL(s.soldQuantity, 0) AS soldQuantity, "
                + "ISNULL(r.importedQuantity, 0) AS importedQuantity "
                + "FROM (SELECT CONVERT(VARCHAR, o.orderDate, 23) AS timePeriod, "
                + "             pv.proVariantID, SUM(od.quantity) AS soldQuantity "
                + "      FROM [Order] o "
                + "      JOIN OrderDetail od ON o.orderID = od.orderID "
                + "      JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "      GROUP BY CONVERT(VARCHAR, o.orderDate, 23), pv.proVariantID) s "
                + "FULL OUTER JOIN "
                + "(SELECT CONVERT(VARCHAR, r.restockDate, 23) AS timePeriod, "
                + "        pv.proVariantID, SUM(r.quantity) AS importedQuantity "
                + " FROM Restock r "
                + " JOIN ProductVariants pv ON r.proVariantID = pv.proVariantID "
                + " GROUP BY CONVERT(VARCHAR, r.restockDate, 23), pv.proVariantID) r "
                + "ON s.timePeriod = r.timePeriod AND s.proVariantID = r.proVariantID "
                + "JOIN ProductVariants pv ON COALESCE(s.proVariantID, r.proVariantID) = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "JOIN Size sz ON pv.sizeID = sz.sizeID "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "ORDER BY timePeriod, p.productName;";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                statistics.add(new StatisticProduct(
                        rs.getString("timePeriod"),
                        rs.getString("productName"),
                        rs.getString("sizeName"),
                        rs.getString("colorName"),
                        rs.getInt("soldQuantity"),
                        rs.getInt("importedQuantity")
                ));

            }
        } catch (SQLException ex) {
            Logger.getLogger(StatisticProductDAO.class.getName()).log(Level.SEVERE, "Error when getting statistic data", ex);
        }
        return statistics;
    }

    public ArrayList<StatisticProduct> getBestSellingProducts() {
        ArrayList<StatisticProduct> bestSelling = new ArrayList<>();
        String query = "SELECT TOP 5 p.productName, sz.sizeName, c.colorName, SUM(od.quantity) AS totalSold "
                + "FROM OrderDetail od "
                + "JOIN ProductVariants pv ON od.productVariantID = pv.proVariantID "
                + "JOIN Product p ON pv.productID = p.productID "
                + "JOIN Size sz ON pv.sizeID = sz.sizeID "
                + "JOIN Color c ON pv.colorID = c.colorID "
                + "GROUP BY p.productName, sz.sizeName, c.colorName "
                + "ORDER BY totalSold DESC";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                bestSelling.add(new StatisticProduct(
                        null,
                        rs.getString("productName"),
                        rs.getString("sizeName"),
                        rs.getString("colorName"),
                        rs.getInt("totalSold"),
                        0
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(StatisticProductDAO.class.getName()).log(Level.SEVERE, "Error when getting best-selling products", ex);
        }
        return bestSelling;
    }

    public ArrayList<StatisticProduct> getWeeklySales() {
        ArrayList<StatisticProduct> statistics = new ArrayList<>();
        String query = "WITH DateRange AS (\n"
                + "    SELECT CAST(DATEADD(DAY, number, DATEADD(DAY, -6, CAST(GETDATE() AS DATE))) AS DATE) AS timePeriod\n"
                + "    FROM master.dbo.spt_values\n"
                + "    WHERE type = 'P' AND number BETWEEN 0 AND 6\n"
                + ")\n"
                + "SELECT \n"
                + "    d.timePeriod,\n"
                + "    ISNULL(SUM(od.quantity), 0) AS soldQuantity\n"
                + "FROM DateRange d\n"
                + "LEFT JOIN [Order] o ON CAST(o.orderDate AS DATE) = d.timePeriod\n"
                + "LEFT JOIN OrderDetail od ON o.orderID = od.orderID\n"
                + "GROUP BY d.timePeriod\n"
                + "ORDER BY d.timePeriod;";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                statistics.add(new StatisticProduct(
                        rs.getString("timePeriod"),
                        "", // Không có productName
                        "", // Không có sizeName
                        "", // Không có colorName
                        rs.getInt("soldQuantity"),
                        0 // Không cần importedQuantity
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(StatisticProductDAO.class.getName()).log(Level.SEVERE, "Error when getting weekly sales data", ex);
        }
        return statistics;
    }

}
