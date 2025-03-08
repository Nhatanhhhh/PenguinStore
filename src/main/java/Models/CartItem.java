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
    private int quantity;
    private String colorName;
    private String imgNames; // Chuỗi chứa danh sách hình ảnh, phân tách bằng dấu phẩy

    public CartItem(String productName, double price, int quantity, String colorName, String imgNames) {
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.colorName = colorName;
        this.imgNames = imgNames;
    }

    public String getProductName() {
        return productName;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getColorName() {
        return colorName;
    }

    public String getImgNames() {
        return imgNames;
    }

    // Phương thức lấy ảnh đầu tiên từ danh sách ảnh
    public String getFirstImage() {
        if (imgNames != null && !imgNames.isEmpty()) {
            return imgNames.split(", ")[0]; // Lấy ảnh đầu tiên
        }
        return "default.jpg"; // Ảnh mặc định nếu không có ảnh nào
    }
}
