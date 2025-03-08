/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class CategoryDAO extends DB.DBContext {

    public ArrayList<Category> getAll() {
        ArrayList<Category> list = new ArrayList<>();
        String sql = "SELECT categoryID, categoryName FROM Category";

        try ( Connection conn = getConn();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new Category(rs.getString("categoryID"), rs.getString("categoryName")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}
