/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;

/**
 *
 * @author Thuan
 */
public class ViewFeedbackCus {
    private String managerNam;
    private String comment;
    private String productName;
    private LocalDate createAt;

    public ViewFeedbackCus() {
    }

    public ViewFeedbackCus(String managerNam, String comment, String productName, LocalDate createAt) {
        this.managerNam = managerNam;
        this.comment = comment;
        this.productName = productName;
        this.createAt = createAt;
    }

    public String getManagerNam() {
        return managerNam;
    }

    public void setManagerNam(String managerNam) {
        this.managerNam = managerNam;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public LocalDate getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDate createAt) {
        this.createAt = createAt;
    }

    @Override
    public String toString() {
        return "ViewFeedbackCus{" + "managerNam=" + managerNam + ", comment=" + comment + ", productName=" + productName + ", createAt=" + createAt + '}';
    }
    
    
}
