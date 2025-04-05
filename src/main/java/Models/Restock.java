/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class Restock {

    private String productName;
    private String productID;
    private String restockID;
    private String proVariantID;
    private int quantity;
    private double price;
    private double totalCost;
    private LocalDate restockDate;
    private String sizeName;
    private String colorName;

    public Restock(String productName, String restockID, String proVariantID, int quantity, double price, double totalCost, LocalDate restockDate, String sizeName, String colorName) {
        this.productName = productName;
        this.restockID = restockID;
        this.proVariantID = proVariantID;
        this.quantity = quantity;
        this.price = price;
        this.totalCost = totalCost;
        this.restockDate = restockDate;
        this.sizeName = sizeName;
        this.colorName = colorName;
    }

    public Restock(String productName, String restockID, String proVariantID, int quantity, double price, double totalCost, LocalDate restockDate) {
        this.productName = productName;
        this.restockID = restockID;
        this.proVariantID = proVariantID;
        this.quantity = quantity;
        this.price = price;
        this.totalCost = totalCost;
        this.restockDate = restockDate;
    }

    public Restock(String productName, String proVariantID, String sizeName, String colorName) {
        this.productName = productName;
        this.proVariantID = proVariantID;
        this.sizeName = sizeName;
        this.colorName = colorName;
    }

    public Restock(String productID) {
        this.productID = productID;
        
    }

    
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public LocalDate getRestockDate() {
        return restockDate;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public void setRestockDate(LocalDate restockDate) {
        this.restockDate = restockDate;
    }

    public Restock(String restockID, String proVariantID, int quantity, double price, double totalCost, LocalDate restockDate) {
        this.restockID = restockID;
        this.proVariantID = proVariantID;
        this.quantity = quantity;
        this.price = price;
        this.totalCost = totalCost;
        this.restockDate = restockDate;
    }

    public String getRestockID() {
        return restockID;
    }

    public void setRestockID(String restockID) {
        this.restockID = restockID;
    }

    public String getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(String proVariantID) {
        this.proVariantID = proVariantID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public LocalDate getRestockDay() {
        return restockDate;
    }

    public void setRestockDay(LocalDate restockDay) {
        this.restockDate = restockDate;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

}
