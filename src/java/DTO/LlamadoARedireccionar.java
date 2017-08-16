/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package DTO;

import java.io.Serializable;

/**
 *
 * @author Felipe
 */
public class LlamadoARedireccionar implements Serializable{
    private int idLlamada;
    private String numeroRedireccion;
    private String piloto;

    /**
     * @return the idLlamada
     */
    public int getIdLlamada() {
        return idLlamada;
    }

    /**
     * @param idLlamada the idLlamada to set
     */
    public void setIdLlamada(int idLlamada) {
        this.idLlamada = idLlamada;
    }

    /**
     * @return the numeroRedireccion
     */
    public String getNumeroRedireccion() {
        return numeroRedireccion;
    }

    /**
     * @param numeroRedireccion the numeroRedireccion to set
     */
    public void setNumeroRedireccion(String numeroRedireccion) {
        this.numeroRedireccion = numeroRedireccion;
    }

    /**
     * @return the piloto
     */
    public String getPiloto() {
        return piloto;
    }

    /**
     * @param piloto the piloto to set
     */
    public void setPiloto(String piloto) {
        this.piloto = piloto;
    }
}
