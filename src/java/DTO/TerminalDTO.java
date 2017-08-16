/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Ricardo Fuentes
 */
public class TerminalDTO implements Serializable{
    private String sep;
    private String anexo;
    private int estado;
    private Map<Integer,LlamadaDto> mapaLlamada = new HashMap();
    
    public static int DESOCUPADO=0;
    public static int RINGUEANDO=1;
    public static int HABLANDO=2;
    public static int CONECTANDO=3;
    public static int DESCONOCIDO=4;
    public static int EN_HOLD=5;
    
    public void setSep(String sep){
        this.sep = sep;
    }
    
    public String getSep(){
        return sep;
    }
    
    public void setAnexo(String anexo){
        this.anexo = anexo;
    }
    
    public String getAnexo(){
        return anexo;
    }
    
    public void setEstado(int estado){
        this.estado = estado;
    }
    
    public int getEstado(){
        return estado;
    }
    
    public void setMapaLlamada(Map mapaLlamada){
        this.mapaLlamada = mapaLlamada;
    }
    
    public Map getMapaLlamada(){
        return mapaLlamada;
    }
}
