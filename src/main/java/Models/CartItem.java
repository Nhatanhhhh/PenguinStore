package Models;

public class CartItem {

    private String productID;
    private String cartID;
    private String productName;
    private double price;
    private int quantity;
    private String sizeName;
    private String colorName;
    private String imgNames; // Chuỗi chứa danh sách hình ảnh, phân tách bằng dấu phẩy

    public CartItem(String productName, double price, int quantity, String colorName, String imgNames) {
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.colorName = colorName;
        this.imgNames = imgNames;
    }
   public CartItem(String cartID, String productName, double price, int quantity, String colorName, String sizeName, String imgNames) {
         this.cartID = cartID;
         this.productName = productName;
         this.price = price;
         this.quantity = quantity;
         this.colorName = (colorName != null) ? colorName : "";
         this.sizeName = (sizeName != null) ? sizeName : "";
         this.imgNames = imgNames;
     }
   
    public CartItem(String productName, double price, int quantity, String sizeName, String colorName, String imgNames) {
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.sizeName = sizeName;
        this.colorName = colorName;
        this.imgNames = imgNames;
    }

    public CartItem(String cartID, String productName, double price, int quantity, String colorName, String imgNames) {
        this.cartID = cartID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.colorName = colorName;
        this.imgNames = imgNames;
    }

    public CartItem(String productID, String productName, double price, int quantity) {
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }

    public CartItem() {

    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getCartID() {
        return cartID;
    }

    public void setCartID(String cartID) {
        this.cartID = cartID;
    }

    public String getProductID() {
        return productID;
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

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public void setImgNames(String imgNames) {
        this.imgNames = imgNames;
    }

}
