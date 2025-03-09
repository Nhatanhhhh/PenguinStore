/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.ColorDAO;
import DAOs.ImageDAO;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import DAOs.SizeDAO;
import DAOs.TypeDAO;
import Models.Color;
import Models.Product;
import Models.ProductVariant;
import Models.Size;
import Models.Type;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Objects;
import jakarta.servlet.annotation.MultipartConfig;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig()
/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ManageProductController extends HttpServlet {

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
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        ProductDAO productDAO = new ProductDAO();
        ProductVariantDAO productVariantDAO = new ProductVariantDAO();
        SizeDAO sizeDAO = new SizeDAO();
        ColorDAO colorDAO = new ColorDAO();
        TypeDAO typeDAO = new TypeDAO();
        if (Objects.isNull(action)) {
            action = "view";
        }
        switch (action) {
            case "view":
                ArrayList<Product> listProduct = productDAO.readAll();
                Map<String, ArrayList<ProductVariant>> productVariantsMap = new HashMap<>();
                for (Product product : listProduct) {
                    ArrayList<ProductVariant> variants = productVariantDAO.viewProductDetail(product.getProductID());
                    productVariantsMap.put(product.getProductID(), variants);
                }
                request.setAttribute("productVariantsMap", productVariantsMap);
                request.setAttribute("listProduct", listProduct);
                request.getRequestDispatcher("/View/ViewProductsAdmin.jsp").forward(request, response);
                break;
            case "edit":
                ArrayList<ProductVariant> productDetail = productVariantDAO.viewProductDetail(id);
                Product chooseProduct = productDAO.getOneProduct(id);
                System.out.println("Product Detail Size: " + productDetail.size());
                for (ProductVariant pv : productDetail) {
                    System.out.println("Variant: " + pv.getColorName() + ", " + pv.getSizeName());
                }
                request.setAttribute("product", chooseProduct);
                request.setAttribute("productDetail", productDetail);
                request.getRequestDispatcher("/View/EditProduct.jsp").forward(request, response);
                break;
            case "create":
                ArrayList<Type> listType = typeDAO.getAll();
                ArrayList<Size> listSize = sizeDAO.getAll();
                ArrayList<Color> listColor = colorDAO.getAll();
                request.setAttribute("listType", listType);
                request.setAttribute("listSize", listSize);
                request.setAttribute("listColor", listColor);
                request.getRequestDispatcher("/View/CreateProduct.jsp").forward(request, response);
                break;
            case "inventory":
                ArrayList<Type> type = typeDAO.getAll();
                for (Type type1 : type) {
                    System.out.println(type1.getTypeName());
                }
                ArrayList<ProductVariant> listDetail = productVariantDAO.viewProductDetail(id);
                Product product = productDAO.getOneProduct(id);

                request.setAttribute("listType", type);
                request.setAttribute("productDetail", listDetail);
                request.setAttribute("product", product);
                request.getRequestDispatcher("/View/Inventory.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
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
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();
        ProductVariantDAO productVariantDAO = new ProductVariantDAO();
        ImageDAO imageDAO = new ImageDAO();
        SizeDAO sizeDAO = new SizeDAO();
        ColorDAO colorDAO = new ColorDAO();
        TypeDAO typeDAO = new TypeDAO();

        if (Objects.isNull(action)) {
            action = "view";
        }

        switch (action) {
            case "view":
            case "edit":
                break;

            case "create":
                String productName = request.getParameter("productName");
                String description = request.getParameter("description");
                int price = Integer.parseInt(request.getParameter("price"));
                String category = request.getParameter("categoryId");
                String typeId = request.getParameter("typeId");
                String[] colorIds = request.getParameterValues("colorIds");
                String[] sizeIds = request.getParameterValues("sizeIds");

                String[] context = request.getServletContext().getRealPath("").split("target");
                String realPath = context[0] + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "Image" + File.separator + "Product";
                ArrayList<String> imageNames = new ArrayList<>();
                for (Part part : request.getParts()) {
                    if (part.getName().equals("selectedFiles") && part.getSize() > 0) {
                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        part.write(realPath + File.separator + fileName);
                        imageNames.add(fileName);
                    }
                }
                String imageString = String.join(",", imageNames);
                Product product = new Product(productName, description, price, typeId);
                try {
                    int createProduct = productDAO.insertProduct(product);
                    int createProductVariant = productVariantDAO.insertProductVariant(productName, sizeIds, colorIds);
                    int addImg = imageDAO.insertImage(imageString, productName);
                } catch (SQLException ex) {
                    Logger.getLogger(ManageProductController.class.getName()).log(Level.SEVERE, null, ex);
                }
                response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
                break;

            case "updateProduct":
            try {
                String productID = request.getParameter("productID");
                String updatedProductName = request.getParameter("productName");
                String updatedDescription = request.getParameter("description");
                int updatedPrice = Integer.parseInt(request.getParameter("price"));

                boolean success = productDAO.updateProduct(productID, updatedProductName, updatedDescription, updatedPrice);
                response.getWriter().write(success ? "Success" : "Error updating product");
            } catch (Exception ex) {
                Logger.getLogger(ManageProductController.class.getName()).log(Level.SEVERE, null, ex);
                response.getWriter().write("Error: " + ex.getMessage());
            }
            break;

            case "updateVariantStatus":
                try {
                String variantID = request.getParameter("variantID");
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                boolean updated = productVariantDAO.updateProductVariantStatus(variantID, status);
                response.getWriter().write(updated ? "Success" : "Failed to update");
            } catch (Exception ex) {
                Logger.getLogger(ManageProductController.class.getName()).log(Level.SEVERE, null, ex);
                response.getWriter().write("Error: " + ex.getMessage());
            }
            break;

            default:
                response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
                break;
        }
    }

}
