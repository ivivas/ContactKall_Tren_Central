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

        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String id = request.getParameter("id");
        String error = "";
        String extensionNumero = "";
        String devicenameNumero = "";
        String extensionNombre = "";
        int idExtension = 0;
        String pilotosAsignados="";
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";
        
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
            try {
                idExtension = Integer.parseInt(request.getParameter("id"));
            }catch (Exception e) {
                //Redirecciono ya que el id anexo no es numerico
                out.println("error 1 :"+e.toString());
                response.sendRedirect("monitorRegistro.jsp");
            }

            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("modificar_anexo")!=null) {
                boolean erroresEncontrados = false;
                String requestTrim_extensionNumero = (request.getParameter("extension_numero")!=null) ? (request.getParameter("extension_numero").trim()) : ("");
                String requestTrim_devicenameNumero = (request.getParameter("devicename_numero") != null) ? (request.getParameter("devicename_numero").trim()) : ("");
                String requestTrim_extensionNombre = (request.getParameter("extension_nombre")!=null) ? (request.getParameter("extension_nombre").trim()) : ("");

                if (requestTrim_extensionNumero.compareTo("")==0) {
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }

                if (erroresEncontrados==false) {
                    PreparedStatement pst = conexion.prepareStatement("UPDATE monitores SET nombre = ?,extension=?,devicename=? WHERE id=?;");
                    PreparedStatement psx = conexion.prepareStatement("DELETE FROM pilotos_monitores WHERE id_piloto = ?;");
                    try {
                        pst.setString(1, requestTrim_extensionNombre);
                        pst.setString(2, requestTrim_extensionNumero);
                        pst.setString(3, requestTrim_devicenameNumero);
                        pst.setInt(4, idExtension);
                        pst.execute();
                        String[] check = request.getParameterValues("pilotos");
                        if(check!=null){
                            for(int i = 0 ; i < check.length ; i ++){
                                if(request.getParameterValues("pilotos")!=null){
                                    psx.setInt(1, Integer.parseInt(request.getParameterValues("pilotos")[i]));
                                    psx.execute();
                                }
                            }
                        }
                        response.sendRedirect("monitorRegistro.jsp?pg=" + pgAnterior);
                    } catch (Exception e) {
                        error = e.toString();
                    }
                    pst.close();
                }
            }
            
            /***************** VERIFICAMOS QUE EL ANEXO EXISTA Y RECUPERAMOS DATOS ******************/
            
            ResultSet rsAnexo = st.executeQuery("SELECT * FROM monitores WHERE id=" + idExtension);
            if (rsAnexo.next()) {
                extensionNumero = rsAnexo.getString("extension").trim();
                devicenameNumero = rsAnexo.getString("devicename").trim();
                extensionNombre = rsAnexo.getString("nombre")!=null ? rsAnexo.getString("nombre").trim() : "";
            } else {
                response.sendRedirect("monitorRegistro.jsp");
            }
            pilotosAsignados+= msgs.getString("sel.para.elim")+"<br>";
            ResultSet rsPilotos = st.executeQuery("select p.id as id,piloto,descripcion from pilotos p join pilotos_monitores pm on p.id = id_piloto join monitores m on id_monitor = m.id where m.id = "+idExtension);
            while(rsPilotos.next()){
                pilotosAsignados+="<input name='pilotos' type='checkbox' value='"+rsPilotos.getInt("id")+"'> "+rsPilotos.getString("piloto")+" - "+rsPilotos.getString("descripcion") +"<br>";
            }
            rsAnexo.close();
            rsPilotos.close();

        } catch (Exception e) {
            error = e.toString();
        }
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/monitorModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNumero%",extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido, "%devicenameNumero%", devicenameNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNombre%",extensionNombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        t_contenido = Plantillas.reemplazar(t_contenido,"%pilotosAsignados%", pilotosAsignados);
        t_contenido = Plantillas.reemplazar(t_contenido,"%idpiloto%", id);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_tbl_title%", msgs.getString("monitor.mod.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnagr_tbl_data%", msgs.getString("extension.mod.tbl.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_monn%", msgs.getString("extension.mod.tbl.extn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_name%", msgs.getString("extension.mod.tbl.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_btn_save%", msgs.getString("extension.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_btn_cancel%", msgs.getString("extension.mod.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%monnagr_tbl_asoc%",msgs.getString("monitor.add.tbl.asoc"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%pilotoAsoc%",msgs.getString("monitor.asignar.piloto"));
        
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

