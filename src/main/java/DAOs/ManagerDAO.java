/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Manager;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Nhat_Anh
 */
public class ManagerDAO {

    private final DBContext dbContext;

    public ManagerDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * L?y th�ng tin qu?n l� t? username v� m?t kh?u (?� hash)
     *
     * @param username T�n ng??i d�ng
     * @param password M?t kh?u ch?a m� h�a (s? ???c m� h�a trong h�m n�y)
     * @return ??i t??ng Manager n?u t�m th?y, ng??c l?i tr? v? null
     */
    public Manager getManagerByUsernameAndPassword(String username, String hashedPassword) {
        Manager manager = null;


        String query = "SELECT * FROM Manager WHERE managerName = ? AND password = ?";
        Object[] params = {username, hashedPassword};
        
        System.out.println("Hashed Password:" + hashedPassword);

        try ( ResultSet rs = dbContext.execSelectQuery(query, params)) {
            if (rs.next()) {
                manager = new Manager(
                        rs.getString("managerID"),
                        rs.getString("managerName"),
                        rs.getString("password"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("address"),
                        rs.getString("dateOfBirth"),
                        rs.getBoolean("role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return manager;
    }


}
