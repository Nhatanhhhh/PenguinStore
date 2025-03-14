/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Le Minh Loc - CE180992
 */
import java.util.Date;

public class UsedVoucher {

    private String usedVoucherID;
    private String voucherID;
    private String customerID;
    private String voucherCode;
    private Date usedAt;
    private int status;
    private double discountPer;
    private double maxDiscountAmount;
    private double discountAmount;
    private double minOrderValue;
    private Date validFrom;
    private Date validUntil;

    // Constructor
    public UsedVoucher(String usedVoucherID, String voucherID, String customerID, Date usedAt, int status) {
        this.usedVoucherID = usedVoucherID;
        this.voucherID = voucherID;
        this.customerID = customerID;
        this.usedAt = usedAt;
        this.status = status;
    }

    public UsedVoucher(String usedVoucherID, String voucherID, String customerID, String voucherCode, Date usedAt, int status, double discountPer, double maxDiscountAmount, double discountAmount, double minOrderValue, Date validFrom, Date validUntil) {
        this.usedVoucherID = usedVoucherID;
        this.voucherID = voucherID;
        this.customerID = customerID;
        this.voucherCode = voucherCode;
        this.usedAt = usedAt;
        this.status = status;
        this.discountPer = discountPer;
        this.maxDiscountAmount = maxDiscountAmount;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.validFrom = validFrom;
        this.validUntil = validUntil;
    }

    // Constructor
    public UsedVoucher(String voucherID, double discountPer, double maxDiscountAmount, double discountAmount, double minOrderValue, Date validFrom, Date validUntil, int status) {
        this.voucherID = voucherID;
        this.discountPer = discountPer;
        this.maxDiscountAmount = maxDiscountAmount;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.validFrom = validFrom;
        this.validUntil = validUntil;
        this.status = status;
    }

    public UsedVoucher(String voucherCode, double discountPer, double maxDiscountAmount, double discountAmount, double minOrderValue) {
        this.voucherCode = voucherCode;
        this.discountPer = discountPer;
        this.maxDiscountAmount = maxDiscountAmount;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public double getDiscountPer() {
        return discountPer;
    }

    public void setDiscountPer(double discountPer) {
        this.discountPer = discountPer;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidUntil() {
        return validUntil;
    }

    // Getters and Setters
    public void setValidUntil(Date validUntil) {
        this.validUntil = validUntil;
    }

    public String getUsedVoucherID() {
        return usedVoucherID;
    }

    public void setUsedVoucherID(String usedVoucherID) {
        this.usedVoucherID = usedVoucherID;
    }

    public String getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(String voucherID) {
        this.voucherID = voucherID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public Date getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Date usedAt) {
        this.usedAt = usedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
