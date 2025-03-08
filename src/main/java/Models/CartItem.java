/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Models;

/**
 *
 * @author Loc_LM
 */
public class CartItem {
    private String productName;
    private double price;
    private String colorName;
    private int quantity;

    public CartItem(String productName, double price, String colorName, int quantity) {
        this.productName = productName;
        this.price = price;
        this.colorName = colorName;
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "Product: " + productName + " | Price: " + price + 
               " | Color: " + colorName + " | Quantity: " + quantity;
    }
}