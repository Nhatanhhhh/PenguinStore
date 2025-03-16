/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author LocLM
 */
public class Cart {

    private String cartID;
    private String customerID;
    private String proVariantID;
    private String productID;
    private int quantity;

    public String getCartID() {
        return cartID;
    }

    public void setCartID(String cartID) {
        this.cartID = cartID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(String proVariantID) {
        this.proVariantID = proVariantID;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Cart() {
    }

    public Cart(String cartID, String customerID, String proVariantID, String productID, int quantity) {
        this.cartID = cartID;
        this.customerID = customerID;
        this.proVariantID = proVariantID;
        this.productID = productID;
        this.quantity = quantity;
    }

    public Cart(String customerID, String productID, String proVariantID, int quantity) {
        this.customerID = customerID;
        this.productID = productID;
        this.proVariantID = proVariantID;
        this.quantity = quantity;
    }
}