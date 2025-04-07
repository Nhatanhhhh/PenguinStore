package Controller;

import DB.DBContext;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

//@WebServlet("/api/products/search")
@WebServlet("/Products/ChatBot/Search")
public class ProductSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cấu hình CORS
        response.setHeader("Access-Control-Allow-Origin", "http://localhost:9999");
        response.setHeader("Access-Control-Allow-Methods", "GET");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setHeader("Access-Control-Allow-Credentials", "true");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            System.out.println("Received request with query: " + request.getQueryString());

            String query = request.getParameter("q");
            if (query == null || query.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Query parameter is required\"}");
                return;
            }

            List<Map<String, Object>> products = searchProducts(query);
            String jsonResponse = new Gson().toJson(products);
            System.out.println("Sending response: " + jsonResponse);

            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    private List<Map<String, Object>> searchProducts(String query) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        String normalizedQuery = normalizeSearchQuery(query);
        String searchPattern = "%" + normalizedQuery + "%";

        try ( Connection conn = DBContext.getConn()) {
            String sql = "SELECT p.*, "
                    + "(SELECT STRING_AGG(CAST(c.colorName AS NVARCHAR(MAX)), ', ') "
                    + " FROM ProductVariants pv JOIN Color c ON pv.colorID = c.colorID "
                    + " WHERE pv.productID = p.productID) AS availableColors, "
                    + "(SELECT STRING_AGG(CAST(s.sizeName AS NVARCHAR(MAX)), ', ') "
                    + " FROM ProductVariants pv LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                    + " WHERE pv.productID = p.productID AND s.sizeName IS NOT NULL) AS availableSizes, "
                    + "(SELECT SUM(pv.stockQuantity) FROM ProductVariants pv WHERE pv.productID = p.productID) AS stockTotal "
                    + "FROM Product p "
                    + "WHERE LOWER(p.productName) LIKE LOWER(?) OR "
                    + "LOWER(REPLACE(p.productName, ' ', '')) LIKE LOWER(?) "
                    + "ORDER BY CASE "
                    + "  WHEN LOWER(p.productName) = LOWER(?) THEN 0 "
                    + "  WHEN LOWER(p.productName) LIKE LOWER(?) THEN 1 "
                    + "  ELSE 2 END";

            try ( PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, searchPattern);
                stmt.setString(2, "%" + normalizedQuery + "%");
                stmt.setString(3, query.toLowerCase());
                stmt.setString(4, query.toLowerCase() + "%");

                try ( ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> product = new HashMap<>();
                        product.put("productID", rs.getString("productID"));
                        product.put("productName", rs.getString("productName"));
                        product.put("price", rs.getDouble("price"));
                        product.put("isSale", rs.getBoolean("isSale"));
                        product.put("description", rs.getString("description"));
                        product.put("stockTotal", rs.getInt("stockTotal"));
                        product.put("availableSizes", rs.getString("availableSizes"));
                        product.put("availableColors", rs.getString("availableColors"));
                        product.put("dateCreate", rs.getTimestamp("dateCreate"));
                        products.add(product);
                    }
                }
            }
        }
        return products;
    }

    private String normalizeSearchQuery(String query) {
        return query.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("đ", "d")
                .replaceAll("[^a-z0-9]", "");
    }
}
