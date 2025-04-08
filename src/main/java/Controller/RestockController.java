package Controller;

import DAOs.RestockDAO;
import Models.Restock;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 * Servlet xử lý nhập hàng (Restock)
 *
 * @author Do Van Luan - CE180457
 */
public class RestockController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String proVariantID = request.getParameter("id");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
            return;
        }

        RestockDAO restockDAO = new RestockDAO();

        switch (action) {
            case "restock":
                if (proVariantID == null || proVariantID.isEmpty()) {
                    response.sendRedirect("errorPage.jsp?message=Not have Product Detail");
                    return;
                }
                request.setAttribute("provariant", restockDAO.getOnlyById(proVariantID));
                request.setAttribute("proVariantID", proVariantID);
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
                break;

            case "restockHistory":
                ArrayList<Restock> restockHistory = restockDAO.getRestockHistory();
                request.setAttribute("restockHistory", restockHistory);
                request.getRequestDispatcher("/View/RestockHistory.jsp").forward(request, response);
                for (Restock restock : restockHistory) {
                    System.out.println(restock.getProductName());
                }
                request.setAttribute("restockHistory", restockHistory);

                break;

            default:
                response.sendRedirect(request.getContextPath() + "/ManageProduct?action=view");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String proVariantID = request.getParameter("proVariantID");
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");

        if (proVariantID == null || quantityStr == null || priceStr == null
                || proVariantID.trim().isEmpty() || quantityStr.trim().isEmpty() || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
            return;
        }

        try {
            int quantity = Integer.parseInt(quantityStr);
            double price = Double.parseDouble(priceStr);

            if (quantity <= 0) {
                request.setAttribute("errorMessage", "Quantity must be greater than 0!");
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
                return;
            }

            if (price <= 0) {
                request.setAttribute("errorMessage", "Price must be greater than 0!");
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
                return;
            }

            RestockDAO restockDAO = new RestockDAO();

          
            Restock restock = restockDAO.getIdProduct(proVariantID);
            if (restock == null) {
                request.setAttribute("errorMessage", "Invalid Product Variant ID!");
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
                return;
            }
            String productID = restock.getProductID();

            boolean success = restockDAO.restockProduct(proVariantID, quantity, price);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ManageProduct?id=" + productID + "&action=inventory");
            } else {
                request.setAttribute("errorMessage", "Restock failed! Please try again.");
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid quantity or price format!");
            request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
        }

    }
}