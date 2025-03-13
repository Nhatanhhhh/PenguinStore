/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Nguyen Nhat Anh - CE181843
 */
public class Manager {

    private String managerID;
    private String managerName;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String address;
    private String dateOfBirth;
    private boolean role;

    public Manager(String managerID, String managerName, String password, String fullName, String email, String phoneNumber, String address, String dateOfBirth, boolean role) {
        this.managerID = managerID;
        this.managerName = managerName;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.role = role;
    }

    public String getManagerID() {
        return managerID;
    }

    public void setManagerID(String managerID) {
        this.managerID = managerID;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public boolean isRole() {
        return role;
    }

    public void setRole(boolean role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Manager{" + "managerID=" + managerID + ", managerName=" + managerName + ", password=" + password + ", fullName=" + fullName + ", email=" + email + ", phoneNumber=" + phoneNumber + ", address=" + address + ", dateOfBirth=" + dateOfBirth + ", role=" + role + '}';
    }
}
