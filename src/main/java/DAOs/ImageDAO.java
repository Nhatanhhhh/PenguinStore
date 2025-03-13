/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Image;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ImageDAO extends DBContext {

    public ArrayList<Image> getImageProduct(String id) throws SQLException {
        ArrayList<Image> listImg = new ArrayList<>();
        String query = "select * from Image where productID = ?";
        Object params[] = {id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                String imgID = rs.getString("imgID");
                String imgName = rs.getString("imgName");
                String productID = rs.getString("productID");
                Image image = new Image(imgID, imgName, productID);
                listImg.add(image);
            }
        } catch (SQLException e) {
            Logger.getLogger(ImageDAO.class.getName()).log(Level.SEVERE, "Error", e);
        }
        return listImg;
    }

    public boolean deleteImg(String id) throws SQLException {
        String sql = "DELETE FROM Image WHERE imgID = ?";
        Object params[] = {id};
        return execQuery(sql, params) != 0;
    }

    public String getImageName(String id) throws SQLException {
        String sql = "SELECT imgName FROM Image WHERE imgID = ?";
        Object params[] = {id};
        String img = null;
        try ( ResultSet rs = execSelectQuery(sql, params);) {
            if (rs.next()) {
                img = rs.getString("imgName");
            }
        } catch (Exception e) {
            Logger.getLogger(ImageDAO.class.getName()).log(Level.SEVERE, "Error", e);
        }
        return img;
    }

    public int insertImage(String listImgName, String nameProduct) throws SQLException {
        int rs = 0;
        if (listImgName == null || listImgName.isEmpty()) {
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

    public int insertImageID(String listImgName, String id) throws SQLException {
        if (listImgName == null || listImgName.isEmpty()) {
            return 0;
        }
        String[] imgArray = listImgName.split(",");
        String sql = "INSERT INTO Image (productID, imgName) VALUES (?, ?)";
        int count = 0;
        for (String img : imgArray) {
            Object[] params = {id, img.trim()};
            count += execQuery(sql, params);
        }

        return count; // Trả về số ảnh đã chèn
    }

}
