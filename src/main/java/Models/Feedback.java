package Models;

import java.util.Date;

/**
 *
 * @author Nhat_Anh
 */
public class Feedback {

    private String feedbackID;
    private String customerID;
    private String productID;
    private String orderID;
    private String comment;
    private String customerName;
    private String getProductName;
    private double rating;
    private Date feedbackCreateAt;
    private boolean isResolved;
    private boolean isViewed;

    // Thuộc tính mới
    private String imgName;
    private double price;
    private String sizeName;

    public Feedback() {
    }

    public Feedback(String feedbackID, String customerID, String productID, String orderID, String comment, String customerName, String getProductName,
            double rating, Date feedbackCreateAt, boolean isResolved, boolean isViewed, String imgName, double price, String sizeName) {
        this.feedbackID = feedbackID;
        this.customerID = customerID;
        this.productID = productID;
        this.orderID = orderID;
        this.comment = comment;
        this.customerName = customerName;
        this.getProductName = getProductName;
        this.rating = rating;
        this.feedbackCreateAt = feedbackCreateAt;
        this.isResolved = isResolved;
        this.isViewed = isViewed;
        this.imgName = imgName;
        this.price = price;
        this.sizeName = sizeName;
    }

    public String getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(String feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getOrderID() {
        return orderID;
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductName() {  // Đổi từ getGetProductName thành getProductName
        return getProductName;
    }

    public void setProductName(String productName) {  // Đổi từ setGetProductName thành setProductName
        this.getProductName = productName;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public Date getFeedbackCreateAt() {
        return feedbackCreateAt;
    }

    public void setFeedbackCreateAt(Date feedbackCreateAt) {
        this.feedbackCreateAt = feedbackCreateAt;
    }

    public boolean isIsResolved() {
        return isResolved;
    }

    public void setIsResolved(boolean isResolved) {
        this.isResolved = isResolved;
    }

    public boolean isIsViewed() {
        return isViewed;
    }

    public void setIsViewed(boolean isViewed) {
        this.isViewed = isViewed;
    }

    // Getter và Setter mới
    public String getImgName() {
        return imgName;
    }

    public void setImgName(String imgName) {
        this.imgName = imgName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    @Override
    public String toString() {
        return "Feedback{"
                + "feedbackID='" + feedbackID + '\''
                + ", customerID='" + customerID + '\''
                + ", productID='" + productID + '\''
                + ", orderID='" + orderID + '\''
                + ", comment='" + comment + '\''
                + ", customerName='" + customerName + '\''
                + ", getProductName='" + getProductName + '\''
                + ", rating=" + rating
                + ", feedbackCreateAt=" + feedbackCreateAt
                + ", isResolved=" + isResolved
                + ", isViewed=" + isViewed
                + ", imgName='" + imgName + '\''
                + ", price=" + price
                + ", sizeName='" + sizeName + '\''
                + '}';
    }
}
