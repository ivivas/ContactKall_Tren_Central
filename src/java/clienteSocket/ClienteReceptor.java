/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package clienteSocket;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

/**
 *
 * @author Jose
 */
public class ClienteReceptor {
    public ClienteReceptor(String numeroLadron,String numeroVictima){
        try{
            Socket skCliente = new Socket("", 8000);
            OutputStream auxW = skCliente.getOutputStream();
            DataOutputStream flujoW = new DataOutputStream(auxW);
            flujoW.writeUTF("Soy el cliente receptor," + numeroLadron+","+numeroVictima);
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
