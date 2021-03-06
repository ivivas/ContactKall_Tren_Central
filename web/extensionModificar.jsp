<%@page import="query.AcdKallGestion"%>
<%@page import="query.ComboQuery"%>
<%@page import="query.Reckall"%>
<%@page import="DTO.Configuracion"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"
%>
<% response.setHeader("Pragma","no-cache"); %>
<% response.setHeader("Cache-Control","no-cache"); %>
<% response.setDateHeader("Expires",0); %>
<% response.setDateHeader("max-age",0); %>
<%
    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equalsIgnoreCase("adm_general") || sesionActual.equalsIgnoreCase("adm_pool") || sesionActual.equalsIgnoreCase("usuario") || sesionActual.equalsIgnoreCase("ggee_asistencia") || sesionActual.equalsIgnoreCase("ggee_secretaria") || sesionActual.equalsIgnoreCase("cap") || sesionActual.equalsIgnoreCase("imb_secretaria") || sesionActual.equalsIgnoreCase("imb_asistencia") || sesionActual.equalsIgnoreCase("pac_asistencia") || sesionActual.equalsIgnoreCase("pac_secretaria") || sesionActual.equalsIgnoreCase("may_asistencia") || sesionActual.equalsIgnoreCase("may_secretaria") ) {

        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String error = "";
        String extensionNumero = "";
        String devicenameNumero = "";
        String extensionNombre = "";
        String opcionReckall = "";
        int idExtension = 0;
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";
        //String modReck = (request.getParameter("modificar_Reck")!=null) ? request.getParameter("modificar_Reck") : "";
        String request_IdReckall = (request.getParameter("idReckall")!=null) ? request.getParameter("idReckall") : "";
        String request_id_Gestion = (request.getParameter("idGestion")!=null) ? request.getParameter("idGestion") : "";
        int reqIdReckall=0;
        int reqIdGestion = 0;
        
        try{
            reqIdReckall = Integer.parseInt(request_IdReckall);
        }catch(Exception e){}
        try{
            reqIdGestion = Integer.parseInt(request_id_Gestion);
        }catch(Exception e){}
        
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
        ResultSet rsAnexo = null;
        Configuracion confReckall = Reckall.configuracionReckall();
        Configuracion confGestion = AcdKallGestion.configuracionGestion();
        int id_Reckall = 0;
        int idGestion = 0;
        try {
            try {
                idExtension = Integer.parseInt(request.getParameter("id"));
            }catch (Exception e) {
                //Redirecciono ya que el id anexo no es numerico
                out.println("error 1 :"+e.toString());
                response.sendRedirect("extensionRegistro.jsp");
            }
            String requestTrim_extensionNumero = (request.getParameter("extension_numero")!=null) ? (request.getParameter("extension_numero").trim()) : ("");
            String requestTrim_devicenameNumero = (request.getParameter("devicename_numero") != null) ? (request.getParameter("devicename_numero").trim()) : ("");
            String requestTrim_extensionNombre = (request.getParameter("extension_nombre")!=null) ? (request.getParameter("extension_nombre").trim()) : ("");
            
            int isExtnMb = 0;
            String extnMb = request.getParameter("extn") != null ? request.getParameter("extn").trim() : "";
            try{
                isExtnMb = Integer.parseInt(extnMb);
            }catch(Exception e){}
            
            
            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("modificar_anexo")!=null) {
                boolean erroresEncontrados = false;
                

                if (requestTrim_extensionNumero.compareTo("")==0) {
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }
                if (erroresEncontrados==false) {
                    PreparedStatement pst = conexion.prepareStatement("UPDATE secretaria SET anexo=?, sep =?, nombre = ? WHERE id=?;");
                    try {
                        pst.setString(1, requestTrim_extensionNumero);
                        pst.setString(2, requestTrim_devicenameNumero);
                        pst.setString(3, requestTrim_extensionNombre);
                        pst.setInt(4, idExtension);
                        pst.execute();
                        if(confReckall.isIntegrado()&&reqIdReckall>0){
                            Connection conR = SQLConexion.conectaRecKall(confReckall.getIpServidor(),confReckall.getBaseDatos(),confReckall.getUsuarioBD(),confReckall.getClaveBD());
                            PreparedStatement psR = null;
                            try{
                                psR = conR.prepareStatement("update tbl_anexos set anexo = ? , descripcion = ? , mac = ?, is_ext_mobility = ? where id_anexo = ? ");
                                psR.setString(1, requestTrim_extensionNumero);
                                psR.setString(2, requestTrim_extensionNombre);
                                psR.setString(3, requestTrim_devicenameNumero.toLowerCase());
                                psR.setInt(4, isExtnMb);
                                psR.setInt(5, reqIdReckall);
                                psR.executeUpdate();
                            } catch(Exception e){
                                System.out.println("Error modificando Reckall: "+e);
                            }finally{
                                try{
                                    conR.close();
                                    psR.close();
                                }catch(Exception e){}
                            }
                            //isExtnMb
                        }
                        if(reqIdGestion>0 && confGestion.isIntegrado()){
                            Connection conGes = null;
                            PreparedStatement psGes = null;
                            try{
                                conGes = SQLConexion.conectar(confGestion.getIpServidor(), confGestion.getBaseDatos(), confGestion.getUsuarioBD(), confGestion.getClaveBD());
                                psGes = conGes.prepareStatement("update extensiones set extension = ? , descripcion = ? where id_extension = ? ");
                                psGes.setString(1, requestTrim_extensionNumero);
                                psGes.setString(2, requestTrim_extensionNombre);
                                psGes.setInt(3, reqIdGestion);
                                if(psGes.executeUpdate()<=0){
                                    System.out.println("Error al actualizar gestion");
                                    System.out.println("qry: update extensiones set extension = ? , descripcion = ? where id_extension = ? -> "
                                            + requestTrim_extensionNumero+" - "+requestTrim_extensionNombre+" - "+reqIdGestion);
                                }
                            }catch(Exception e){
                                System.out.println("Error modificando Gestion: "+e);
                            }finally{
                                try{
                                    conGes.close();
                                    psGes.close();
                                }catch(Exception e){}
                            }
                        }
                        
                        response.sendRedirect("extensionRegistro.jsp?pg=" + pgAnterior);
                    } catch (Exception e) {
                        error = e.toString();
                    }
                    pst.close();
                }
            }
            /***************** VERIFICAMOS QUE EL ANEXO EXISTA Y RECUPERAMOS DATOS ******************/
            rsAnexo = st.executeQuery("SELECT * FROM secretaria WHERE id=" + idExtension);
            if (rsAnexo.next()) {
                extensionNumero = rsAnexo.getString("anexo").trim();
                devicenameNumero = rsAnexo.getString("sep").trim();
                extensionNombre = rsAnexo.getString("nombre")!=null ? rsAnexo.getString("nombre").trim() : "";
            } else {
                response.sendRedirect("extensionRegistro.jsp");
            }
            
            if(confReckall.isIntegrado()){
                opcionReckall+="<div  style=\"float:left;width: 15%;\" >Reckall</div>";
                int extMbl=0;
                PreparedStatement ps = null;
                ResultSet rs = null;
                Connection con = null;
                try{
                    con = SQLConexion.conectaRecKall(confReckall.getIpServidor(),confReckall.getBaseDatos(),confReckall.getUsuarioBD(),confReckall.getClaveBD());
                    ps = con.prepareStatement("select count(*)  as cont, is_ext_mobility, id_anexo  from tbl_anexos where anexo = ? and (lower(mac) = lower(?) or lower(mac) = lower(?)) group by is_ext_mobility, id_anexo ");
                    ps.setString(1, extensionNumero);
                    ps.setString(2, devicenameNumero);
                    ps.setString(3, devicenameNumero.substring(3));
                    rs = ps.executeQuery();
                    while(rs.next()){
                        //cont = rs.getInt("cont");
                        extMbl = rs.getInt("is_ext_mobility");
                        id_Reckall = rs.getInt("id_anexo");
                    }
                }catch(Exception e){
                    System.out.println("Error consultando datos en Reckall:  "+e);
                }finally{
                    try{
                        con.close();
                        ps.close();
                        rs.close();
                    }catch(Exception e){}
                }
                String check="";
                if(extMbl == 1){
                    check = "checked";
                }
                opcionReckall +="<div style=\"width:15%;float:left;\">Extension <br/>Mobility</div> <input name=\"extn\" id=\"extn\" value=\"1\"  "
                        + "style=\"width:auto;margin-left:2%;\" type=\"checkbox\" "+check+">";
            }
            
            if(confGestion.isIntegrado()){
                Connection conG = null;
                PreparedStatement psG = null;
                ResultSet rsG = null;
                try{
                    conG = SQLConexion.conectar(confGestion.getIpServidor(), confGestion.getBaseDatos(), confGestion.getUsuarioBD(), confGestion.getClaveBD());
                    psG = conG.prepareStatement("select id_extension from extensiones where extension = ? ");
                    psG.setString(1,extensionNumero);
                    rsG = psG.executeQuery();
                    while(rsG.next()){
                        idGestion = rsG.getInt("id_extension");
                    }
                }catch(Exception e){
                    System.out.println("Error buscando id de gestion: "+e);
                }finally{
                    try{
                        conG.close();
                        psG.close();
                        rsG.close();
                    }catch(Exception e){ }
                }
            }

        } catch (Exception e) {
            error = e.toString();
        }finally{
            try{
                st.close();
                conexion.close();
                rsAnexo.close();
            }catch(Exception e){}
        }
        
        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/extensionModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNumero%",extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido, "%devicenameNumero%", devicenameNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%extensionNombre%",extensionNombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_tbl_title%", msgs.getString("extension.mod.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_tbl_data%", msgs.getString("extension.mod.tbl.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_tbl_extn%", msgs.getString("extension.mod.tbl.extn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_tbl_name%", msgs.getString("extension.mod.tbl.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_btn_save%", msgs.getString("extension.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extnmod_btn_cancel%", msgs.getString("extension.mod.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%opcion_Reckall%", opcionReckall);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id_Reckall%", id_Reckall+"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%id_Gestion%", idGestion+"");
        
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
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "");

        out.println(t_maestra);
    } else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

