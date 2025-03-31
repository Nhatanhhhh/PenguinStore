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
    private String proVariantID; // Bổ sung thêm trường proVariantID

    // Các constructor hiện có (giữ nguyên)
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

    // Constructor mới bổ sung để phù hợp với DAO
    public CartItem(String cartID, String productID, String proVariantID, String productName,
            double price, int quantity, String sizeName, String colorName, String imgName) {
        this.cartID = cartID;
        this.productID = productID;
        this.proVariantID = proVariantID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.sizeName = sizeName;
        this.colorName = colorName;
        this.imgNames = imgName;
    }

    // Constructor mặc định
    public CartItem() {
    }

    // Thêm getter và setter cho proVariantID
    public String getProVariantID() {
        return proVariantID;
    }

    public void setProVariantID(String proVariantID) {
        this.proVariantID = proVariantID;
    }

    // Các getter và setter hiện có (giữ nguyên)
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

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public String getImgNames() {
        return imgNames;
    }

    public void setImgNames(String imgNames) {
        this.imgNames = imgNames;
    }

    // Phương thức lấy ảnh đầu tiên từ danh sách ảnh
    public String getFirstImage() {
        if (imgNames != null && !imgNames.isEmpty()) {
            String[] images = imgNames.split(", ");
            return images.length > 0 ? images[0] : "default.jpg";
        }
        return "default.jpg";
    }
}
