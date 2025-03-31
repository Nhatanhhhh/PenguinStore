package Models;

import java.util.List;
import Models.CartItem;

public class TempOrder {

    private final String customerID;
    private final List<CartItem> cartItems;
    private final String voucherID;
    private final double subtotal;
    private final double discount;
    private final double total;

    public TempOrder(String customerID, List<CartItem> cartItems,
            String voucherID, double subtotal,
            double discount, double total) {
        this.customerID = customerID;
        this.cartItems = cartItems;
        this.voucherID = voucherID;
        this.subtotal = subtotal;
        this.discount = discount;
        this.total = total;
    }

    // Getter methods remain the same
    public String getCustomerID() {
        return customerID;
    }

    public List<CartItem> getCartItems() {
        return cartItems;
    }

    public String getVoucherID() {
        return voucherID;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public double getDiscount() {
        return discount;
    }

    public double getTotal() {
        return total;
    }
}
