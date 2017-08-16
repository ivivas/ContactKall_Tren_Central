/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import adportas.SQLConexion;
import java.io.*;
import java.sql.Connection;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import query.*;

/**
 *
 * @author Jose
 */
public class TablaEstadistica extends HttpServlet{
    private void processRequest(HttpServletRequest request,HttpServletResponse response){
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        ResourceBundle msgs = null;
        if(request.getSession().getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }
        else{
            msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
        }
        Connection con = null;
        try{
            String sesion = request.getSession().getAttribute("tipo").toString();

            int opcionTabla = Integer.parseInt(request.getParameter("opcionTabla"));
            String piloto = request.getParameter("piloto");
            String anexo = request.getParameter("anexo");
            String user = request.getSession().getAttribute("usuario").toString().trim();
            int idPool = SesionQuery.idPilotoSesion(user);
                    
            int lapso = Integer.parseInt(request.getParameter("lapso"));
            con = SQLConexion.conectar();
            PrintWriter out = response.getWriter();
            switch(opcionTabla){
                case 0:
                    List<String> pilotos ;
                    if(sesion.equals("supervisor")){
                        pilotos = ComboQuery.listaPilotos3(con,idPool);
                    }else{
                        pilotos = ComboQuery.listaPilotos3(con);
                    }
                    
                    out.print(AgenteQuery.getTablaEstadisticasPool(con, msgs,pilotos,lapso));
                    break;
                case 1:
                    List<String> secretarias = ComboQuery.listaSecretariaACD2(con);
                    out.print(AgenteQuery.getTablaEstadisticasAgente(con, msgs,secretarias,lapso));
                    break;
                case 2:
                    List<String> secretariasXPiloto = ComboQuery.listaSecretaria(con, piloto);
                    out.print(AgenteQuery.getTablaEstadisticasAgenteXPiloto(con, msgs, secretariasXPiloto, lapso));
                    break;
                case 3:
                    out.print(AgenteQuery.getTablaEstadisticasAgenteUnico(con, msgs, anexo, lapso));
                    break;
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                con.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
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
