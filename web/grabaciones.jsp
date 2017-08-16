<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="BO.CargaMenu"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="query.ComboQuery"%>
<%@page import="query.Reckall"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="adportas.Plantillas"%>
<% response.setHeader("Pragma","no-cache"); %>
<% response.setHeader("Cache-Control","no-cache"); %>
<% response.setDateHeader("Expires",0); %>
<% response.setDateHeader("max-age",0); %>
<%
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (!sesionActual.equalsIgnoreCase("adm_general")  && !sesionActual.equalsIgnoreCase("supervisor")){
        out.println("<script>");
        out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
        out.println("</script>");
        out.println("<body onload=\'regresar()\';>");
    }else{
        ComboQuery ii = new ComboQuery();
        String user = session.getAttribute("usuario").toString().trim();
        Connection con = null;
        Reckall.conf = Reckall.configuracionReckall();
        String titulosGenerados = null;
        boolean[] titulos = new boolean[5]; //mostrarAnexo - mostrarContraparte - mostrarTipo - mostrarFechaInicioTermino - mostrarDuracion;
        String limit = request.getParameter("limit")==null?"0":request.getParameter("limit");
        String offset = request.getParameter("offset")!=null?request.getParameter("offset"):"0";
        String numero = request.getParameter("numero_")==null?"":request.getParameter("numero_");
        String piloto = request.getParameter("piloto");
        String fechaDesde = request.getParameter("desde")==null?"":request.getParameter("desde");
        String fechaHasta = request.getParameter("hasta")==null?"":request.getParameter("hasta");
        int cantidad = Integer.parseInt(request.getParameter("cantidad")==null?"10":request.getParameter("cantidad"));
        String contraparte = request.getParameter("contraparte")==null?"":request.getParameter("contraparte");
        String idCall = request.getParameter("id_call")==null?"":request.getParameter("id_call").trim();
        ResourceBundle msgs;
        int totalGrabaciones = 0;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }
        else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        con = SQLConexion.conectar();
        titulosGenerados = Reckall.titulosGenerados(titulos,msgs);
        String comboPiloto = ComboQuery.comboPiloto(con,request.getParameter("piloto")==null?"":request.getParameter("piloto"),user, sesionActual );
        String tablaGrabaciones = "";
        String paginado = "";
        String buscar = request.getParameter("buscar");
        String index = request.getParameter("index");
        if(!fechaDesde.equals("") && fechaDesde.length()==10){
            fechaDesde+=" 00:00";
        }
        if(!fechaHasta.equals("") && fechaHasta.length()==10){
            fechaHasta+=" 23:59";
        }
        try{
            if(buscar!=null){
                tablaGrabaciones = Reckall.tablaGrabaciones(con,limit,offset,numero,contraparte,fechaDesde,fechaHasta,msgs.getString("reckall.busqueda.vacia"),piloto,titulos,idCall);
                paginado = Reckall.paginado(con,index,Integer.parseInt(limit),Integer.parseInt(offset),cantidad, numero, contraparte,piloto,fechaDesde,fechaHasta,idCall);
                totalGrabaciones = Reckall.totalGrabaciones(con,index,Integer.parseInt(limit),Integer.parseInt(offset),cantidad, numero, contraparte,piloto,fechaDesde,fechaHasta,idCall);
            }
        }catch(Exception e){
            System.out.println("Error en grabaciones.jsp: "+e);
        }finally{
            try{
                con.close();
            }catch(Exception e){}
        }
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/grabaciones.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact_reck.html");
        String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
        String t_javascript = Plantillas.leer(ruta + "/js/grabaciones.js");
        t_javascript = Plantillas.reemplazar(t_javascript, "%sel.piloto%", msgs.getString("msg.err.empty"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%fecha_no_valida1%", msgs.getString("error.formatfh2"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%fecha_no_valida2%", msgs.getString("error.formatfh2"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%fecha_no_valida3%", msgs.getString("error.formatfh2"));
        
        t_menu = Plantillas.reemplazar(t_menu, "%class_hab%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_disp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_grab%","botonesactive");
        t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_agente%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_camp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_enc%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ges%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");
        
        if(limit.equals("20")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%20%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%50%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%100%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%200%","");
        }else if(limit.equals("50")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%50%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%20%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%100%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%200%","");
        }
        else if(limit.equals("100")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%100%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%50%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%20%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%200%","");
        }else if(limit.equals("200")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%200%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%50%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%100%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%20%","");
        }
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%cantidad%",msgs.getString("reckall.cantidad"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%inicio%",msgs.getString("reckall.inicio"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%idLlamada%",msgs.getString("reckall.id"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%numeroRevisado%",msgs.getString("reckall.numero.revisado"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%contraparte%",msgs.getString("reckall.contraparte"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tipoLlamada%",msgs.getString("reckall.tipo.llamada"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%fechaDesde%",msgs.getString("reckall.fecha.desde"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%fechaHasta%",msgs.getString("reckall.fecha.hasta"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%termino%",msgs.getString("reckall.termino"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%duracion%",msgs.getString("reckall.duracion"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%archivo%",msgs.getString("reckall.archivo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%numpiloto%", msgs.getString("reckall.piloto"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%menu%", ComboQuery.menu());   
        t_contenido = Plantillas.reemplazar(t_contenido,"%opcion_piloto%",comboPiloto);
        t_contenido = Plantillas.reemplazar(t_contenido,"%num%",numero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%titulosGenerados%",titulosGenerados);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_contraparte%",contraparte);
        t_contenido = Plantillas.reemplazar(t_contenido,"%desde%",fechaDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%hasta%",fechaHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%paginado%",paginado);
        t_contenido = Plantillas.reemplazar(t_contenido,"%tablaGrabaciones%",tablaGrabaciones);
        t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%", session.getAttribute("usuario").toString());
        t_contenido = Plantillas.reemplazar(t_contenido, "%formato_f_desde%", msgs.getString("llamadaRegistro.tag.pie.format"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%formato_f_hasta%", msgs.getString("llamadaRegistro.tag.pie.format"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%id_call%", msgs.getString("reckall.id"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%valor_id_call%", idCall);
        t_contenido = Plantillas.reemplazar(t_contenido, "%format_fecha%", msgs.getString("encuesta.format.date2"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%tot_reg%", msgs.getString("msg.total"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%cant_tot_reg%",totalGrabaciones+"");
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%","<div id=\"titulo\"><h2>"+msgs.getString("menu.adm.txt.grabaciones")+"</h2></div>");
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }

        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
        

        out.print(t_maestra);
        
    }
%>