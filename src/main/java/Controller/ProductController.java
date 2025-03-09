/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Feedback;
import DAOs.TypeDAO;
import Models.Product;
import Models.ProductVariant;
import Models.Type;
import java.io.IOException;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        System.out.println("PRODUCT ID: " + id); // Bổ sung log để debug

        String action = request.getParameter("action");
        String typeDetail = request.getParameter("type");
        String categoryDetail = request.getParameter("category");

        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        ProductVariantDAO productVariantDAO = new ProductVariantDAO();

        // Lấy danh sách loại sản phẩm
        ArrayList<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            String categoryName = type.getCategoryName();
            categoryMap.computeIfAbsent(categoryName, k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);

        if (Objects.isNull(action)) {
            action = "view";
        }
        switch (action) {
            case "view":
                ArrayList<Product> listProduct = productDAO.readAll();
                request.setAttribute("listProduct", listProduct);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            case "detail":
                ArrayList<ProductVariant> listDetail = productVariantDAO.viewProductDetail(id);
                Product product = productDAO.getOneProduct(id);

                double averageRating = FeedbackDAO.getAverageRating(id);
                int totalReviews = FeedbackDAO.getTotalReviews(id);
                List<Feedback> feedbackList = FeedbackDAO.getLatestFeedbacks(id);

                request.setAttribute("productDetail", listDetail);
                request.setAttribute("product", product);
                request.setAttribute("averageRating", averageRating);
                request.setAttribute("totalReviews", totalReviews);
                request.setAttribute("feedbackList", feedbackList);
                request.getRequestDispatcher("/View/ProductDetail.jsp").forward(request, response);
                break;
            case "detailType":
                if (Objects.isNull(typeDetail) && Objects.isNull(categoryDetail)) {
                    response.sendRedirect(request.getContextPath() + "/Product?action=view");
                }
                List<String> typeList = new ArrayList<>();
                for (Type type : listType) {
                    if (categoryDetail != null && type.getCategoryName().equalsIgnoreCase(categoryDetail)) {
                        typeList.add(type.getTypeName());
                    }
                }
                String[] typeForList = typeList.toArray(new String[0]);
                ArrayList<Product> productByCategory = productDAO.getFilteredProducts(typeForList, null, null);
                request.setAttribute("typeDetail", typeDetail);
                request.setAttribute("categoryDetail", categoryDetail);
                request.setAttribute("listProduct", productByCategory);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/Product?action=view");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TypeDAO typeDAO = new TypeDAO();
        ProductDAO productDAO = new ProductDAO();

        String sortCondition = request.getParameter("sortBy");
        ArrayList<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);

        String[] selectedTypes = request.getParameterValues("typeFilter");
        String[] selectedPrices = request.getParameterValues("priceFilter");
        request.setAttribute("selectedTypes", selectedTypes != null ? Arrays.asList(selectedTypes) : new ArrayList<>());
        request.setAttribute("selectedPrices", selectedPrices != null ? Arrays.asList(selectedPrices) : new ArrayList<>());

        if (Objects.isNull(action)) {
            action = "view";
        }
        switch (action) {
            case "search":
                String searchQuery = request.getParameter("searchQuery");
                ArrayList<Product> listProduct = productDAO.searchProduct(searchQuery);
                request.setAttribute("listProduct", listProduct);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            case "filter":
                ArrayList<Product> listProductFilter = productDAO.getFilteredProducts(selectedTypes, selectedPrices, sortCondition);
                request.setAttribute("listProduct", listProductFilter);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            case "sort":
                ArrayList<Product> sortedProducts = productDAO.getFilteredProducts(selectedTypes, selectedPrices, sortCondition);
                request.setAttribute("listProduct", sortedProducts);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
            default:
                ArrayList<Product> defaultProductList = productDAO.getFilteredProducts(null, null, sortCondition);
                request.setAttribute("listProduct", defaultProductList);
                request.getRequestDispatcher("/View/ViewProducts.jsp").forward(request, response);
                break;
        }
    }
}
