/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class Image {

    private String imgID;
    private String imgName;
    private String productID;

    public Image() {
    }

    public Image(String imgID, String imgName, String productID) {
        this.imgID = imgID;
        this.imgName = imgName;
        this.productID = productID;
    }

    public String getImgID() {
        return imgID;
    }

    public void setImgID(String imgID) {
        this.imgID = imgID;
    }

    public String getImgName() {
        return imgName;
    }

    public void setImgName(String imgName) {
        this.imgName = imgName;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

}