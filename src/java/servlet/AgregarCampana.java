/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.IPKall;

/**
 *
 * @author Jose
 */
public class AgregarCampana extends HttpServlet {

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ResourceBundle msgs = null;
            if (request.getSession().getAttribute("msgs") == null) {
                Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            } else {
                msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
            }
            PrintWriter out = response.getWriter();
            response.setCharacterEncoding("utf-8");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String inicio = request.getParameter("inicio") != null ? request.getParameter("inicio").trim() : "";
            String fin = request.getParameter("fin") != null ? request.getParameter("fin").trim() : "";
            String estado = request.getParameter("estado");
            String agentes = request.getParameter("ids") == "" ? request.getParameter("ids") : request.getParameter("ids").substring(0, request.getParameter("ids").length() - 1);
            String clientes = request.getParameter("clientes") == "" ? request.getParameter("clientes") : request.getParameter("clientes").substring(0, request.getParameter("clientes").length() - 1);
            if (!nombre.equals("") & !descripcion.equals("") & !inicio.equals("") & !fin.equals("") & !estado.equals("")) {
                String respuestaAgentesOcupados = IPKall.validarAgentesOcupadosEnOtrasCampañas(agentes, inicio, fin);
                if (respuestaAgentesOcupados.equalsIgnoreCase("ok")) {
                    int campana = IPKall.insertarCampaña(nombre, descripcion, inicio, fin, estado);
                    if (campana > 0) {
                        IPKall.insertarColaboradores(agentes, clientes, campana);
                        out.print("ok");
//                        out.print(msgs.getString("campana.agregada"));
                    } else {
                        out.print(msgs.getString("campana.insertar.error"));
                    }
                } else {
                    out.print("Los siguientes anexos estan ocupados dentro del horario especificado en las siguientes campa&ntilde;as: <br>" + respuestaAgentesOcupados);
                }
            } else {
                out.print(msgs.getString("msg.err.empty"));
            }
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
