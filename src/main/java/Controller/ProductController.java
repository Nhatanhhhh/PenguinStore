/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import DAOs.TypeDAO;
import Models.Feedback;
import Models.Product;
import Models.ProductVariant;
import Models.Type;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

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
        String action = Objects.requireNonNullElse(request.getParameter("action"), "view");
        String typeDetail = request.getParameter("type");
        String categoryDetail = request.getParameter("category");
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        ProductVariantDAO productVariantDAO = new ProductVariantDAO();
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);
        switch (action) {
            case "view":
                request.setAttribute("listProduct", productDAO.readAll());
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            case "detail":
                if (id != null) {
                    request.setAttribute("productDetail", productVariantDAO.viewProductDetail(id));
                    request.setAttribute("product", productDAO.getOneProduct(id));
                    request.setAttribute("averageRating", FeedbackDAO.getAverageRating(id));
                    request.setAttribute("totalReviews", FeedbackDAO.getTotalReviews(id));
                    request.setAttribute("feedbackList", FeedbackDAO.getLatestFeedbacks(id));
                    request.getRequestDispatcher("/View/ProductDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/Product?action=view");
                }
                break;
            case "detailType":
                if (categoryDetail != null) {
                    List<String> typeList = new ArrayList<>();
                    for (Type type : listType) {
                        if (type.getCategoryName().equalsIgnoreCase(categoryDetail)) {
                            typeList.add(type.getTypeName());
                        }
                    }
                    request.setAttribute("listProduct", productDAO.getFilteredProducts(typeList.toArray(new String[0]), null, null));
                } else if (typeDetail != null) {
                    request.setAttribute("listProduct", productDAO.getFilteredProducts(new String[]{typeDetail}, null, null));
                } else {
                    response.sendRedirect(request.getContextPath() + "/Product?action=view");
                    return;
                }
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/Product?action=view");
                break;
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
        String action = Objects.requireNonNullElse(request.getParameter("action"), "view");
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();

        String sortCondition = request.getParameter("sortBy");
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);

        String[] selectedTypes = request.getParameterValues("typeFilter");
        String[] selectedPrices = request.getParameterValues("priceFilter");
        request.setAttribute("selectedTypes", selectedTypes != null ? Arrays.asList(selectedTypes) : new ArrayList<>());
        request.setAttribute("selectedPrices", selectedPrices != null ? Arrays.asList(selectedPrices) : new ArrayList<>());

        List<Product> filteredProducts = productDAO.getFilteredProducts(selectedTypes, selectedPrices, sortCondition);
        if (filteredProducts == null || filteredProducts.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Product?action=view");
            return;
        }

        request.setAttribute("listProduct", filteredProducts);
        request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
    }
}
