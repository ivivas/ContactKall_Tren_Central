package clienteSocket;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class ClienteWhispering
{
  static final String HOST = "127.0.0.1";
  static final int PUERTO = 6020;

  public ClienteWhispering(String extensionMonitor,String devNameMonitor,String extensionAgente,String devNameAgente,int tipo)
  {
    try
    {
      System.out.println("algo X ");
      Socket skCliente = new Socket(HOST, PUERTO);
      OutputStream auxW = skCliente.getOutputStream();

      DataOutputStream flujoW = new DataOutputStream(auxW);
      //System.out.println("numero del router : " + numeroRoutePoint + " puerto : " + 6000);
      flujoW.writeUTF("Soy el cliente applet," + extensionMonitor+","+devNameMonitor+","+extensionAgente+","+devNameAgente+","+tipo);

      InputStream aux = skCliente.getInputStream();

      DataInputStream flujo = new DataInputStream(aux);

      System.out.println(flujo.readUTF());

      skCliente.close();
    }
    catch (Exception e)
    {
      System.out.println(e.getMessage());
    }
  }

  public static void main(String[] arg)
  {
    //new ClienteWhispering("86998");
  }
}