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

        // Kiểm tra action có null không trước khi xử lý
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
                request.setAttribute("proVariantID", proVariantID);
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
                break;

            case "restockHistory":
                ArrayList<Restock> restockHistory = restockDAO.getRestockHistory();
                request.setAttribute("restockHistory", restockHistory);
                request.getRequestDispatcher("/View/RestockHistory.jsp").forward(request, response);
                for (Restock restock : restockHistory) {
                    System.out.println(restock.getProductName()); // Kiểm tra dữ liệu có đủ 10 sản phẩm không
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
                || proVariantID.isEmpty() || quantityStr.isEmpty() || priceStr.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
            return;
        }

        try {
            int quantity = Integer.parseInt(quantityStr);
            double price = Double.parseDouble(priceStr);

            RestockDAO restockDAO = new RestockDAO();
            boolean success = restockDAO.restockProduct(proVariantID, quantity, price);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/Restock?action=restockHistory");
            } else {
                request.setAttribute("errorMessage", "Restock failed! Please try again.");
                request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid quantity or price format!");
            request.getRequestDispatcher("/View/Restock.jsp").forward(request, response);
        }
    }
}
