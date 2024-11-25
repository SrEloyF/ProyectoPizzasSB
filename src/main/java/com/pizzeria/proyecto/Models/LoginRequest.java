package com.pizzeria.proyecto.Models;

import lombok.Data;

@Data
public class LoginRequest {
    private String usuario;
    private String contrasena;


    public LoginRequest(String usuario, String contrasena) {
        this.usuario = usuario;
        this.contrasena = contrasena;
    }

}
