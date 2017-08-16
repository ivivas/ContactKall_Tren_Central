/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Campana;
import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.IPKall;
import query.SesionQuery;

/**
 *
 * @author Jose
 */
public class AgentesDisponibles extends HttpServlet {

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        ResourceBundle msgs = null;
        if (request.getSession().getAttribute("msgs") == null) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        } else {
            msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
        }
        try {
            String user = request.getSession().getAttribute("usuario").toString().trim();
            int id_piloto_sesion = SesionQuery.idPilotoSesion(user);
            String sesionActual = (request.getSession().getAttribute("tipo") != null) ? request.getSession().getAttribute("tipo").toString() : "";
            Configuracion conf = IPKall.conf == null ? IPKall.configuracionIPKall() : IPKall.conf;
            con = SQLConexion.conectaIPKall(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            int idCampana = Integer.parseInt(request.getParameter("id"));
            Campana campana = IPKall.listaCampanasX(con, String.valueOf(idCampana));
            if (request.getParameter("text") != null) {
                out.print(campana.getNombre());
                out.print("<br>" + msgs.getString("agentes.disponibles") + "<br>");
                out.print("<div id='agentesDisponibles'>");
                int id = Integer.parseInt(request.getParameter("id"));
                if (sesionActual.equalsIgnoreCase("supervisor")) {
                    out.print(IPKall.listaAgentesDisponiblesSupervisor(con, id, id_piloto_sesion));
                } else {
                    out.print(IPKall.listaAgentesDisponibles(con, id));
                }
                out.print("</div>");
                out.print(msgs.getString("clientes.asignados") + "<br>");
                out.print("<div id=\"panelCliente\">" + IPKall.datosClientes(con, Integer.parseInt(String.valueOf(idCampana))) + "</div>");
                out.print("<a href='#' onclick='modificar(" + idCampana + ")'><img src='imagenes/save.png'></a>");
                out.print("<a href='#' onclick='abrirVentana()'><img src='imagenes/asignarC.png'></a>");
                out.print("<a href='#' onclick='ocultar()'><img src='imagenes/cancel.png'></a>");
            } else {
                out.print("<h4>" + msgs.getString("agentes.disponibles") + "</h4>");
                int id = Integer.parseInt(request.getParameter("id"));
                if (sesionActual.equalsIgnoreCase("supervisor")) {
                    out.print(IPKall.listaAgentesDisponiblesSupervisor(con, id, id_piloto_sesion));
                } else {
                    out.print(IPKall.listaAgentesDisponibles(con, id));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (Exception e) {
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
