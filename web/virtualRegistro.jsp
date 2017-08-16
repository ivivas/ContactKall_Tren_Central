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
        if(sesionActual.equalsIgnoreCase("adm_general")) {
            /****************** Variables Globales **************************/
            ComboQuery ii = new ComboQuery();
            int contador = 0;
            int ncheckbox = 0;
            String error = "";
            String estilocaja = "caja";

            String salidaTabla1 = "";
            String salidaPaginado1 = "";
            String variablesGet = "";
            String variablesGetMasPg = "";
            String registros_mostrar_reemplazo = "";

            ResourceBundle msgs;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }else{
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }

            /***************************************************************/
            String busca_virtual = (request.getParameter("busca_virtual") != null) ? request.getParameter("busca_virtual").trim() : "";
            String busca_descripcion = (request.getParameter("busca_descripcion") != null) ? request.getParameter("busca_descripcion").trim() : "";
            String registros_mostrar = (request.getParameter("registros_mostrar") != null) ? request.getParameter("registros_mostrar").trim() : "15";

            Connection conexion = SQLConexion.conectar();
            Statement st = conexion.createStatement();

            try {
                /**************************** ELIMINAR EXTENSIONES *******************************/
                if (request.getParameter("ncheckbox_eliminar") != null) {
                    try {
                        int ncheckbox_eliminar = Integer.parseInt(request.getParameter("ncheckbox_eliminar"));
                        if (ncheckbox_eliminar > 0) {
                            String piloto = null;

                            PreparedStatement pst2 = conexion.prepareStatement("DELETE FROM pilotos WHERE id=?");
                            for (int i = 1; i <= ncheckbox_eliminar; i++) {
                                if (request.getParameter("check" + i) != null) {
                                    ////////////////////////////////////////
                                    PreparedStatement pstA = conexion.prepareStatement("select piloto from pilotos where id =?");
                                    PreparedStatement pstB = conexion.prepareStatement("update secretaria set piloto_asociado = NULL WHERE piloto_asociado=?");

                                    pstA.setInt(1, Integer.parseInt(request.getParameter("check" + i)));
                                    ResultSet rs = pstA.executeQuery();
                                    if (rs.next()) {
                                        piloto = rs.getString("piloto").trim();
                                    }
                                    rs.close();
                                    pstA.close();
                                    ///////////////////////////////////////////////////
                                    if (piloto != null) {
                                        pstB.setString(1, piloto);
                                        pstB.executeUpdate();
                                    }
                                    pstB.close();
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
                variablesGet += (busca_virtual != "" || busca_virtual == null) ? "&busca_virtual=" + busca_virtual : "";
                variablesGet += (busca_descripcion != "" || busca_descripcion == null) ? "&busca_descripcion=" + busca_descripcion : "";
                variablesGet += (registros_mostrar != "") ? "&registros_mostrar=" + registros_mostrar : "15";

                /******************** Genero resultado paginados ****************************/
                Paginado3 paginado = new Paginado3();

                String SQLTabla = " pilotos ";
                String SQLWhere = " where piloto LIKE ? and descripcion LIKE ?";
                String SQLOrderBy = " ORDER BY piloto ASC";

                int registrosMostrar = 15;
                try {
                    registrosMostrar = Integer.parseInt(registros_mostrar);
                } catch (Exception e) {
                    registrosMostrar = 15;
                }
                int pg = 1;
                try {
                    pg = Integer.parseInt(request.getParameter("pg"));
                } catch (Exception e) {
                    //out.println("error 3 :"+e.toString());
                }
                String query = "SELECT COUNT(*) AS registrosTotalPaginado FROM " + SQLTabla + " " + SQLWhere;
                PreparedStatement pstCount = conexion.prepareStatement(query);
                pstCount.setString(1, busca_virtual + "%");
                pstCount.setString(2, busca_descripcion + "%");

                paginado = new Paginado3(pstCount, registrosMostrar, pg);
                paginado.setMaximoTamanoBarra(10);
                salidaPaginado1 = paginado.getBarraPaginado("virtualRegistro.jsp", variablesGet);

                pstCount.close();

                PreparedStatement pstCount2 = conexion.prepareStatement(query);
                pstCount2.setString(1, busca_virtual + "%");
                pstCount2.setString(2, busca_descripcion + "%");
                ResultSet rsTotales = pstCount2.executeQuery();
                if (rsTotales.next()) {
                    contador = rsTotales.getInt("registrosTotalPaginado");
                }

                if (contador < (pg * registrosMostrar)) {
                    registros_mostrar = String.valueOf(contador - (registrosMostrar * (pg - 1)));
                }
                String query1 = "select * from " + SQLTabla + " " + SQLWhere +" "+SQLOrderBy+ " limit " + (registros_mostrar)+ " OFFSET " + ((pg - 1) * registrosMostrar) ;
                String nombreBDSQLServer = "Microsoft SQL Server";
                if(nombreBDSQLServer.equalsIgnoreCase(conexion.getMetaData().getDatabaseProductName()) ){
                    query1 = "select * from ( Select top " + (registros_mostrar) + " * from ( select top " + String.valueOf(pg * registrosMostrar) + " * from " + SQLTabla + " " + SQLWhere + " ORDER BY piloto desc ) as q1 ORDER BY q1.piloto ASC ) as q2 ORDER BY q2.piloto DESC";
                }
                PreparedStatement pstResult = conexion.prepareStatement(query1);
                pstResult.setString(1, busca_virtual + "%");
                pstResult.setString(2, busca_descripcion + "%");

                ResultSet rs = paginado.getResultSet(pstResult);
                int numeroRegistro = (pg - 1) * registrosMostrar;
                int fila = 1;
                while (rs.next()) {
                    if (Perfiles.numeroVirtual(sesionActual, rs.getString("piloto"))) {
                        fila = (1 + (fila * -1));
                        ncheckbox++;
                        salidaTabla1 += "<tr class=\"fila" + fila + "\">\n";
                        salidaTabla1 += "<td width=\"7%\"><strong>" + ++numeroRegistro + "</strong></td>\n";
                        salidaTabla1 += "<td width=\"7%\"><input type=\"checkbox\" id=\"check" + ncheckbox + "\" name=\"check" + ncheckbox + "\" value=\"" + rs.getString("id") + "\"></td>\n";
                        salidaTabla1 += "<td ><a href=\"virtualModificar.jsp?id=" + rs.getString("id") + "&p=" + pg + "\">" + rs.getString("piloto") + "</a></td>\n";
                        salidaTabla1 += "<td>" + rs.getString("descripcion") + "</td>\n";
                        salidaTabla1 += "<td width=\"7%\" ><a onMouseOver=\"mostrarToolTit('"+rs.getString("piloto")+"')\" onMouseOut=\"ocultarToolTit('"+rs.getString("piloto")+"')\" href=\"virtualNumeroAgregar.jsp?id=" + rs.getString("id") + "&p=" + pg + "\">"+msgs.getString("virtual.reg.msg.addext")+"</a><div id='"+rs.getString("piloto")+"' class='toolkit'>"+msgs.getString("anexos.asignados")+"</div></td>\n";
                        String ruteo = null;
                            if(rs.getString("ruteo").equals("0")){
                                ruteo = msgs.getString("virtual.idle");
                            }
                            else if(rs.getString("ruteo").equals("1")){
                                ruteo = msgs.getString("virtual.topdown");
                            }
                            else if(rs.getString("ruteo").equals("2")){
                                ruteo = msgs.getString("virtual.circular");
                            }
                            else if(rs.getString("ruteo").equals("3")){
                                ruteo = msgs.getString("virtual.broadcast");
                            }
                            salidaTabla1 += "<td width=\"7%\" >"+ruteo+"</a></td>\n";
                        salidaTabla1 += "</tr>\n";
                    }
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
                    response.sendRedirect("virtulaRegistro.jsp?pg=" + paginado.getNumeroPaginas() + variablesGet);
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

            String t_contenido = Plantillas.leer(ruta + "/plantillas/virtualRegistro.html");
            t_contenido = Plantillas.reemplazar(t_contenido, "%error_jsp%", error);
            t_contenido = Plantillas.reemplazar(t_contenido, "%variablesGetMasPg%", variablesGetMasPg);
            t_contenido = Plantillas.reemplazar(t_contenido, "%registros_extensiones%", salidaTabla1);
            t_contenido = Plantillas.reemplazar(t_contenido, "%barraPaginado%", salidaPaginado1);
            t_contenido = Plantillas.reemplazar(t_contenido, "%busca_virtual%", busca_virtual);
            t_contenido = Plantillas.reemplazar(t_contenido, "%busca_descripcion%", busca_descripcion);
            t_contenido = Plantillas.reemplazar(t_contenido, "%registros_mostrar_reemplazo%", registros_mostrar_reemplazo);
            t_contenido = Plantillas.reemplazar(t_contenido, "%estilocaja%", estilocaja);
            
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_numvrt%", msgs.getString("virtual.reg.num"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_descrip%", msgs.getString("virtual.reg.desc"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_regxpag%", msgs.getString("virtual.reg.reg"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_btn_find%", msgs.getString("virtual.reg.btn.find"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_tbl_nvrt%", msgs.getString("virtual.reg.tbl.nvrt"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_tbl_desc%", msgs.getString("virtual.reg.tbl.desc"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_tbl_num%", msgs.getString("virtual.reg.tbl.num"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_tbl_dis%", msgs.getString("virtual.reg.tbl.dis"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_btn_new%", msgs.getString("virtual.reg.btn.new"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%vrtreg_btn_del%", msgs.getString("virtual.reg.btn.del"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%anexos.asignados%", msgs.getString("anexos.asignados"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%no.anexos.asignados%", msgs.getString("no.anexos.asignados"));
            
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
            t_javascript = Plantillas.reemplazar(t_javascript, "%ncheckbox%", String.valueOf(ncheckbox).toString());
            t_javascript = Plantillas.reemplazar(t_javascript, "%variablesGetMasPg%", variablesGetMasPg);
            
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
