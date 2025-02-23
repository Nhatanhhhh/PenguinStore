/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductVariants {
    private String proVariantID;
    private boolean status;
    private int stockQuantity;
    private String sizeName;
    private String colorName;

    public ProductVariants() {
    }

    public ProductVariants(String proVariantID, boolean status, int stockQuantity, String colorName, String sizeName) {
        this.proVariantID = proVariantID;
        this.status = status;
        this.stockQuantity = stockQuantity;
        this.sizeName = sizeName;
        this.colorName = colorName;
    }

    public String getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(String proVariantID) {
        this.proVariantID = proVariantID;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
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
