/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Thuan
 */
public class OrderStatusStatistic {
    private String orderDate;
    private int completedOrders;
    private int deliveryFailed;
    private int canceledOrders;

    public OrderStatusStatistic() {
    }

    public OrderStatusStatistic(String orderDate, int completedOrders, int deliveryFailed, int canceledOrders) {
        this.orderDate = orderDate;
        this.completedOrders = completedOrders;
        this.deliveryFailed = deliveryFailed;
        this.canceledOrders = canceledOrders;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public int getCompletedOrders() {
        return completedOrders;
    }

    public void setCompletedOrders(int completedOrders) {
        this.completedOrders = completedOrders;
    }

    public int getDeliveryFailed() {
        return deliveryFailed;
    }

    public void setDeliveryFailed(int deliveryFailed) {
        this.deliveryFailed = deliveryFailed;
    }

    public int getCanceledOrders() {
        return canceledOrders;
    }

    public void setCanceledOrders(int canceledOrders) {
        this.canceledOrders = canceledOrders;
    }

    @Override
    public String toString() {
        return "OrderStatusStatistic{" + "orderDate=" + orderDate + ", completedOrders=" + completedOrders + ", deliveryFailed=" + deliveryFailed + ", canceledOrders=" + canceledOrders + '}';
    }

   
    
}
