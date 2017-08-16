/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import clienteSocket.AgenteSocket;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Jose
 */
public class AccionesAgente extends HttpServlet{
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            int accion = Integer.parseInt(request.getParameter("accion"));
            String anexo = request.getParameter("anexo");
            switch(accion){
                case 4:
                    //llamar
                    String destino  = request.getParameter("destino");
                    AgenteSocket socket = new AgenteSocket(anexo, destino, accion);
                    break;
                case 5:
                    //contestar
                    AgenteSocket socket1 = new AgenteSocket(anexo, "-", accion);
                    break;
                case 6:
                    //espera
                    AgenteSocket socket2 = new AgenteSocket(anexo, "-", accion);
                    break;
                case 7:
                    //unhold
                    AgenteSocket socket3 = new AgenteSocket(anexo, "-", accion);
                    break;
                case 8:
                    //conferencia
                    String destinoConferencia  = request.getParameter("destino");
                    AgenteSocket socket4 = new AgenteSocket(anexo, destinoConferencia, accion);
                    break;
                case 9:
                    //redirect
                    String destinoRedirect  = request.getParameter("destino");
                    AgenteSocket socket5 = new AgenteSocket(anexo, destinoRedirect, accion);
                    break;
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}
