/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import clienteSocket.ClienteWhispering;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Jose
 */
public class Whispering extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            response.setCharacterEncoding("utf-8");
            HttpSession session = request.getSession();
            PrintWriter out = response.getWriter();
            ResourceBundle msgs = null;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }
            else{ 
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }
            String monitor = request.getParameter("monitor");
            String extensionAgente = request.getParameter("numeroAgente");
            String devNameAgente = request.getParameter("devNameAgente");
            String extensionMonitor = request.getParameter("numeroMonitor")==null?monitor.split("-")[0]:request.getParameter("numeroMonitor");
            String devNameMonitor = request.getParameter("devNameMonitor")==null?monitor.split("-")[1]:request.getParameter("devNameMonitor");
            int tipo = request.getParameter("tipo") != null ? Integer.parseInt(request.getParameter("tipo").trim()): -1;
            if(tipo==1){
                out.print(msgs.getString("iniciando.silencioso"));
            }
            else if(tipo==2){
                out.print(msgs.getString("iniciando.whispering"));
            }
            else{
                out.print(msgs.getString("finalizando.whispering"));
            }
            
//soliencioso = 1,no sielncioso = 2, cortar= 0
            ClienteWhispering cliente = new ClienteWhispering( extensionMonitor, devNameMonitor, extensionAgente, devNameAgente, tipo);
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
