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
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        ComboQuery ii = new ComboQuery();
        /****************** Variables Globales **************************/
        String error = "";
        String nombre = "";
        String virtualDescripcion = "";
        int largo = 0;
        String tipo ="";
        int idExtension = 0;
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";

        /***************************************************************/
        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();
        try {
            try {
                idExtension = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {
                //Redirecciono ya que el id anexo no es numerico
                out.println("error 1 :"+e.toString());
                response.sendRedirect("ctiportRegistro.jsp");
            }
            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("modificar_virtual")!=null) {
                boolean erroresEncontrados = false;
                int largoMusica=0;
                String requestTrim_musica = (request.getParameter("musica_nombre")!=null) ? (request.getParameter("musica_nombre").trim()) : ("");
                String requestTrim_tipo = (request.getParameter("tipo")!=null) ? (request.getParameter("tipo").trim()) : ("");
                String requestTrim_largo = (request.getParameter("largo")!=null) ? (request.getParameter("largo").trim()) : ("");
                String requestTrim_descripcion = (request.getParameter("virtual_descripcion")!=null) ? (request.getParameter("virtual_descripcion").trim()) : ("");
                if (requestTrim_musica.compareTo("")==0 | requestTrim_tipo.compareTo("")==0 | requestTrim_descripcion.compareTo("")==0) {
                    erroresEncontrados = true;
                    error = msgs.getString("virtual.alerta.falta");
                }
                try{
                    largoMusica = Integer.parseInt(requestTrim_largo);
                    largoMusica = largoMusica * 1000;
                }catch(Exception e){}
                if (erroresEncontrados==false) {
                    System.out.println("requestTrim_largo: "+requestTrim_largo);
                    System.out.println("requestTrim_musica "+requestTrim_musica);
                    System.out.println("requestTrim_tipo "+requestTrim_tipo);
                    System.out.println("requestTrim_descripcion "+requestTrim_descripcion);
                    System.out.println("idExtension "+idExtension);
                    
                    if(requestTrim_largo.equals("")){
                        PreparedStatement pst = conexion.prepareStatement("UPDATE ctiports SET nombre_ctiport=?,tipo_ctiport=?, descripcion = ? WHERE id=?;");
                        try {
                            pst.setString(1, requestTrim_musica);
                            pst.setString(2, requestTrim_tipo);
                            pst.setString(3, requestTrim_descripcion);
                            pst.setInt(4, idExtension);
                            pst.executeUpdate();
                        response.sendRedirect("ctiportRegistro.jsp?pg=" + pgAnterior);
                        } catch (Exception e) {
                            error = e.toString();
                            System.out.println("error ::: " ); e.printStackTrace();
                        }
                        pst.close();
                    }else{
                        PreparedStatement pst = conexion.prepareStatement("UPDATE ctiports SET nombre_ctiport=?,tipo_ctiport=?,largo_musica=?, descripcion = ? WHERE id=?;");
                        try {  
                            pst.setString(1, requestTrim_musica);
                            pst.setString(2, requestTrim_tipo);
                            //pst.setInt(3, Integer.parseInt(requestTrim_largo));largoMusica
                            pst.setInt(3, largoMusica);
                            pst.setString(4, requestTrim_descripcion);
                            pst.setInt(5, idExtension);
                            System.out.println("execute: "+pst.executeUpdate());
                            response.sendRedirect("ctiportRegistro.jsp?pg=" + pgAnterior);
                        } catch (Exception e) {
                            error = e.toString();
                            System.out.println("error ::: "+e ); 
                            //e.printStackTrace();
                        }
                        pst.close();
                    }
                }
            }
            /***************** VERIFICAMOS QUE EL ANEXO EXISTA Y RECUPERAMOS DATOS ******************/
            ResultSet rsAnexo = st.executeQuery("SELECT * FROM ctiports WHERE id=" + idExtension);
            if (rsAnexo.next()) {
                nombre= rsAnexo.getString("nombre_ctiport").trim();
                virtualDescripcion = rsAnexo.getString("descripcion")!=null ? rsAnexo.getString("descripcion").trim() : "";
                //largo= rsAnexo.getString("largo_musica")!=null ? rsAnexo.getString("largo_musica").trim() : "";
                largo = rsAnexo.getInt("largo_musica");
                if(largo > 0 ){
                    largo = largo /1000;
                }
                String sel = rsAnexo.getString("tipo_ctiport")!=null ? rsAnexo.getString("tipo_ctiport").trim() : "";;
                tipo = ComboQuery.comboTipoCtiPort(sel);
            } else {
                response.sendRedirect("ctiportRegistro.jsp");
            }
            rsAnexo.close();
        } catch (Exception e) {
            error = e.toString();
        }
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/ctiportModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%musica_nombre%",nombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_descripcion%",virtualDescripcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%largo%",largo+"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%opciones_musica%",tipo);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualHorario%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%mod%",msgs.getString("ctiport.modificar"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%nom%",msgs.getString("ctiport.nombre"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%desc%",msgs.getString("ctiport.descripcion"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%lar%", msgs.getString("ctiport.largo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tipo%",msgs.getString("ctiport.tipo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%guardar%",msgs.getString("ctiport.img.guardar"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%cancelar%",msgs.getString("ctiport.img.cancelar"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_save%", msgs.getString("virtual.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_cancel%", msgs.getString("virtual.mod.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_largo_tooltip%", msgs.getString("cti.largo.toolkit"));
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.ctiPort%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.ctiPort%", msgs.getString("menu.adm.txt.ctiPort") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }

        String t_javascript = Plantillas.leer(ruta + "/js/extension.js");
        t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%","0");
        t_javascript = Plantillas.reemplazar(t_javascript,"%m%",msgs.getString("ctiport.alerta.falta"));
        t_javascript = Plantillas.reemplazar(t_javascript,"%format_num%",msgs.getString("msg.format.num"));
        
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
        
        t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_monitor%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_cti%","botonesactive");
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

