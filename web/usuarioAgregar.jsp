<%@page import="query.ComboQuery"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*" %><%
response.setHeader("Pragma","no-cache"); 
 response.setHeader("Cache-Control","no-cache"); 
 response.setDateHeader("Expires",0); 
 response.setDateHeader("max-age",0); 

    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equalsIgnoreCase("adm_general")) {
    
        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String error = "";
        String requestTrim_usuario   = "";
        String requestTrim_clave = "";
        String requestTrim_repClave="";
        String requestTrim_tipo = "";
        String comboSuper="";
        String requestIdSepSup="";
        String comboPool="";
        String reqIdPool="";
        
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
        try {
            /**************************** RECUPERO VALORES DE CAMPO Y CREO SELECT DE PERFIL *******************************/
            requestTrim_usuario = (request.getParameter("usuario")!=null) ? (request.getParameter("usuario").trim()) : ("");
            requestTrim_clave = (request.getParameter("clave")!=null) ? (request.getParameter("clave").trim()) : ("");
            requestTrim_tipo = (request.getParameter("agregar_tipo")!=null) ? (request.getParameter("agregar_tipo").trim()) : ("");
            requestIdSepSup = (request.getParameter("combo_sep_sup")!=null) ? (request.getParameter("combo_sep_sup").trim()) : ("");
            reqIdPool = (request.getParameter("combo_pool")!=null) ? (request.getParameter("combo_pool").trim()) : ("");

            /**************************** VERIFICAR DATOS Y AGREGAR USUARIOS ***************************/
            if (request.getParameter("agregar_usuario")!=null) {
                boolean erroresEncontrados = false;
                if (requestTrim_usuario.compareTo("")==0 || requestTrim_clave.compareTo("")==0 || requestTrim_tipo.compareTo("")==0) {
                    erroresEncontrados = true;
                    error += msgs.getString("error.data.inc")+"<br>";
                }
                if (erroresEncontrados==false) {
                    int cont = 0;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try{
                        ps = conexion.prepareStatement("select count(*) from sesion where usuario = ? ");
                        ps.setString(1, requestTrim_usuario.toLowerCase());
                        rs = ps.executeQuery();
                        while(rs.next()){
                            cont = rs.getInt(1);
                        }
                    }catch(Exception e){
                        System.out.println("Error contando usuario: "+e);
                    }finally{
                        try{
                            ps.close();
                            rs.close();
                        }catch(Exception e){}
                    }
                    if(cont>0){
                        error += msgs.getString("msg.err.usr.dlp")+"<br>";
                    }else{
                        PreparedStatement pst = null;
                        int upd = 0;
                        try {
                            pst = conexion.prepareStatement("INSERT INTO sesion (usuario,clave,tipo,es_logueado) values (?,?,?,0);");
                            pst.setString(1,requestTrim_usuario.toLowerCase());
                            pst.setString(2, requestTrim_clave);
                            pst.setString(3, requestTrim_tipo);
                            upd = pst.executeUpdate();

                        } catch (Exception e) {
                            System.out.println("Error: "+e);
                            erroresEncontrados = true;
                            error += e.toString()+"<br>";
                        }finally{
                            try{
                                pst.close();
                            }catch(Exception e){}
                        }
                        if(upd > 0){
                            if(!requestTrim_tipo.equals("adm_general")){
                                int idUsr = 0;
                                PreparedStatement psUsr = null;
                                ResultSet rsUsr = null;
                                try{
                                    psUsr = conexion.prepareStatement("select id from sesion where usuario = ? and clave = ?");
                                    psUsr.setString(1, requestTrim_usuario.toLowerCase());
                                    psUsr.setString(2,requestTrim_clave);
                                    rsUsr = psUsr.executeQuery();
                                    while(rsUsr.next()){
                                        idUsr = rsUsr.getInt("id");
                                    }
                                }catch(Exception e){
                                    System.out.println("Error buscando id agente: "+e);
                                    error += e.toString()+"<br>";
                                }finally{
                                    try{
                                        psUsr.close();
                                        rsUsr.close();
                                    }catch(Exception e){}
                                }
                                if(idUsr != 0){
                                    PreparedStatement psIn = null;
                                    PreparedStatement psPS = null;
                                    int idSep = 0;
                                    int idPool = 0;
                                    try{
                                        idSep = Integer.parseInt(requestIdSepSup);
                                    }catch(Exception e){
                                        System.out.println("requestIdSepSup: "+requestIdSepSup);
                                    }
                                    try{
                                        idPool = Integer.parseInt(reqIdPool);
                                    }catch(Exception e){
                                        System.out.println("reqIdPool: "+reqIdPool);
                                    }
                                    try{
                                        psIn = conexion.prepareStatement("insert into sesion_secretaria(id_sesion,id_secretaria,tipo) values (?,?,?)");
                                        psIn.setInt(1, idUsr);
                                        psIn.setInt(2, idSep);
                                        psIn.setInt(3, 1);
                                        psIn.executeUpdate();
                                    }catch(Exception e){
                                        System.out.println("Error insertando en tabla sesion_secretaria: "+e);
                                        error+=e.toString()+"<br>";
                                    }
                                    try{
                                        psPS = conexion.prepareStatement("insert into pilotos_sesion(id_piloto,id_sesion) values(?,?);");
                                        psPS.setInt(1,idPool);
                                        psPS.setInt(2,idUsr);
                                        
                                        psPS.executeUpdate();
                                    }catch(Exception e){
                                        System.out.println("Error insertando en tabla pilotos_sesion "+e);
                                    }
                                }else{
                                    System.out.println("Error, no se encuentra idUsuario....");
                                }
                            }
                        }
                        response.sendRedirect("usuarioRegistro.jsp");
                    }
                }
            }//fin if request.getParameter("agregar_usuario")!=null
            
        }catch (Exception e) {
            out.println("error 3 "+e.toString());
            error += e.toString()+"<br>";
            System.out.println("Error general: "+e);
        }
        try{
            comboSuper += "<select id='combo_sep_sup' name='combo_sep_sup' style=\"float:left;width: 15%\"><option value=''>"+msgs.getString("opcion.desh.opt.def")+"</option>";
            PreparedStatement psSup = conexion.prepareStatement("SELECT id,devicename,nombre from monitores where id not in (select id_secretaria from  sesion_secretaria)");
            ResultSet rsx = psSup.executeQuery();
            while(rsx.next()){
                    int id = rsx.getInt("id");
                    String sep = rsx.getString("devicename").trim();
                    String nom = rsx.getString("nombre").trim();
                    comboSuper+="<OPTION  value=\""+id+"\">"+sep+" - "+nom+"</OPTION>";
            }
            comboSuper+="</select>";
        }catch(Exception e){
            
            System.out.println("Error buscando monitores: "+e);
        }
        try{
            comboPool+="<select id='combo_pool' name='combo_pool' style=\"float:left;width: 15%\"><option value=''>"+msgs.getString("opcion.desh.opt.def")+"</option>";
            PreparedStatement ps = conexion.prepareStatement("select id, piloto, descripcion from pilotos");
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                comboPool+="<option value=\""+rs.getInt("id")+"\" >"+rs.getString("piloto")+" - "+rs.getString("descripcion")+"</option>";
            }
        }catch(Exception e){
            System.out.println("Error buscando pilotos: "+e);
        }
        comboPool+="</select>";
        try{
            conexion.close();
        }catch(Exception e){}
        
        requestTrim_tipo = " <SELECT  size=\"1\" name=\"agregar_tipo\" id=\"agregar_tipo\" onchange=\"cambiaTipo(this)\" style=\"float:left;width: 15%\"> "+
                            " <OPTION  value=\"\">"+msgs.getString("cmb.def.ext")+"</OPTION>" +
                            " <OPTION  value=\"adm_general\">adm_general</OPTION>" +
                            " <OPTION  value=\"supervisor\">supervisor</OPTION>" +
                            " </SELECT >";

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/usuario_agregar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%usuario%",requestTrim_usuario);
        t_contenido = Plantillas.reemplazar(t_contenido,"%clave%",requestTrim_clave);
        t_contenido = Plantillas.reemplazar(t_contenido,"%repclave%",requestTrim_repClave);
        t_contenido = Plantillas.reemplazar(t_contenido,"%seleccion_tipo%",requestTrim_tipo);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%seleccion_extension_sup%",comboSuper);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%userNombreToolkit%",msgs.getString("user.nombre.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%userPassToolkit%",msgs.getString("user.password.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%userRPassToolkit%",msgs.getString("user.password.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%userTipoToolkit%",msgs.getString("user.tipo.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%userExtensionToolkit%",msgs.getString("user.extension.toolkit"));
                
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_title%",msgs.getString("usuario.add.tabla.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_data%",msgs.getString("usuario.add.tabla.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_user%",msgs.getString("usuario.add.tabla.user"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_pass%",msgs.getString("usuario.add.tabla.pass"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_reppass%",msgs.getString("usuario.add.tabla.reppass"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_type%",msgs.getString("usuario.add.tabla.type"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_extn%",msgs.getString("monitor.reg.monn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_pool%",msgs.getString("menu.adm.txt.numeroVirtual"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%seleccion_pool_sup%",comboPool);
        t_contenido = Plantillas.reemplazar(t_contenido,"%userPoolToolTip%",msgs.getString("user.pool.tooltip"));
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_btn_save%",msgs.getString("usuario.add.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_btn_cancel%",msgs.getString("usuario.add.btn.cancel"));

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
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_nodata_add%" , msgs.getString("msg.err.empty"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_dist_pss%" , msgs.getString("msg.err.distinc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%variablesGetMasPg%" , "");
        t_javascript = Plantillas.reemplazar(t_javascript, "%ncheckbox%" , "0");
        
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
        
        //String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
        
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%",t_contenido);
        //t_maestra = Plantillas.reemplazar(t_maestra,"%ncheckbox%","0");
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;

        out.println(t_maestra);
} else {
    out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
}
%>