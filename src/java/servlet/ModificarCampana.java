/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Campana;
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
public class ModificarCampana extends HttpServlet {

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String sesionActual = (request.getSession().getAttribute("tipo") != null) ? request.getSession().getAttribute("tipo").toString() : "";
            String user = "";
            int id_piloto_sesion = -1;
            if (sesionActual.equalsIgnoreCase("supervisor")) {
                user = request.getSession().getAttribute("usuario").toString().trim();
                id_piloto_sesion = SesionQuery.idPilotoSesion(user);
            }
            PrintWriter out = response.getWriter();
            ResourceBundle msgs = null;
            Connection con = null;
            if (request.getSession().getAttribute("msgs") == null) {
                Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            } else {
                msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
            }
            con = SQLConexion.conectaIPKall(IPKall.conf.getIpServidor(), IPKall.conf.getBaseDatos(), IPKall.conf.getUsuarioBD(), IPKall.conf.getClaveBD());
            String campana = request.getParameter("campana");
            String agentes = "";
            String clientes = "";
            try {
                agentes = request.getParameter("ids") == null ? "" : request.getParameter("ids").substring(0, request.getParameter("ids").length() - 1);
                clientes = request.getParameter("clientes") == null ? "" : request.getParameter("clientes").substring(0, request.getParameter("clientes").length() - 2);
            } catch (Exception e) {
                e.printStackTrace();
            }
            Campana datosCampana = IPKall.listaCampanasX(con, campana);
            String modificar = request.getParameter("modificar");
            if (modificar != null) {
                String inicio = request.getParameter("inicio") != null ? request.getParameter("inicio").trim() : "";
                String fin = request.getParameter("fin") != null ? request.getParameter("fin").trim() : "";
                String respuestaAgentesOcupados = IPKall.validarAgentesOcupadosEnOtrasCampañasModificar(agentes, inicio, fin, campana);
                if (respuestaAgentesOcupados.equalsIgnoreCase("ok")) {
                    if (modificar.equals("agente")) {
                        IPKall.validarRelacionesExistentes(con, agentes, clientes, Integer.parseInt(campana), sesionActual, id_piloto_sesion);

//                        out.print(msgs.getString("campana.correctamente"));
                        out.print("ok");
                    } else if (IPKall.actualizarDatosCampana(con, Integer.parseInt(campana), request.getParameter("nombre"), request.getParameter("descripcion"), request.getParameter("inicio"), request.getParameter("fin"), request.getParameter("estado")) > 0) {
                        IPKall.validarRelacionesExistentes(con, agentes, clientes, Integer.parseInt(campana), sesionActual, id_piloto_sesion);
//                        out.print(msgs.getString("campana.modificar.correctamente"));
                        out.print("ok");
                    } else {
                        out.print(msgs.getString("campana.error"));
                    }
                } else {
                    out.print("Los siguientes anexos estan ocupados dentro del horario especificado en las siguientes campa&ntilde;as: <br>" + respuestaAgentesOcupados);
                }
            } else {
                out.print("<div id=\"respuestaAgregar\" style=\"color:red\"></div>");
                out.print("<table class='tablacampana' width=\"100%\">");
                out.print("<input type='hidden' id='id' value='" + campana + "'>");
                out.print("<tr><td>" + msgs.getString("campana.nombre") + "</td><td><input type='text' id='nombre' value='" + datosCampana.getNombre() + "'></td>");
                out.print("<tr><td>" + msgs.getString("campana.desc") + "</td><td><input type='text' id='descripcion' value='" + datosCampana.getDescripcion() + "'></td>");
                //out.print("<tr><td>"+msgs.getString("campana.inicio")+"</td><td><input type='text' readonly onclick=\"CalendarioStart()\" onkeydown=\"if(this.value.length >= 40){ return false; } else { return true;}\" id='addInicio' value='"+datosCampana.getFechaHoraInicio()+"'></td>");
                out.print("<tr><td>" + msgs.getString("campana.inicio") + "</td><td><input type='text' id='addInicio' value='" + datosCampana.getFechaHoraInicio() + "'></td>");
                //out.print("<tr><td>"+msgs.getString("campana.fin")+"</td><td><input type='text' readonly  onclick=\"CalendarioStart2()\" onkeydown =\"if(this.value.length >= 40){ return false; } else { return true;}\"  id='addFin' value='"+datosCampana.getFechaHoraTermino()+"'></td>");
                out.print("<tr><td>" + msgs.getString("campana.fin") + "</td><td><input type='text' id='addFin' value='" + datosCampana.getFechaHoraTermino() + "'></td>");
                out.print("<tr><td>" + msgs.getString("campana.estado") + "</td><td>" + IPKall.comboEstado(datosCampana.getEstado(), msgs) + "</td></table>");

                out.print("<div style=\"width:100%;\" id=\"cargarFileClientes\"><a href='#' onclick='subir()' class=\"botones btnadddel\">" + msgs.getString("campana.modificar.asigar_cliente") + "</a></div>");
                //out.print("<input type=\"button\" id=\"asignarAgente\" onclick='agentes()' value=\"%asignar_agentes%\"><br>");
                //out.print("<input type=\"button\" id=\"asignarCliente\" onclick='subir()' value=\"%asignar_clientes%\"><br>");
                if (sesionActual.equalsIgnoreCase("supervisor")) {
                    out.print("<div id='panelAgente' style=\"width:50%;\"><h4>Agentes</h4>" + IPKall.listaAgentesDisponiblesSupervisor(con, Integer.parseInt(campana), id_piloto_sesion) + "</div><div id='panelCliente' style=\"width:50%;\"><h4>Clientes</h4>" + IPKall.datosClientes(con, Integer.parseInt(campana)) + "</div>");
                } else {
                    out.print("<div id='panelAgente' style=\"width:50%;\"><h4>Agentes</h4>" + IPKall.listaAgentesDisponibles(con, Integer.parseInt(campana)) + "</div><div id='panelCliente' style=\"width:50%;\"><h4>Clientes</h4>" + IPKall.datosClientes(con, Integer.parseInt(campana)) + "</div>");
                }
                out.print("<a style='position:absolute;top:500px;left:40px;' id='agregarCampana' onclick='modificar()' class=\"botones btnadddel\">" + msgs.getString("campana.modificar.guardar") + "</a>");
//            out.print("<div><a href='#' id='agregarCampana' onclick='modificar()'><img src='imagenes/ok.png'><a></div>");
//            out.print("<div><a id='cerrarDiv' onclick='cerrar()'><img src='imagenes/exit.png'></a></div>");
                out.print("<a id='cerrarDiv' style='position:absolute;top:500px;left:600px;' onclick='cerrar()' class=\"botones btnadddel\">" + msgs.getString("campana.modificar.cancelar") + "</a>");
            }
            con.close();
        } catch (Exception e) {
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
