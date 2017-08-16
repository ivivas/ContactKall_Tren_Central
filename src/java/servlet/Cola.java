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
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Jose
 */
public class Cola extends HttpServlet {

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        ResultSet rs = null, rs2 = null, rs3 = null, rs4 = null, rs5 = null;
        PreparedStatement pst = null, pst2 = null, pst3 = null, pst4 = null, pst5 = null;
        Connection conexion = null;
        try {
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
            pst = conexion.prepareStatement("SELECT * FROM pilotos");
            Map mapaPilotos = ServidorMapaPilotos.mapaPilotos;
            rs = pst.executeQuery();
            pst2 = null;
            rs2 = null;
            pst3 = null;
            rs3 = null;
            pst4 = null;
            rs4 = null;
            if (mapaPilotos == null) {
                out.print("Error...");
            } else {
                while (rs.next()) {
                    String pilotorg = request.getParameter("piloto");
                    if (pilotorg.equals(rs.getString("piloto"))) {
                        String id = rs.getString("id").trim();
                        pst2 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where id_pilotos = ? and fecha_llamada > ? and fecha_llamada < ? ");
                        String piloto = rs.getString("piloto") != null ? rs.getString("piloto").trim() : "";
                        pst2.setInt(1, Integer.parseInt(id));
                        pst2.setTimestamp(2, timestampAyer);
                        pst2.setTimestamp(3, timestampMannana);
                        rs2 = pst2.executeQuery();
                        pst3 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where id_pilotos = ? and fecha_llamada > ? and fecha_llamada < ? and tipo_llamada = 1");
                        pst3.setInt(1, Integer.parseInt(id));
                        pst3.setTimestamp(2, timestampAyer);
                        pst3.setTimestamp(3, timestampMannana);
                        rs3 = pst3.executeQuery();
                        pst4 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where id_pilotos = ? and fecha_llamada > ? and fecha_llamada < ? and tipo_llamada = 2");
                        pst4.setInt(1, Integer.parseInt(id));
                        pst4.setTimestamp(2, timestampAyer);
                        pst4.setTimestamp(3, timestampMannana);
                        rs4 = pst4.executeQuery();
                        rs2.next();
                        rs3.next();
                        rs4.next();
                        PilotoPortal pp = (PilotoPortal) mapaPilotos.get(piloto);
//                        out.print("<a href='#' id='pickup' onClick='pickup()'>Pickup</a>");
                        out.print("<div style=\"width:100%\"><a href='#' class='botones btnadddel' id='pickup' onClick='pickup()'>Pickup</a><div>");
                        out.print("Cantidad Llamadas en cola: ");
                        out.println(rs.getString("llamadas_en_cola") != null ? rs.getString("llamadas_en_cola").trim() : "0");
                        out.print("<br>");
                        out.println("<table class=\"cola_llamados\"><tr><th>Número Entrante</th><th>Tiempo en Espera</th></tr>");
                        if (pp != null && !pp.getMapaLlamadasEnCola().isEmpty()) {
                            Iterator it = pp.getMapaLlamadasEnCola().values().iterator();
                            while (it.hasNext()) {
                                //out.println("<llamadaEncolada>");
                                DTO.LlamadaEncoladaPortal llamadaEncolada = (DTO.LlamadaEncoladaPortal) it.next();
                                String numLlamante = llamadaEncolada.getNumeroLlamante();
                                int idLlamada = llamadaEncolada.getIdLlamada();
                                out.println("<tr><td>" + numLlamante + "</td>");
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
                                    out.println("<td>" + tiempoDeshabilitado + "</td></tr>");
                                }
                            }
                            out.print("</table>");
                        }
                    }
                }
            }
        } catch (Exception ex) {
            out.println(ex.toString());
            ex.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                //ex.printStackTrace();
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
