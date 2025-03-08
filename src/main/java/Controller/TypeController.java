package Controller;

import DAOs.CategoryDAO;
import DAOs.TypeDAO;
import Models.Category;
import Models.Type;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Objects;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * TypeController - Manages CRUD operations for product types.
 *
 * @author Do Van Luan
 */
@WebServlet(name = "TypeController", urlPatterns = {"/Type"})
public class TypeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TypeDAO typeDAO = new TypeDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        ArrayList<Category> categoryList = categoryDAO.getAll();

        if (Objects.isNull(action)) {
            action = "list"; // Default to listing types
        }

        switch (action) {
            case "list":
                ArrayList<Type> typeList = typeDAO.getAll();
                request.setAttribute("typeList", typeList);
                request.getRequestDispatcher("/View/ListType.jsp").forward(request, response);
                break;

            case "edit":
                String typeID = request.getParameter("id");

                System.out.println("Received typeID: " + typeID);
                System.out.println("Query String: " + request.getQueryString());

                if (typeID == null || typeID.trim().isEmpty()) {
                    request.getRequestDispatcher("/View/ListType.jsp").forward(request, response);
                    return;
                }

                Type existingType = typeDAO.getOnlyById(typeID);

                if (existingType == null) {
                    request.getRequestDispatcher("/View/ListType.jsp").forward(request, response);
                    return;
                }

                // Gửi cả type và danh sách category sang JSP
                request.setAttribute("type", existingType);
                request.setAttribute("categoryList", categoryList);
                request.getRequestDispatcher("/View/EditType.jsp").forward(request, response);
                break;

            case "create":

                request.setAttribute("categoryList", categoryList);
                request.getRequestDispatcher("/View/CreateType.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Type?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TypeDAO typeDAO = new TypeDAO();

        if (Objects.isNull(action)) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                ArrayList<Type> typeList = typeDAO.getAll();
                request.setAttribute("typeList", typeList);
                request.getRequestDispatcher("/View/ListType.jsp").forward(request, response);
                break;

            case "create":

                String typeName = request.getParameter("typeName");
                String categoryID = request.getParameter("categoryID");

                if (typeName == null || typeName.trim().isEmpty() || categoryID == null || categoryID.trim().isEmpty()) {
                    request.setAttribute("error", "Please Enter your data.");
                    request.getRequestDispatcher("/View/CreateType.jsp").forward(request, response);
                    return;
                }

                Type newType = new Type(null, categoryID, typeName);

                int rowsAffected = typeDAO.create(newType);
                System.out.println("gia tri create tra ve: " + rowsAffected);
                // Check result
                if (rowsAffected > 0) {
                    response.sendRedirect(request.getContextPath() + "/Type?action=list");
                } else {
                    request.setAttribute("error", "Create invalue! Phease try again.");
                    request.getRequestDispatcher("/View/CreateType.jsp").forward(request, response);
                }
                break;

            case "edit":

                String typeID = request.getParameter("typeID");
                String updatedTypeName = request.getParameter("typeName");
                String updatedCategoryID = request.getParameter("categoryID");

                Type updatedType = new Type(typeID, updatedCategoryID, updatedTypeName);
                typeDAO.update(updatedType);

                response.sendRedirect(request.getContextPath() + "/Type?action=list");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Type?action=list");
                break;
        }

    }

}