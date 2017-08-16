<%@page import="DTO.EstadisticaIVR"%>
<%@page import="BO.EstadisticaIVRBo"%>
<%@page import="java.util.Calendar"%>
<%@page import="query.ComboQuery"%>
<%@page import="BO.CargaMenu"%>
<%@page import="adportas.Plantillas"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
    try {
        ResourceBundle msgs;
        if (session.getAttribute("msgs") == null) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        } else {
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
        if (sesionActual.equals("adm_general") | sesionActual.equals("supervisor")) {

            ComboQuery ii = new ComboQuery();

            String fechaDesde = request.getParameter("fechaDesde") != null ? request.getParameter("fechaDesde") : "";
            String fechaHasta = request.getParameter("fechaHasta") != null ? request.getParameter("fechaHasta") : "";
            String nivel = request.getParameter("nivel") != null ? request.getParameter("nivel") : "1";
            String invalida = request.getParameter("invalida");
            boolean mostrarInvalida = invalida != null ? true: false;
            String formatoFecha2 = "dd/MM/yyyy";
            java.text.SimpleDateFormat mCformatoFecha2 = new java.text.SimpleDateFormat(formatoFecha2);
            Calendar calendario = Calendar.getInstance();
            if (fechaHasta.equals("")) {
                calendario.add(Calendar.DATE, 0);
                fechaHasta = mCformatoFecha2.format(calendario.getTime()) + " 23:59:59";
            }
            if (fechaDesde.equals("")) {
                calendario.add(Calendar.DAY_OF_WEEK, -7);
                fechaDesde = mCformatoFecha2.format(calendario.getTime()) + " 00:00:00";
            }
            session.setAttribute("fechaDesde", fechaDesde);
            session.setAttribute("fechaHasta", fechaHasta);
            
            EstadisticaIVRBo eivrb = new EstadisticaIVRBo(fechaDesde, fechaHasta,Integer.parseInt(nivel));
            EstadisticaIVR bo = eivrb.obtenerEstadisticaIVR(mostrarInvalida);
            String[] colores = eivrb.getArrayColores();
            String valoresGrafico = "";
            String simbologiaIVR = "<table>";
            int totalInvalida = 0;
            for(int i = 0; i < bo.getIdAccion().size();i++){
                if(bo.getAccionInicial().get(i) == 42){
                    totalInvalida += bo.getCantidadOpcion().get(i);
                }
                else{
                    valoresGrafico += "{value: "+bo.getCantidadOpcion().get(i)+",color: '"+colores[i]+"',highlight: '"+colores[i]+"',label: '"+bo.getDescripcionAccion().get(i)+"'},";
                    simbologiaIVR+= "<tr><td>"+bo.getDescripcionAccion().get(i)+"</td><td>"+bo.getCantidadOpcion().get(i)+"</td><td style='background-color:"+colores[i] +";width:30px;'></td></tr>";
                }
            }
            if(mostrarInvalida){
                valoresGrafico += "{value: "+totalInvalida+",color: 'black',highlight: 'black',label: 'Opcion Invalida'},";
                    simbologiaIVR+= "<tr><td>Opcion Invalida</td><td>"+totalInvalida+"</td><td style='background-color:black;width:30px;'></td></tr>";
            }
            
            
            String ruta = getServletConfig().getServletContext().getRealPath("");
            String t_contenido = Plantillas.leer(ruta + "/plantillas/estadisticaIVR.html");
            String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
            //String t_javascript = Plantillas.leer(ruta + "/js/encuesta.js");

            String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);

            t_menu = Plantillas.reemplazar(t_menu, "%class_hab%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_disp%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_grab%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_agente%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_camp%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_enc%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ges%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botonesactive");
            t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

            String tieneTitulos = ii.getTieneTitulos(msgs);
            if (tieneTitulos != "") {
                t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "<div id=\"titulo\"><h2>" + msgs.getString("menu.adm.txt.ivr") + "</h2></div>");
            } else {
                t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "");
            }
            if(nivel.equals("1")){
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel1%", "selected");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel2%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel3%", "");
            }
            else if(nivel.equals("3")){
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel1%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel2%", "selected");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel3%", "");
            }
            else{
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel1%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel2%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sel3%", "selected");                
            }
            t_contenido = Plantillas.reemplazar(t_contenido, "%fechaDesde%", msgs.getString("reckall.fecha.desde"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%fechaHasta%", msgs.getString("reckall.fecha.hasta"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%desde%", fechaDesde);
            t_contenido = Plantillas.reemplazar(t_contenido, "%hasta%", fechaHasta);
            t_contenido = Plantillas.reemplazar(t_contenido, "%empty%", msgs.getString("msg.err.empty"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%format1%", msgs.getString("encuesta.format.date3"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%format2%", msgs.getString("encuesta.format.date3"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%formato_alert%", msgs.getString("encuesta.format.date3"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%valores_grafico%", valoresGrafico);
            t_contenido = Plantillas.reemplazar(t_contenido, "%simbologia_ivr%", simbologiaIVR);
            t_contenido = Plantillas.reemplazar(t_contenido, "%checked%", invalida!=null?" checked ":"");
            t_maestra = Plantillas.reemplazar(t_maestra, "%menu%", t_menu);
            t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
            t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");
            t_maestra = Plantillas.reemplazar(t_maestra, "%css%", "");

            out.println(t_maestra);
        } else {
            response.sendRedirect("index.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>