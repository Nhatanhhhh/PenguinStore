/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author truon
 */
public class ShowStaffDTO {

    private String managerName;
    private String email;

    public ShowStaffDTO(String managerName, String email) {
        this.managerName = managerName;
        this.email = email;
    }

    public String getManagerName() {
        return managerName;
    }

    public String getEmail() {
        return email;
    }
}
