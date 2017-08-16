/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package DTO;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Felipe
 */
public class LlamadaEncoladaPortal implements Serializable  {
    private int idLlamada;
    private Date horaEncolada;
    private String numeroLlamante;

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
     * @return the horaEncolada
     */
    public Date getHoraEncolada() {
        return horaEncolada;
    }

    /**
     * @param horaEncolada the horaEncolada to set
     */
    public void setHoraEncolada(Date horaEncolada) {
        this.horaEncolada = horaEncolada;
    }

    /**
     * @return the numeroLlamante
     */
    public String getNumeroLlamante() {
        return numeroLlamante;
    }

    /**
     * @param numeroLlamante the numeroLlamante to set
     */
    public void setNumeroLlamante(String numeroLlamante) {
        this.numeroLlamante = numeroLlamante;
    }
    
}
