package Controller;

import DAOs.FeedbackDAO;
import Models.Feedback;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet handling viewing feedback list with logging and enhanced security.
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "ViewListFeedback", urlPatterns = {"/ViewListFeedback"})
public class ViewListFeedback extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewListFeedback.class.getName());

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewListFeedback</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewListFeedback at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        LOGGER.log(Level.INFO, "Processing GET request for ViewListFeedback");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt to feedback list");
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String role = (String) session.getAttribute("role");
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks();

        request.setAttribute("feedbacks", feedbacks);
        if ("ADMIN".equals(role)) {
            LOGGER.log(Level.INFO, "Admin is viewing feedback list");
            request.getRequestDispatcher("/View/ListFeedbackAdmin.jsp").forward(request, response);
        } else {
            LOGGER.log(Level.INFO, "Staff is viewing dashboard");
            request.getRequestDispatcher("/View/DashBoardForStaff.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles viewing and management of feedback list.";
    }
}
