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
public class EstadisticaDTO {
    public EstadisticaDTO(){
    }
    private int idAccion;
    private String boton;
    private String argumento;
    private String subrutina;
    private int tipoAccion;
    private int cantidad;
    private double porcentaje;
    private String descripcion;
    
    public void setIdAccion(int idAccion){
        this.idAccion = idAccion;
    }
    
    public int getIdAccion(){
        return idAccion;
    }
    
    public void setBoton(String boton){
        this.boton = boton;
    }
    
    public String getBoton(){
        return boton;
    }
    
    public void setArgumento(String argumento){
        this.argumento = argumento;
    }
    
    public String argumento(){
        return argumento;
    }
    
    public void setSubrutina(String subrutina){
        this.subrutina = subrutina;
    }
    
    public String getSubrutina(){
        return subrutina;
    }
    
    public void setTipoAccion(int tipoAccion){
        this.tipoAccion = tipoAccion;
    }
    
    public int getTipoAccion(){
        return tipoAccion;
    }
    
    public void setCantidad(int cantidad){
        this.cantidad = cantidad;
    }
    
    public int getCantidad(){
        return cantidad;
    }
    
    public void setPorcentaje(double porcentaje){
        this.porcentaje = porcentaje;
    }
    
    public double getPorcentaje(){
        return porcentaje;
    }
    
    public void setDescripcion(String descripcion){
        this.descripcion = descripcion;
    }
    
    public String getDescripcion(){
        return descripcion;
    }
}
