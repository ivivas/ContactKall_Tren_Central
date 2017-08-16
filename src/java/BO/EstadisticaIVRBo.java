/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package BO;

import DTO.EstadisticaIVR;
import query.EstadisticaIVRQuery;

public class EstadisticaIVRBo {
    
    private String fechaDesde;
    private String fechaHasta;
    private int nivel;
    private String[] arrayColores;
    
    public EstadisticaIVRBo(String fechaDesde,String fechaHasta, int nivel){
        this.fechaDesde = fechaDesde;
        this.fechaHasta = fechaHasta;
        this.nivel = nivel;
        iniciarColores();
    }
    
    public EstadisticaIVR obtenerEstadisticaIVR(boolean mostrarInvalida){
        EstadisticaIVRQuery eivrq = new EstadisticaIVRQuery(this.fechaDesde, this.fechaHasta,this.nivel);
        return eivrq.obtenerEstadisticaIVR(mostrarInvalida);
    }
    
    private void iniciarColores(){
        arrayColores = new String[20];
        arrayColores[0] = "red";
        arrayColores[1] = "green";
        arrayColores[2] = "yellow";
        arrayColores[3] = "blue";
        arrayColores[4] = "orange";
        arrayColores[5] = "skyblue";
        arrayColores[6] = "pink";
        arrayColores[7] = "silver";
        arrayColores[8] = "brown";
        arrayColores[9] = "black";
        arrayColores[10] = "red";
        arrayColores[11] = "green";
        arrayColores[12] = "yellow";
        arrayColores[13] = "blue";
        arrayColores[14] = "orange";
        arrayColores[15] = "skyblue";
        arrayColores[16] = "pink";
        arrayColores[17] = "silver";
        arrayColores[18] = "brown";
        arrayColores[19] = "black";
    }
    public String[] getArrayColores(){
        return this.arrayColores;
    }
}
