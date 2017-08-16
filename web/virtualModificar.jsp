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
    if(sesionActual.equalsIgnoreCase("adm_general")) {

        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String error = "";
        String virtualNumero = "";
        String virtualDescripcion = "";
        String virtualPickup = "";
        String virtualNumFueraHora ="";
        String opcionesRuteo="";
        int id_horario=0;
        String comboHorario="";
        int idExtension = 0;
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
            } catch (Exception e) {
                //Redirecciono ya que el id anexo no es numerico
                out.println("error 1 :"+e.toString());
                response.sendRedirect("virtualRegistro.jsp");
            }

            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("modificar_virtual")!=null) {
                boolean erroresEncontrados = false;
                String requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");
                String requestTrim_extensionNombre = (request.getParameter("virtual_descripcion")!=null) ? (request.getParameter("virtual_descripcion").trim()) : ("");
                String requestTrim_extensionPickup = (request.getParameter("virtual_pickup")!=null) ? (request.getParameter("virtual_pickup").trim()) : ("");
                String requestTrim_extensionFueraHora = (request.getParameter("virtual_num_fuera_hora")!=null) ? (request.getParameter("virtual_num_fuera_hora").trim()) : ("");
                String requestTrim_ruteo = request.getParameter("ruteo")!=null ? request.getParameter("ruteo") : "0";
                String requestTrim_idHorario = request.getParameter("horario")!=null ? request.getParameter("horario") : "0";
                if (requestTrim_extensionNumero.compareTo("")==0) {
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }
                System.out.println("requestTrim_idHorario: "+requestTrim_idHorario);
                if (erroresEncontrados==false) {
                    PreparedStatement pst = conexion.prepareStatement("UPDATE pilotos SET piloto=?, descripcion = ?, anexo_rebalse = ?, numero_fuera_horario = '"+ requestTrim_extensionFueraHora+"',ruteo=?, id_horarios=? WHERE id=?;");
                    try {
                        PreparedStatement pst2 = conexion.prepareStatement("SELECT * from pilotos WHERE id=?;");
                        pst2.setInt(1, idExtension);
                        ResultSet rsPilotoAnterior = pst2.executeQuery();
                        rsPilotoAnterior.next();
                        String pilotoAnterior = rsPilotoAnterior.getString("piloto");

                        pst2.close();
                        pst.setString(1, requestTrim_extensionNumero);
                        pst.setString(2, requestTrim_extensionNombre);
                        pst.setString(3, requestTrim_extensionPickup);
                        pst.setInt(4, Integer.parseInt(requestTrim_ruteo));
                        pst.setInt(5, Integer.parseInt(requestTrim_idHorario));
                        pst.setInt(6, idExtension);
                        pst.execute();

                        PreparedStatement pst3 = conexion.prepareStatement("UPDATE secretaria SET piloto_asociado = ? WHERE piloto_asociado=?;");
                        pst3.setString(1,requestTrim_extensionNumero );
                        pst3.setString(2, pilotoAnterior);
                        pst3.execute();
                        response.sendRedirect("virtualRegistro.jsp?pg=" + pgAnterior);
                    } catch (Exception e) {
                        error = e.toString();
                        System.out.println("error ::: " ); e.printStackTrace();
                    }
                    pst.close();
                }
            }
            
            /***************** VERIFICAMOS QUE EL ANEXO EXISTA Y RECUPERAMOS DATOS ******************/
            ResultSet rsAnexo = st.executeQuery("SELECT * FROM pilotos WHERE id=" + idExtension);
            if (rsAnexo.next()) {
                virtualNumero= rsAnexo.getString("piloto").trim();
                virtualDescripcion = rsAnexo.getString("descripcion")!=null ? rsAnexo.getString("descripcion").trim() : "";
                virtualPickup = rsAnexo.getString("anexo_rebalse")!=null ? rsAnexo.getString("anexo_rebalse").trim() : "";
                virtualNumFueraHora = rsAnexo.getString("numero_fuera_horario")!=null ? rsAnexo.getString("numero_fuera_horario").trim() : "";
                id_horario = rsAnexo.getInt("id_horarios");
                opcionesRuteo = Plantillas.comboRuteo(rsAnexo.getString("ruteo"),msgs);
            } else {
                response.sendRedirect("virtualRegistro.jsp");
            }
            rsAnexo.close();
            
            ResultSet rs = st.executeQuery("select id,nombre_horario from horarios order by 1");
            while(rs.next()){
                String select="";
                if(rs.getInt("id")==id_horario){
                    select = "selected";
                }
                comboHorario+="<option value='"+rs.getInt("id")+"' "+select+">"+rs.getString("nombre_horario").trim()+"</option>";
            }

        } catch (Exception e) {
            error = e.toString();
        }finally{
            try{
                st.close();
                conexion.close();
            }catch(Exception e){}
        }

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/virtualModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualNumero%",virtualNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDescripcion%",virtualDescripcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualPickup%",virtualPickup);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_num_fuera_hora%",virtualNumFueraHora);
        t_contenido = Plantillas.reemplazar(t_contenido,"%opciones_ruteo%",opcionesRuteo);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualHorario%", String.valueOf(idExtension).toString());
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_title%", msgs.getString("virtual.mod.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_data%", msgs.getString("virtual.mod.tbl.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_numvrt%", msgs.getString("virtual.mod.tbl.numvrt"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_mod%", msgs.getString("virtual.mod.tbl.desc"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_numpkp%", msgs.getString("virtual.mod.tbl.numpkp"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_tbl_hor%", msgs.getString("virtual.mod.tbl.hor1"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_adjhor%", msgs.getString("virtual.mod.btn.ajhor"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_save%", msgs.getString("virtual.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_cancel%", msgs.getString("virtual.mod.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%dis%",  msgs.getString("virtual.mod.tbl.dis"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hora%",  msgs.getString("virtual.mod.tbl.hor"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%opciones_horario%",  comboHorario);
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.numeroVirtual%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.numeroVirtual%", msgs.getString("menu.adm.txt.numeroVirtual") );
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
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botonesactive");
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