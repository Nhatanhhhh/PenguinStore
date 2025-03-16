/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author PC
 */
import java.io.Serializable;
import java.util.Date;

public class OrderDetail implements Serializable {

    private String orderDetailID;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private Date dateOrder;
    private String orderID;
    private String productVariantID;

    public OrderDetail() {
    }

    public OrderDetail(String orderDetailID, int quantity, double unitPrice, double totalPrice, Date dateOrder, String orderID, String productVariantID) {
        this.orderDetailID = orderDetailID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.dateOrder = dateOrder;
        this.orderID = orderID;
        this.productVariantID = productVariantID;
    }

    public String getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(String orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getDateOrder() {
        return dateOrder;
    }

    public void setDateOrder(Date dateOrder) {
        this.dateOrder = dateOrder;
    }

    public String getOrderID() {
        return orderID;
    }

    public void setOrderID(String orderID) {
        this.orderID = orderID;
    }

    public String getProductVariantID() {
        return productVariantID;
    }

    public void setProductVariantID(String productVariantID) {
        this.productVariantID = productVariantID;
    }
}
