<%@page import="DTO.Configuracion"%>
<%@page import="query.IPKall"%>
<%@page import="query.Reckall"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1" language="java"
    import="adportas.*"%>
<%
    Configuracion confReckall = Reckall.conf==null?Reckall.configuracionReckall():Reckall.conf;
    Configuracion confIPkall = IPKall.conf==null?IPKall.configuracionIPKall():IPKall.conf;
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
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_cabecera.html");
        String t_menu = Plantillas.leer(ruta + "/plantillas/menuAdmin.html");
        String t_contenido = "";
        //tio permamnente
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_hdext%", msgs.getString("menu.btn.hbext"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_cola%", msgs.getString("menu.btn.cola"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_agt%", ruta+"/imagenes/agente.png");
        if(confReckall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","<td width='135' align='center'><a href='grabaciones.jsp' target='FramePrincipal' ><img src='imagenes/voice.png'></a></td>");
        }
        else{
            t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","");
        }
        if(confIPkall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","<td width='10' align='center'><a href='campana.jsp'  target='_top' ><img src='imagenes/campana.png'></a></td>");
        }else{
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","");
        }
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_conf%", msgs.getString("menu.btn.conf"));
        //t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_agt%", ruta+"/imagenes/agente.png");
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
        String t_menu = Plantillas.leer(ruta + "/plantillas/menuPool.html");
        String t_contenido = "";
        
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_hdext%", msgs.getString("menu.btn.hbext"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_cola%", msgs.getString("menu.btn.cola"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_agt%", ruta+"/imagenes/agente.png");
        if(confReckall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","<td width='135' align='center'><a href='grabaciones.jsp' target='FramePrincipal' ><img src='imagenes/voice.png'></a></td>");
        }
        else{
        t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","");
        }
        if(confIPkall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","<td width='10' align='center'><a href='campana.jsp'  target='_top' ><img src='imagenes/campana.png'></a></td>");
        }
        else{
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","");
        }
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_conf%", msgs.getString("menu.btn.conf"));
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_btn_exit%", msgs.getString("menu.btn.exit"));

        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_plantilla%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido_pagina%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

        out.println(t_maestra);

    }else if(sesionActual.compareTo("usuario")==0){
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_cabecera.html");
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu.html");
        String t_contenido = "";
        t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","<td width='135' align='center'><a href='grabaciones.jsp' target='FramePrincipal' class='btnMenu btncola'>"+msgs.getString("menu.btn.grab")+"</a></td>");
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_hdext%", msgs.getString("menu.btn.hbext"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_cola%", msgs.getString("menu.btn.cola"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_agt%", msgs.getString("menu.btn.agt"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_conf%", msgs.getString("menu.btn.conf"));
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_btn_exit%", msgs.getString("menu.btn.exit"));
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_plantilla%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido_pagina%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

        out.println(t_maestra);

    }
    else if(sesionActual.equalsIgnoreCase("supervisor")){
    String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_cabecera.html");
        String t_menu = Plantillas.leer(ruta + "/plantillas/menuSupervisor.html");
        String t_contenido = "";
        if(confReckall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","<td width='135' align='center'><a href='grabaciones.jsp' target='FramePrincipal' ><img src='imagenes/voice.png'></a></td>");
        }
        else{
        t_menu = Plantillas.reemplazar(t_menu,"%grabaciones%","");
        }
        if(confIPkall.isIntegrado()){
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","<td width='10' align='center'><a href='campana.jsp'  target='_top' ><img src='imagenes/campana.png'></a></td>");
        }
        else{
            t_menu = Plantillas.reemplazar(t_menu,"%campanas%","");
        }        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_hdext%", msgs.getString("menu.btn.hbext"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_cola%", msgs.getString("menu.btn.cola"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_agt%", msgs.getString("menu.btn.agt"));
        t_menu = Plantillas.reemplazar(t_menu, "%menu_btn_conf%", msgs.getString("menu.btn.conf"));
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_btn_exit%", msgs.getString("menu.btn.exit"));
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu_plantilla%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido_pagina%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

        out.println(t_maestra);

    }
    else {
        out.println("<script>");
        out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
        out.println("</script>");
        out.println("<body onload=\'regresar()\';>");
    }
%>



