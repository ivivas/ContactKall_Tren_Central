/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

/**
 *
 * @author Ricardo
 */
public class EncuestaPreguntasDTO {
    private int numero;
    private String shortDesc;
    private String descripcion;
    
    public void setNumero(int numero){
        this.numero = numero;
    }
    
    public int getNumero(){
        return numero;
    }
    
    public void setShortDesc(String shortDesc){
        this.shortDesc = shortDesc;
    }
    
    public String getShortDesc(){
        return shortDesc;
    }
    
    public void setDescripcion(String descripcion){
        this.descripcion = descripcion;
    }
    
    public String getDescripcion(){
        return descripcion;
    }
}
