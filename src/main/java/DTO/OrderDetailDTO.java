/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author PC
 */
public class OrderDetailDTO {
    private int quantity;
    private String productName;
    private double price;
    private String imgName;
    private String sizeName;
    private String status;

    public OrderDetailDTO(int quantity, String productName, double price, String imgName, String sizeName, String status) {
        this.quantity = quantity;
        this.productName = productName;
        this.price = price;
        this.imgName = imgName;
        this.sizeName = sizeName;
        this.status = status;
    }

    public int getQuantity() { return quantity; }
    public String getProductName() { return productName; }
    public double getPrice() { return price; }
    public String getImgName() { return imgName; }
    public String getSizeName() { return sizeName; }
    public String getStatus() { return status; }
}
