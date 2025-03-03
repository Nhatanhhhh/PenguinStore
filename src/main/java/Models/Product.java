/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class Product {

    private String productID;
    private String productName;
    private String description;
    private double price;
    private String categoryName;
    private String imgName;
    private String typeName;
    private String typeID;

    public Product(String productID, String productName, String description, double price, String typeName, String categoryName, String imgName) {
        this.productID = productID;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.typeName = typeName;
        this.categoryName = categoryName;
        this.imgName = imgName;

    }

    public Product(String productName, String description, double price, String typeID) {
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.typeID = typeID;
    }

    public Product(String productID, String productName, double price) {
        this.productID = productID;
        this.productName = productName;
        this.price = price;
    }

    public Product() {
    }

    public String getTypeID() {
        return typeID;
    }

    public void setTypeID(String typeID) {
        this.typeID = typeID;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getImgName() {
        return imgName;
    }

    public void setImgName(String imgName) {
        this.imgName = imgName;
    }

}
