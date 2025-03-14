package DAOs;

import DB.DBContext;
import Models.ProductVariant;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import Models.Restock;
import java.sql.ResultSet;

/**
 * RestockDAO d?ng ?? c?p nh?t l?i s? l??ng h?ng trong kho.
 *
 * @author Do Van Luan
 */
public class RestockDAO extends DBContext {

    /**
     * Update stock quantity
     *
     * @param proVariantID ID of product variant
     * @param quantity Quantity to add
     * @return true if update successful, false if failed
     */
    public boolean restockProduct(String proVariantID, int quantity, double price) {
        Connection conn = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psInsertHistory = null;

        try {
            conn = getConn();
            conn.setAutoCommit(false);

            String sqlUpdateStock = "UPDATE ProductVariants SET stockQuantity = stockQuantity + ? WHERE proVariantID = ?";
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);
            psUpdateStock.setInt(1, quantity);
            psUpdateStock.setString(2, proVariantID);
            psUpdateStock.executeUpdate();

            String sqlInsertHistory = "INSERT INTO Restock (proVariantID, quantity, price, totalCost, restockDate) VALUES (?, ?, ?, ?, ?)";
            psInsertHistory = conn.prepareStatement(sqlInsertHistory);

            double totalCost = quantity * price;
            LocalDate restockDate = LocalDate.now();

            psInsertHistory.setString(1, proVariantID);
            psInsertHistory.setInt(2, quantity);
            psInsertHistory.setDouble(3, price);
            psInsertHistory.setDouble(4, totalCost);
            psInsertHistory.setDate(5, Date.valueOf(restockDate));

            psInsertHistory.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(RestockDAO.class.getName()).log(Level.SEVERE, "Error when importing prosucts", ex);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } finally {
            try {
                if (psUpdateStock != null) {
                    psUpdateStock.close();
                }
                if (psInsertHistory != null) {
                    psInsertHistory.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    public ArrayList<Restock> getRestockHistory() {
        ArrayList<Restock> list = new ArrayList<>();
        String query = "SELECT \n"
                + "    Product.productName, \n"
                + "    Size.sizeName, \n"
                + "    Color.colorName, \n"
                + "    Restock.restockID, \n"
                + "    Restock.proVariantID, \n"
                + "    Restock.quantity, \n"
                + "    Restock.price, \n"
                + "    Restock.totalCost,\n"
                + "    Restock.restockDate\n"
                + "FROM Restock\n"
                + "LEFT JOIN ProductVariants ON ProductVariants.proVariantID = Restock.proVariantID\n"
                + "LEFT JOIN Product ON Product.productID = ProductVariants.productID\n"
                + "LEFT JOIN Size ON Size.sizeID = ProductVariants.sizeID\n"
                + "LEFT JOIN Color ON Color.colorID = ProductVariants.colorID\n"
                + "ORDER BY Restock.restockDate DESC;";

        try ( ResultSet rs = execSelectQuery(query)) {

            while (rs.next()) {
                Date sqlDate = rs.getDate("restockDate");  // Lấy giá trị ngày
                LocalDate restockDate = (sqlDate != null) ? sqlDate.toLocalDate() : null; // Kiểm tra null trước khi convert

                list.add(new Restock(
                        rs.getString("productName"),
                        rs.getString("restockID"),
                        rs.getString("proVariantID"),
                        rs.getInt("quantity"),
                        rs.getDouble("price"),
                        rs.getDouble("totalCost"),
                        restockDate, // Gán giá trị đã kiểm tra null
                        rs.getString("sizeName"),
                        rs.getString("colorName")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
