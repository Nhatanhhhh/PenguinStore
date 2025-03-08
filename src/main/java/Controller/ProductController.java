/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Product;
import Models.ProductVariant;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductController extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        ProductDAO productDAO = new ProductDAO();
        ProductVariantDAO productVariantDAO = new ProductVariantDAO();
        if (id == null || id.isEmpty()) {
            ArrayList<Product> listProduct = productDAO.readAll();
            request.setAttribute("listProduct", listProduct);
            request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
        } else {
            ArrayList<ProductVariant> listDetail = productVariantDAO.viewProductDetail(id);
            Product product = productDAO.getOneProduct(id);
            request.setAttribute("productDetail", listDetail);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/View/ProductDetail.jsp").forward(request, response);
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();
        if (action != null || "search".equals(action)) {
            String searchQuery = request.getParameter("searchQuery");
            ArrayList<Product> listProduct = productDAO.searchProduct(searchQuery);
            request.setAttribute("listProduct", listProduct);
            request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
        }
    }
}
