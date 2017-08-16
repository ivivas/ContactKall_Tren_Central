<%@page import="query.AgenteQuery"%>
<%@page import="DTO.Configuracion"%>
<%@page import="query.IPKall"%>
<%@page import="adportas.Plantillas"%>
<%@page import="query.ComboQuery"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.sql.Connection"%>
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
    if(sesionActual.equals("adm_general") | sesionActual.equals("usuario")){
        try{
            con = SQLConexion.conectar();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        String usuario = session.getAttribute("usuario").toString();
        String datosUsuario;
            String anexo;
            String deviceName;
        try{
            datosUsuario = ComboQuery.getAnexoSupervisor(con,usuario);
            anexo = datosUsuario.split("-")[0];
            deviceName = datosUsuario.split("-")[1];
        }
        catch(Exception e){
            datosUsuario = "";
            anexo = "";
            deviceName = "";
        }
        if(!anexo.equals("") | !deviceName.equals("")|sesionActual.equals("adm_general")){
            String piloto = request.getParameter("piloto")==null?"":request.getParameter("piloto");
            String opcionesPiloto = ComboQuery.comboPiloto(con,piloto);
            String opcionHD = ComboQuery.estadoAgente(con,anexo);
            String ruta	= getServletConfig().getServletContext().getRealPath("");
            String t_contenido = Plantillas.leer(ruta + "/plantillas/agente.html");
            t_contenido = Plantillas.reemplazar(t_contenido, "%opciones_piloto%", opcionesPiloto);
            t_contenido = Plantillas.reemplazar(t_contenido, "%piloto%", piloto);
            t_contenido = Plantillas.reemplazar(t_contenido, "%seleccione%", msgs.getString("agente.seleccione"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.ok%", msgs.getString("agente.ok"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.nook%", msgs.getString("agente.nook"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.out%", msgs.getString("agente.out"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%agente.sin%", msgs.getString("agente.sin"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%",usuario);
            t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
            t_contenido = Plantillas.reemplazar(t_contenido, "%devicename%", deviceName);
            t_contenido = Plantillas.reemplazar(t_contenido, "%device%", deviceName);
            t_contenido = Plantillas.reemplazar(t_contenido, "%datosSupervisor%", datosUsuario);
            t_contenido = Plantillas.reemplazar(t_contenido, "%supervisor%", msgs.getString("agente.usuario"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%anx%",  msgs.getString("agente.supervisor.anexo"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%devname%",  msgs.getString("agente.supervisor.devicename"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%estado%",  msgs.getString("agente.usuario.estado"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%cerrar_sesion%",  msgs.getString("agente.cerrar.sesion"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%hd%",  opcionHD);
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
                conIPkall.close();
            }
            else{
                t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%campana_disponible%", "");
                t_contenido = Plantillas.reemplazar(t_contenido, "%visible%", "style='visibility:hidden;'");
            }
            t_contenido = Plantillas.reemplazar(t_contenido, "%jquery%", ruta+"/js/jquery.js");
            String t_javascript = Plantillas.leer(ruta + "/js/agente.js");
            t_javascript = Plantillas.reemplazar(t_javascript, "%cargando%", msgs.getString("dashboard.cargando"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%nueva_pestaña%",  msgs.getString("agente.browser.nueva.pestaña"));
            String t_css = Plantillas.leer(ruta + "/css/agente.css");
            t_contenido = Plantillas.reemplazar(t_contenido,"%javascript%",t_javascript);
            t_contenido = Plantillas.reemplazar(t_contenido,"%css%",t_css);
            out.print(t_contenido);
        }
        else{
                out.println(msgs.getString("agente.error.conf"));
                out.println("<br><a href='habilitador2.jsp'>Volver</a");
        }
        con.close();
    }
    else{
        out.print(msgs.getString("agente.permisos"));
        response.sendRedirect("index.jsp");
    }
%>