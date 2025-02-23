/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Do Van Luan - CE180457
 */
public class Type {

    private String typeID;
    private String typeName;
    private String categoryID;
    private String categoryName;

    public Type(String typeID, String typeName, String categoryID,String categoryName) {
        this.typeID = typeID;
        this.typeName = typeName;
        this.categoryID = categoryID;
        this.categoryName = categoryName;
    }

    public Type(String typeID, String categoryID, String typeName) {
        this.typeID = typeID;
        this.categoryID = categoryID;
        this.typeName = typeName;
    }

    public Type(String typeName, String categoryName) {
        this.typeName = typeName;
        this.categoryName = categoryName;
    }

    public Type() {
    }

    public String getTypeID() {
        return typeID;
    }

    public void setTypeID(String typeID) {
        this.typeID = typeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

}
