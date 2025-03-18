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

/**
 *
 * @author Le Minh Loc CE180992
 */
public class AddToCartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        if (customer == null) {
            response.sendRedirect("View/LoginCustomer.jsp");
            return;
        }

        String customerID = customer.getCustomerID();
        String productID = request.getParameter("productID");
        String sizeName = request.getParameter("size");
        String colorName = request.getParameter("color");
        String quantityStr = request.getParameter("quantity");

        if (customerID == null || productID == null || sizeName == null || colorName == null || quantityStr == null) {
            response.sendRedirect("View/ProductDetail.jsp?error=MissingData");
            return;
        }

        int quantity = Integer.parseInt(quantityStr);
        String proVariantID = null;

        try ( Connection conn = DBContext.getConn()) {
            // 🔹 Truy vấn proVariantID từ database dựa trên sizeName, colorName, productID
            String variantQuery = "SELECT pv.proVariantID FROM dbo.ProductVariants pv "
                    + "JOIN dbo.Size s ON pv.sizeID = s.sizeID "
                    + "JOIN dbo.Color c ON pv.colorID = c.colorID "
                    + "WHERE s.sizeName = ? AND c.colorName = ? AND pv.productID = ?";
            PreparedStatement variantPs = conn.prepareStatement(variantQuery);
            variantPs.setString(1, sizeName);
            variantPs.setString(2, colorName);
            variantPs.setString(3, productID);

            ResultSet variantRs = variantPs.executeQuery();
            if (variantRs.next()) {
                proVariantID = variantRs.getString("proVariantID");
            }

            if (proVariantID == null) {
                response.sendRedirect("View/ProductDetail.jsp?error=InvalidVariant");
                return;
            }

            // 🔹 Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            String checkSql = "SELECT quantity FROM Cart WHERE customerID = ? AND productID = ? AND proVariantID = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, customerID);
            checkPs.setString(2, productID);
            checkPs.setString(3, proVariantID);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Nếu sản phẩm đã có, cập nhật số lượng
                int existingQuantity = rs.getInt("quantity");
                int newQuantity = existingQuantity + quantity;

                String updateSql = "UPDATE Cart SET quantity = ? WHERE customerID = ? AND productID = ? AND proVariantID = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newQuantity);
                updatePs.setString(2, customerID);
                updatePs.setString(3, productID);
                updatePs.setString(4, proVariantID);
                updatePs.executeUpdate();
            } else {
                // Nếu sản phẩm chưa có, thêm mới vào giỏ hàng
                String insertSql = "INSERT INTO Cart (customerID, productID, proVariantID, quantity) VALUES (?, ?, ?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setString(1, customerID);
                insertPs.setString(2, productID);
                insertPs.setString(3, proVariantID);
                insertPs.setInt(4, quantity);
                insertPs.executeUpdate();
            }

            // Chuyển hướng về trang sản phẩm kèm thông báo thành công
            response.sendRedirect("View/Product?id=" + productID + "&message=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("View/ProductDetail.jsp?error=DatabaseError");
        }
    }
}
