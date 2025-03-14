/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Thuan
 */
public class TopOrderCustomer {
    private String email;
    private String statusName;

    public TopOrderCustomer(String email, String statusName) {
        this.email = email;
        this.statusName = statusName;
    }

    @Override
    public String toString() {
        return "TopOrderCustomer{" + "email=" + email + ", statusName=" + statusName + '}';
    }

    public TopOrderCustomer() {
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }
    
}
