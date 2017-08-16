<%-- 
    Document   : secretarias
    Created on : 21-07-2009, 12:20:16 PM
    Author     : max
--%>

<%@page import="adportas.SQLConexion"%>
<%@ page contentType="text/xml" pageEncoding="UTF-8" language="java"
         import="adportas.Disponibilidad"
         import="adportas.Postgres"
         
         import="java.sql.*"
        %>

<%
    Connection conexion = null;
            try {

                conexion = SQLConexion.conectar();
                PreparedStatement pst = conexion.prepareStatement("SELECT * FROM secretaria order by estado desc, estado_uso asc, ultimo_uso desc");
                //PreparedStatement pst = conexion.prepareStatement("SELECT * FROM secretaria WHERE piloto_asociado = ? order by nombre");
                //pst.setString(1, piloto);
                ResultSet rs = pst.executeQuery();
                out.println("<Pool>");
                while (rs.next()) {
                    Timestamp fechaDeshabilitacion = rs.getTimestamp("fecha_deshabilitacion");
                    String motivoDeshabilitacion = (rs.getString("motivo_de_deshabilitacion") != null) ? rs.getString("motivo_de_deshabilitacion") : "";
                    String motivoError = (rs.getString("motivo_error") != null) ? rs.getString("motivo_error") : "";
                    String sep = (rs.getString("sep") != null) ? rs.getString("sep") : "";
                    String anexo = (rs.getString("anexo") != null) ? rs.getString("anexo") : "";
                    String id = (rs.getString("id") != null) ? rs.getString("id") : "";
                    String nombre = (rs.getString("nombre") != null) ? rs.getString("nombre") : "";
                    String estado = (rs.getString("estado") != null) ? rs.getString("estado") : "";
                    String ultimoUso = (rs.getString("ultimo_uso") != null) ? rs.getString("ultimo_uso") : "";
                    String estadoUso = (rs.getString("estado_uso") != null) ? rs.getString("estado_uso") : "";
                    String piloto_asociado_ = (rs.getString("piloto_asociado") != null) ? rs.getString("piloto_asociado") : "0";
                    String tiempoDeshabilitado = "";
                    if (fechaDeshabilitacion != null) {
                        java.util.Date fechaActual = new java.util.Date();
                       long diferencia = fechaActual.getTime()-fechaDeshabilitacion.getTime();
                       
                       int segundos  = (int) Math.floor(diferencia / (1000));

                       int minutos = segundos / 60  ;

                       segundos =  segundos % 60;
                       String segString = segundos+"";
                       segString = segundos < 10  ? "0" + segString:segString;
                       int horas = minutos /60;
                       minutos = minutos %60;
                       String minString = minutos+"";
                       minString = minutos < 10  ? "0" + minString:minString;
                       int dias = horas /24;
                       horas= horas % 24;
                       String hrString = horas+"";
                       hrString = horas < 10  ? "0" + hrString:hrString;

                         tiempoDeshabilitado =dias + " Dias "+hrString + ":" + minString + ":" + segString;

                    }
                    out.println("   <secretaria>");
                    out.println("       <id>");
                    out.println(id.trim());
                    out.println("</id>");
                    out.println("       <anexo>");
                    out.println(anexo.trim());
                    out.println("</anexo>");
                    out.println("       <sep>");
                    out.println(sep.trim());
                    out.println("</sep>");
                    out.println("       <nombre>");
                    out.println(nombre.trim());
                    out.println("</nombre>");
                    out.println("       <estado>");
                    out.println(estado.trim());
                    out.println("</estado>");
                    out.println("       <ultimo_uso>");
                    out.println(ultimoUso.trim());
                    out.println("</ultimo_uso>");
                    out.println("       <estado_uso>");
                    out.println(estadoUso.trim());
                    out.println("</estado_uso>");
                    out.println("       <piloto_asociado>");
                    out.println(piloto_asociado_.trim());
                    out.println("</piloto_asociado>");
                    out.println("       <motivoDeshabilitacion>");
                    out.println(motivoDeshabilitacion.trim());
                    out.println("</motivoDeshabilitacion>");
                    out.println("       <tiempoDeshabilitado>");
                    out.println(tiempoDeshabilitado.trim());
                    out.println("</tiempoDeshabilitado>");
                    out.println("       <motivoError>");
                    out.println(motivoError.trim());
                    out.println("</motivoError>");
                    out.println("   </secretaria>");  //(request.getParameter("p")!=null) ? request.getParameter("p") : "";
                    out.flush();
                }
                rs.close();
                pst.close();
                out.println("</Pool>");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            finally{
                try{
                    conexion.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }

            }
       

%>

