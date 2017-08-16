<%-- 
    Document   : disponibilidad
    Created on : 13-07-2009, 03:29:29 PM
    Author     : max
--%>

<%@page import="query.ComboQuery"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"
        import="java.sql.*"
        import="java.util.Vector"
        import="java.util.List"
        import="java.util.ArrayList"
        import="adportas.Disponibilidad"
        import="adportas.Plantillas"
        %>

<%
            String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
            if (!sesionActual.equalsIgnoreCase("adm_general") && !sesionActual.equalsIgnoreCase("supervisor") && !sesionActual.equalsIgnoreCase("adm_pool") && !sesionActual.equalsIgnoreCase("usuario") && !sesionActual.equalsIgnoreCase("ggee_asistencia") && !sesionActual.equalsIgnoreCase("ggee_secretaria") && !sesionActual.equalsIgnoreCase("cap") && !sesionActual.equalsIgnoreCase("imb_secretaria") && !sesionActual.equalsIgnoreCase("imb_asistencia") && !sesionActual.equalsIgnoreCase("pac_asistencia") && !sesionActual.equalsIgnoreCase("pac_secretaria") && !sesionActual.equalsIgnoreCase("may1") && !sesionActual.equalsIgnoreCase("may2") && !sesionActual.equalsIgnoreCase("may3") && !sesionActual.equalsIgnoreCase("may4") ) {
                out.println("<script>");
                out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
                out.println("</script>");
                out.println("<body onload=\'regresar()\';>");
            } else {
                
                ResourceBundle msgs;
                if(session.getAttribute("msgs")==null){
                    Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                    ResourceBundle.clearCache();
                    msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
                }else{
                    msgs = (ResourceBundle) session.getAttribute("msgs");
                }

                /*********************PLANTILLAS************************/
                String ruta = getServletConfig().getServletContext().getRealPath("");
                String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
                t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

                String t_contenido = Plantillas.leer(ruta + "/plantillas/disponibilidad.html");
                t_contenido = Plantillas.reemplazar(t_contenido, "%sesion%", sesionActual);
                t_contenido = Plantillas.reemplazar(t_contenido, "%disp_applet_jar%", msgs.getString("pagina.applet"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%menu%", ComboQuery.menu());   
                t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);

                out.println(t_maestra);
            }
%>
