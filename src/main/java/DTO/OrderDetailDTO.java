package DTO;

public class OrderDetailDTO {

    private String imgName;
    private String productName;
    private double unitPrice;
    private String colorName;
    private String sizeName;
    private int quantity;
    private double totalAmount;
    private double discountAmount;
    private double finalAmount;
    private String dateOrder;
    private String statusOrderName;
    private String fullName;

    public OrderDetailDTO(String imgName, String productName, double unitPrice, String colorName, String sizeName, int quantity, double totalAmount, double discountAmount, double finalAmount, String dateOrder, String statusOrderName) {
        this.imgName = imgName;
        this.productName = productName;
        this.unitPrice = unitPrice;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.dateOrder = dateOrder;
        this.statusOrderName = statusOrderName;
    }

    public OrderDetailDTO(String imgName, String productName, double unitPrice, String colorName, String sizeName, int quantity, double totalAmount, double discountAmount, double finalAmount, String dateOrder, String statusOrderName, String fullName) {
        this.imgName = imgName;
        this.productName = productName;
        this.unitPrice = unitPrice;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.dateOrder = dateOrder;
        this.statusOrderName = statusOrderName;
        this.fullName = fullName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getImgName() {
        return imgName;
    }

    public String getProductName() {
        return productName;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public String getColorName() {
        return colorName;
    }

    public String getSizeName() {
        return sizeName;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public String getDateOrder() {
        return dateOrder;
    }

    public String getStatusOrderName() {
        return statusOrderName;
    }
}
