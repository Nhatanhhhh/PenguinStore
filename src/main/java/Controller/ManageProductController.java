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
import Models.Image;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.checkerframework.checker.guieffect.qual.UI;

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
        try {
            String action = request.getParameter("action");
            String id = request.getParameter("id");
            ProductDAO productDAO = new ProductDAO();
            ProductVariantDAO productVariantDAO = new ProductVariantDAO();
            ImageDAO imageDAO = new ImageDAO();
            SizeDAO sizeDAO = new SizeDAO();
            ColorDAO colorDAO = new ColorDAO();
            TypeDAO typeDAO = new TypeDAO();
            ArrayList<Type> listTypeA = typeDAO.getAll();
            Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
            for (Type type : listTypeA) {
                String categoryName = type.getCategoryName();
                if (!categoryMap.containsKey(categoryName)) {
                    categoryMap.put(categoryName, new ArrayList<>());
                }
                categoryMap.get(categoryName).add(type);
            }
            request.setAttribute("listType", listTypeA);
            request.setAttribute("categoryMap", categoryMap);
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
                    ArrayList<Type> typeEdit = typeDAO.getAll();
                    ArrayList<ProductVariant> listDetailEdit = productVariantDAO.viewProductDetail(id);
                    ArrayList<Image> listImgEdit = imageDAO.getImageProduct(id);
                    Product productEdit = productDAO.getOneProduct(id);
                    request.setAttribute("listImg", listImgEdit);
                    request.setAttribute("listType", typeEdit);
                    request.setAttribute("productDetail", listDetailEdit);
                    request.setAttribute("product", productEdit);
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
                    ArrayList<ProductVariant> listDetail = productVariantDAO.viewProductDetail(id);
                    ArrayList<Image> listImg = imageDAO.getImageProduct(id);
                    Product product = productDAO.getOneProduct(id);
                    request.setAttribute("listImg", listImg);
                    request.setAttribute("listType", type);
                    request.setAttribute("productDetail", listDetail);
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/View/Inventory.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
                    break;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ManageProductController.class.getName()).log(Level.SEVERE, null, ex);
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
        try {
            String action = request.getParameter("action");
            ProductDAO productDAO = new ProductDAO();
            ProductVariantDAO productVariantDAO = new ProductVariantDAO();
            ImageDAO imageDAO = new ImageDAO();
            SizeDAO sizeDAO = new SizeDAO();
            ColorDAO colorDAO = new ColorDAO();
            TypeDAO typeDAO = new TypeDAO();
            ArrayList<Type> listType = typeDAO.getAll();
            if (Objects.isNull(action)) {
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    response.sendRedirect(request.getRequestURI());
                    return;
                }
                action = "view";
            }
            switch (action) {
                case "updateSaleStatus":
                    String productIDUpdateSale = request.getParameter("productID");
                    boolean isSale = Boolean.parseBoolean(request.getParameter("isSale"));
                    System.out.println("------------------------------");
                    boolean success = productDAO.updateSaleStatus(productIDUpdateSale, isSale);
                    response.getWriter().write(success ? "Success" : "Fail");
                    break;
                case "filter":
                    String selectedType = request.getParameter("selectedType");
                    String stockFilter = request.getParameter("stockFilter");
                    ArrayList<Product> listProduct = productDAO.readAll();
                    Map<String, ArrayList<ProductVariant>> productVariantsMap = new HashMap<>();
                    for (Product product : listProduct) {
                        ArrayList<ProductVariant> variants = productVariantDAO.viewProductDetail(product.getProductID());
                        productVariantsMap.put(product.getProductID(), variants);
                    }
                    ArrayList<Product> filteredProducts = new ArrayList<>();
                    for (Product product : listProduct) {
                        boolean matchesType = (selectedType == null || selectedType.isEmpty()) || product.getTypeName().equals(selectedType);
                        boolean matchesStock = true;

                        if (stockFilter != null && !stockFilter.isEmpty()) {
                            ArrayList<ProductVariant> variants = productVariantsMap.get(product.getProductID());
                            if (variants != null) {
                                matchesStock = variants.stream().anyMatch(variant
                                        -> ("below5".equals(stockFilter) && variant.getStockQuantity() < 5)
                                        || ("below10".equals(stockFilter) && variant.getStockQuantity() < 10)
                                );
                            }
                        }

                        if (matchesType && matchesStock) {
                            filteredProducts.add(product);
                        }
                    }

                    request.setAttribute("listType", listType);
                    request.setAttribute("listProduct", filteredProducts);
                    request.setAttribute("productVariantsMap", productVariantsMap);
                    request.getRequestDispatcher("/View/ViewProductsAdmin.jsp").forward(request, response);
                    break;
                case "create":
                    String productName = request.getParameter("productName");
                    String description = request.getParameter("description");
                    int price = Integer.parseInt(request.getParameter("price"));
                    String category = request.getParameter("categoryId");
                    String typeId = request.getParameter("typeId");
                    String[] colorIds = request.getParameterValues("colorIds");
                    String[] sizeIds = request.getParameterValues("sizeIds");
                    boolean isProductExist = productDAO.checkProduct(productName);
                    if (isProductExist) {
                        ArrayList<Size> listSize = sizeDAO.getAll();
                        ArrayList<Color> listColor = colorDAO.getAll();
                        request.setAttribute("listType", listType);
                        request.setAttribute("listSize", listSize);
                        request.setAttribute("listColor", listColor);
                        request.setAttribute("productName", productName);
                        request.setAttribute("description", description);
                        request.setAttribute("price", price);
                        request.setAttribute("category", category);
                        request.setAttribute("typeId", typeId);
                        request.setAttribute("selectedColorIds", colorIds);
                        request.setAttribute("selectedSizeIds", sizeIds);
                        request.setAttribute("errorMessage", "Product name already exists. Please choose a different name.");
                        request.getRequestDispatcher("/View/CreateProduct.jsp").forward(request, response);
                        return;
                    }
                    String[] context = request.getServletContext().getRealPath("").split("target");
                    String realPath = context[0] + "src" + File.separator + "main" + File.separator
                            + "webapp" + File.separator + "Image" + File.separator + "Product";
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
                    String productIDUpdate = request.getParameter("productID");
                    String updatedProductName = request.getParameter("productName");
                    String updatedDescription = request.getParameter("description");
                    String priceStr = request.getParameter("price");
                    try {
                        int updatedPrice = Integer.parseInt(priceStr);
                        if (productDAO.checkNameUpdate(updatedProductName, productIDUpdate)) {
                            response.getWriter().write("DuplicateName");
                            return;
                        }
                        Product proUpdate = new Product(productIDUpdate, updatedProductName, updatedDescription, updatedPrice);
                        boolean successIsSale = productDAO.updateProduct(proUpdate);
                        response.getWriter().write(successIsSale ? "Success" : "Error updating product");
                        System.out.println(successIsSale);
                    } catch (NumberFormatException e) {
                        response.getWriter().write("InvalidPrice");
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
                case "deleteImage":
                    String imgID = request.getParameter("imgID");
                    String imgName = imageDAO.getImageName(imgID);
                    boolean checkDelete = imageDAO.deleteImg(imgID);
                    System.out.println("checkDelete: " + checkDelete);
                    System.out.println("Image name" + imgName);
                    if (checkDelete) {
                        String[] contextDelete = request.getServletContext().getRealPath("").split("target");
                        String imagePath = contextDelete[0] + "src" + File.separator + "main" + File.separator + "webapp"
                                + File.separator + "Image" + File.separator + "Product" + File.separator + imgName;
                        File imageFile = new File(imagePath);
                        if (imageFile.exists()) {
                            imageFile.delete();
                        }
                        response.getWriter().write("success");
                    } else {
                        response.getWriter().write("error");
                    }
                    break;
                case "updateImage":
                    String[] contextUpdate = request.getServletContext().getRealPath("").split("target");
                    String realPathUpdate = contextUpdate[0] + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "Image" + File.separator + "Product";
                    String idPUpdate = request.getParameter("id");
                    ArrayList<String> imageNamesUpdate = new ArrayList<>();
                    for (Part part : request.getParts()) {
                        if (part.getName().equals("selectedFiles") && part.getSize() > 0) {
                            String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                            part.write(realPathUpdate + File.separator + fileName);
                            imageNamesUpdate.add(fileName);
                        }
                    }
                    String imageStringUpdate = String.join(",", imageNamesUpdate);
                    int updateImage = imageDAO.insertImageID(imageStringUpdate, idPUpdate);
                    System.out.println("Update imgggggggggggggggggggtg" + updateImage);
                    response.sendRedirect(request.getHeader("Referer"));
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
                    break;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ManageProductController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}