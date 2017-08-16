/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.sql.Timestamp;

/**
 *
 * @author Mario
 */
public class LoginLogout {

    private String agente;
    private String piloto;
    private String horaDesde;
    private String horaHasta;
    private Timestamp inicioDia;
    private Timestamp terminoDia;
    private String diaBuscado;
    private long login;
    private long logout;
    private Timestamp horaActual;
    private Timestamp fechaUltimoEstado;
    private int ultimo_estado = -1;

    public String getAgente() {
        return agente;
    }

    public void setAgente(String agente) {
        this.agente = agente;
    }

    public String getPiloto() {
        return piloto;
    }

    public void setPiloto(String piloto) {
        this.piloto = piloto;
    }

    public String getHoraDesde() {
        return horaDesde;
    }

    public void setHoraDesde(String horaDesde) {
        this.horaDesde = horaDesde;
    }

    public String getHoraHasta() {
        return horaHasta;
    }

    public void setHoraHasta(String horaHasta) {
        this.horaHasta = horaHasta;
    }

    public String getDiaBuscado() {
        return diaBuscado;
    }

    public void setDiaBuscado(String diaBuscado) {
        this.diaBuscado = diaBuscado;
    }

    public long getLogin() {
        return login;
    }

    public void setLogin(long login) {
        this.login += login;
    }

    public long getLogout() {
        return logout;
    }

    public void setLogout(long logout) {
        this.logout += logout;
    }

    public Timestamp getInicioDia() {
        return inicioDia;
    }

    public void setInicioDia(Timestamp inicioDia) {
        this.inicioDia = inicioDia;
    }

    public Timestamp getTerminoDia() {
        return terminoDia;
    }

    public void setTerminoDia(Timestamp terminoDia) {
        this.terminoDia = terminoDia;
    }

    public int getUltimo_estado() {
        return ultimo_estado;
    }

    public void setUltimo_estado(int ultimo_estado) {
        this.ultimo_estado = ultimo_estado;
    }

    public Timestamp getHoraActual() {
        return horaActual;
    }

    public void setHoraActual(Timestamp horaActual) {
        this.horaActual = horaActual;
    }

    /**
     * @return the fechaUltimoEstado
     */
    public Timestamp getFechaUltimoEstado() {
        return fechaUltimoEstado;
    }

    /**
     * @param fechaUltimoUso the fechaUltimoEstado to set
     */
    public void setFechaUltimoEstado(Timestamp fechaUltimoUso) {
        this.fechaUltimoEstado = fechaUltimoUso;
    }

}
