<%@page import="query.ComboQuery"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"%>
<% response.setHeader("Pragma", "no-cache");
 response.setHeader("Cache-Control", "no-cache");
 response.setDateHeader("Expires", 0);
 response.setDateHeader("max-age", 0);
 
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equalsIgnoreCase("adm_general")) {
        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        int ncheckbox = 0;
        String error = "";
        String estilocaja = "caja";

        String salidaTabla1 = "";
        String salidaPaginado1 = "";
        String variablesGet = "";
        String variablesGetMasPg = "";
        String registros_mostrar_reemplazo = "";

        String nombre = "";
        int estado = 0;
        int estado_uso = 0;

        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }

        /***************************************************************/
        String busca_extension = (request.getParameter("busca_extension") != null) ? request.getParameter("busca_extension").trim() : "";
        String busca_nombre = (request.getParameter("busca_nombre") != null) ? request.getParameter("busca_nombre").trim() : "";
        String registros_mostrar = (request.getParameter("registros_mostrar") != null) ? request.getParameter("registros_mostrar").trim() : "15";
        int pg = 1;
        try {
            pg = Integer.parseInt(request.getParameter("pg"));
        } catch (Exception e) {
            //out.println("error 3 :"+e.toString());
        }

        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("10")) ? "<option selected>10</option>" : "<option>10</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("15")) ? "<option selected>15</option>" : "<option>15</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("20")) ? "<option selected>20</option>" : "<option>20</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("25")) ? "<option selected>25</option>" : "<option>25</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("45")) ? "<option selected>45</option>" : "<option>45</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("50")) ? "<option selected>50</option>" : "<option>50</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("100")) ? "<option selected>100</option>" : "<option>100</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("150")) ? "<option selected>150</option>" : "<option>150</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("200")) ? "<option selected>200</option>" : "<option>200</option>";
        registros_mostrar_reemplazo += (registros_mostrar.equalsIgnoreCase("250")) ? "<option selected>250</option>" : "<option>250</option>";

        /*************************************************VARIABLES GET PARA PASARLE AL PAGINADO***********************************/
        variablesGet += (busca_extension != "" || busca_extension == null) ? "&busca_extension=" + busca_extension : "";
        variablesGet += (busca_nombre != "" || busca_nombre == null) ? "&busca_nombre=" + busca_nombre : "";
        variablesGet += (registros_mostrar != "") ? "&registros_mostrar=" + registros_mostrar : "15";

        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();

        try {
            /**************************** ELIMINAR MONITORES *******************************/
            if (request.getParameter("ncheckbox_eliminar") != null) {
                try {
                    int ncheckbox_eliminar = Integer.parseInt(request.getParameter("ncheckbox_eliminar"));
                    if (ncheckbox_eliminar > 0) {
                        PreparedStatement pstx = conexion.prepareStatement("DELETE FROM pilotos_monitores WHERE id_monitor=?");
                        PreparedStatement pst2 = conexion.prepareStatement("DELETE FROM monitores WHERE id=?");
                        for (int i = 1; i <= ncheckbox_eliminar; i++) {
                            //if (request.getParameter("check" + i)!=null && request.getParameter("check" + i).compareTo(session.getAttribute("id_usuario").toString())!=0) {
                            if (request.getParameter("check" + i) != null) {
                                pstx.setInt(1,Integer.parseInt(request.getParameter("check" + i)) );
                                pstx.execute();
                                pst2.setInt(1, Integer.parseInt(request.getParameter("check" + i)));
                                pst2.execute();
                            }
                        }
                        pst2.close();
                    }
                } catch (Exception e) {
                    out.println("error 2 : " + e.toString());
                    error = e.toString();
                }
            }

            /******************** Genero resultado paginados ****************************/
            Paginado3 paginado = new Paginado3();

            String SQLTabla = " monitores ";
            String SQLWhere = " where extension LIKE ? and nombre LIKE ? ";
            String SQLOrderBy = " ORDER BY extension ASC ";

            int registrosMostrar = 15;
            try {
                registrosMostrar = Integer.parseInt(registros_mostrar);
            } catch (Exception e) {
                registrosMostrar = 15;
            }

            String query = "SELECT COUNT(*) AS registrosTotalPaginado FROM " + SQLTabla + " " + SQLWhere;
            PreparedStatement pstCount = conexion.prepareStatement(query);
            pstCount.setString(1, busca_extension + "%");
            pstCount.setString(2, busca_nombre + "%");

            paginado = new Paginado3(pstCount, registrosMostrar, pg);
            paginado.setMaximoTamanoBarra(10);
            salidaPaginado1 = paginado.getBarraPaginado("monitorRegistro.jsp", variablesGet);

            pstCount.close();

            String query1 = "select * from " + SQLTabla + SQLWhere + SQLOrderBy +" LIMIT " + String.valueOf(registrosMostrar) + " OFFSET " + ((pg - 1) * registrosMostrar);

            String nombreBDSQLServer = "Microsoft SQL Server";
            if(nombreBDSQLServer.equalsIgnoreCase(conexion.getMetaData().getDatabaseProductName()) ){
                query1 = "select * from ( Select top " + (registros_mostrar) + " * from ( select top " + String.valueOf(pg * registrosMostrar) + " * from " + SQLTabla + " " + SQLWhere + " ORDER BY anexo desc ) as q1 ORDER BY q1.anexo ASC ) as q2 ORDER BY q2.anexo DESC";
            }

            PreparedStatement pstResult = conexion.prepareStatement(query1);
            pstResult.setString(1, busca_extension + "%");
            pstResult.setString(2, busca_nombre + "%");

            ResultSet rs = paginado.getResultSet(pstResult);
            int numeroRegistro = (pg - 1) * registrosMostrar;
            int fila = 1;
            while (rs.next()) {
                fila = (1 + (fila * -1));
                String habilitada = "";
                String estadotelefono = "";

                ncheckbox++;
                salidaTabla1 += "<tr class=\"fila" + fila + "\">\n";
                salidaTabla1 += "<td width=\"7%\"><strong>" + ++numeroRegistro + "</strong></td>\n";
                salidaTabla1 += "<td width=\"7%\"><input type=\"checkbox\" id=\"check" + ncheckbox + "\" name=\"check" + ncheckbox + "\" value=\"" + rs.getString("id") + "\"></td>\n";
                salidaTabla1 += "<td ><a href=\"monitorModificar.jsp?id=" + rs.getString("id") + "&p=" + pg + "\">" + rs.getString("extension") + "</a></td>\n";
                salidaTabla1 += "<td>" + rs.getString("nombre") + "</td>\n";
                salidaTabla1 += "<td>" + rs.getString("devicename") + "</td>\n";
                //salidaTabla1 += "<td><a onMouseOver=\"mostrarToolTit('"+rs.getString("extension")+"')\" onMouseOut=\"ocultarToolTit('"+rs.getString("extension")+"')\" href='pilotoAgregar.jsp?id="+rs.getInt("id")+"'>"+msgs.getString("piloto.asignados")+"</a><div id='"+rs.getString("extension")+"' class='toolkit'>"+msgs.getString("pilotos.asignados")+"</div></td>";
                salidaTabla1 += "</tr>\n";
            }
            rs.close();
            pstResult.close();
            if (ncheckbox < 10) {
                estilocaja = "caja2";
            }
            if (salidaTabla1.compareTo("") == 0) {
                salidaTabla1 += "<tr class=\"fila0\"><td colspan=\"6\" align=\"center\">"+msgs.getString("error.nodata")+"</td></tr>";

            }
            //Si el usuario Ingresa un pg con un numero inexistente lo redireccionamos
            if (paginado.getNumeroPaginas() < pg && paginado.getNumeroPaginas() > 0) {
                response.sendRedirect("extensionRegistro.jsp?pg=" + paginado.getNumeroPaginas() + variablesGet);
            }

            variablesGetMasPg = ("?pg=" + pg + variablesGet);
        } catch (Exception e) {
            out.println("error 1 :" + e.toString());
            error = e.toString();
        }
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta = getServletConfig().getServletContext().getRealPath("");

        String t_contenido = Plantillas.leer(ruta + "/plantillas/monitorRegistro.html");
        t_contenido = Plantillas.reemplazar(t_contenido, "%error_jsp%", error);
        t_contenido = Plantillas.reemplazar(t_contenido, "%variablesGetMasPg%", variablesGetMasPg);
        t_contenido = Plantillas.reemplazar(t_contenido, "%registros_extensiones%", salidaTabla1);
        t_contenido = Plantillas.reemplazar(t_contenido, "%barraPaginado%", salidaPaginado1);
        t_contenido = Plantillas.reemplazar(t_contenido, "%busca_extension%", busca_extension);
        t_contenido = Plantillas.reemplazar(t_contenido, "%busca_nombre%", busca_nombre);
        t_contenido = Plantillas.reemplazar(t_contenido, "%registros_mostrar_reemplazo%", registros_mostrar_reemplazo);
        t_contenido = Plantillas.reemplazar(t_contenido, "%estilocaja%", estilocaja);

        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbl_monn%", msgs.getString("monitor.reg.tabla.monn"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbl_name%", msgs.getString("monitor.reg.tabla.name"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%extreg_tbl_reg%", msgs.getString("extension.reg.reg"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%extreg_btn_find%", msgs.getString("extension.reg.btn.find"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbldat_monn%", msgs.getString("monitor.reg.tabla.monn"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbldat_name%", msgs.getString("monitor.reg.tabla.name"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbldat_dev%", msgs.getString("monitor.reg.tabla.dev"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%monreg_tbldat_add%", msgs.getString("monitor.reg.tabla.add"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%extreg_btn_new%", msgs.getString("extension.reg.btn.new"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%extreg_btn_delete%", msgs.getString("extension.reg.btn.delete"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%piloto_asignados%", msgs.getString("piloto.asignados"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%no_piloto_asignados%", msgs.getString("no.piloto.asignados"));
        
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
        t_javascript = Plantillas.reemplazar(t_javascript, "%ncheckbox%", String.valueOf(ncheckbox).toString());
        t_javascript = Plantillas.reemplazar(t_javascript, "%variablesGetMasPg%", variablesGetMasPg);

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
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "");

        out.println(t_maestra);
    } else {
        out.println("<script>");
        out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
        out.println("</script>");
        out.println("<body onload=\'regresar()\';>");
    }
%>
