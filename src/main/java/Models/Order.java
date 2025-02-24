/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;
import java.util.Date;
/**
 *
 * @author PC
 */


/**
 * Model class for OrderHistory
 */
public class Order {
    private String orderID;
    private String customerID;
    private double totalAmount;
    private double discountAmount;
    private double finalAmount;
    private Date orderDate;
    private String statusOID;
    private String voucherID;

    // Getters and Setters
    public String getOrderID() { return orderID; }
    public void setOrderID(String orderID) { this.orderID = orderID; }

    public String getCustomerID() { return customerID; }
    public void setCustomerID(String customerID) { this.customerID = customerID; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public String getStatusOID() { return statusOID; }
    public void setStatusOID(String statusOID) { this.statusOID = statusOID; }

    public String getVoucherID() { return voucherID; }
    public void setVoucherID(String voucherID) { this.voucherID = voucherID; }
}
