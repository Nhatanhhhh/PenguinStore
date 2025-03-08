/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;
/**
 *
 * @author Do Van Luan - CE180457
 */
public class Voucher {
    private String voucherID;
    private String voucherCode;
    private double discountPer;
    private double discountAmount;
    private double minOrderValue;
    private LocalDate validFrom; // Get current time
    private LocalDate validUntil; // Get custom time by form
    private double maxDiscountAmount;
    private boolean voucherStatus;

    public Voucher(String voucherID, String voucherCode, double discountPer, double discountAmount, double minOrderValue, LocalDate validFrom, LocalDate validUntil, double maxDiscountAmount, boolean voucherStatus) {
        this.voucherID = voucherID;
        this.voucherCode = voucherCode;
        this.discountPer = discountPer;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.validFrom = validFrom;
        this.validUntil = validUntil;
        this.maxDiscountAmount = maxDiscountAmount;
        this.voucherStatus = voucherStatus;
    }

    
    
    public Voucher(String voucherCode, double discountPer, double discountAmount, double minOrderValue, LocalDate validFrom, LocalDate validUntil, double maxDiscountAmount, boolean voucherStatus) {
        this.voucherCode = voucherCode;
        this.discountPer = discountPer;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.validFrom = validFrom;
        this.validUntil = validUntil;
        this.maxDiscountAmount = maxDiscountAmount;
        this.voucherStatus = voucherStatus;
    }

    public Voucher(String voucherCode, double discountPer, double discountAmount, double minOrderValue, LocalDate validFrom, LocalDate validUntil, double maxDiscountAmount) {
        this.voucherCode = voucherCode;
        this.discountPer = discountPer;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.validFrom = validFrom;
        this.validUntil = validUntil;
        this.maxDiscountAmount = maxDiscountAmount;
    }

    

    public Voucher() {
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

    public LocalDate getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(LocalDate validFrom) {
        this.validFrom = validFrom;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = validUntil;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }
    
     public boolean isVoucherStatus() {
        return voucherStatus;
    }

    public void setVoucherStatus(boolean voucherStatus) {
        this.voucherStatus = voucherStatus;
    }

    public String getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(String voucherID) {
        this.voucherID = voucherID;
    }
    
    
}