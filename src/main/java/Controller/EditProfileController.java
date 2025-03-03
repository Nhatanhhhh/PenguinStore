package Controller;

import DAOs.UpdateProfileDAO;
import Models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
@WebServlet(name = "EditProfileController", urlPatterns = {"/EditProfile"})
public class EditProfileController extends HttpServlet {

    private boolean validatePhone(String phone) {
        return phone.matches("^0\\d{9,10}$"); // Must start with 0, length of 10-11 digits
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");

        if (customer == null) {
            request.setAttribute("errorMessage", "Invalid session. Please log in again.");
            request.getRequestDispatcher("View/LoginCustomer.jsp").forward(request, response);
            return;
        }

        // Retrieve form data
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");

        // Validate input data
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Phone number cannot be empty.");
            request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
            return;
        }

        if (!validatePhone(phone)) {
            request.setAttribute("errorMessage", "Invalid phone number. Please enter a valid format (10-11 digits starting with 0).");
            request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Address cannot be empty.");
            request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
            return;
        }

        // Check if any data has changed
        boolean phoneChanged = !phone.equals(customer.getPhoneNumber());
        boolean addressChanged = !address.equals(customer.getAddress());
        boolean stateChanged = !state.equals(customer.getState());
        boolean zipChanged = !zip.equals(customer.getZip());
        boolean fullNameChanged = !fullName.equals(customer.getFullName());

        if (!phoneChanged && !addressChanged && !stateChanged && !zipChanged && !fullNameChanged) {
            request.setAttribute("errorMessage", "No changes detected in your profile information.");
            request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
            return;
        }

        // Update customer object with new data
        customer.setFullName(fullName);
        customer.setPhoneNumber(phone);
        customer.setAddress(address);
        customer.setState(state);
        customer.setZip(zip);

        // Update in the database
        UpdateProfileDAO userDAO = new UpdateProfileDAO();
        try {
            boolean isUpdated = userDAO.updateCustomer(customer);
            if (isUpdated) {
                session.setAttribute("user", customer);

                String successMessage = "Successfully updated: ";
                if (fullNameChanged) {
                    successMessage += "Full Name, ";
                }
                if (phoneChanged) {
                    successMessage += "Phone Number, ";
                }
                if (addressChanged) {
                    successMessage += "Address, ";
                }
                if (stateChanged) {
                    successMessage += "State, ";
                }
                if (zipChanged) {
                    successMessage += "ZIP Code, ";
                }
                successMessage = successMessage.substring(0, successMessage.length() - 2) + ".";

                request.setAttribute("successMessage", successMessage);
            } else {
                request.setAttribute("errorMessage", "Update failed. Please try again.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(EditProfileController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Database connection error! Please try again later.");
        }

        request.getRequestDispatcher("View/EditProfile.jsp").forward(request, response);
    }
}
