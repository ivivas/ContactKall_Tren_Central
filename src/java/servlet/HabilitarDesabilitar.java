/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import clienteSocket.AgenteSocket;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.AgenteQuery;

/**
 *
 * @author Jose
 */
public class HabilitarDesabilitar extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            String anexo = request.getParameter("anexo");
            String piloto = AgenteQuery.obtenerPilotoXAnexo(anexo);
            int estado = AgenteQuery.accionAgente(anexo);
            if(request.getParameter("op") == null){
                if(estado==0){
                    AgenteSocket agente = new AgenteSocket(anexo,piloto,3);
                    //out.print("<script>alert('agente deshabilitado')</script>");
                    out.print("agente deshabilitado");
                }else if(estado==1){
                    AgenteSocket agente = new AgenteSocket(anexo,piloto, 2);
                    //out.print("<script>alert('agente habilitado')</script>");
                    out.print("agente habilitado");
                }else if(estado==2){
                    //out.print("<script>alert('terminal fuera de servicio')</script>");
                    out.print("terminal fuera de servicio");
                }
            }else{
                if(estado==0){
                    AgenteSocket agente = new AgenteSocket(anexo,piloto, 3);
                }
                else if(estado==1){
                    AgenteSocket agente = new AgenteSocket(anexo, piloto,2);
                }
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
