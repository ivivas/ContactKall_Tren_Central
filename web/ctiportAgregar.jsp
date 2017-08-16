<%@page import="adportas.Plantillas"%>
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
        ComboQuery ii = new ComboQuery();
        /****************** Variables Globales **************************/
        //String opcionesRuteo =Plantillas.comboRuteo("5",msgs);
        String error = "";
        String requestTrim_extensionNumero = "";
        String requestTrim_nombre = "";
        String requestTrim_nombreX = "";
        String requestTrim_largoMusica ="";
        String requestTrim_tipoMusica = "";
        String opcionesMusica = "<option value='musicaEspera'>"+msgs.getString("ctiport.espera")+"</option><option value='fuerahora'>"+msgs.getString("ctiport.fuera")+"</option><option value='bienvenida'>"+msgs.getString("ctiport.hola")+"</option>";
        //String alertAfterLoad = "mostrarDivOpciones(document.getElementById('select_usuario_perfil'));";
        
        /***************************************************************/
        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();
        
        try {
            /**************************** RECUPERO VALORES DE CAMPO Y CREO SELECT DE PERFIL *******************************/
            requestTrim_nombreX = (request.getParameter("musica_nombre")!=null) ? (request.getParameter("musica_nombre").trim()) : ("");
            requestTrim_nombre = (request.getParameter("virtual_descripcion")!=null) ? (request.getParameter("virtual_descripcion").trim()) : ("");
            requestTrim_largoMusica = (request.getParameter("largo")!=null) ? (request.getParameter("largo").trim()) : ("");
            requestTrim_tipoMusica = (request.getParameter("tipo")!=null) ? (request.getParameter("tipo").trim()) : ("");

            /**************************** VERIFICAR DATOS Y AGREGAR USUARIOS ***************************/
            if (request.getParameter("agregar_anexo")!=null) {
                boolean erroresEncontrados = false;
                if (requestTrim_nombreX.compareTo("")==0 || requestTrim_nombre.compareTo("")==0 || requestTrim_tipoMusica.compareTo("5")==0 ){
                    erroresEncontrados = true;
                    error = msgs.getString("msg.err.empty");
                }
                if (erroresEncontrados==false) {
                    int largo =0;
                    try{
                        largo = Integer.parseInt(requestTrim_largoMusica.equals("")?"0":requestTrim_largoMusica);
                        largo = largo * 1000;
                    }catch(Exception e){}
                    PreparedStatement pst = conexion.prepareStatement("INSERT INTO  ctiports (id,nombre_ctiport,tipo_ctiport,largo_musica,descripcion) values (nextval('ctiports_id_seq'),?,?,?,? )");
                    try {                                                
                        pst.setString(1, requestTrim_nombreX);
                        pst.setString(2, requestTrim_tipoMusica);
                        pst.setInt(3, largo);
                        pst.setString(4, requestTrim_nombre);
                        pst.executeUpdate();
                    } catch (Exception e) {
                        erroresEncontrados = true;
                        error = e.getMessage().replace("ERROR:","");
                    }
                    pst.close();
                }
                if (erroresEncontrados==false) {
                    response.sendRedirect("ctiportRegistro.jsp");
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
        String t_contenido = Plantillas.leer(ruta + "/plantillas/ctiportAgregar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%musica_nombre%",requestTrim_nombreX);
        t_contenido = Plantillas.reemplazar(t_contenido,"%musica_numero%",requestTrim_extensionNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtual_descripcion%",requestTrim_nombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%opciones_musica%",opcionesMusica);
        t_contenido = Plantillas.reemplazar(t_contenido,"%largo%","");
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_save%", msgs.getString("virtual.mod.btn.save"));

        t_contenido = Plantillas.reemplazar(t_contenido,"%ctiNumeroToolkit%",msgs.getString("cti.numero.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ctiDescripcionToolkit%",msgs.getString("cti.desc.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ctiLargoToolkit%",msgs.getString("cti.largo.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ctiTipoToolkit%",msgs.getString("ctiTipoToolkit"));


        t_contenido = Plantillas.reemplazar(t_contenido,"%nuevonum%",msgs.getString("ctiport.nuevo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%nom%",msgs.getString("ctiport.nombre"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%desc%",msgs.getString("ctiport.descripcion"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tipo%",msgs.getString("ctiport.tipo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%lar%",msgs.getString("ctiport.largo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%sel%",msgs.getString("opcion.desh.opt.def"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%lar%",msgs.getString("ctiport.largo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%guardar%",msgs.getString("ctiport.img.guardar"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%cancelar%",msgs.getString("ctiport.img.cancelar"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%vrtmod_btn_cancel%", msgs.getString("virtual.mod.btn.cancel"));
        
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
        t_javascript = Plantillas.reemplazar(t_javascript, "%m%", msgs.getString("ctiport.alerta.falta"));
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