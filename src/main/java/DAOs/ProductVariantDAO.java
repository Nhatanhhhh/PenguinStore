/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Product;
import Models.ProductVariants;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductVariantDAO extends DBContext {

    private Connection conn;

    

    public ArrayList<ProductVariants> viewProductDetail(String proID) {
        ArrayList<ProductVariants> productVariant = new ArrayList<>();
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
                ProductVariants proVariant = new ProductVariants(proVariantID, status, stockQuantity, colorName, sizeName);
                productVariant.add(proVariant);
            }
        } catch (Exception e) {
        }
        return productVariant;
    }
}