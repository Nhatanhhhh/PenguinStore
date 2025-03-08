/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import java.sql.SQLException;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ImageDAO extends DBContext {

    public int insertImage(String listImgName, String nameProduct) throws SQLException {
        int rs = 0;
        if ( listImgName == null || listImgName.isEmpty()) {
            return rs;
        }
        String[] imgArray = listImgName.split(",");
        String sql = "INSERT INTO Image (productID, imgName)\n"
                + "SELECT p.productID, ? \n"
                + "FROM Product p\n"
                + "WHERE p.productName = ?;";
        for (String img : imgArray) {
            Object[] params = {img, nameProduct};
            rs = execQuery(sql, params);
        }
        return rs;
    }

}