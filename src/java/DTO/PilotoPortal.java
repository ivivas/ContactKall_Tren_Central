/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author felipe
 */
public class PilotoPortal implements Serializable {

    private int id;
    private String piloto;
    private int llamadasEnCola;
    private Map<Integer, LlamadaEncoladaPortal> mapaLlamadasEnCola = new HashMap();
    private int llamadasEntrantesEnElDia;
    private int llamadasEntrantesXAnexo;
    private String descripcion;
    private int idCentroCosto;
    private int tratarAnexosInternosComoClientes;
    private int permitirLlamadasDirectas;
    private String numeroFueraHorario;
    private String anexoRebalse;

    /**
     * @return the llamadasEntrantesEnElDia
     */
    public int getLlamadasEntrantesEnElDia() {
        return llamadasEntrantesEnElDia;
    }

    /**
     * @param llamadasEntrantesEnElDia the llamadasEntrantesEnElDia to set
     */
    public void setLlamadasEntrantesEnElDia(int llamadasEntrantesEnElDia) {
        this.llamadasEntrantesEnElDia = llamadasEntrantesEnElDia;
    }

    /**
     * @return the llamadasEntrantesXAnexo
     */
    public int getLlamadasEntrantesXAnexo() {
        return llamadasEntrantesXAnexo;
    }

    /**
     * @param llamadasEntrantesXAnexo the llamadasEntrantesXAnexo to set
     */
    public void setLlamadasEntrantesXAnexo(int llamadasEntrantesXAnexo) {
        this.llamadasEntrantesXAnexo = llamadasEntrantesXAnexo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
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

    /**
     * @return the idCentroCosto
     */
    public int getIdCentroCosto() {
        return idCentroCosto;
    }

    /**
     * @param idCentroCosto the idCentroCosto to set
     */
    public void setIdCentroCosto(int idCentroCosto) {
        this.idCentroCosto = idCentroCosto;
    }

    /**
     * @return the tratarAnexosInternosComoClientes
     */
    public int getTratarAnexosInternosComoClientes() {
        return tratarAnexosInternosComoClientes;
    }

    /**
     * @param tratarAnexosInternosComoClientes the
     * tratarAnexosInternosComoClientes to set
     */
    public void setTratarAnexosInternosComoClientes(int tratarAnexosInternosComoClientes) {
        this.tratarAnexosInternosComoClientes = tratarAnexosInternosComoClientes;
    }

    /**
     * @return the permitirLlamadasDirectas
     */
    public int getPermitirLlamadasDirectas() {
        return permitirLlamadasDirectas;
    }

    /**
     * @param permitirLlamadasDirectas the permitirLlamadasDirectas to set
     */
    public void setPermitirLlamadasDirectas(int permitirLlamadasDirectas) {
        this.permitirLlamadasDirectas = permitirLlamadasDirectas;
    }

    /**
     * @return the llamadasEnCola
     */
    public int getLlamadasEnCola() {
        return llamadasEnCola;
    }

    /**
     * @param llamadasEnCola the llamadasEnCola to set
     */
    public void setLlamadasEnCola(int llamadasEnCola) {
        this.llamadasEnCola = llamadasEnCola;
    }

    /**
     * @return the mapaLlamadasEnCola
     */
    public Map<Integer, LlamadaEncoladaPortal> getMapaLlamadasEnCola() {
        return mapaLlamadasEnCola;
    }

    /**
     * @param mapaLlamadasEnCola the mapaLlamadasEnCola to set
     */
    public void setMapaLlamadasEnCola(Map<Integer, LlamadaEncoladaPortal> mapaLlamadasEnCola) {
        this.mapaLlamadasEnCola = mapaLlamadasEnCola;
    }

    /**
     * @return the numeroFueraHorario
     */
    public String getNumeroFueraHorario() {
        return numeroFueraHorario;
    }

    /**
     * @param numeroFueraHorario the numeroFueraHorario to set
     */
    public void setNumeroFueraHorario(String numeroFueraHorario) {
        this.numeroFueraHorario = numeroFueraHorario;
    }

    /**
     * @return the anexoRebalse
     */
    public String getAnexoRebalse() {
        return anexoRebalse;
    }

    /**
     * @param anexoRebalse the anexoRebalse to set
     */
    public void setAnexoRebalse(String anexoRebalse) {
        this.anexoRebalse = anexoRebalse;
    }

}
