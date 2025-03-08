/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import Models.Customer;
import Models.Feedback;
import Models.Product;
import Models.Size;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class FeedbackController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FeedbackController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FeedbackController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();

        List<Feedback> feedbackList = FeedbackDAO.getOrderedProductsForFeedback(customerID);
        System.out.println("Feedback List Size: " + feedbackList.size());
        Set<String> uniqueProducts = new HashSet<>();
        for (Feedback feedback : feedbackList) {
            System.out.println("Feedback Product ID: " + feedback.getProductID());
            uniqueProducts.add(feedback.getProductID());
        }
        System.out.println("Unique Products: " + uniqueProducts.size()); // Kiểm tra số lượng sản phẩm duy nhất
        request.setAttribute("feedbackList", feedbackList);

        // Duyệt qua danh sách feedback để lấy thông tin chi tiết sản phẩm
        for (Feedback feedback : feedbackList) {
            if (feedback.getProductID() != null) {
                Product product = FeedbackDAO.getProductByID(feedback.getProductID());
                Size size = FeedbackDAO.getSizeByProductVariant(feedback.getProductID());

                if (product != null) {
                    System.out.println("Product found: " + product.getProductName());
                    request.setAttribute("product_" + feedback.getProductID(), product);
                } else {
                    System.out.println("Product not found for ID: " + feedback.getProductID());
                }

                if (size != null) {
                    System.out.println("Size found: " + size.getSizeName());
                    request.setAttribute("size_" + feedback.getProductID(), size);
                } else {
                    System.out.println("Size not found for Product ID: " + feedback.getProductID());
                }
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("View/Feedback.jsp");
        dispatcher.forward(request, response);

        dispatcher.forward(request, response);
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("Error: User session is NULL, redirecting to login.");
            response.sendRedirect("Login");
            return;
        }

        Customer customer = (Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID(); // Lấy từ session
        String productID = request.getParameter("productID");
        String orderID = request.getParameter("orderID");
        String comment = request.getParameter("review");
        double rating = Double.parseDouble(request.getParameter("rating"));

        // Kiểm tra xem customerID có hợp lệ không
        if (customerID == null || customerID.trim().isEmpty()) {
            System.out.println("Error: customerID is NULL or empty.");
            response.sendRedirect("error.jsp");
            return;
        }
        LocalDate today = LocalDate.now();

        System.out.println("customerID: " + customerID);
        System.out.println("productID: " + productID);
        System.out.println("orderID: " + orderID);

        Feedback feedback = new Feedback();
        feedback.setFeedbackID(java.util.UUID.randomUUID().toString());
        feedback.setCustomerID(customerID);
        feedback.setProductID(productID);
        feedback.setOrderID(orderID);
        feedback.setComment(comment);
        feedback.setRating(rating);
        feedback.setFeedbackCreateAt(Date.valueOf(today)); 
        feedback.setIsResolved(false);
        feedback.setIsViewed(false);

        boolean isSaved = FeedbackDAO.saveFeedback(feedback);

        if (isSaved) {
            session.setAttribute("message", "Send feedback successfully!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Send feedback failure! Please try again.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect("Feedback");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
