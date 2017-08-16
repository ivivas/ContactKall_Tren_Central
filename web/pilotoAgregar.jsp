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
    if (sesionActual.compareTo("adm_pool")==0 || sesionActual.compareTo("adm_general")==0) {
        try{
            Connection conexion = null;
            /****************** Variables Globales **************************/
            ComboQuery ii = new ComboQuery();
            int ncheckbox = 0;
            String error = "";
            String variablesGetMasPg = "";        
            String alertAfterLoad = "mostrarDivOpciones(document.getElementById('select_usuario_perfil'));";

            int idUsuario = 0;
            String select_usuarioPerfil = "";
            String usuarioNick = "";
            String usuarioNombre = "";
            String select_anexosAsignados = "";
            String select_anexosDisponibles = "";
            String pgAnterior = (request.getParameter("p")!=null) ? request.getParameter("p") : "";

            ResourceBundle msgs;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }else{
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }

            /***************************************************************/
            conexion = SQLConexion.conectar();
            Statement st = conexion.createStatement();
            try {

                try {
                    idUsuario = (request.getParameter("id") != null) ? Integer.parseInt(request.getParameter("id")) : 88888;
                } catch (Exception e) {
                    //Redirecciono ya que el id usuario no existe
                    response.sendRedirect("virtualRegistro.jsp");
                }

                /**
                 * *************** VERIFICAMOS QUE EL USUARIO EXISTA Y
                 * RECUPERAMOS DATOS *****************
                 */
                String query = "SELECT * FROM monitores WHERE id=?";
                PreparedStatement ps = conexion.prepareStatement(query);
                ps.setInt(1, idUsuario);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    usuarioNick = rs.getString("extension").trim();
                    usuarioNombre = (rs.getString("nombre").trim() != null) ? rs.getString("nombre").trim() : "";

                } else {
                    response.sendRedirect("monitorRegistro.jsp");
                }
                rs.close();
                ps.close();

                /**
                 * ************************** VERIFICAR DATOS Y MODIFICAMOS
                 * USUARIO ******************************
                 */
                if (request.getParameter("modificar") != null) {
                    boolean erroresEncontrados = false;
                    String queryAsig = "INSERT INTO pilotos_monitores (id_piloto,id_monitor) VALUES (?,?)";
                    String queryDesig = "DELETE FROM pilotos_monitores where id_monitor = ? and id_piloto = ? ";

                    String[] requestTrim_usuarioAnexosAsignados = request.getParameterValues("select_anexos_asignados");
                    String[] requestTrim_usuarioAnexosDesignados = request.getParameterValues("select_anexos_disponibles");

                    PreparedStatement pst1 = conexion.prepareStatement(queryAsig);
                    
                    PreparedStatement pst2 = conexion.prepareStatement(queryDesig);
                        
                    if (requestTrim_usuarioAnexosAsignados != null) {
                        for (int jj = 0; jj < requestTrim_usuarioAnexosAsignados.length; jj++) {
                            try {
                                pst1.setInt(1, Integer.parseInt(requestTrim_usuarioAnexosAsignados[jj]));
                                pst1.setInt(2, idUsuario);
                                int valor = 0;
                                PreparedStatement psValidar = conexion.prepareStatement("select id from pilotos_monitores where id_piloto = ? and id_monitor = ?;");
                                psValidar.setInt(1, Integer.parseInt(requestTrim_usuarioAnexosAsignados[jj]));
                                psValidar.setInt(2, idUsuario);
                                ResultSet rsValidar = psValidar.executeQuery();
                                while(rsValidar.next()){
                                    valor = rsValidar.getInt("id");
                                }
                                if(valor == 0){
                                    pst1.executeUpdate();
                                }
                            } catch (Exception ex) {
                                ex.printStackTrace();
                                erroresEncontrados = true;
                                error = "Problemas al intentar asignar los pilotos. Intentelo nuevamente";
                            }
                        }
                    }
                    if (requestTrim_usuarioAnexosDesignados != null) {
                        for (int jj = 0; jj < requestTrim_usuarioAnexosDesignados.length; jj++) {
                            try {
                                pst2.setInt(1, idUsuario);
                                pst2.setInt(2, Integer.parseInt(requestTrim_usuarioAnexosDesignados[jj]));
                                pst2.executeUpdate();
                            } catch (Exception ex) {
                                ex.printStackTrace();
                                erroresEncontrados = true;
                                error = "Problemas al intentar Designar los pilotos. Intentelo nuevamente";
                            }
                        }
                    }
                    pst1.close();
                    pst2.close();
                    if (erroresEncontrados == false) {
                        response.sendRedirect("monitorRegistro.jsp");
                    }
                }

                /**
                 * ************************** CREO SELECT ANEXOS ASIGNADOS Y
                 * DISPONIBLES ******************************
                 */
                query = "SELECT p.id as id,p.piloto as piloto,p.descripcion as descripcion FROM pilotos p JOIN pilotos_monitores pm on p.id = pm.id_piloto join monitores m on pm.id_monitor = m.id  WHERE m.id = ? ORDER BY p.piloto ASC";
                PreparedStatement pst00 = conexion.prepareStatement(query);
                pst00.setInt(1, idUsuario);

                ResultSet rsSelectAnexosAsignados = pst00.executeQuery();
                while (rsSelectAnexosAsignados.next()) {
                    select_anexosAsignados += "<option value=\"" + rsSelectAnexosAsignados.getInt("id") + "\" >" + rsSelectAnexosAsignados.getString("piloto") + " - " + rsSelectAnexosAsignados.getString("descripcion") + "</option>";
                }
                rsSelectAnexosAsignados.close();
                pst00.close();

                query = "SELECT p.id as id,p.piloto as piloto,p.descripcion as descripcion FROM pilotos p where p.id not in(select id_piloto from pilotos_monitores) ORDER BY p.piloto ASC";
                pst00 = conexion.prepareStatement(query);
                ResultSet rsSelectAnexosDisponibles = pst00.executeQuery();
                while (rsSelectAnexosDisponibles.next()) {
                    select_anexosDisponibles += "<option value=\"" + rsSelectAnexosDisponibles.getInt("id") + "\" >" + rsSelectAnexosDisponibles.getString("piloto") + " - " + rsSelectAnexosDisponibles.getString("descripcion") + "</option>";
                }
                rsSelectAnexosDisponibles.close();
                pst00.close();

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
            String t_contenido = Plantillas.leer(ruta + "/plantillas/pilotoAgregar.html");
            t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
            t_contenido = Plantillas.reemplazar(t_contenido,"%id%",String.valueOf(idUsuario));
            t_contenido = Plantillas.reemplazar(t_contenido,"%p%", pgAnterior);
            t_contenido = Plantillas.reemplazar(t_contenido,"%usuarioNick%",usuarioNick);
            t_contenido = Plantillas.reemplazar(t_contenido,"%usuarioNombre%",usuarioNombre);
            t_contenido = Plantillas.reemplazar(t_contenido,"%select_usuarioPerfil%",select_usuarioPerfil);
            t_contenido = Plantillas.reemplazar(t_contenido,"%select_anexosAsignados%",select_anexosAsignados);
            t_contenido = Plantillas.reemplazar(t_contenido,"%select_anexosDisponibles%",select_anexosDisponibles);
            
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_tbl_titlevrt%",msgs.getString("virtual.addextn.tblus.title"));
            t_contenido = Plantillas.reemplazar(t_contenido,"%mntadan_tbl_data%",msgs.getString("monitor.addextn.tblus.data"));
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_tbl_num%",msgs.getString("virtual.addextn.tblus.num")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_tbl_desc%",msgs.getString("virtual.addextn.tblus.desc")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%mntadan_tbl_titleanx%",msgs.getString("monitor.addextn.tblanx.title")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_tbl_pilasg%",msgs.getString("piloto.asignados")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_tbl_pildsp%",msgs.getString("piloto.disponibles")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_btn_save%",msgs.getString("virtual.addextn.btn.save")); 
            t_contenido = Plantillas.reemplazar(t_contenido,"%vrtadan_btn_cancel%",msgs.getString("virtual.addextn.btn.cancel")); 
            
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

            String t_javascript = Plantillas.leer(ruta + "/js/virtualNumero.js");
            
            t_javascript = Plantillas.reemplazar(t_javascript , "%js_err_nodatadel1%" , msgs.getString("error.msgs.principal.nodata"));
            t_javascript = Plantillas.reemplazar(t_javascript , "%js_conf_del1%" , msgs.getString("error.msgs.principal.confdel"));
            t_javascript = Plantillas.reemplazar(t_javascript , "%js_err_datainc1%" , msgs.getString("error.data.inc"));
            t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%",String.valueOf(ncheckbox).toString());
            t_javascript = Plantillas.reemplazar(t_javascript,"%variablesGetMasPg%",variablesGetMasPg);
            
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
            t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
            t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;
            

            out.println(t_maestra);

        }catch(Exception ex){
             ex.printStackTrace();
        }
    } else {
        response.sendRedirect("index.jsp");
    }
%>
