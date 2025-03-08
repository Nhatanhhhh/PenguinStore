/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.ManagerDAO;
import DAOs.TypeDAO;
import DB.DBContext;
import DTO.ShowStaffDTO;
import Models.Manager;
import Models.Type;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;

/**
 *
 * @author Thuan
 */
@WebServlet(name = "StaffController", urlPatterns = {"/Staff"})
public class StaffController extends HttpServlet {
    
    private DBContext db;
    
     @Override
    public void init() throws ServletException {
        super.init();
        db = new DBContext();  
        System.out.println("DBContext init: " + db);
        try {
           db.getConn();  
       } catch (Exception e) {
           throw new ServletException("Failed", e);
       }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String managerName = request.getParameter("id");
        ManagerDAO managerDAO = new ManagerDAO(db);

        if (Objects.isNull(action)) {
            action = "list"; // Default to listing types
        }

        switch (action) {
            case "list":

                ArrayList<ShowStaffDTO> managerList = managerDAO.getNameAndEmail();
                request.setAttribute("managerList", managerList);
                request.getRequestDispatcher("/View/ListStaff.jsp").forward(request, response);
                break;

            case "detail":

                if (managerName == null || managerName.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/Staff?action=list");
                    return;
                }

                Manager managerDetail = managerDAO.getByManagerName(managerName);

                if (managerDetail == null) {
                    response.sendRedirect(request.getContextPath() + "/Staff?action=list");
                    return;
                }

                request.setAttribute("managerDetail", managerDetail);
                request.getRequestDispatcher("/View/DetailStaff.jsp").forward(request, response);
                break;

            case "edit":

                System.out.println("Received Staff Name: " + managerName);
                System.out.println("Query String: " + request.getQueryString());

                if (managerName == null || managerName.trim().isEmpty()) {
                    request.getRequestDispatcher("/View/EditStaff.jsp").forward(request, response);

                    return;
                }

                Manager existingManager = managerDAO.getByManagerName(managerName);
                
                
                if (existingManager == null) {
                    request.getRequestDispatcher("/View/EditStaff.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("manager", existingManager);
                request.getRequestDispatcher("/View/EditStaff.jsp").forward(request, response);
                break;

            case "create":
                request.getRequestDispatcher("/View/CreateStaff.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/Staff?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
       
        ManagerDAO managerDAO = new ManagerDAO(db);

        if (Objects.isNull(action)) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                ArrayList<ShowStaffDTO> managerList = managerDAO.getNameAndEmail();
                request.setAttribute("managerList", managerList);
                request.getRequestDispatcher("/View/ListStaff.jsp").forward(request, response);
                break;

            case "create":

                String managerNameCreate = request.getParameter("managerName");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phoneNumber = request.getParameter("phoneNumber");
                String address = request.getParameter("address");
                String dateCreate = convertToFullDateTime(request.getParameter("dateOfBirth"));

                if (managerNameCreate == null || managerNameCreate.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                    request.setAttribute("error", "Please Enter your data.");
                    request.getRequestDispatcher("/View/CreateStaff.jsp").forward(request, response);
                    return;
                }

                Manager managerCreate = new Manager(null, managerNameCreate, password, fullName, email, phoneNumber, address, dateCreate, false);

                int rowsAffected = managerDAO.insert(managerCreate);
                System.out.println("gia tri create tra ve: " + rowsAffected);
                // Ki?m tra k?t qu?
                if (rowsAffected > 0) {
                    response.sendRedirect(request.getContextPath() + "/Staff?action=list");
                } else {
                    request.setAttribute("error", "Create invalue! Phease try again.");
                    request.getRequestDispatcher("/View/CreateStaff.jsp").forward(request, response);
                }
                break;

            case "edit":
               
                String managerName = request.getParameter("managerName");
 
                String date = convertToFullDateTime(request.getParameter("dateOfBirth"));
                Manager managerUpdate = new Manager(null,
                        request.getParameter("managerName"),
                        request.getParameter("password"),
                        request.getParameter("fullName"),
                        request.getParameter("email"),
                        request.getParameter("phoneNumber"),
                        request.getParameter("address"),
                        date,
                        false);

                try {
                     int check = managerDAO.updateByManagerName(managerName, managerUpdate);
                     System.out.println("Check: "  +check);
                } catch (Exception e) {
                    System.out.println(e);
                }

                response.sendRedirect(request.getContextPath() + "/Staff?action=list");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Staff?action=list");
                break;
        }

    }

    public static String convertToFullDateTime(String dateStr) {
        try {
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

            Date date = inputFormat.parse(dateStr);
            return outputFormat.format(date);
        } catch (ParseException e) {
            return null;
        }
    }
}
