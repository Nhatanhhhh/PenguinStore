package Controller;

import DB.DBContext;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AddToCartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("Invalid request method");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("getVariant".equals(action)) {
            handleGetVariant(request, response);
            return;
        }
        
        // Xử lý thêm vào giỏ hàng
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (customer == null) {
            String productID = request.getParameter("productID");
            String redirectUrl = "View/LoginCustomer.jsp?redirect=ProductDetail.jsp";
            if (productID != null) {
                redirectUrl += "?id=" + productID;
            }
            response.sendRedirect(redirectUrl);
            return;
        }

        String customerID = customer.getCustomerID();
        String productID = request.getParameter("productID");
        String variantId = request.getParameter("selectedVariantId");
        String quantityStr = request.getParameter("quantity");

        // Kiểm tra dữ liệu đầu vào
        if (productID == null || productID.isEmpty() ||
            variantId == null || variantId.isEmpty() || 
            quantityStr == null || quantityStr.isEmpty()) {
            
            response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=InvalidInput");
            return;
        }

        try {
            int quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=InvalidQuantity");
                return;
            }

            try (Connection conn = DBContext.getConn()) {
                // Kiểm tra tồn tại variant
                if (!isVariantValid(conn, productID, variantId)) {
                    response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=InvalidVariant");
                    return;
                }

                // Kiểm tra tồn tại sản phẩm trong giỏ hàng
                String checkSql = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
                try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                    checkPs.setString(1, customerID);
                    checkPs.setString(2, productID);
                    checkPs.setString(3, variantId);
                    
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next()) {
                            // Cập nhật số lượng nếu đã có
                            int existingQuantity = rs.getInt("quantity");
                            int newQuantity = existingQuantity + quantity;
                            
                            String updateSql = "UPDATE Cart SET quantity = ? WHERE customerID = ? AND productID = ? AND proVariantID = ?";
                            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                                updatePs.setInt(1, newQuantity);
                                updatePs.setString(2, customerID);
                                updatePs.setString(3, productID);
                                updatePs.setString(4, variantId);
                                updatePs.executeUpdate();
                            }
                        } else {
                            // Thêm mới nếu chưa có
                            String insertSql = "INSERT INTO Cart (customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                                insertPs.setString(1, customerID);
                                insertPs.setString(2, productID);
                                insertPs.setString(3, variantId);
                                insertPs.setInt(4, quantity);
                                insertPs.executeUpdate();
                            }
                        }
                    }
                }

                // Thành công - redirect về trang sản phẩm
                response.sendRedirect("Product?action=detail&id=" + productID + "&message=success");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=InvalidQuantity");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=DatabaseError");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ProductDetail.jsp?id=" + productID + "&error=SystemError");
        }
    }

    private void handleGetVariant(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String productID = request.getParameter("productID");
        String sizeName = request.getParameter("size");
        String colorName = request.getParameter("color");
        
        // Kiểm tra dữ liệu đầu vào
        if (productID == null || productID.isEmpty() || colorName == null || colorName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        try (Connection conn = DBContext.getConn()) {
            String variantQuery = "SELECT pv.proVariantID FROM ProductVariants pv "
                    + "LEFT JOIN Size s ON pv.sizeID = s.sizeID "
                    + "LEFT JOIN Color c ON pv.colorID = c.colorID "
                    + "WHERE pv.productID = ? "
                    + "AND (s.sizeName = ? OR (? = '' AND s.sizeName IS NULL)) "
                    + "AND c.colorName = ?";

            try (PreparedStatement variantPs = conn.prepareStatement(variantQuery)) {
                variantPs.setString(1, productID);
                variantPs.setString(2, sizeName != null ? sizeName : "");
                variantPs.setString(3, sizeName != null ? sizeName : "");
                variantPs.setString(4, colorName);

                try (ResultSet variantRs = variantPs.executeQuery()) {
                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    
                    if (variantRs.next()) {
                        String proVariantID = variantRs.getString("proVariantID");
                        response.getWriter().write(proVariantID != null ? proVariantID : "null");
                    } else {
                        response.getWriter().write("null");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System error");
        }
    }

    private boolean isVariantValid(Connection conn, String productID, String variantId) 
            throws SQLException {
        String checkSql = "SELECT 1 FROM ProductVariants WHERE productID = ? AND proVariantID = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, productID);
            ps.setString(2, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
