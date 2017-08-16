/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.ComboQuery;
import query.IPKall;

/**
 *
 * @author Jose
 */
public class Sincronizar extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            String host = IPKall.conf.getIpServidor();
            String db = IPKall.conf.getBaseDatos();
            String user = IPKall.conf.getUsuarioBD();
            String clave = IPKall.conf.getClaveBD();
            Connection con = SQLConexion.conectaIPKall(host, db, user, clave);
            List<String> listaAgentesACD = ComboQuery.listaSecretariaACD();
            for(String agente : listaAgentesACD){
                String anexo = agente.split("%")[0];
                String nombre = agente.split("%")[1];
                String sep = agente.split("%")[2];
                if(IPKall.noEstaEnIpKall(con,anexo)){
                    IPKall.insertarAgente(con, anexo, nombre, sep);
                }
            }
            out.print("Sincronizado.");
            con.close();
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
