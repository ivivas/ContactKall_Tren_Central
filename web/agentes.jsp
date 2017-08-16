<%@page import="BO.CargaMenu"%>
<%@page import="DTO.Configuracion"%>
<%@page import="query.IPKall"%>
<%@page import="query.AgenteQuery"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="query.ComboQuery"%>
<%@page import="adportas.Plantillas"%>
<%
    Configuracion confIPkall = IPKall.conf==null?IPKall.configuracionIPKall():IPKall.conf;
    Connection con = null;
    ResourceBundle msgs = null;
    if(session.getAttribute("msgs")==null){
        Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
        ResourceBundle.clearCache();
        msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
    }
    else{
        msgs = (ResourceBundle) session.getAttribute("msgs");
    }
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if(sesionActual.equals("adm_general") | sesionActual.equals("supervisor")){
        ComboQuery ii = new ComboQuery();
        String user = session.getAttribute("usuario").toString().trim();
        try{
            con = SQLConexion.conectar();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        String supervisor = session.getAttribute("usuario").toString();
        String datosSupervisor;
        String anexo;
        String deviceName;
        try{
            datosSupervisor = ComboQuery.getAnexoSupervisor(con,supervisor);
            anexo = datosSupervisor.split("-")[0];
            deviceName = datosSupervisor.split("-")[1];
        }
        catch(Exception e){
            datosSupervisor = "";
            anexo = "";
            deviceName = "";
        }
        if(!anexo.equals("") | !deviceName.equals("")|sesionActual.equals("adm_general")){
            String piloto = request.getParameter("piloto")==null?"":request.getParameter("piloto");
            String opcionesPiloto = ComboQuery.comboPiloto(con,piloto,user,sesionActual);
            String ruta	= getServletConfig().getServletContext().getRealPath("");
            
            String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
            String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
            
            t_menu = Plantillas.reemplazar(t_menu, "%class_hab%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_disp%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_grab%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_agente%","botonesactive");
            t_menu = Plantillas.reemplazar(t_menu, "%class_camp%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_enc%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ges%","botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");
            
            String t_contenido = Plantillas.leer(ruta + "/plantillas/agentes.html");
            t_contenido = Plantillas.reemplazar(t_contenido, "%opciones_piloto%", opcionesPiloto);
            t_contenido = Plantillas.reemplazar(t_contenido, "%piloto%", piloto);
            t_contenido = Plantillas.reemplazar(t_contenido, "%seleccione%", msgs.getString("agente.seleccione"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.ok%", msgs.getString("agente.ok"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.nook%", msgs.getString("agente.nook"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.out%", msgs.getString("agente.out"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.sin%", msgs.getString("agente.sin"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%",supervisor);
            t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
            t_contenido = Plantillas.reemplazar(t_contenido, "%devicename%", deviceName);
            t_contenido = Plantillas.reemplazar(t_contenido, "%datosSupervisor%", datosSupervisor);
            t_contenido = Plantillas.reemplazar(t_contenido, "%supervisor%", msgs.getString("agente.supervisor"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%anx%",  msgs.getString("agente.supervisor.anexo"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%devname%",  msgs.getString("agente.supervisor.devicename"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%cerrar_sesion%",  msgs.getString("agente.cerrar.sesion"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%num_piloto%",  msgs.getString("reckall.piloto"));
//            t_contenido = Plantillas.reemplazar(t_contenido, "%cola%", AgenteQuery.listarCola(con,piloto)+"");
            if(confIPkall.isIntegrado()){
                Connection conIPkall = null;
                try{
                    conIPkall = SQLConexion.conectaIPKall(confIPkall.getIpServidor(),confIPkall.getBaseDatos(), confIPkall.getUsuarioBD(), confIPkall.getClaveBD());
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%", IPKall.campanasModuloSupervisor(conIPkall));
                t_contenido = Plantillas.reemplazar(t_contenido, "%campana_disponible%", msgs.getString("campana.disponible"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%visible%", "style='visibility:visible;'");
                if(conIPkall!=null){
                    conIPkall.close();
                }
            }else{
                t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%campana_disponible%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%visible%", "style='visibility:hidden;'");
            }
            
            String tieneTitulos = ii.getTieneTitulos(msgs);
            if(tieneTitulos != ""){
                t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%","<div id=\"titulo\"><h2>"+msgs.getString("menu.adm.txt.agentes")+"</h2></div>" );
            }else{
                t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
            }
            
            t_contenido = Plantillas.reemplazar(t_contenido, "%jquery%", ruta+"\\js\\jquery.js");
            String t_javascript = Plantillas.leer(ruta + "/js/agente.js");
            t_javascript = Plantillas.reemplazar(t_javascript, "%cargando%", msgs.getString("dashboard.cargando"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%nueva_pestaña%",  msgs.getString("agente.browser.nueva.pestaña"));
                t_javascript = Plantillas.reemplazar(t_javascript, "%msg_silence%",  msgs.getString("msg.caluga.monsil"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_coach%",  msgs.getString("msg.caluga.moncoach"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_cortar%",  msgs.getString("msg.caluga.end"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_grab%",  msgs.getString("menu.btn.grab"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_conf%",  msgs.getString("msg.caluga.conf"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_robar%",  msgs.getString("msg.caluga.robar"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%msg_habili%",  msgs.getString("msg.caluga.habdes"));
            
            
            String t_css = Plantillas.leer(ruta + "/css/agente.css");
            
            
            //t_contenido = Plantillas.reemplazar(t_contenido,"%javascript%",t_javascript);
            //t_contenido = Plantillas.reemplazar(t_contenido,"%css%",t_css);
            t_maestra = Plantillas.reemplazar(t_maestra,"%css%", t_css) ;
            t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
            t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
            t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%", t_contenido) ;
            
            out.print(t_maestra);
        }else{
                out.println(msgs.getString("agente.error.conf"));
                out.println("<br><a href='habilitador2.jsp'>Volver</a");
        }
        con.close();
    }else{
        out.print(msgs.getString("agente.permisos"));
        response.sendRedirect("index.jsp");
    }
%>