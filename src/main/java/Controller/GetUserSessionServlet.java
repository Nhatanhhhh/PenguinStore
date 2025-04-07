/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author Nhat_Anh
 */
@WebServlet("/api/getUserSession")
public class GetUserSessionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        Object user = request.getSession().getAttribute("user");
        if (user != null) {
            // Sử dụng Gson để chuyển đổi thành JSON
            com.google.gson.Gson gson = new com.google.gson.Gson();
            out.print(gson.toJson(user));
        } else {
            out.print("{}"); // Trả về object rỗng thay vì "null"
        }
    }
}