<%@page import="query.AcdKallGestion"%>
<%@page import="query.Reckall"%>
<%@page import="DTO.Configuracion"%>
<%@page import="query.ComboQuery"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*" %>
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
        String requestTrim_uso = "";
        String extension_movi = "";
        String alertAfterLoad = "mostrarDivOpciones(document.getElementById('select_usuario_perfil'));";
        int estado=0;
        String opcionReckall = "";
        int isExtnMb =0;
        
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
        Configuracion confReckall = Reckall.configuracionReckall();
        try {
            /**************************** RECUPERO VALORES DE CAMPO Y CREO SELECT DE PERFIL *******************************/
            requestTrim_extensionNumero = (request.getParameter("extension_numero")!=null) ? (request.getParameter("extension_numero").trim()) : ("");
            requestTrim_devicenameNumero = (request.getParameter("devicename_numero") != null) ? (request.getParameter("devicename_numero").trim()) : ("");
            requestTrim_nombre = (request.getParameter("extension_nombre")!=null) ? (request.getParameter("extension_nombre").trim()) : ("");
            requestTrim_estado = (request.getParameter("extension_estado")!=null) ? (request.getParameter("extension_estado").trim()) : ("");
            requestTrim_estado = (request.getParameter("extension_estado")!=null) ? (request.getParameter("extension_estado").trim()) : ("");
            extension_movi = request.getParameter("extn") != null ? request.getParameter("extn").trim() : "";
            
            /**************************** VERIFICAR DATOS Y AGREGAR USUARIOS ***************************/
            if (request.getParameter("agregar_anexo")!=null) {
                boolean erroresEncontrados = false;

                if (requestTrim_extensionNumero.compareTo("")==0 || requestTrim_nombre.compareTo("")==0   || requestTrim_devicenameNumero.compareTo("") == 0){
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }
                try{
                    if(requestTrim_estado!="")
                       estado=Integer.parseInt(requestTrim_estado);
                }catch (Exception ex){
                    estado=0;
                    ex.printStackTrace();
                }
                if (erroresEncontrados==false) {
                    String sentenciaFechaActual ="NOW()";
                    String nombreBDSQLServer = "Microsoft SQL Server";
                    if(nombreBDSQLServer.equalsIgnoreCase(conexion.getMetaData().getDatabaseProductName()) ){
                        sentenciaFechaActual = "CURRENT_TIMESTAMP";
                    }
                    PreparedStatement pst = conexion.prepareStatement("INSERT INTO secretaria (anexo,sep,nombre,estado,ultimo_uso,estado_uso,piloto_asociado) values (?,?,?,?,"+sentenciaFechaActual+",0,'')");
                    try {                                                
                        pst.setString(1, requestTrim_extensionNumero);
                        pst.setString(2, requestTrim_devicenameNumero);
                        pst.setString(3, requestTrim_nombre);
                        pst.setInt(4, estado);
                        pst.executeUpdate();
                        
                    } catch (Exception e) {
                        erroresEncontrados = true;
                        error = e.getMessage().replace("ERROR:","") ;
                    }finally{
                        try{
                            conexion.close();
                            pst.close();
                        }catch(Exception e){}
                    }
                    if(!erroresEncontrados && confReckall.isIntegrado()){
                        Connection conR = null;
                        PreparedStatement psR = null;
                        ResultSet rsR = null;
                        PreparedStatement psSu = null;
                        ResultSet rsSuc=null;
                        int suc=0;
                        try{
                            isExtnMb = Integer.parseInt(extension_movi);
                        }catch(Exception e){}
                        try{
                            conR = SQLConexion.conectaRecKall(confReckall.getIpServidor(),confReckall.getBaseDatos(),confReckall.getUsuarioBD(),confReckall.getClaveBD());
                            psSu = conR.prepareStatement("select pk_sucursal from tbl_sucursales order by 1 limit 1");
                            rsSuc = psSu.executeQuery();
                            if(rsSuc.next()){
                                suc = rsSuc.getInt("pk_sucursal");
                            }
                            psR = conR.prepareStatement("insert into tbl_anexos(anexo, descripcion, mac, is_ext_mobility, fecha_registro, fk_tbl_sucursales) values(?,?,?,?,now(),?)");
                            psR.setString(1, requestTrim_extensionNumero);
                            psR.setString(2, requestTrim_nombre);
                            psR.setString(3, requestTrim_devicenameNumero.toLowerCase());
                            psR.setInt(4, isExtnMb);
                            psR.setInt(5, suc);
                            if(psR.executeUpdate()<=0){
                                error+="<br>Error Reckall: No Insert...";
                                System.out.println("insert into tbl_anexos(anexo, descripcion, mac, is_ext_mobility, fecha_registro) values(?,?,?,?,now()) ->"
                                        + requestTrim_extensionNumero+" "+requestTrim_nombre+" "+requestTrim_devicenameNumero.toLowerCase()+" "+isExtnMb);
                            }
                        }catch(Exception e){
                            System.out.println("Error agregando a RecKall: "+e);
                            erroresEncontrados = true;
                            error+="<br>Error Reckall: "+e.toString();
                        }finally{
                            try{
                                conR.close();
                                psR.close();
                                rsR.close();
                                psSu.close();
                                rsSuc.close();
                            }catch(Exception e){}
                        }
                    }
                    Configuracion confGestion = AcdKallGestion.configuracionGestion();
                    if(confGestion.isIntegrado()){
                        Connection conG= null;
                        PreparedStatement psG = null;
                        try{
                            conG = SQLConexion.conectar(confGestion.getIpServidor(), confGestion.getBaseDatos(), confGestion.getUsuarioBD(), confGestion.getClaveBD());
                            psG = conG.prepareStatement("INSERT INTO extensiones(extension,descripcion,fecha) values (?,?,now())");
                            psG.setString(1,requestTrim_extensionNumero);
                            psG.setString(2,requestTrim_nombre);
                            if(psG.executeUpdate()<=0){
                                error+="<br>Error AcdkallGestion No Insert...";
                                System.out.println(" Error: INSERT INTO extensiones(extension,descripcion,fecha) values (?,?,now()) -> "+requestTrim_extensionNumero
                                        +" - "+requestTrim_nombre);
                            }
                        }catch(Exception e){
                            System.out.println("Error agregando a gestion: "+e);
                            erroresEncontrados = true;
                            error+="<br>Error AdkallGestion: "+e.toString();
                        }finally{
                            try{
                                conG.close();
                                psG.close();
                            }catch(Exception e){}
                        }
                    }
                    
                }
                if (!erroresEncontrados) {
                    response.sendRedirect("extensionRegistro.jsp");
                }
            }
            if(confReckall.isIntegrado()){
                opcionReckall+="<div  style=\"float:left;width: 10%;\" >Reckall</div>"
                        +"<div style=\"float:left;margin-right: 10px;margin-left: 10px;\" class=\"answer\" onmouseover=\"mostrarToolKit(document.getElementById('t6'),6)\" onmouseout=\"ocultarToolKit(document.getElementById('t6'))\">"
                        +"<i class=\"fa fa-question-circle\"></i></div>&nbsp;&nbsp;<div id=\"t6\" class=\"toolkit\" ></div>"
                        + "<div style=\"width:10%;float:left;margin-left: 2%;\">Extension <br/>Mobility</div> <input name=\"extn\" id=\"extn\" value=\"1\"  style=\"width:auto;margin-left:2%;\" type=\"checkbox\" >";
            }
            
            requestTrim_estado=" <SELECT  size=\"1\" name=\"extension_estado\"> "+
                               " <OPTION selected value=\"1\">habilitada</OPTION>" +
                               " <OPTION selected value=\"0\">desabilitada</OPTION>" +
                               " </SELECT >";
        } catch (Exception e) {
            error = e.toString();
        }
        

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/extensionAgregar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNumero%",requestTrim_extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido, "%devicenameNumero%", requestTrim_devicenameNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNombre%",requestTrim_nombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionEstado%",requestTrim_estado);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_title%",msgs.getString("extension.add.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_data%",msgs.getString("extension.add.tbl.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_extn%",msgs.getString("extension.add.tbl.extn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_name%",msgs.getString("extension.add.tbl.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_est%",msgs.getString("extension.add.tbl.est"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_btn_save%",msgs.getString("extension.add.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extagr_btn_cancel%",msgs.getString("extension.add.btn.cancel"));

        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNumeroToolkit%",msgs.getString("extension.numero.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionDNToolkit%",msgs.getString("extension.dn.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNombreToolkit%",msgs.getString("extension.nombre.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionEstadoToolkit%",msgs.getString("extension.estado.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%opcion_Reckall%", opcionReckall);
        t_contenido = Plantillas.reemplazar(t_contenido,"%reckallToolkit%",msgs.getString("extension.reckall.toolkit"));
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.extensiones%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.extensiones%", msgs.getString("menu.adm.txt.extensiones") );
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
        t_javascript = Plantillas.reemplazar(t_javascript,"%alertAfterLoad%",alertAfterLoad);
        
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
        
        t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botonesactive");
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_monitor%","botones");
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
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;

        out.println(t_maestra);
    } else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

