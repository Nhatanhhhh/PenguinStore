/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAOs.FeedbackDAO;
import Models.Feedback;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Nhat_Anh
 */
public class CreateFeedbackController extends HttpServlet {

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
            out.println("<title>Servlet CreateFeedbackController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateFeedbackController at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
            response.sendRedirect("Login");
            return;
        }

        Models.Customer customer = (Models.Customer) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        String productID = request.getParameter("productID");
        String orderID = request.getParameter("orderID");
        String comment = request.getParameter("review");
        String ratingParam = request.getParameter("rating-" + productID);

        System.out.println("Message: " + session.getAttribute("message"));
        System.out.println("Message Type: " + session.getAttribute("messageType"));

        if (productID == null || orderID == null || ratingParam == null || ratingParam.trim().isEmpty()) {
            session.setAttribute("message", "Please choose the number of stars and enter the assessment before sending!");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/View/Feedback.jsp");
            return;
        }

        double rating;
        try {
            rating = Double.parseDouble(ratingParam.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Rating is not valid");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/View/Feedback.jsp");
            return;
        }

        if (comment == null || comment.trim().length() < 10) {
            session.setAttribute("message", "The evaluation content needs at least 10 characters!");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/View/Feedback.jsp");
            return;
        }

        // Tạo feedback
        Feedback feedback = new Feedback();
        feedback.setFeedbackID(java.util.UUID.randomUUID().toString());
        feedback.setCustomerID(customerID);
        feedback.setProductID(productID);
        feedback.setOrderID(orderID);
        feedback.setComment(comment.trim());
        feedback.setRating(rating);
        feedback.setFeedbackCreateAt(new java.util.Date());
        feedback.setIsResolved(false);
        feedback.setIsViewed(false);

        boolean isSaved = FeedbackDAO.saveFeedback(feedback);

        if (isSaved) {
            session.setAttribute("message", "Send the success evaluation!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Send a failure assessment, please try again.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect("Feedback?orderID=" + orderID);
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
