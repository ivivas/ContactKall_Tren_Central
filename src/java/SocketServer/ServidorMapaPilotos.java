/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package SocketServer;


import java.io.*;


import java.net.*;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

//ServidorMapaPilotos CtiRoutePoint
public class ServidorMapaPilotos implements Runnable {

    public static  int PUERTO = 4040;
    Thread t = new Thread(this);
    Socket skCliente = null;
    boolean banderaFinProceso = false;//comprueba que ya se ha realizado la redireccion
    public static Map mapaPilotos;
    public static boolean TERMINAR = false;
    ServerSocket skServidor;

    public ServidorMapaPilotos() {
    }

    public void iniciar(){
        skServidor = null;
        try {
            skServidor = new ServerSocket(PUERTO);
        } catch (IOException ex) {
            System.out.println("error creando soket: "+ex);
        }
        while (true) {
            banderaFinProceso = false;
            try {
                skCliente = skServidor.accept(); // Crea objeto
                // System.out.println("Sirvo al cliente " + numCli);
                InputStream auxR = skCliente.getInputStream();

                ObjectInputStream in = new ObjectInputStream(new BufferedInputStream(auxR));

                Map mapa = (Map) in.readObject();
                ServidorMapaPilotos.mapaPilotos = mapa;
 
                in.close();
                auxR.close();
            } catch (Exception ex) {
                try {
                    //     ex.printStackTrace();
                    Thread.sleep(1000);
                } catch (InterruptedException ex1) {
                    Logger.getLogger(ServidorMapaPilotos.class.getName()).log(Level.SEVERE, null, ex1);
                }
                banderaFinProceso = true;
            } finally {
                banderaFinProceso = true;
            }
            banderaFinProceso = true;
        }
    }
    
    public void terminar(){
        TERMINAR = true;
        try {
            this.skServidor.close();
        } catch (IOException ex) {
            Logger.getLogger(ServidorMapaPilotos.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("fin servidor mapa de pilotos");
    }

    public static void main(String[] arg) {

       ServidorMapaPilotos smp = new ServidorMapaPilotos();

        Thread th = new Thread(smp);
        th.start();

        try {
            Thread.sleep(2000);
        } catch (InterruptedException ex) {
            Logger.getLogger(ServidorMapaPilotos.class.getName()).log(Level.SEVERE, null, ex);
        }
        smp.terminar();

    }

    public void run() {
      iniciar();
    }
}
