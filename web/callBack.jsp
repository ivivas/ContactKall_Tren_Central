<%@page import="query.CallBackQry"%>
<%@page import="query.ComboQuery"%>
<%@page import="adportas.Paginado3"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="query.AcdKallGestion"%>
<%@page import="DTO.Configuracion"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.Fechas"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="BO.CargaMenu"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="adportas.Plantillas"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (!sesionActual.equalsIgnoreCase("adm_general") && !sesionActual.equalsIgnoreCase("adm_pool")  && !sesionActual.equalsIgnoreCase("supervisor")){
        out.println("<script>");
        out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
        out.println("</script>");
        out.println("<body onload=\'regresar()\';>");
    }else{
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }
        else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        ComboQuery ii = new ComboQuery();
        String query = "";
        String limit = request.getParameter("limit")==null?"0":request.getParameter("limit");
        String buscaCampania = request.getParameter("campania") != null ? request.getParameter("campania").trim() : "";
        String buscaRut = request.getParameter("rut") != null ? request.getParameter("rut").trim() : "";
        String buscaNombre = request.getParameter("nombre") != null ? request.getParameter("nombre").trim() : "";
        String buscaApellido = request.getParameter("apellido") != null ? request.getParameter("apellido").trim() : "";
        String buscaFechaDesde = request.getParameter("fecha_desde") != null ? request.getParameter("fecha_desde").trim() : "";
        String buscaFechaHasta = request.getParameter("fecha_hasta") != null ? request.getParameter("fecha_hasta").trim() : "";
        String buscaEstado = request.getParameter("estado") != null ? request.getParameter("estado").trim() : "0";
        String tabla ="";
        String error = "";
        
        StringBuilder salidaTabla1 = new StringBuilder(1000);
        String barra = "";
        
        String variablesGet = "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm:ss");

        
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cAyer = Calendar.getInstance();
        cAyer.add(Calendar.DATE, -1);
        Date ayer = cAyer.getTime();
        
        if(!buscaFechaDesde.equals("")){
            if(Fechas.valida(buscaFechaDesde)){
                if(buscaFechaDesde.length()<=11){
                    buscaFechaDesde+=" 00:00:00";
                }
            }else{
                error+=msgs.getString("error.format");
            }
        }else{
            buscaFechaDesde = df.format(ayer)+" 00:00";
        }
        if(!buscaFechaHasta.equals("")){
            if(Fechas.valida(buscaFechaHasta)){
                if(buscaFechaHasta.length()<=11){
                    buscaFechaHasta+=" 23:59:59";
                }
            }else{
                error+=msgs.getString("error.format");
            }
        }else{
            buscaFechaHasta = df.format(new Date())+" 23:59";
        }
        variablesGet+=(!buscaCampania.equals("")) ? "&campania="+buscaCampania : "";
        variablesGet+=(!buscaRut.equals("")) ? "&rut="+buscaRut : "";
        variablesGet+=(!buscaNombre.equals("")) ? "&nombre="+buscaNombre : "";
        variablesGet+=(!buscaApellido.equals("")) ? "&apellido="+buscaApellido : "";
        variablesGet+=(!buscaFechaDesde.equals("")) ? "&fecha_desde="+buscaFechaDesde : "";
        variablesGet+=(!buscaFechaHasta.equals("")) ? "&fecha_hasta="+buscaFechaHasta : "";
        variablesGet+=(!buscaEstado.equals("")) ? "&estado="+buscaEstado : "";
        variablesGet+=(!limit.equals("")) ? "&limit="+limit : "";
        
        String SQLTabla = " "+" cliente "+" ";
        String SQLWhere = " where 1=1 ";
        int pg = 1;
        try {
            if(request.getParameter("pg")!=null && request.getParameter("pg")!="")
            pg = Integer.parseInt(request.getParameter("pg"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        String campania = "";
        String rut = "";
        String nombre = "";
        String apellido = "";
        String estado = "";
        String fechaD = "";
        String fechaH = "";
        if(!buscaCampania.trim().equalsIgnoreCase("")){
            campania = " and id_campania = " + buscaCampania+" ";
        }
        if(!buscaRut.trim().equalsIgnoreCase("")){
            rut = " and rut_cliente LIKE '%" + buscaRut + "%' ";
        }
        if (!buscaNombre.trim().equalsIgnoreCase("")) {
            nombre = " and nombre_cliente LIKE '%" + buscaNombre + "%' ";
        }
        if (!buscaApellido.trim().equalsIgnoreCase("")) {
            apellido = " and apellido_cliente LIKE '%" + buscaApellido + "%' ";
        }
        if (!buscaEstado.trim().equalsIgnoreCase("")) {
            if(buscaEstado.trim().equals("1")){
                estado = " and criterio_cliente = 'conectado' ";
            }
            else if(buscaEstado.trim().equals("2")){
                estado = " and criterio_cliente = 'rechazada' ";
            }
        }
        if (!buscaFechaDesde.trim().equalsIgnoreCase("")) {
            fechaD = " and fecha_ultimo_contacto >= '" + buscaFechaDesde + "' ";
            
        }
        if (!buscaFechaHasta.trim().equalsIgnoreCase("")) {
            fechaH = " and fecha_ultimo_contacto <= '" + buscaFechaHasta + "' ";
        }
        
        
        SQLWhere = SQLWhere + (campania + rut + nombre + apellido + estado + fechaD + fechaH);
        String SQLOrderBy = " ORDER BY fecha_ultimo_contacto DESC ";
        //int totales = 0;
        
        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement psCont = null;
        PreparedStatement psPag = null;
        ResultSet rs = null;
        ResultSet rsCont = null;
        try{
            if(request.getParameter("buscar") != null){
                //int total = 0;
                //System.out.println("Antes de buscar");
                con = SQLConexion.conectar();
                
                //System.out.println("qry: select count(*) from "+SQLTabla+" "+SQLWhere);
                
                psCont = con.prepareStatement("select count(*) from "+SQLTabla+" "+SQLWhere);
                int total = 0;
                rsCont = psCont.executeQuery();
                while(rsCont.next()){
                    total = rsCont.getInt(1);
                }
                if(total >0){
                    psPag = con.prepareStatement("select count(*) as registrosTotalPaginado from "+SQLTabla+" "+SQLWhere);
                    Paginado3 paginado = new Paginado3(psPag,Integer.parseInt(limit),pg);
                    paginado.setMaximoTamanoBarra(10);
                    barra = paginado.getBarraPaginado2("callBack.jsp", variablesGet);
                    ps = con.prepareStatement("select * from "+SQLTabla+" "+SQLWhere+" "+SQLOrderBy+" limit "+limit+" OFFSET "+((pg-1) * Integer.parseInt(limit)));
                    rs = ps.executeQuery();
                    query = ps.toString().substring(0, ps.toString().indexOf("limit"));
                    System.out.print(query);
                    int cont_registros = (Integer.parseInt(limit) * pg)-Integer.parseInt(limit);
                    while(rs.next()){
                        cont_registros++;
                        salidaTabla1.append("<tr>");
                        salidaTabla1.append("<td>"+rs.getInt("id_cliente")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("rut_cliente")!=null?rs.getString("rut_cliente").trim():"No Informado")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("nombre_cliente")!=null?rs.getString("nombre_cliente").trim():"No Informado")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("apellido_cliente")!=null?rs.getString("apellido_cliente").trim():"No Informado")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("telefono_cliente")!=null ? rs.getString("telefono_cliente").trim() : "&nbsp;")+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("fecha_ultimo_contacto").trim()+"</td>");
                        salidaTabla1.append("<td>"+CallBackQry.nombreCampania(rs.getInt("id_campania"))+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("criterio_cliente").trim().equals("conectado")?"Conectado":"Rechazada")+"</td>");
                        salidaTabla1.append("</tr>\n");
                    }
                }
                else{
                    salidaTabla1.append("<tr><td colspan=\"14\">"+msgs.getString("llamadaRegistro.tag.err.nodata")+"</td></tr>");
                }
                session.setAttribute("tabla",salidaTabla1.toString());
            }
        }catch(Exception e){
            error+="<br/>Error: "+e.toString();
            e.printStackTrace();
            System.out.println("Error buscando registros de llamadas de callback: "+e);
            error = e.getMessage();
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
                psCont.close();
                rsCont.close();
            }catch(Exception e){}
        }
        
        String comboCampaña = "<option value=''>Seleccione</option>";
        for(String camp : CallBackQry.listaCampania()){
            String idC = camp.split("@")[0];
            String nomC = camp.split("@")[1];
            if(idC.equals(buscaCampania)){
                comboCampaña+="<option value='"+idC+"' selected>"+nomC+"</option>";
            }
            else{
                comboCampaña+="<option value='"+idC+"'>"+nomC+"</option>";
            }
        }

        
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/callBack.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        String t_css = Plantillas.leer(ruta + "/css/llamadasRegistros.css");
        String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
        String t_javascript = "";
        
        t_menu = Plantillas.reemplazar(t_menu, "%class_hab%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_disp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_grab%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_agente%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_camp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_enc%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ges%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botonesactive");
        
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
       
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_rut%",buscaRut);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_nombre%",buscaNombre);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_apellido%",buscaApellido);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_apellido%",buscaApellido);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_fecha_desde%",buscaFechaDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_fecha_hasta%",buscaFechaHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%opcion_campaña%",comboCampaña);
        t_contenido = Plantillas.reemplazar(t_contenido,"%tablaLlamadas%",salidaTabla1.toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%error%",error!=null?error:"");
        
        if(buscaEstado.equals("0")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%est0%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est1%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est2%","");
        }
        else if(buscaEstado.equals("1")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%est0%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est1%","selected");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est2%","");            
        }
        else if(buscaEstado.equals("2")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%est0%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est1%","");
            t_contenido = Plantillas.reemplazar(t_contenido,"%est2%","selected");     
        }
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%paginado%",barra);
        t_contenido = Plantillas.reemplazar(t_contenido,"%total%",msgs.getString("msg.total"));

       
        t_contenido = Plantillas.reemplazar(t_contenido,"%empty1%",msgs.getString("msg.err.empty"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%empty2%",msgs.getString("msg.err.empty"));
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.llamadasRegistros%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.llamadasRegistros%", msgs.getString("menu.adm.txt.registro") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", t_css) ;
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
        
        out.print(t_maestra);
        
    }
%>
