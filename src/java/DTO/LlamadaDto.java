/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.io.Serializable;

/**
 *
 * @author Ricardo Fuentes
 */
public class LlamadaDto implements Serializable {
    
    private int callId=0;
    private String contraparte="";
    private int estado=0;
    
    public void setCallId(int callId){
        this.callId = callId;
    }
    
    public int getCallId(){
        return callId;
    }
    
    public void setContraparte(String contraparte){
        this.contraparte = contraparte;
    }
    
    public String getContraparte(){
        return contraparte;
    }
    
    public void setEstado(int estado){
        this.estado = estado;
    }
    
    public int getEstado(){
        return estado;
    }
}
