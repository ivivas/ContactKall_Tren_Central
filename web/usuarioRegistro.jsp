<%@page import="query.ComboQuery"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"%>
<% response.setHeader("Pragma","no-cache"); %>
<% response.setHeader("Cache-Control","no-cache"); %>
<% response.setDateHeader("Expires",0); %>
<% response.setDateHeader("max-age",0); %>
<%
String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
if (sesionActual.equalsIgnoreCase("adm_general")) {
    
    ComboQuery ii = new ComboQuery();
    int contador=0;
    String registros_mostrar_reemplazo="";
    String buscar_usuario="";
    String registros_mostrar="";
    String variablesGet = "";
    String salidaPaginado1 = "";
    String usuario_antiguo="";
    int ncheckbox = 0;
    String salidaTabla1 = "";
    String variablesGetMasPg = "";
    String error="";
    String msgCarga="";
    
    ResourceBundle msgs;
    if(session.getAttribute("msgs")==null){
        Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
        ResourceBundle.clearCache();
        msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
    }else{
        msgs = (ResourceBundle) session.getAttribute("msgs");
    }

    buscar_usuario = (request.getParameter("buscar_usuario")!=null) ? request.getParameter("buscar_usuario").trim() : "";
    registros_mostrar = (request.getParameter("registros_mostrar")!=null) ? request.getParameter("registros_mostrar").trim() : "15";
    msgCarga = (request.getParameter("msgCarga")!=null) ? request.getParameter("msgCarga").trim() : "";
    try{
        Connection conexion = SQLConexion.conectar();
        if (request.getParameter("ncheckbox_eliminar")!=null){
            try {
                int ncheckbox_eliminar = Integer.parseInt(request.getParameter("ncheckbox_eliminar"));
                if (ncheckbox_eliminar > 0) {
                    PreparedStatement pst2 = conexion.prepareStatement("DELETE FROM sesion WHERE id=?");
                    PreparedStatement pstRel = conexion.prepareStatement("delete from sesion_secretaria where id_sesion = ?");
                    boolean err = true;
                    for (int i=1; i<=ncheckbox_eliminar; i++) {
                        if(request.getParameter("check" + i)!=null) {
                            pst2.setInt(1, Integer.parseInt(request.getParameter("check" + i)));
                            if(pst2.executeUpdate()<=0){
                                err = false;
                            }
                            try{
                                pstRel.setInt(1, Integer.parseInt(request.getParameter("check" + i)));
                                pstRel.execute();
                            }catch(Exception e){
                                System.out.println("Error eliminando de la tabla sesion_secretaria: "+e);
                            }
                        }
                    }
                    if(err){
                        msgCarga = msgs.getString("error.msg.del");
                    }else{
                        msgCarga = msgs.getString("error.msg.nodel");
                    }
                    pst2.close();
                }
            } catch (Exception e) {
                out.println("error 2 : "+ e.toString());
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

        variablesGet += (buscar_usuario != "") ? "&buscar_usuario="+buscar_usuario : "";
        variablesGet += (registros_mostrar != "") ? "&registros_mostrar="+registros_mostrar : "15";

        Paginado3 paginado = new Paginado3();

        String SQLTabla = "sesion";
        String SQLWhere = "where usuario LIKE ? ";
        String SQLOrderBy = "ORDER BY usuario ASC";
        int registrosMostrar = 15;
        try {
            if(registros_mostrar!=null && registros_mostrar!="")
            registrosMostrar = Integer.parseInt(registros_mostrar);
        }catch(Exception e) {
            registrosMostrar = 15;
        }
        int pg = 1;
        try {
            if(request.getParameter("pg")!=null && request.getParameter("pg")!="")
            pg = Integer.parseInt(request.getParameter("pg"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        String query="SELECT COUNT(*) AS registrosTotalPaginado FROM " + SQLTabla + " " + SQLWhere;
        PreparedStatement pstCount = conexion.prepareStatement(query);
        pstCount.setString(1,buscar_usuario+"%");
        paginado = new Paginado3(pstCount,registrosMostrar,pg);
        paginado.setMaximoTamanoBarra(10);
        salidaPaginado1 = paginado.getBarraPaginado2("usuarioRegistro.jsp", variablesGet);
        pstCount.close();

        PreparedStatement pstCount2 = conexion.prepareStatement("SELECT COUNT(*) AS registrosTotalPaginado FROM " + SQLTabla + " " + SQLWhere);
        pstCount2.setString(1,buscar_usuario+"%");
        ResultSet rsTotales = pstCount2.executeQuery();
        if(rsTotales.next()) contador = rsTotales.getInt("registrosTotalPaginado");
        rsTotales.close();
        pstCount2.close();

        if(contador<(pg*registrosMostrar)) registros_mostrar = String.valueOf(contador - (registrosMostrar*(pg-1)));
        String query2="select * from  "+ SQLTabla +" "+ SQLWhere +" order by id limit "+ (registros_mostrar) + " OFFSET " + ((pg - 1) * registrosMostrar);
        String nombreBDSQLServer = "Microsoft SQL Server";
        if(nombreBDSQLServer.equalsIgnoreCase(conexion.getMetaData().getDatabaseProductName()) ){
            query2="select * from ( Select top "+ (registros_mostrar) +" * from ( select top "+ String.valueOf(pg*(registrosMostrar)) +" * from "+ SQLTabla +" "+ SQLWhere +" ORDER BY usuario desc ) as q1 ORDER BY q1.usuario ASC ) as q2 ORDER BY q2.usuario DESC";
        }
        //System.out.println("qry: "+query2);
        PreparedStatement pstResult = conexion.prepareStatement(query2);
        pstResult.setString(1,buscar_usuario+"%");
        ResultSet rs = paginado.getResultSet(pstResult);

        int numeroRegistro = (pg-1) * registrosMostrar;
        int fila = 1;
        String ext_asignadas = "";
        String clav_asignadas = "";
        //cerrarlos
        Statement stt = conexion.createStatement();
        Statement stExtensiones = conexion.createStatement();
        Statement stt2 = conexion.createStatement();
        while (rs.next()) {
            if(!usuario_antiguo.equalsIgnoreCase(rs.getString("usuario").trim())) {
                fila = (1 + (fila * -1));
                ncheckbox++;
                salidaTabla1 += "<tr class=\"fila" + fila + "\">\n";
                salidaTabla1 += "<td width=\"2%\"><strong>" + ++numeroRegistro + "</strong></td>\n";
                salidaTabla1 += "<td width=\"4%\"><input type=\"checkbox\" id=\"check" + ncheckbox + "\" name=\"check" + ncheckbox + "\" value=\""+ rs.getString("id") +"\"></td>\n";
                salidaTabla1 += "<td width=\"16%\" ><a href=\"usuarioModificar.jsp?id=" + rs.getString("id") + "&p=" + pg + "\">" + rs.getString("usuario") +"</a></td>\n";
                //salidaTabla1 += "<td width=\"16%\" >" + rs.getString("clave") + "</td>\n";
                salidaTabla1 += "<td width=\"16%\" >" + rs.getString("tipo") + "</td>\n";
                salidaTabla1 += "</tr>\n";
                ext_asignadas = "";
                clav_asignadas = "";
                usuario_antiguo = rs.getString("usuario").trim();
            }
        }
        rs.close();
        stt.close();
        stExtensiones.close();
        stt2.close();
        pstResult.close();
        conexion.close();
        if (salidaTabla1.compareTo("")==0) {
            salidaTabla1 += "<tr class=\"fila0\"><td colspan=\"6\" align=\"center\">"+msgs.getString("error.nodata")+"</td></tr>";
        }

        //Si el usuario Ingresa un pg con un numero inexistente lo redireccionamos
        if (paginado.getNumeroPaginas() < pg && paginado.getNumeroPaginas()>0) {
            response.sendRedirect("usuarioRegistro.jsp?pg="+ paginado.getNumeroPaginas() + variablesGet);
        }
        variablesGetMasPg = ("?pg=" + pg + variablesGet);

    }catch (Exception ex){
        //ex.printStackTrace();
        System.out.println("Error buscando: "+ex);
    }
    if(!msgCarga.equals("")){
        msgCarga = "<div style=\"margin: 1% auto;\"><strong>"+msgCarga+"</Strong></div>";
    }
    
    String ruta = getServletConfig().getServletContext().getRealPath("");
    String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
    
    String t_contenido = Plantillas.leer(ruta + "/plantillas/usuarioRegistro.html");
    
    String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
    
    t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botonesactive");
    t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botones");
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
    
    t_contenido = Plantillas.reemplazar(t_contenido,"%variablesGetMasPg%",variablesGetMasPg);
    t_contenido = Plantillas.reemplazar(t_contenido, "%registros_mostrar_reemplazo%", registros_mostrar_reemplazo);
    t_contenido = Plantillas.reemplazar(t_contenido, "%buscar_usuario%", buscar_usuario);
    t_contenido = Plantillas.reemplazar(t_contenido, "%paginado_usuarios%",salidaPaginado1);
    t_contenido = Plantillas.reemplazar(t_contenido,"%registros_usuarios%",salidaTabla1);
    t_contenido = Plantillas.reemplazar(t_contenido,"%busca_usuario%",buscar_usuario);
    
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_reg_user%",msgs.getString("usuarios.registro.user"));
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_reg_regxpag%",msgs.getString("usuarios.registro.regt"));
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_tbl_user%",msgs.getString("usuarios.registro.tbl.usr"));
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_tbl_type%",msgs.getString("usuarios.registro.tbl.type"));
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_btn_find%",msgs.getString("usuarios.registro.btn.find")); 
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_btn_new%",msgs.getString("usuarios.registro.btn.new")); 
    t_contenido = Plantillas.reemplazar(t_contenido,"%usuario_btn_delete%",msgs.getString("usuarios.registro.btn.del")); 
    t_contenido = Plantillas.reemplazar(t_contenido,"%msg_carga%",msgCarga); 

    String tieneTitulos = ii.getTieneTitulos(msgs);
    String divTitulos="<div id=\"titulo\">" + 
                    "<h2>%menu.adm.txt.usuarios%</h2>" +
                    "</div>";
    if(tieneTitulos != ""){
        t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
        t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.usuarios%", msgs.getString("menu.adm.txt.usuarios") );
    }else{
        t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
    }
    
    String t_javascript = Plantillas.leer(ruta + "/js/usuario.js");
    
    t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_nodatadel1%" , msgs.getString("error.msgs.principal.nodata"));
    t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del1%" , msgs.getString("error.msgs.principal.confdel"));
    t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc1%" , msgs.getString("error.data.inc"));
    t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%",String.valueOf(ncheckbox).toString());
    t_javascript = Plantillas.reemplazar(t_javascript,"%variablesGetMasPg%",variablesGetMasPg);
    
    t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
    t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
    t_maestra   = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
    t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;
               
    out.println(t_maestra);

}else {
    out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
}
%>
