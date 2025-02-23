/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author PC
 */
import java.io.Serializable;

public class ProductVariants implements Serializable {
    private String proVariantID;
    private String status;
    private int stockQuantity;
    private String productID;
    private String sizeID;
    private String colorID;

    public ProductVariants() {
    }

    public ProductVariants(String proVariantID, String status, int stockQuantity, String productID, String sizeID, String colorID) {
        this.proVariantID = proVariantID;
        this.status = status;
        this.stockQuantity = stockQuantity;
        this.productID = productID;
        this.sizeID = sizeID;
        this.colorID = colorID;
    }

    public String getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(String proVariantID) {
        this.proVariantID = proVariantID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getSizeID() {
        return sizeID;
    }

    public void setSizeID(String sizeID) {
        this.sizeID = sizeID;
    }

    public String getColorID() {
        return colorID;
    }

    public void setColorID(String colorID) {
        this.colorID = colorID;
    }
}
