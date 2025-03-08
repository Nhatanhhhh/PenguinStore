/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Color;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ColorDAO extends DBContext{
    
    public ArrayList<Color> getAll(){
        ArrayList<Color> listColor = new ArrayList<>();
        String sql = "select * from Color";
        try (ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {                
                 String colorID = rs.getString("colorID");
                 String colorName = rs.getString("colorName");
                 Color color =new Color(colorID, colorName);
                 listColor.add(color);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ColorDAO.class.getName()).log(Level.SEVERE, "Error when get Color data", ex);
        }
        return listColor;
    }
}