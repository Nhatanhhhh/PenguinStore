/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import DTO.ShowStaffDTO;
import Models.Manager;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nhat_Anh
 */
public class ManagerDAO {

    private final DBContext dbContext;

    public ManagerDAO(DBContext dbContext) {
        this.dbContext = dbContext;
    }

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

    public ArrayList<ShowStaffDTO> getNameAndEmail() {
        ArrayList<ShowStaffDTO> getNameAndEmail = new ArrayList<>();

        String query = "SELECT managerName,email from Manager WHERE role=0";

        try ( ResultSet rs = dbContext.execSelectQuery(query)) {
            while (rs.next()) {
                getNameAndEmail.add(new ShowStaffDTO(rs.getString("managerName"), rs.getString("email")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return getNameAndEmail;
    }

    public Manager getByManagerName(String managerName) {
        Manager manager = null;

        String query = "SELECT * FROM Manager WHERE managerName = ?";
        Object[] params = {managerName};

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

    public int updateByManagerName(String managerName, Manager managerChange) {
        String sqlUpdate = "UPDATE Manager SET "
                + "managerName = ?, "
                + "password = ?, "
                + "fullName = ?, "
                + "email = ?, "
                + "phoneNumber = ?, "
                + "address = ?, "
                + "dateOfBirth = ?, "
                + "role = ? "
                + "WHERE managerName = ?";
        String passMD5 = md5(managerChange.getPassword());
        try {

            if (!managerName.equals(managerChange.getManagerName())) {
                Manager checkName = getByManagerName(managerChange.getManagerName());
                if (checkName != null) {
                    return 0;
                } else if (!checkName.getPassword().equals(managerChange.getPassword())) {
                    passMD5 = md5(managerChange.getPassword());
                }
            }

            Object[] updateParams = {
                managerChange.getManagerName(),
                passMD5,
                managerChange.getFullName(),
                managerChange.getEmail(),
                managerChange.getPhoneNumber(),
                managerChange.getAddress(),
                managerChange.getDateOfBirth(),
                managerChange.isRole(),
                managerName
            };

            return dbContext.execQuery(sqlUpdate, updateParams);

        } catch (SQLException e) {
            Logger.getLogger(ManagerDAO.class.getName()).log(Level.SEVERE, null, e);
            return 0;
        }
    }

    public int insert(Manager manager) {
        if (getByManagerName(manager.getManagerName()) != null) {
            return 0;
        }

        String hashedPassword = DBContext.hashPasswordMD5(manager.getPassword());

        String sql = "INSERT INTO Manager(managerName, password, fullName, email, phoneNumber, address, dateOfBirth, role) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 0)";

        Object[] params = {
            manager.getManagerName(),
            hashedPassword,
            manager.getFullName(),
            manager.getEmail(),
            manager.getPhoneNumber(),
            manager.getAddress(),
            manager.getDateOfBirth()

        };

        try {
            return dbContext.execQuery(sql, params);
        } catch (SQLException e) {
            Logger.getLogger(ManagerDAO.class.getName()).log(Level.SEVERE, null, e);
            return 0;
        }
    }

    private String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");

            byte[] messageDigest = md.digest(input.getBytes());

            // Chuy?n byte array thành d?ng hex
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                // Chuy?n t?ng byte thành d?ng hex (2 ký t?)
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
