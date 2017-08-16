/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.PilotoPortal;
import SocketServer.ServidorMapaPilotos;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Ricardo Fuentes
 */
@WebServlet(name = "Colas", urlPatterns = {"/Colas"})
public class Colas extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        ResultSet rs = null, rs2 = null, rs3 = null, rs4 = null, rs5 = null;
        PreparedStatement pst = null, pst2 = null, pst3 = null, pst4 = null, pst5 = null;
        Connection conexion = null;
        try{
            Calendar calendarFechaAyer = Calendar.getInstance();
            calendarFechaAyer.add(Calendar.DAY_OF_MONTH, -1);
            calendarFechaAyer.set(Calendar.HOUR_OF_DAY, 23);
            calendarFechaAyer.set(Calendar.MINUTE, 59);
            calendarFechaAyer.set(Calendar.SECOND, 59);
            calendarFechaAyer.set(Calendar.MILLISECOND, 0);
            Timestamp timestampAyer = new Timestamp(calendarFechaAyer.getTimeInMillis());
            Calendar calendarFechaManana = Calendar.getInstance();
            calendarFechaManana.add(Calendar.DAY_OF_MONTH, 1);
            calendarFechaManana.set(Calendar.HOUR_OF_DAY, 0);
            calendarFechaManana.set(Calendar.MINUTE, 0);
            calendarFechaManana.set(Calendar.SECOND, 0);
            calendarFechaManana.set(Calendar.MILLISECOND, 0);
            Timestamp timestampMannana = new Timestamp(calendarFechaManana.getTimeInMillis());
            conexion = SQLConexion.conectar();
            pst = null;
            pst = conexion.prepareStatement("SELECT * FROM pilotos order by id");
            Map mapaPilotos = ServidorMapaPilotos.mapaPilotos;
            rs = pst.executeQuery();
            pst2 = null;
            rs2 = null;
            pst3 = null;
            rs3 = null;
            pst4 = null;
            rs4 = null;
            if(mapaPilotos == null){
                out.print("Error...");
            }else{
            while (rs.next()) {
                String id = rs.getString("id").trim();
                pst2 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where fecha_llamada > ? and fecha_llamada < ? ");
                String piloto = rs.getString("piloto") != null ? rs.getString("piloto").trim() : "";
                pst2.setTimestamp(1, timestampAyer);
                pst2.setTimestamp(2, timestampMannana);
                rs2 = pst2.executeQuery();
                pst3 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where fecha_llamada > ? and fecha_llamada < ? and tipo_llamada = 1");
                pst3.setTimestamp(1, timestampAyer);
                pst3.setTimestamp(2, timestampMannana);
                rs3 = pst3.executeQuery();
                pst4 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where fecha_llamada > ? and fecha_llamada < ? and tipo_llamada = 2");
                pst4.setTimestamp(1, timestampAyer);
                pst4.setTimestamp(2, timestampMannana);
                rs4 = pst4.executeQuery();
                rs2.next();
                rs3.next();
                rs4.next();
                PilotoPortal pp = (PilotoPortal) mapaPilotos.get(piloto);
                out.print("Cantidad Llamadas en cola "+piloto+": ");
                out.println(rs.getString("llamadas_en_cola") != null ? rs.getString("llamadas_en_cola").trim() : "0");
                out.print("<br>");
                out.println("<table class=\"cola_llamados\" ><tr><th>Número Entrante</th><th>Tiempo de Espera</th></tr>");
                if (pp != null && !pp.getMapaLlamadasEnCola().isEmpty()) {
                    Iterator it = pp.getMapaLlamadasEnCola().values().iterator();
                    while (it.hasNext()) {
                        DTO.LlamadaEncoladaPortal llamadaEncolada = (DTO.LlamadaEncoladaPortal) it.next();
                        String numLlamante = llamadaEncolada.getNumeroLlamante();
                        int idLlamada = llamadaEncolada.getIdLlamada();
                        out.println("<tr><td>"+numLlamante+"</td>");
                        java.util.Date fechaDeshabilitacion = llamadaEncolada.getHoraEncolada();
                        String tiempoDeshabilitado = "";
                        if (fechaDeshabilitacion != null) {
                            java.util.Date fechaActual = new java.util.Date();
                            long diferencia = fechaActual.getTime() - fechaDeshabilitacion.getTime();
                            int segundos = (int) Math.floor(diferencia / (1000));
                            int minutos = segundos / 60;
                            segundos = segundos % 60;
                            String segString = segundos + "";
                            segString = segundos < 10 ? "0" + segString : segString;
                            int horas = minutos / 60;
                            minutos = minutos % 60;
                            String minString = minutos + "";
                            minString = minutos < 10 ? "0" + minString : minString;
                            int dias = horas / 24;
                            horas = horas % 24;
                            String hrString = horas + "";
                            hrString = horas < 10 ? "0" + hrString : hrString;
                            tiempoDeshabilitado = hrString + ":" + minString + ":" + segString;
                            out.println("<td>"+tiempoDeshabilitado+"</td></tr>");
                        }
                    }
                    
                }
                out.print("</table>");
            }
        }
        } catch (Exception ex) {
            out.println(ex.toString());
            System.out.println("Error en COLAS: "+ex);
        }
        finally {
            try {
                conexion.close();
                rs.close();
                rs2.close();
                pst.close();
                pst2.close();
                rs3.close();
                pst3.close();
                rs4.close();
                rs5.close();
                pst4.close();
                pst5.close();
            }
            catch (Exception ex) {
                //ex.printStackTrace();
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
