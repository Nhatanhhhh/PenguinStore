/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class StatisticProduct {

    private String timePeriod;
    private String productName;
    private String sizeName;
    private String colorName;
    private int soldQuantity;
    private int importedQuantity;

    public StatisticProduct(String timePeriod, String productName, String sizeName, String colorName, int soldQuantity, int importedQuantity) {
        this.timePeriod = timePeriod;
        this.productName = productName;
        this.sizeName = sizeName;
        this.colorName = colorName;
        this.soldQuantity = soldQuantity;
        this.importedQuantity = importedQuantity;
    }

    // Getters & Setters
    public String getTimePeriod() {
        return timePeriod;
    }

    public void setTimePeriod(String timePeriod) {
        this.timePeriod = timePeriod;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getImportedQuantity() {
        return importedQuantity;
    }

    public void setImportedQuantity(int importedQuantity) {
        this.importedQuantity = importedQuantity;
    }
}
