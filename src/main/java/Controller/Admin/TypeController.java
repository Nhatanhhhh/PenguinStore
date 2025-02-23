package Controller.Admin;

import DAOs.TypeDAO;
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

        if (Objects.isNull(action)) {
            action = "list"; // Default to listing types
        }

        switch (action) {
            case "list":
                ArrayList<Type> typeList = typeDAO.getAll();
                request.setAttribute("typeList", typeList);
                request.getRequestDispatcher("/View/Admin/TypeProduct/ListType.jsp").forward(request, response);
                break;

            case "edit":
                String typeID = request.getParameter("id");
                System.out.println("Received typeID: " + typeID);
                System.out.println("Query String: " + request.getQueryString());

                if (typeID == null || typeID.trim().isEmpty()) {
                    request.getRequestDispatcher("/View/Admin/TypeProduct/EditType.jsp").forward(request, response);

                    return;
                }

                Type existingType = typeDAO.getOnlyById(typeID);  // ID ? ?�y l� chu?i

                if (existingType == null) {
                    request.getRequestDispatcher("/View/Admin/TypeProduct/EditType.jsp").forward(request, response);

                    return;
                }

                request.setAttribute("type", existingType);
                request.getRequestDispatcher("/View/Admin/TypeProduct/EditType.jsp").forward(request, response);

                break;

            case "create":
                request.getRequestDispatcher("/View/Admin/TypeProduct/CreateType.jsp").forward(request, response);
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
                request.getRequestDispatcher("/View/Admin/TypeProduct/ListType.jsp").forward(request, response);
                break;

            case "create":
                // L?y d? li?u t? form
                String typeName = request.getParameter("typeName");
                String categoryID = request.getParameter("categoryID");

                // Ki?m tra d? li?u ??u v�o c� h?p l? kh�ng
                if (typeName == null || typeName.trim().isEmpty() || categoryID == null || categoryID.trim().isEmpty()) {
                    request.setAttribute("error", "Vui l�ng nh?p ??y ?? th�ng tin.");
                    request.getRequestDispatcher("/View/Admin/TypeProduct/CreateType.jsp").forward(request, response);
                    return;
                }

                // T?o ??i t??ng Type (typeID l� null v� s? t? ??ng sinh ra trong DB n?u c� auto-increment)
                Type newType = new Type(null, categoryID, typeName);

                // Th?c hi?n th�m v�o DB
                int rowsAffected = typeDAO.create(newType);
                System.out.println("gia tri create tra ve: " + rowsAffected);
                // Ki?m tra k?t qu?
                if (rowsAffected > 0) {
                    response.sendRedirect(request.getContextPath() + "/Type?action=list");
                } else {
                    request.setAttribute("error", "Th�m lo?i s?n ph?m th?t b?i. Vui l�ng th? l?i.");
                    request.getRequestDispatcher("/View/Admin/TypeProduct/CreateType.jsp").forward(request, response);
                }
                break;

            case "edit":
                // L?y d? li?u t? form
                String typeID = request.getParameter("typeID");
                String updatedTypeName = request.getParameter("typeName");
                String updatedCategoryID = request.getParameter("categoryID");

                // ??m b?o th? t? tham s? ?�ng theo constructor (typeID, categoryID, typeName)
                Type updatedType = new Type(typeID, updatedCategoryID, updatedTypeName);
                typeDAO.update(updatedType);

                // Chuy?n h??ng v? danh s�ch sau khi ch?nh s?a
                response.sendRedirect(request.getContextPath() + "/Type?action=list");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Type?action=list");
                break;
        }

    }

}
