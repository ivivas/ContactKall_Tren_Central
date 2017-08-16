/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package SocketServer;

/**
 *
 * @author felipe
 */
public class ManejadorSockets {

    public static  ServidorMapaPilotos smp = new ServidorMapaPilotos();
    public static Thread th;
    public static Thread th2;

    public static void iniciarServidor(){
        th2 = new Thread(smp);
        th2.start();
    }

    public static void terminarServidor(){
       smp.terminar();
    }

}
