/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package DTO;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Jose
 */
public class EstadisticaIVR {
    private List<Integer> idAccion;
    private List<String> botonAccion;
    private List<Integer> tipoAccion;
    private List<Integer> nivelSubrutina;
    private List<String> nombreSubrutina;
    private List<Integer> cantidadOpcion;
    private List<Integer> total;
    private List<String> descripcionAccion;
    private List<Integer> accionInicial;

    public EstadisticaIVR(){
        this.idAccion = new ArrayList();
        this.botonAccion = new ArrayList();
        this.tipoAccion = new ArrayList();
        this.nivelSubrutina = new ArrayList();
        this.nombreSubrutina = new ArrayList();
        this.cantidadOpcion = new ArrayList();
        this.total = new ArrayList();
        this.descripcionAccion = new ArrayList();
        this.accionInicial = new ArrayList();
    }
    
    public List<Integer> getIdAccion() {
        return idAccion;
    }

    public List<String> getBotonAccion() {
        return botonAccion;
    }

    public List<Integer> getTipoAccion() {
        return tipoAccion;
    }

    public List<Integer> getNivelSubrutina() {
        return nivelSubrutina;
    }
    
    public List<String> getNombreSubrutina() {
        return nombreSubrutina;
    }
    
    public List<Integer> getCantidadOpcion() {
        return cantidadOpcion;
    }

    public List<Integer> getTotal() {
        return total;
    }

    public List<String> getDescripcionAccion() {
        return descripcionAccion;
    }

    public List<Integer> getAccionInicial() {
        return accionInicial;
    }

    public void setAccionInicial(List<Integer> accionInicial) {
        this.accionInicial = accionInicial;
    }

}