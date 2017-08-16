<%@page import="query.ComboQuery"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"%>
<% response.setHeader("Pragma","no-cache"); 
 response.setHeader("Cache-Control","no-cache"); 
 response.setDateHeader("Expires",0); 
 response.setDateHeader("max-age",0); 
 
    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equalsIgnoreCase("adm_general") || sesionActual.equalsIgnoreCase("adm_pool") || sesionActual.equalsIgnoreCase("usuario") || sesionActual.equalsIgnoreCase("ggee_asistencia") || sesionActual.equalsIgnoreCase("ggee_secretaria") || sesionActual.equalsIgnoreCase("cap") || sesionActual.equalsIgnoreCase("imb_secretaria") || sesionActual.equalsIgnoreCase("imb_asistencia") || sesionActual.equalsIgnoreCase("pac_asistencia") || sesionActual.equalsIgnoreCase("pac_secretaria") || sesionActual.equalsIgnoreCase("may_asistencia") || sesionActual.equalsIgnoreCase("may_secretaria") ) {
    
        String x="";
        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String error = "";
        String requestTrim_extensionNumero = "";
        String requestTrim_nombre = "";
        String requestTrim_devicenameNumero = "";
        String requestTrim_estado = "";
        String alertAfterLoad = "mostrarDivOpciones(document.getElementById('select_usuario_perfil'));";
        
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        /***************************************************************/
        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();

        try {
            /**************************** RECUPERO VALORES DE CAMPO Y CREO SELECT DE PERFIL *******************************/
            requestTrim_extensionNumero = (request.getParameter("extension_numero")!=null) ? (request.getParameter("extension_numero").trim()) : ("");
            requestTrim_devicenameNumero = (request.getParameter("devicename_numero") != null) ? (request.getParameter("devicename_numero").trim()) : ("");
            requestTrim_nombre = (request.getParameter("extension_nombre")!=null) ? (request.getParameter("extension_nombre").trim()) : ("");
            requestTrim_estado = (request.getParameter("extension_estado")!=null) ? (request.getParameter("extension_estado").trim()) : ("");
            
            /**************************** VERIFICAR DATOS Y AGREGAR USUARIOS ***************************/
            if (request.getParameter("agregar_anexo")!=null) {
                boolean erroresEncontrados = false;

                if (requestTrim_extensionNumero.compareTo("")==0 || requestTrim_nombre.compareTo("")==0   || requestTrim_devicenameNumero.compareTo("") == 0){
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }
                
                if (erroresEncontrados==false) {
                    
                    PreparedStatement pst = conexion.prepareStatement("INSERT INTO monitores (nombre,extension,devicename) values (?,?,?)");
                    try {                                                
                        pst.setString(1, requestTrim_nombre);
                        pst.setString(2, requestTrim_extensionNumero);
                        pst.setString(3, requestTrim_devicenameNumero);
                        pst.executeUpdate();
                        
                    } catch (Exception e) {
                        erroresEncontrados = true;
                        error = e.getMessage().replace("ERROR:","") ;
                    }
                    pst.close();
                }
                
                if (erroresEncontrados==false) {
                    response.sendRedirect("monitorRegistro.jsp");
                }
            }

        } catch (Exception e) {
            error = e.toString();
        }
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/monitorAgregar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNumero%",requestTrim_extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido, "%devicenameNumero%", requestTrim_devicenameNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNombre%",requestTrim_nombre);
        
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_title%",msgs.getString("monitor.add.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_data%",msgs.getString("monitor.add.tbl.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_monn%",msgs.getString("monitor.reg.tabla.monn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_name%",msgs.getString("monitor.reg.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_asoc%",msgs.getString("monitor.add.tbl.asoc"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_btn_save%",msgs.getString("extension.add.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extagr_btn_cancel%",msgs.getString("extension.add.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%pilotoAsoc%",msgs.getString("monitor.asignar.piloto"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monitorNumeroToolkit%",msgs.getString("monitor.numero.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monitorDNToolkit%",msgs.getString("monitor.dn.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monitorNombreToolkit%",msgs.getString("monitor.nombre.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monitorPilotoToolkit%",msgs.getString("monitor.piloto.toolkit"));
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.monitores%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.monitores%", msgs.getString("menu.adm.txt.monitores") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }
        
        String t_javascript = Plantillas.leer(ruta + "/js/extension.js");
        
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del1%", msgs.getString("error.msgs.principal.nodata"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del1%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_nodata%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc1%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc2%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc3%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc4%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del2%", msgs.getString("error.msgs.principal.nodata"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del2%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%","0");
        
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
        
        t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_monitor%","botonesactive");
        t_menu = Plantillas.reemplazar(t_menu,"%class_cti%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_horario%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_otros%","botones");
        
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.usuarios%",msgs.getString("menu.adm.txt.usuarios"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.extensiones%",msgs.getString("menu.adm.txt.extensiones"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.numeroVirtual%",msgs.getString("menu.adm.txt.numeroVirtual"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.monitores%",msgs.getString("menu.adm.txt.monitores"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.ctiPort%",msgs.getString("menu.adm.txt.ctiPort"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.horario%",msgs.getString("menu.adm.txt.horario"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.otros%",msgs.getString("menu.adm.txt.otros"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.volver%",msgs.getString("menu.adm.txt.volver"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.salir%",msgs.getString("menu.adm.txt.salir"));
        
        //String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%",t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "");

        out.println(t_maestra);
    } else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

