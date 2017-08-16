<%-- 
    Document   : configuracion
    Created on : 03-08-2009, 09:48:13 AM
    Author     : max
--%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1" language = "java"
    import="java.sql.*"
    import="adportas.*"
%>
 

<%
String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";

ResourceBundle msgs;
if(session.getAttribute("msgs")==null){
    Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
    ResourceBundle.clearCache();
    msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
}else{
    msgs = (ResourceBundle) session.getAttribute("msgs");
}
if (sesionActual.equalsIgnoreCase("adm_general")) {
    String ruta = getServletConfig().getServletContext().getRealPath("");
    String t_maestra =Plantillas.leer(ruta + "/plantillas/plantilla_cabecera.html");
    String t_menu = Plantillas.leer(ruta + "/plantillas/menu_configuracion_administrador.html");
    String t_contenido = "";
    
    t_menu = Plantillas.reemplazar(t_menu, "%conf_menu_title%", msgs.getString("conf.menu.title"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_user%", msgs.getString("conf.menu.btn.user"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_extn%", msgs.getString("conf.menu.btn.extn"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_nvirt%", msgs.getString("conf.menu.btn.nvrt"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_cti%", msgs.getString("conf.menu.btn.cti"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_monitor%", msgs.getString("conf.menu.btn.monitor"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_hor%", msgs.getString("conf.menu.btn.hor"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_inter%", msgs.getString("conf.menu.btn.inter"));
    t_menu = Plantillas.reemplazar(t_menu, "%conf_btn_extconf%", msgs.getString("conf.menu.btn.exit"));
    
    t_maestra = Plantillas.reemplazar(t_maestra, "%menu_btn_exit%", msgs.getString("menu.btn.exit"));
    
    t_maestra = Plantillas.reemplazar(t_maestra, "%menu_plantilla%", t_menu);
    t_maestra = Plantillas.reemplazar(t_maestra, "%contenido_pagina%", t_contenido);
    t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

    out.println(t_maestra);
}else if(sesionActual.equalsIgnoreCase("adm_pool") || sesionActual.trim().equalsIgnoreCase("ggee_asistencia") || sesionActual.trim().equalsIgnoreCase("ggee_secretaria")
            || sesionActual.trim().equalsIgnoreCase("cap") || sesionActual.trim().equalsIgnoreCase("imb_asistencia")
            || sesionActual.trim().equalsIgnoreCase("imb_secretaria") || sesionActual.trim().equalsIgnoreCase("pac_asistencia")
            || sesionActual.trim().equalsIgnoreCase("pac_secretaria") || sesionActual.trim().equalsIgnoreCase("may1")
            || sesionActual.trim().equalsIgnoreCase("may2") || sesionActual.trim().equalsIgnoreCase("may3") || sesionActual.trim().equalsIgnoreCase("may4"))
{
    String ruta = getServletConfig().getServletContext().getRealPath("");
    String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_cabecera.html");
    String t_menu = Plantillas.leer(ruta + "/plantillas/menu_configuracion_pool.html");
    String t_contenido = "";
    
    t_maestra = Plantillas.reemplazar(t_maestra, "%menu_btn_exit%", msgs.getString("menu.btn.exit"));

    t_maestra = Plantillas.reemplazar(t_maestra, "%menu_plantilla%", t_menu);
    t_maestra = Plantillas.reemplazar(t_maestra, "%contenido_pagina%", t_contenido);
    t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

    out.println(t_maestra);

} else {
    out.println("<script>");
    out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
    out.println("</script>");
    out.println("<body onload=\'regresar()\';>");
}
%>