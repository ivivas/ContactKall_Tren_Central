<%@page import="query.SesionQuery"%>
<%@page import="BO.CargaMenu"%>
<%@page import="DTO.Configuracion"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="query.IPKall"%>
<%@page import="query.AgenteQuery"%>
<%@page import="adportas.Plantillas"%>
<%@page import="query.ComboQuery"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%
    Connection con = null;
    Configuracion confIPkall = IPKall.conf==null?IPKall.configuracionIPKall():IPKall.conf;
    ResourceBundle msgs = null;
    try{
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
        if(sesionActual.equals("adm_general") | sesionActual.equals("supervisor")){
            ComboQuery ii = new ComboQuery();
            String user = session.getAttribute("usuario").toString().trim();
            try{
                con = SQLConexion.conectar();
            }catch(Exception e){
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
            }catch(Exception e){
                datosSupervisor = "";
                anexo = "";
                deviceName = "";
            }
            String idPiloto="";
            String pilotoAsoc = "";
            if(sesionActual.equals("supervisor")){
                idPiloto = SesionQuery.idPilotoSesion(user)+"";
                pilotoAsoc = SesionQuery.pilotoById(Integer.parseInt(idPiloto));
            }

            if(!anexo.equals("") || !deviceName.equals("")||sesionActual.equals("adm_general")){
                String piloto = request.getParameter("piloto")==null?"":request.getParameter("piloto");
                String opcionesPiloto = ComboQuery.comboPiloto(con,piloto,user,sesionActual);
                String ruta	= getServletConfig().getServletContext().getRealPath("");

                String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
                String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
                String t_contenido = Plantillas.leer(ruta + "/plantillas/piloto.html");
                String t_css = Plantillas.leer(ruta + "/css/agente.css");
                String t_javascript = Plantillas.leer(ruta + "/js/piloto.js");

                t_menu = Plantillas.reemplazar(t_menu, "%class_hab%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_disp%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_grab%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%","botonesactive");
                t_menu = Plantillas.reemplazar(t_menu, "%class_agente%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_camp%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_enc%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_ges%","botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

                t_javascript = Plantillas.reemplazar(t_javascript, "%cargando%", msgs.getString("dashboard.cargando"));
                t_javascript = Plantillas.reemplazar(t_javascript, "%nueva_pestaña%",  msgs.getString("agente.browser.nueva.pestaña"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%opciones_piloto%", opcionesPiloto);
                t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%",supervisor);
                t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
                t_contenido = Plantillas.reemplazar(t_contenido, "%devicename%", deviceName);
                t_contenido = Plantillas.reemplazar(t_contenido, "%supervisor%", msgs.getString("agente.supervisor"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%anx%",  msgs.getString("agente.supervisor.anexo"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%devname%",  msgs.getString("agente.supervisor.devicename"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%cerrar_sesion%",  msgs.getString("agente.cerrar.sesion"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%value_user%",  user);
                t_contenido = Plantillas.reemplazar(t_contenido, "%value_perfil%",  sesionActual);
                t_contenido = Plantillas.reemplazar(t_contenido, "%value_idpilas%",  idPiloto);
                t_contenido = Plantillas.reemplazar(t_contenido, "%value_pilasoc%",  pilotoAsoc);

                if(confIPkall.isIntegrado()){
                    Connection conIP = SQLConexion.conectaIPKall(confIPkall.getIpServidor(),confIPkall.getBaseDatos(),confIPkall.getUsuarioBD(),confIPkall.getClaveBD());
                    t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%", IPKall.campanasModuloSupervisor(conIP));
                    t_contenido = Plantillas.reemplazar(t_contenido, "%campana_disponible%", msgs.getString("campana.disponible"));
                    t_contenido = Plantillas.reemplazar(t_contenido, "%visible%", "style='visibility:visible;'");
                    conIP.close();
                }else{
                    t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%","");
                    t_contenido = Plantillas.reemplazar(t_contenido, "%campana_disponible%", "");
                    t_contenido = Plantillas.reemplazar(t_contenido, "%visible%", "style='visibility:hidden;'");
                }
                String tieneTitulos = ii.getTieneTitulos(msgs);
                if(tieneTitulos != ""){
                    t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%","<div id=\"titulo\"><h2>"+msgs.getString("menu.adm.txt.pilotos")+"</h2></div>" );
                }else{
                    t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
                }

                t_contenido = Plantillas.reemplazar(t_contenido, "%datosSupervisor%", datosSupervisor);
                t_maestra = Plantillas.reemplazar(t_maestra,"%css%", t_css) ;
                t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
                t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
                t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%", t_contenido) ;

                out.print(t_maestra);
            }else{
                out.println("supervisor debe tener anexo y devicename configurado");
                out.println("<br><a href='habilitador2.jsp'>Volver</a");        
            }

        }else{
            out.print(msgs.getString("agente.permisos"));
            response.sendRedirect("index.jsp");
        }
    }catch(Exception e){
        System.out.println("Error en Piloto.jsp: "+e);
    }finally{
        try{
        con.close();
        }catch(Exception e){}
    }
%>