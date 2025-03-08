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

    private int cartID;
    private int customerID;
    private int proVariantID;
    private int productID;
    private int quantity;

 
    
    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(int proVariantID) {
        this.proVariantID = proVariantID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
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

    public Cart(int cartID, int customerID, int proVariantID, int productID, int quantity) {
        this.cartID = cartID;
        this.customerID = customerID;
        this.proVariantID = proVariantID;
        this.productID = productID;
        this.quantity = quantity;
    }
}