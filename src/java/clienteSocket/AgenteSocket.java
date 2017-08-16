package clienteSocket;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.Socket;

public class AgenteSocket {
    private static final String HOST = "127.0.0.1";
    private static final int PUERTO = 9000;
    private String anexo;
    private String piloto;
    
    public AgenteSocket(String anexo,String piloto,int accion){
        //this.anexo = anexo;
        //this.piloto = piloto;
        try{
            Socket skCliente = new Socket(HOST, PUERTO);
            OutputStream auxW = skCliente.getOutputStream();
            DataOutputStream flujoW = new DataOutputStream(auxW);
            flujoW.writeUTF("peticion agente," + anexo +","+accion+","+piloto);
            InputStream aux = skCliente.getInputStream();
            DataInputStream flujo = new DataInputStream(aux);
            skCliente.close();
            //OutputStream auxW = skCliente.getOutputStream();
            //DataOutputStream flujoW = new DataOutputStream(auxW);
//            ObjectOutputStream flujoW = new ObjectOutputStream(skCliente.getOutputStream());
//            flujoW.writeObject("peticion agente," + this.anexo +","+accion+","+this.piloto);
//            InputStream aux = skCliente.getInputStream();
//            //DataInputStream flujo = new DataInputStream(aux);
//            ObjectInputStream flujo = new ObjectInputStream(aux);
//            Object o = flujo.readObject();
//            if(o instanceof String){
//                System.out.println("recibe: "+o);
//            }else if(o instanceof TerminalDTO){
//                System.out.println("");
//            }
            //System.out.println(flujo.readUTF());
            
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
