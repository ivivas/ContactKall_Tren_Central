/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package DTO;

/**
 *
 * @author Jose
 */
public class Configuracion {

    private String ipServidor;
    private String baseDatos;
    private String usuarioBD;
    private String claveBD;
    private boolean integrado;
    private String rutaPortal;
    private String rutaGrabacion;


    public String getIpServidor() {
        return ipServidor;
    }

    public void setIpServidor(String ipServidor) {
        this.ipServidor = ipServidor;
    }

    public String getBaseDatos() {
        return baseDatos;
    }

    public void setBaseDatos(String baseDatos) {
        this.baseDatos = baseDatos;
    }

    public String getUsuarioBD() {
        return usuarioBD;
    }

    public void setUsuarioBD(String usuarioBD) {
        this.usuarioBD = usuarioBD;
    }

    public String getClaveBD() {
        return claveBD;
    }

    public void setClaveBD(String claveBD) {
        this.claveBD = claveBD;
    }

    public boolean isIntegrado() {
        return integrado;
    }

    public void setIntegrado(boolean integrado) {
        this.integrado = integrado;
    }

    public String getRutaPortal() {
        return rutaPortal;
    }

    public void setRutaPortal(String rutaPortal) {
        this.rutaPortal = rutaPortal;
    }
    public String getRutaGrabacion() {
        return rutaGrabacion;
    }

    public void setRutaGrabacion(String rutaGrabacion) {
        this.rutaGrabacion = rutaGrabacion;
    }

   
}
