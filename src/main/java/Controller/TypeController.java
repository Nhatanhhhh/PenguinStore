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
import java.util.List;

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
                String searchQuery = request.getParameter("search");

                List<Type> list;
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    list = typeDAO.searchTypes(searchQuery);
                } else {
                    int page = 1;
                    int recordsPerPage = 10;

                    if (request.getParameter("page") != null) {
                        page = Integer.parseInt(request.getParameter("page"));
                    }

                    int offset = (page - 1) * recordsPerPage;
                    list = typeDAO.getPaginatedList(offset, recordsPerPage);
                    int totalRecords = typeDAO.getTotalTypes();
                    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                }

                request.setAttribute("typeList", list);
                request.setAttribute("searchQuery", searchQuery);
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
                int page = 1; // Mặc định trang đầu tiên
                int recordsPerPage = 5; // Số loại sản phẩm hiển thị mỗi trang

                // Lấy trang từ request (nếu có) và xử lý lỗi nếu giá trị không hợp lệ
                try {
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        page = Integer.parseInt(pageParam);
                        if (page < 1) {
                            page = 1; // Không cho phép trang nh�? hơn 1
                        }
                    }
                } catch (NumberFormatException e) {
                    page = 1; // Nếu lỗi, quay v�? trang đầu tiên
                }

                int offset = (page - 1) * recordsPerPage;
                List<Type> list = typeDAO.getPaginatedList(offset, recordsPerPage);
                int totalRecords = typeDAO.getTotalTypes();
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

                if (totalPages == 0) {
                    totalPages = 1; // �?ảm bảo ít nhất có 1 trang để không lỗi giao diện
                }

                request.setAttribute("typeList", list);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);

                request.getRequestDispatcher("/View/ListType.jsp").forward(request, response);
                break;

            case "create":
                String typeName = request.getParameter("typeName");
                String categoryID = request.getParameter("categoryID");

                if (typeName == null || typeName.trim().isEmpty() || categoryID == null || categoryID.trim().isEmpty()) {
                    request.setAttribute("error", "Please enter your data.");
                    request.getRequestDispatcher("/View/CreateType.jsp").forward(request, response);
                    return;
                }

                if (typeDAO.isTypeNameExists(typeName)) {

                    response.sendRedirect(request.getContextPath() + "/Type?action=create");
                    request.setAttribute("error", "Type name already exists.");
                    return;
                }

                Type newType = new Type(null, categoryID, typeName);
                int rowsAffected = typeDAO.create(newType);

                if (rowsAffected > 0) {
                    response.sendRedirect(request.getContextPath() + "/Type?action=list");
                } else {
                    request.setAttribute("error", "Create failed! Please try again.");
                    request.getRequestDispatcher("/View/CreateType.jsp").forward(request, response);
                }
                break;

            case "edit":
                String typeID = request.getParameter("typeID");
                String updatedTypeName = request.getParameter("typeName");
                String updatedCategoryID = request.getParameter("categoryID");

                if (typeID == null || updatedTypeName == null || updatedCategoryID == null
                        || typeID.trim().isEmpty() || updatedTypeName.trim().isEmpty() || updatedCategoryID.trim().isEmpty()) {
                    request.setAttribute("error", "Please fill in all fields.");
                    request.getRequestDispatcher("/View/EditType.jsp").forward(request, response);
                    return;
                }

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
