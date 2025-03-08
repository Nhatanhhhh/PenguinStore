/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import DTO.ShowStaffDTO;
import Models.Customer;
import Models.Manager;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
 * @author Nguyen Nhat Anh - CE181843
 */
public class ManagerDAO extends DBContext {

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

        try ( ResultSet rs = execSelectQuery(query, params)) {
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

        try ( ResultSet rs = execSelectQuery(query)) {
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

        try ( ResultSet rs = execSelectQuery(query, params)) {
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
                + "role = 0 "
                + "WHERE managerName = ?";

        try {

            if (!managerName.equals(managerChange.getManagerName())) {
                Manager checkName = getByManagerName(managerChange.getManagerName());
                if (checkName != null) {
                    return 0;
                }
            }
            String passMD5 = md5(managerChange.getPassword());
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

            return execQuery(sqlUpdate, updateParams);
        } catch (SQLException e) {
            Logger.getLogger(ManagerDAO.class.getName()).log(Level.SEVERE, null, e);
            return 0;
        }
    }

    public boolean insert(Manager manager) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isSuccess = false;

        // Hash mật khẩu trước khi lưu vào DB
        String hashedPassword = DBContext.hashPasswordMD5(manager.getPassword());

        try {
            conn = DBContext.getConn();
            String sql = "INSERT INTO Manager(managerName, password, fullName, email, phoneNumber, address, dateOfBirth, role) VALUES (?, ?, ?, ?, ?, ?, ?, 0)";
            ps = conn.prepareStatement(sql);

            ps.setString(1, manager.getManagerName());
            ps.setString(2, manager.getPassword());
            ps.setString(3, hashedPassword);
            ps.setString(4, manager.getFullName());
            ps.setString(5, manager.getEmail());
            ps.setString(6, manager.getPhoneNumber());
            ps.setString(7, manager.getAddress());
            ps.setString(8, manager.getDateOfBirth());

            int rowsAffected = ps.executeUpdate();
            isSuccess = (rowsAffected > 0);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Đóng ps, conn
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return isSuccess;
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