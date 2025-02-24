/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Nhat_Anh
 */
public class Customer {
    private String customerID;
    private String userName;
    private String passWord;
    private String fullName;
    private String email;
    private String googleID;
    private String accessToken;
    private String address;
    private int phoneNumber;
    private String zip;
    private String state;
    private boolean isVerified;

    public Customer() {
    }
    

    public Customer(String customerID, String userName, String passWord, String fullName, String email, String googleID, String accessToken, String address, int phoneNumber, String zip, String state, boolean isVerified) {
        this.customerID = customerID;
        this.userName = userName;
        this.passWord = passWord;
        this.fullName = fullName;
        this.email = email;
        this.googleID = googleID;
        this.accessToken = accessToken;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.zip = zip;
        this.state = state;
        this.isVerified = isVerified;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGoogleID() {
        return googleID;
    }

    public void setGoogleID(String googleID) {
        this.googleID = googleID;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(int phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public boolean isIsVerified() {
        return isVerified;
    }

    public void setIsVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    @Override
    public String toString() {
        return "Customer{" + "customerID=" + customerID + ", userName=" + userName + ", passWord=" + passWord + ", fullName=" + fullName + ", email=" + email + ", googleID=" + googleID + ", accessToken=" + accessToken + ", address=" + address + ", phoneNumber=" + phoneNumber + ", zip=" + zip + ", state=" + state + ", isVerified=" + isVerified + '}';
    }
    
}
