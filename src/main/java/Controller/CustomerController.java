/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import DAOs.CustomerDAO;
import DB.DBContext;
import DTO.ShowCusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Objects;

/**
 *
 * @author Thuan
 */
@WebServlet(name = "CusController", urlPatterns = {"/Customer"})
public class CustomerController extends HttpServlet{

        
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        CustomerDAO customerDAO = new CustomerDAO();

        if (Objects.isNull(action)) {
            action = "list"; // Default to listing types
        }

        switch (action) {
            case "list":

                ArrayList<ShowCusDTO> listCus = customerDAO.getListCus();
                request.setAttribute("listCus", listCus);
                request.getRequestDispatcher("/View/ListCustomer.jsp").forward(request, response);
                break;
//            default:
//                response.sendRedirect(request.getContextPath() + "/Customer?action=list");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
       
        CustomerDAO customerDAO = new CustomerDAO();

        if (Objects.isNull(action)) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                ArrayList<ShowCusDTO> listCus = customerDAO.getListCus();
                request.setAttribute("listCus", listCus);
                request.getRequestDispatcher("/View/ListCustomer.jsp").forward(request, response);
                break;
//            default:
//                response.sendRedirect(request.getContextPath() + "/Customer?action=list");
               
        }
    }
    
    
}

