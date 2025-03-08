/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Product;
import Models.ProductVariant;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductVariantDAO extends DBContext {

    private Connection conn;

    public ArrayList<ProductVariant> viewProductDetail(String proID) {
        ArrayList<ProductVariant> productVariant = new ArrayList<>();
        String sql = "SELECT PV.proVariantID, PV.status, PV.stockQuantity, C.colorName, S.sizeName\n"
                + "FROM   Product P\n"
                + "INNER JOIN ProductVariants PV ON P.productID = PV.productID\n"
                + "LEFT JOIN Color C ON PV.colorID = C.colorID\n"
                + "LEFT JOIN Size S ON PV.sizeID = S.sizeID\n"
                + "WHERE P.productID = CONVERT(UNIQUEIDENTIFIER, ?);";
        Object param[] = {proID};
        try ( ResultSet rs = execSelectQuery(sql, param)) {
            while (rs.next()) {
                String proVariantID = rs.getString("proVariantID");
                boolean status = rs.getBoolean("status");
                int stockQuantity = rs.getInt("stockQuantity");
                String colorName = rs.getString("colorName");
                String sizeName = rs.getString("sizeName");
                ProductVariant proVariant = new ProductVariant(proVariantID, status, stockQuantity, colorName, sizeName);
                productVariant.add(proVariant);
            }
        } catch (Exception e) {
        }
        return productVariant;
    }

    public int insertProductVariant(String productName, String[] listSize, String[] listColor) {
        String colorPlaceholders = String.join(",", Collections.nCopies(listColor.length, "?"));
        String sizePlaceholders = String.join(",", Collections.nCopies(listSize.length, "?"));
        String sql = "INSERT INTO ProductVariants (productID, colorID, sizeID, status, stockQuantity) "
                + "SELECT p.productID, c.colorID, s.sizeID, 0, 0 "
                + "FROM Product p "
                + "JOIN TypeProduct t ON p.typeID = t.typeID "
                + "JOIN Category cat ON t.categoryID = cat.categoryID "
                + "JOIN Color c ON c.colorID IN (" + colorPlaceholders + ") "
                + "JOIN Size s ON s.sizeID IN (" + sizePlaceholders + ") "
                + "WHERE p.productName = ?;";

        List<Object> paramList = new ArrayList<>();
        Collections.addAll(paramList, (Object[]) listColor);
        Collections.addAll(paramList, (Object[]) listSize);
        paramList.add(productName);

        Object[] params = paramList.toArray();
        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, "Error inserting new product variant", ex);
            return 0;
        }
    }

    public ArrayList<ProductVariant> getAll() {
        ArrayList<ProductVariant> productVariant = new ArrayList<>();
        String sql = "SELECT pPV.proVariantID, PV.status, PV.stockQuantity, C.colorName, S.sizeName\n"
                + "FROM   Product P\n"
                + "INNER JOIN ProductVariants PV ON P.productID = PV.productID\n"
                + "LEFT JOIN Color C ON PV.colorID = C.colorID\n"
                + "LEFT JOIN Size S ON PV.sizeID = S.sizeID;";

        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                String proVariantID = rs.getString("proVariantID");
                boolean status = rs.getBoolean("status");
                int stockQuantity = rs.getInt("stockQuantity");
                String colorName = rs.getString("colorName");
                String sizeName = rs.getString("sizeName");
                ProductVariant proVariant = new ProductVariant(proVariantID, status, stockQuantity, colorName, sizeName);
                productVariant.add(proVariant);
            }
        } catch (Exception ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, "Error view all product variant", ex);
        }
        return productVariant;
    }
}