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
    if (sesionActual.equalsIgnoreCase("adm_general")) {

        /****************** Variables Globales **************************/
        ComboQuery ii = new ComboQuery();
        String error = "";
        String modificar_usuario = "";
        String modificar_clave = "";
        String modificar_tipo = "";
        String tipo_usuario="";
        String styleCmbDevice="";
        String cmbDevice = "";
        int id_usuario = 0;
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";
        String cmbPool="";

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
            try {
                id_usuario = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {
                //Redirecciono ya que el id anexo no es numerico
                out.println("error 1 :"+e.toString());
                response.sendRedirect("usuarioRegistro.jsp");
            }

            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("bt_modificar_usuario")!=null) {
                boolean erroresEncontrados = false;
                String requestTrim_usuario = (request.getParameter("modificar_usuario")!=null) ? (request.getParameter("modificar_usuario").trim()) : ("");
               
                String requestTrim_clave = (request.getParameter("modificar_clave")!=null) ? (request.getParameter("modificar_clave").trim()) : ("");
                String requestTrim_tipo = (request.getParameter("modificar_tipo")!=null) ? (request.getParameter("modificar_tipo").trim()) : ("");
                String requestTrim_Dev = (request.getParameter("combo_sep")!=null) ? (request.getParameter("combo_sep").trim()) : ("");
                String requestTrim_Pool = (request.getParameter("combo_pool")!=null) ? (request.getParameter("combo_pool").trim()) : ("");
                
                int secretaria = 0;
                int idPool=0;
                
                try{
                    secretaria = Integer.parseInt(requestTrim_Dev);
                }catch(Exception e){}
                try{
                    idPool = Integer.parseInt(requestTrim_Pool);
                }catch(Exception e){}
                
                String qry="UPDATE sesion SET ";
                if(!requestTrim_clave.equals("")){
                    qry += "clave ='"+requestTrim_clave+"', ";
                }
                qry+=" tipo=?, usuario=?  where  id=?;";
                if (erroresEncontrados==false) {
                    try {
                        PreparedStatement pst = conexion.prepareStatement(qry);
                        //pst.setString(1, requestTrim_clave);
                        pst.setString(1, requestTrim_tipo);
                        pst.setString(2, requestTrim_usuario);
                        pst.setInt(3, id_usuario);
                        
                        pst.execute();
                        response.sendRedirect("usuarioRegistro.jsp?pg=" + pgAnterior+"&msgCarga="+msgs.getString("error.msgs.regok"));
                        pst.close();
                    } catch (Exception e) {
                        error = e.toString();
                    }
                    int contSe=0;
                    int contPl=0;
                    PreparedStatement psCont = null;
                    ResultSet rsCont = null;
                    PreparedStatement psCP = null;
                    ResultSet rsCP = null;
                    try{
                        psCont = conexion.prepareStatement("select count(*) from sesion_secretaria where id_sesion = ?");
                        psCont.setInt(1,id_usuario);
                        rsCont = psCont.executeQuery();
                        while(rsCont.next()){
                            contSe=rsCont.getInt(1);
                        }
                    }catch(Exception e){
                    }finally{
                        try{
                            psCont.close();
                            rsCont.close();
                        }catch(Exception e){}
                    }
                    try{
                        psCP = conexion.prepareStatement("select count(*) from pilotos_sesion where id_sesion = ? ");
                        psCP.setInt(1,id_usuario);
                        rsCP = psCP.executeQuery();
                        while(rsCP.next()){
                            contPl = rsCP.getInt(1);
                        }
                    }catch(Exception e){
                    }finally{
                        try{
                            psCP.close();
                            rsCP.close();
                        }catch(Exception e){}
                    }
                    
                    PreparedStatement psSecUs = null;
                    PreparedStatement psDlPl = null;
                    
                    if(requestTrim_tipo.equals("adm_general")){
                        if(contSe>0){
                            try{
                                psSecUs = conexion.prepareStatement("delete from sesion_secretaria where id_sesion = ?");
                                psSecUs.setInt(1, id_usuario);
                                psSecUs.executeUpdate();
                            }catch(Exception e){}finally{
                                try{
                                    psSecUs.close();
                                }catch(Exception e){}
                            }
                        }
                        if(contPl>0){
                            try{
                                psDlPl = conexion.prepareStatement("delete from pilotos_sesion where id_sesion = ?");
                                psDlPl.setInt(1, id_usuario);
                                psDlPl.executeUpdate();
                            }catch(Exception e){
                            }finally{
                                try{
                                    psDlPl.close();
                                }catch(Exception e){}
                            }
                        }
                    }else{
                        try{
                            if(contSe>0){
                                psSecUs = conexion.prepareStatement("update sesion_secretaria set id_secretaria = ? , tipo = 1 where id_sesion = ?");
                            }else{
                                psSecUs = conexion.prepareStatement("insert into sesion_secretaria(id_secretaria, id_sesion, tipo) values (?,?,1)");
                            }
                            psSecUs.setInt(1, secretaria);
                            psSecUs.setInt(2, id_usuario);
                            
                            psSecUs.executeUpdate();
                        }catch(Exception e){
                            System.out.println("Error actualizando sesion_secretaria: "+e);
                        }finally{
                            try{
                                psSecUs.close();
                            }catch(Exception e){}
                        }
                        try{
                            if(contPl>0){
                                psDlPl = conexion.prepareStatement("update pilotos_sesion set id_piloto = ? where id_sesion = ?");
                            }else{
                                psDlPl = conexion.prepareStatement("insert into pilotos_sesion(id_piloto,id_sesion) values(?,?)");
                            }
                            psDlPl.setInt(1,idPool);
                            psDlPl.setInt(2,id_usuario);
                            psDlPl.executeUpdate();
                        }catch(Exception e){
                            System.out.println("Error al actulizar pilotos_sesion: "+e);
                        }
                    }
                }
            }
            
            /***************** VERIFICAMOS QUE EL USUARIO EXISTA Y RECUPERAMOS DATOS ******************/
            String query="SELECT * FROM sesion WHERE id=?";
            PreparedStatement ps= conexion.prepareStatement(query);
            ps.setInt(1,id_usuario);
            ResultSet rs_usuario =ps.executeQuery();  // st.executeQuery("SELECT * FROM sesion WHERE id=" + id);

            if (rs_usuario.next()) {
                modificar_usuario = rs_usuario.getString("usuario").trim();
                modificar_clave = rs_usuario.getString("clave")!=null ? rs_usuario.getString("clave").trim() : "";
                modificar_tipo= rs_usuario.getString("tipo").trim();
                tipo_usuario = modificar_tipo;
            } else {
                response.sendRedirect("usuarioRegistro.jsp");
            }
            rs_usuario.close();

            if(modificar_tipo.equals("adm_general")){
                styleCmbDevice = "style=\"visibility:hidden;\"";
                modificar_tipo="<SELECT style=\"width: 15%;\" size=\"1\" name=\"modificar_tipo\" onchange=\"cambiaTipo(this)\" id=\"modificar_tipo\"> "+
                           "      <OPTION selected value=\"adm_general\">adm_general</OPTION>" +
                           "      <OPTION value=\"supervisor\">supervisor</OPTION>" +
                           "    </SELECT >";

            }else if(modificar_tipo.equals("supervisor")){
                modificar_tipo="<SELECT style=\"width: 15%;\" size=\"1\" name=\"modificar_tipo\" id=\"modificar_tipo\" onchange=\"cambiaTipo(this)\"> "+
                               "      <OPTION  value=\"adm_general\">adm_general</OPTION>" +
                               "      <OPTION selected value=\"supervisor\">supervisor</OPTION>" +
                               "    </SELECT >";
            }
            cmbDevice+="<SELECT style=\"width: 15%;\" size=\"1\" name=\"combo_sep\" id=\"combo_sep\">"+
                    "<OPTION  value=''>"+msgs.getString("cmb.def.ext")+"</OPTION>";
            //PreparedStatement psIdSec = null;
            //ResultSet rsIdSec = null;
            //int idSec=0;
            int idPool=0;
            PreparedStatement psDev=null;
            ResultSet rsDev=null;
            PreparedStatement psIP = null;
            ResultSet rsIP = null;
            PreparedStatement psPool = null;
            ResultSet rsPool = null;
            /*try{
                psIdSec = conexion.prepareStatement("select id_secretaria from sesion_secretaria where id_sesion = ?");
                psIdSec.setInt(1, id_usuario);
                rsIdSec = psIdSec.executeQuery();
                while(rsIdSec.next()){
                    idSec = rsIdSec.getInt("id_secretaria");
                }
            }catch(Exception e){
                System.out.println("Error buscando secretaria: "+e);
            }finally{
                try{
                    psIdSec.close();
                    rsIdSec.close();
                }catch(Exception e){}
            }*/
            try{
                psIP = conexion.prepareStatement("select id_piloto from pilotos_sesion where id_sesion = ? ");
                psIP.setInt(1, id_usuario);
                rsIP = psIP.executeQuery();
                while(rsIP.next()){
                    idPool = rsIP.getInt("id_piloto");
                }
            }catch(Exception e){
                System.out.println("Error buscando ID pool: "+e);
            }finally{
                try{
                    psIP.close();
                    rsIP.close();
                }catch(Exception e){}
            }
            cmbPool+="<select id='combo_pool' name='combo_pool' style=\"width: 15%\"><option value=''>"+msgs.getString("opcion.desh.opt.def")+"</option>";
            try{
                psPool = conexion.prepareStatement("select id, piloto, descripcion from pilotos");
                rsPool = psPool.executeQuery();
                while(rsPool.next()){
                    String select = "";
                    int idP = rsPool.getInt("id");
                    if(idP == idPool){
                        select = "selected";
                    }
                    cmbPool+="<option value=\""+idP+"\" "+select+" >"+rsPool.getString("piloto")+" - "+rsPool.getString("descripcion")+"</option>";
                }
            }catch(Exception e){
                System.out.println("Error buscando Pooles: "+e);
            }
            cmbPool+="</SELECT >";
            try{
                psDev = conexion.prepareStatement("SELECT * from monitores left join sesion_secretaria on id = id_secretaria where id not in (select id_secretaria from  sesion_secretaria where id_sesion != ?)");
                psDev.setInt(1, id_usuario);
                rsDev = psDev.executeQuery();
                while(rsDev.next()){
                    int id_sesion = rsDev.getInt("id_sesion");
                    String sel = "";
                    int id = rsDev.getInt("id");
                    String sep = rsDev.getString("devicename").trim();
                    String nom = rsDev.getString("nombre").trim();
                    if(id_sesion == id_usuario){
                        sel = "selected";
                    }
                    cmbDevice += "<OPTION  value=\""+id+"\" "+sel+">"+sep+" - "+nom+"</OPTION>";
                
                }
            }catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    psDev.close();
                    rsDev.close();
                }catch(Exception e){}
            }
            cmbDevice += "</SELECT >";
        } catch (Exception e) {
            error = e.toString();
        }finally{
            try{
                conexion.close();
            }catch(Exception e){}
        }        

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/usuarioModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%modificar_usuario%",modificar_usuario);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%modificar_clave%","");
        t_contenido = Plantillas.reemplazar(t_contenido,"%modificar_tipo%",modificar_tipo);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(id_usuario).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_title%", msgs.getString("usuario.mod.tabla.title"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_data%", msgs.getString("usuario.mod.tabla.data"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_user%", msgs.getString("usuario.mod.tabla.user"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_pass%", msgs.getString("usuario.mod.tabla.pass"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_reppass%", msgs.getString("usuario.mod.tabla.reppass"));
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_type%", msgs.getString("usuario.mod.tabla.type"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_btn_save%", msgs.getString("usuario.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_btn_cancel%", msgs.getString("usuario.mod.btn.cancel"));
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%style_device%", styleCmbDevice);
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_device%", msgs.getString("monitor.reg.monn"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%usrmod_tbl_cmbdevice%", cmbDevice);
        t_contenido = Plantillas.reemplazar(t_contenido,"%usragr_tbl_pool%", msgs.getString("menu.adm.txt.numeroVirtual"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%seleccion_pool_sup%",cmbPool);
        t_contenido = Plantillas.reemplazar(t_contenido,"%tag_empty%", msgs.getString("msg.err.empty"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tag_empty2%", msgs.getString("msg.err.empty"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_pool_tooltip%", msgs.getString("user.pool.tooltip"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_monitor_tooltip%", msgs.getString("user.extension.toolkit"));

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
        
        String t_javascript = "";
        
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
        
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%",t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;

        out.println(t_maestra);
    } else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

