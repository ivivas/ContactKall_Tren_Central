<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"
        import = "query.*"%>
<% response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",0);
response.setDateHeader("max-age",0);

    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equalsIgnoreCase("adm_general")) {
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String opcionesRuteo =Plantillas.comboRuteo("5",msgs);
        String error = "";
        String requestTrim_extensionNumero = "";
        String requestTrim_nombre = "";
        String requestTrim_extensionPickup ="";
        String requestTrim_uso = "";
        String alertAfterLoad = "mostrarDivOpciones(document.getElementById('select_usuario_perfil'));";
        int estado=0;
        String requestTrim_extensionFueraHora = "";
        String requestTrim_tipoRuteo = "";
       
        /***************************************************************/
        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();
        DiaQuery diaQuery = new DiaQuery(SQLConexion.conectar());
        int idHorarioPredeterminado = diaQuery.getIdHorarioPredeterminado();
        try {
            /**************************** RECUPERO VALORES DE CAMPO Y CREO SELECT DE PERFIL *******************************/
            requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");
            requestTrim_nombre = (request.getParameter("virtual_descripcion")!=null) ? (request.getParameter("virtual_descripcion").trim()) : ("");
            requestTrim_extensionPickup = (request.getParameter("virtual_pickup")!=null) ? (request.getParameter("virtual_pickup").trim()) : ("");
            requestTrim_extensionFueraHora = (request.getParameter("virtual_num_fuera_hora")!=null) ? (request.getParameter("virtual_num_fuera_hora").trim()) : ("");
            requestTrim_tipoRuteo = request.getParameter("ruteo")!=null ? request.getParameter("ruteo").trim() : "";
            /**************************** VERIFICAR DATOS Y AGREGAR USUARIOS ***************************/
            if (request.getParameter("agregar_anexo")!=null) {
                boolean erroresEncontrados = false;

                if (requestTrim_extensionNumero.compareTo("")==0 || requestTrim_nombre.compareTo("")==0  ){
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
                }
                                
                if (erroresEncontrados==false) {
                    PreparedStatement pst = conexion.prepareStatement("INSERT INTO  pilotos (id,piloto,descripcion,anexo_rebalse,id_horarios,tratar_anexos_internos_como_clientes,permitir_llamadas_directas,numero_fuera_horario,ruteo) values (nextval('pilotos_id_seq'),?,?,?,?,0,0,'"+requestTrim_extensionFueraHora+"',? )");
                    try {                                                
                        pst.setString(1, requestTrim_extensionNumero);
                        pst.setString(2, requestTrim_nombre);
                        pst.setString(3, requestTrim_extensionPickup);
                        pst.setInt(4, idHorarioPredeterminado);
                        pst.setInt(5, Integer.parseInt(requestTrim_tipoRuteo));
                        pst.executeUpdate();

                    } catch (Exception e) {
                        erroresEncontrados = true;
                        error = e.getMessage().replace("ERROR:","");
                    }
                    pst.close();
                }
                if (erroresEncontrados==false) {
                    response.sendRedirect("virtualRegistro.jsp");
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
        String t_contenido = Plantillas.leer(ruta + "/plantillas/virtualAgregar.html");
        
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_numero%",requestTrim_extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_descripcion%",requestTrim_nombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_pickup%",requestTrim_nombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_num_fuera_hora%",requestTrim_extensionFueraHora);
        t_contenido = Plantillas.reemplazar(t_contenido, "%opciones_ruteo%", opcionesRuteo);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_tbl_title%",msgs.getString("virtual.add.tbl.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_tbl_newvrt%",msgs.getString("virtual.add.tbl.newnum"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_tbl_numvrt%",msgs.getString("virtual.add.tbl.numvrt"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_tbl_desc%",msgs.getString("virtual.add.tbl.desc"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_tbl_numpkp%",msgs.getString("virtual.add.tbl.numpkp"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_btn_save%",msgs.getString("virtual.add.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadd_btn_cancel%",msgs.getString("virtual.add.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%sel%",msgs.getString("opcion.desh.opt.def"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hora%",msgs.getString("virtual.mod.tbl.hor"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%dis%",msgs.getString("virtual.reg.tbl.dis"));
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualNumeroToolkit%",msgs.getString("virtual.numero.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDescripcionToolkit%",msgs.getString("virtual.desc.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualPickupToolkit%",msgs.getString("virtual.pickup.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualFueraToolkit%",msgs.getString("virtual.fuera.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDistribucionToolkit%",msgs.getString("virtual.distribucion.toolkit"));

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

