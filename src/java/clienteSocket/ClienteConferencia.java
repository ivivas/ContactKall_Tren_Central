package clienteSocket;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class ClienteConferencia
{
  static final String HOST = "127.0.0.1";
  static final int PUERTO = 7000;

    public ClienteConferencia(String numeroAgente,String numeroMonitor,String devNameMonitor){
        try{
            Socket skCliente = new Socket("", 7000);
            OutputStream auxW = skCliente.getOutputStream();
            DataOutputStream flujoW = new DataOutputStream(auxW);
            flujoW.writeUTF("llego una conferencia," +numeroAgente+","+numeroMonitor+","+devNameMonitor);
            InputStream aux = skCliente.getInputStream();
            DataInputStream flujo = new DataInputStream(aux);
            System.out.println(flujo.readUTF());
            skCliente.close();
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}