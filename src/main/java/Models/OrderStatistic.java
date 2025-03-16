/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class OrderStatistic {

    private String orderDate;
    private int orderCount;

    public OrderStatistic(String orderDate, int orderCount) {
        this.orderDate = orderDate;
        this.orderCount = orderCount;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public int getOrderCount() {
        return orderCount;
    }
}
