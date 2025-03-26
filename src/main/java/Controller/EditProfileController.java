package Controller;

import DAOs.ProductDAO;
import DAOs.TypeDAO;
import DAOs.UpdateProfileDAO;
import Models.Customer;
import Models.Type;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "EditProfileController", urlPatterns = {"/EditProfile"})
public class EditProfileController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditProfileController.class.getName());

    // Định dạng kiểm tra hợp lệ
    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-zÀ-ỹ ]{2,50}$"); // Tên phải có chữ cái và tối thiểu 2 ký tự
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9,10}$"); // Bắt đầu bằng 0 và có độ dài 10-11 số
    private static final Pattern ZIP_PATTERN = Pattern.compile("^\\d{4,6}$"); // ZIP code phải là số từ 4-6 chữ số
    private static final int MIN_ADDRESS_LENGTH = 5; // Địa chỉ phải có ít nhất 5 ký tự

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        TypeDAO typeDAO = new TypeDAO();
        request.setAttribute("listProduct", productDAO.getProductCustomer());
        List<Type> listType = typeDAO.getAll();
        Map<String, List<Type>> categoryMap = new LinkedHashMap<>();
        for (Type type : listType) {
            categoryMap.computeIfAbsent(type.getCategoryName(), k -> new ArrayList<>()).add(type);
        }
        request.setAttribute("categoryMap", categoryMap);
        request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");

        if (customer == null) {
            LOGGER.log(Level.WARNING, "Người dùng chưa đăng nhập.");
            session.setAttribute("errorMessage", "Invalid session. Please log in again.");
            response.sendRedirect("Login");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName").trim();
        String phone = request.getParameter("phoneNumber").trim();
        String address = request.getParameter("address").trim();
        String state = request.getParameter("state").trim();
        String zip = request.getParameter("zip").trim();

        // Kiểm tra dữ liệu nhập vào
        if (!validateFullName(fullName)) {
            session.setAttribute("errorMessage", "Invalid name. Only letters and spaces are allowed (min 2 characters).");
            response.sendRedirect("View/EditProfile.jsp");
            return;
        }

        if (!validatePhone(phone)) {
            session.setAttribute("errorMessage", "Invalid phone number. Must start with 0 and be 10-11 digits.");
            response.sendRedirect("View/EditProfile.jsp");
            return;
        }

        if (!validateAddress(address)) {
            session.setAttribute("errorMessage", "Address must be at least 5 characters.");
            response.sendRedirect("View/EditProfile.jsp");
            return;
        }

        if (!validateZip(zip)) {
            session.setAttribute("errorMessage", "ZIP Code must be a number between 4-6 digits.");
            response.sendRedirect("View/EditProfile.jsp");
            return;
        }

        // Kiểm tra xem có thay đổi dữ liệu hay không
        boolean hasChanges = false;
        StringBuilder changeDetails = new StringBuilder("Updated fields: ");

        if (!fullName.equals(customer.getFullName())) {
            customer.setFullName(fullName);
            hasChanges = true;
            changeDetails.append("Full Name, ");
        }

        if (!phone.equals(customer.getPhoneNumber())) {
            customer.setPhoneNumber(phone);
            hasChanges = true;
            changeDetails.append("Phone, ");
        }

        if (!address.equals(customer.getAddress())) {
            customer.setAddress(address);
            hasChanges = true;
            changeDetails.append("Address, ");
        }

        if (!state.equals(customer.getState())) {
            customer.setState(state);
            hasChanges = true;
            changeDetails.append("State, ");
        }

        if (!zip.equals(customer.getZip())) {
            customer.setZip(zip);
            hasChanges = true;
            changeDetails.append("ZIP Code, ");
        }

        if (!hasChanges) {
            session.setAttribute("errorMessage", "No changes detected in your profile.");
            response.sendRedirect("View/EditProfile.jsp");
            return;
        }

        // Thực hiện cập nhật thông tin vào database
        UpdateProfileDAO updateProfileDAO = new UpdateProfileDAO();
        try {
            boolean isUpdated = updateProfileDAO.updateCustomer(customer);
            if (isUpdated) {
                session.setAttribute("user", customer);
                session.setAttribute("successMessage", changeDetails.substring(0, changeDetails.length() - 2) + " successfully.");
            } else {
                session.setAttribute("errorMessage", "Profile update failed. Please try again.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database update error", ex);
            session.setAttribute("errorMessage", "Database error occurred! Please try again later.");
        }

        response.sendRedirect("View/EditProfile.jsp");
    }

    // Hàm kiểm tra họ và tên
    private boolean validateFullName(String fullName) {
        return NAME_PATTERN.matcher(fullName).matches();
    }

    // Hàm kiểm tra số điện thoại
    private boolean validatePhone(String phone) {
        return PHONE_PATTERN.matcher(phone).matches();
    }

    // Hàm kiểm tra địa chỉ
    private boolean validateAddress(String address) {
        return address.length() >= MIN_ADDRESS_LENGTH;
    }

    // Hàm kiểm tra ZIP Code
    private boolean validateZip(String zip) {
        return ZIP_PATTERN.matcher(zip).matches();
    }
}
