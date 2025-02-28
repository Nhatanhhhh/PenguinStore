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
     * L?y thông tin qu?n lý t? username và m?t kh?u (?ã hash)
     *
     * @param username Tên ng??i dùng
     * @param password M?t kh?u ch?a mã hóa (s? ???c mã hóa trong hàm này)
     * @return ??i t??ng Manager n?u tìm th?y, ng??c l?i tr? v? null
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
