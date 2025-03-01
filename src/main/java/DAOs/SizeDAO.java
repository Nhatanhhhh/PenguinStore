/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Size;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class SizeDAO extends DBContext {

    public ArrayList<Size> getAll() {
        ArrayList<Size> listSize = new ArrayList<>();
        String sql = "select * from Size ORDER By sizeName ";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                String sizeID = rs.getString("sizeID");
                String sizeName = rs.getString("sizeName");
                Size size = new Size(sizeID, sizeName);
                listSize.add(size);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SizeDAO.class.getName()).log(Level.SEVERE, "Error when get Size data", ex);
        }
        return listSize;
    }
}
