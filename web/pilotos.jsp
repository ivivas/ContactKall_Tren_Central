<%@page import="SocketServer.ServidorMapaPilotos"%>
<%@page import="DTO.PilotoPortal"%>
<%@ page contentType="text/xml" 
         pageEncoding="UTF-8" 
         language="java"
         import="adportas.*"
         import="java.sql.*"
         import="java.util.*"
         %>
<%
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
        String tipo = (String) session.getAttribute("tipo");
        String usuario = (String) session.getAttribute("usuario");

        conexion = SQLConexion.conectar();
        pst = null;
        pst = conexion.prepareStatement("SELECT * FROM pilotos");
        Map mapaPilotos = ServidorMapaPilotos.mapaPilotos;
        rs = pst.executeQuery();
        //String ruta = getServletConfig().getServletContext().getRealPath("");
        pst2 = null;
        rs2 = null;
        pst3 = null;
        rs3 = null;
        pst4 = null;
        rs4 = null;
        out.println("<Pool>");
        while (rs.next()) {
            String id = rs.getString("id").trim();
            pst2 = conexion.prepareStatement("SELECT count(*) as cantidad FROM llamadas where id_pilotos = ? and fecha_llamada > ? and fecha_llamada < ? ");
            String piloto = rs.getString("piloto") != null ? rs.getString("piloto").trim() : "";
            pst2.setInt(1, Integer.parseInt(id));
            pst2.setTimestamp(2, timestampAyer);
            pst2.setTimestamp(3, timestampMannana);
            rs2 = pst2.executeQuery();
            //   System.out.println(pst2.toString());
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
            out.println("   <pilotos>");
            out.println("       <id>");
            out.println(id);
            out.println("</id>");
            out.println("       <piloto>");
            out.println(rs.getString("piloto").trim());
            out.println("</piloto>");
            out.println("       <descripcion>");
            out.println(rs.getString("descripcion").trim());
            out.println("</descripcion>");
            out.println("       <llamadasEnCola>");
            out.println(rs.getString("llamadas_en_cola") != null ? rs.getString("llamadas_en_cola").trim() : "0");
            out.println("</llamadasEnCola>");
            out.println("       <cantidadLlamadas>");
            out.println(rs2.getInt("cantidad"));
            out.println("</cantidadLlamadas>");
            out.println("<llamadasEncoladas>");
            if (pp != null && !pp.getMapaLlamadasEnCola().isEmpty()) {
                Iterator it = pp.getMapaLlamadasEnCola().values().iterator();
                while (it.hasNext()) {
                    out.println("<llamadaEncolada>");
                    DTO.LlamadaEncoladaPortal llamadaEncolada = (DTO.LlamadaEncoladaPortal) it.next();
                    String numLlamante = llamadaEncolada.getNumeroLlamante();
                    int idLlamada = llamadaEncolada.getIdLlamada();
                    out.println("<llamante>");
                    out.println(numLlamante);
                    out.println("</llamante>");
                    out.println("<tiempoEspera>");
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
                        out.println(tiempoDeshabilitado);

                    }
                    out.println("</tiempoEspera>");
                    out.println("</llamadaEncolada>");
                }
            }
            out.println("</llamadasEncoladas>");
            out.println("<monitores>");
            pst5 = conexion.prepareStatement("select m.id,m.extension,m.devicename,m.nombre from pilotos as p"
                    + " left join pilotos_monitores as pm on p.id = pm.id_piloto "
                    + " left join monitores as m on pm.id_monitor = m.id where p.id =?");
            pst5.setInt(1, rs.getInt("id"));
            rs5 = pst5.executeQuery();
            while(rs5.next()){
                int idMonitor = rs5.getInt("id");
                String devicename = rs5.getString("devicename") != null ? rs5.getString("devicename").trim().toUpperCase():"";
                String extension = rs5.getString("extension") != null ? rs5.getString("extension").trim():"";
                String nombre = rs5.getString("nombre") != null ? rs5.getString("nombre").trim():"";
                out.println("<monitor>");
                out.println("<id_monitor>");   
                out.println(""+idMonitor);   
                out.println("</id_monitor>");
                out.println("<devicename_monitor>");   
                out.println(""+devicename);   
                out.println("</devicename_monitor>");
                  
                out.println("<extension_monitor>");   
                out.println(""+extension);   
                out.println("</extension_monitor>");
                out.println("<nombre_monitor>");   
                out.println(""+nombre);   
                out.println("</nombre_monitor>");
                 
               out.println("</monitor>");  
            }
            out.println("</monitores>");
            out.println("       <cantidadLlamadasEntrantesXRoutePoint>");
            out.println(rs3.getInt("cantidad"));
            out.println("</cantidadLlamadasEntrantesXRoutePoint>");

            out.println("       <cantidadLlamadasEntrantesXAnexo>");
            out.println(rs4.getInt("cantidad"));
            out.println("</cantidadLlamadasEntrantesXAnexo>");

            out.println("       <anexoRebalse>");
            String anexoRebalse = rs.getString("anexo_rebalse") != null ? rs.getString("anexo_rebalse") : "";
            out.println(anexoRebalse.trim());
            out.println("</anexoRebalse>");
            out.println("   </pilotos>");
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
            out.println("</Pool>");
        } catch (Exception ex) {}
    }
%>


