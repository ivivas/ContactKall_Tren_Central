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
        String user = session.getAttribute("usuario").toString().trim();
        String limit = request.getParameter("limit")==null?"0":request.getParameter("limit");
        String buscaIdCall = request.getParameter("id_call") != null ? request.getParameter("id_call").trim() : "";
        //String buscaExtension = request.getParameter("extension") != null ? request.getParameter("extension").trim() : "";
        String buscaContraparte = request.getParameter("contraparte") != null ? request.getParameter("contraparte").trim() : "";
        String buscaUltRedireccion = request.getParameter("ult_red") != null ? request.getParameter("ult_red").trim() : "";
        String buscaNumFinal = request.getParameter("num_final") != null ? request.getParameter("num_final").trim() : "";
        String buscaRingMin = request.getParameter("ring_min") != null ? request.getParameter("ring_min").trim() : "";
        String buscaRingMax = request.getParameter("ring_max") != null ? request.getParameter("ring_max").trim() : "";
        String buscaTipo = request.getParameter("busca_tipo") != null ? request.getParameter("busca_tipo").trim() : "";
        String buscaFechaDesde = request.getParameter("fecha_desde") != null ? request.getParameter("fecha_desde").trim() : "";
        String buscaFechaHasta = request.getParameter("fecha_hasta") != null ? request.getParameter("fecha_hasta").trim() : "";
        String buscaAbandonada = request.getParameter("abandonada") != null ? request.getParameter("abandonada").trim() : "";
        String buscaDurMin = request.getParameter("dur_min") != null ? request.getParameter("dur_min").trim() : "";
        String buscaPiloto = request.getParameter("piloto") != null ? request.getParameter("piloto").trim() : "";
        String buscaNumero = request.getParameter("numero_") != null ? request.getParameter("numero_").trim() : "";
        
        String tipos_disponibles = "";
        String checkAbandonada = "";
        StringBuilder salidaTabla1 = new StringBuilder(1000);
        String barra = "";
        String error = "";
        String variablesGet = "";
        String SQLabandonadas = "";
        String totalBusqueda="";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm:ss");
        
        if(!buscaAbandonada.equals("")){
            checkAbandonada = "checked";
            SQLabandonadas = " and (estado1 = 'abandonada' or estado3='abandonada') ";
        }
        boolean flag1 = true, flag2 = true;
        int busca_idllamada = 0;
        int pst_duracion = 0;
        int ringsMinimos = 0;
        int ringsMaximos = 10000;
        try{
            busca_idllamada = Integer.parseInt(buscaIdCall);
        }catch(Exception e){
            buscaIdCall = "";
        }
        try{
            pst_duracion = Integer.parseInt(buscaDurMin);
        }catch(Exception e){
            buscaDurMin = "";
        }
        try{
            ringsMinimos = Integer.parseInt(buscaRingMin);
        }catch(Exception e){
            buscaRingMin = "";
        }
        try{
            ringsMaximos = Integer.parseInt(buscaRingMax);
        }catch(Exception e){
            buscaRingMax = "";
        }
        
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
                flag1 = false;
            }
        }else{
            flag1 = false;
            buscaFechaDesde = df.format(ayer)+" 00:00";
        }
        if(!buscaFechaHasta.equals("")){
            if(Fechas.valida(buscaFechaHasta)){
                if(buscaFechaHasta.length()<=11){
                    buscaFechaHasta+=" 23:59:59";
                }
            }else{
                error+=msgs.getString("error.format");
                flag2 = false;
            }
        }else{
            flag2 = false;
            buscaFechaHasta = df.format(new Date())+" 23:59";
        }
        variablesGet+=(!buscaIdCall.equals("")) ? "&id_call="+buscaIdCall : "";
        variablesGet+=(!buscaNumero.equals("")) ? "&numero_="+buscaNumero : "";
        variablesGet+=(!buscaPiloto.equals("")) ? "&piloto="+buscaPiloto : "";
        variablesGet+=(!buscaContraparte.equals("")) ? "&contraparte="+buscaContraparte : "";
        variablesGet+=(!buscaUltRedireccion.equals("")) ? "&ult_red="+buscaUltRedireccion : "";
        variablesGet+=(!buscaNumFinal.equals("")) ? "&num_final="+buscaNumFinal : "";
        variablesGet+=(!buscaRingMax.equals("")) ? "&ring_min="+buscaRingMin : "";
        variablesGet+=(!buscaRingMax.equals("")) ? "&ring_max="+buscaRingMax : "";
        variablesGet+=(!buscaTipo.equals("")) ? "&busca_tipo="+buscaTipo : "";
        variablesGet+=(!buscaFechaDesde.equals("")) ? "&fecha_desde="+buscaFechaDesde : "";
        variablesGet+=(!buscaFechaHasta.equals("")) ? "&fecha_hasta="+buscaFechaHasta : "";
        variablesGet+=(!buscaAbandonada.equals("")) ? "&abandonada="+buscaAbandonada : "";
        variablesGet+=(!buscaDurMin.equals("")) ? "&dur_min="+buscaDurMin : "";
        variablesGet+=(!limit.equals("")) ? "&limit="+limit : "";
        
        String SQLTabla = " "+" vista_llamadas_mixtas "+" ";
        String SQLWhere = "";
        String extensionQuery = "", contraparteQuery = "", redireccionQuery = "", finalQuery = "", centrocostoQuery = "", usuarioQuery = "", tipoQry="";
        int pg = 1;
        try {
            if(request.getParameter("pg")!=null && request.getParameter("pg")!="")
            pg = Integer.parseInt(request.getParameter("pg"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(buscaNumero.equals("-1")){
            String anexos="";
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try{
                con = SQLConexion.conectar();
                ps = con.prepareStatement("select anexo from secretaria where piloto_asociado = ? ");
                ps.setString(1, buscaPiloto);
                rs = ps.executeQuery();
                int cont = 0;
                while(rs.next()){
                    if(cont>0){
                        anexos+=",";
                    }
                    cont++;
                    anexos += "'"+rs.getString("anexo").trim()+"'";
                }
            }catch(Exception e){
                System.out.println("Error buscanto todos los anexos en registro de llamadas: "+e);
            }finally{
                try{
                    con.close();
                    ps.close();
                    rs.close();
                }catch(Exception e){}
            }
            extensionQuery = " and extension in (" + anexos + ") ";
        }else{
            extensionQuery = " and extension = '" + buscaNumero + "' ";
        }
        if (!buscaContraparte.trim().equalsIgnoreCase("")) {
            contraparteQuery = " and contraparte LIKE '" + buscaContraparte + "%' ";
        }
        if (!buscaUltRedireccion.trim().equalsIgnoreCase("")) {
            redireccionQuery = " and ultima_redireccion LIKE '" + buscaUltRedireccion + "%' ";
        }
        if (!buscaNumFinal.trim().equalsIgnoreCase("")) {
            finalQuery = " and numero_final LIKE '" + buscaNumFinal + "%' ";
        }
        if(!buscaTipo.equals("")){
            tipoQry = " AND tipo = '"+buscaTipo+"' ";
        }
        
        if (busca_idllamada != 0) {
            SQLWhere = " where  duracion>= ? AND tiempo_origen>= ? AND tiempo_origen<= ? "
                    + " and rings >= ? and rings <= ? and id_llamada = ? " + SQLabandonadas + tipoQry;
        }else{
            SQLWhere = "where duracion>= ? AND tiempo_origen>= ? AND tiempo_origen<= ? "
                                + " and rings >= ? and rings <= ? " + SQLabandonadas + tipoQry;
        }
        SQLWhere = SQLWhere + (extensionQuery + contraparteQuery + redireccionQuery + finalQuery + centrocostoQuery + usuarioQuery);
        String SQLOrderBy = " ORDER BY tiempo_origen ASC ";
        //int totales = 0;
        
        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement psCont = null;
        PreparedStatement psPag = null;
        ResultSet rs = null;
        ResultSet rsCont = null;
        Configuracion confGestion = AcdKallGestion.conf==null?AcdKallGestion.configuracionGestion():AcdKallGestion.conf;
        try{
            if(flag1&&flag2){
                //int total = 0;
                //System.out.println("Antes de buscar");
                con = SQLConexion.conectar(confGestion.getIpServidor(),confGestion.getBaseDatos(),confGestion.getUsuarioBD(),confGestion.getClaveBD());
                
                //System.out.println("qry: select count(*) from "+SQLTabla+" "+SQLWhere);
                
                psCont = con.prepareStatement("select count(*) from "+SQLTabla+" "+SQLWhere);
                psCont.setInt(1, pst_duracion);
                psCont.setTimestamp(2, Fechas.ddmmaa2time(buscaFechaDesde));
                psCont.setTimestamp(3, Fechas.ddmmaa2time(buscaFechaHasta));
                psCont.setInt(4, ringsMinimos);
                psCont.setInt(5, ringsMaximos);
                int total = 0;
                if (busca_idllamada != 0) {
                    psCont.setInt(6, busca_idllamada);
                }
                rsCont = psCont.executeQuery();
                while(rsCont.next()){
                    totalBusqueda = ""+rsCont.getInt(1);
                    total = rsCont.getInt(1);
                }
                if(total >0){
                    psPag = con.prepareStatement("select count(*) as registrosTotalPaginado from "+SQLTabla+" "+SQLWhere);
                    psPag.setInt(1, pst_duracion);
                    psPag.setTimestamp(2, Fechas.ddmmaa2time(buscaFechaDesde));
                    psPag.setTimestamp(3, Fechas.ddmmaa2time(buscaFechaHasta));
                    psPag.setInt(4, ringsMinimos);
                    psPag.setInt(5, ringsMaximos);
                    if (busca_idllamada != 0) {
                        psPag.setInt(6, busca_idllamada);
                    }
                    Paginado3 paginado = new Paginado3(psPag,Integer.parseInt(limit),pg);
                    paginado.setMaximoTamanoBarra(10);
                    barra = paginado.getBarraPaginado2("llamadasRegistros.jsp", variablesGet);

                    ps = con.prepareStatement("select * from "+SQLTabla+" "+SQLWhere+" "+SQLOrderBy+" limit "+limit+" OFFSET "+((pg-1) * Integer.parseInt(limit)));
                    ps.setInt(1, pst_duracion);
                    ps.setTimestamp(2, Fechas.ddmmaa2time(buscaFechaDesde));
                    ps.setTimestamp(3, Fechas.ddmmaa2time(buscaFechaHasta));
                    ps.setInt(4, ringsMinimos);
                    ps.setInt(5, ringsMaximos);
                    if (busca_idllamada != 0) {
                        ps.setInt(6, busca_idllamada);
                    }
                    rs = ps.executeQuery();
                    query = ps.toString().substring(0, ps.toString().indexOf("limit"));
                    int cont_registros = (Integer.parseInt(limit) * pg)-Integer.parseInt(limit);
                    while(rs.next()){
                        cont_registros++;
                        salidaTabla1.append("<tr>");
                        salidaTabla1.append("<td>"+cont_registros+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("id_llamada").trim()+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("extension").trim()+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("contraparte").trim()+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("ultima_redireccion")!=null ? rs.getString("ultima_redireccion").trim() : "&nbsp;")+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("numero_final").trim()+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("estado1") != null ? rs.getString("estado1").trim() : "&nbsp;")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("estado2") != null ? rs.getString("estado2").trim() : "&nbsp;")+"</td>");
                        salidaTabla1.append("<td>"+(rs.getString("estado3") != null ? rs.getString("estado3").trim() : "&nbsp;")+"</td>");
                        String tipo = "";
                        if(rs.getString("tipo").trim().equals("anexos")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.ext");
                        }else if(rs.getString("tipo").trim().equals("entrante")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.in");
                        }else if(rs.getString("tipo").trim().equals("saliente")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.out");
                        }
                        salidaTabla1.append("<td>"+tipo+"</td>");
                        salidaTabla1.append("<td>"+sdf.format(rs.getTimestamp("tiempo_origen"))+"</td>");
                        salidaTabla1.append("<td>"+sdf1.format(rs.getTimestamp("tiempo_origen"))+"</td>");
                        salidaTabla1.append("<td>"+Fechas.segundos2HMS_2(rs.getInt("duracion"))+"</td>");
                        salidaTabla1.append("<td>"+rs.getString("rings").trim()+"</td>");
                        salidaTabla1.append("</tr>\n");
                    }
                }else{
                    salidaTabla1.append("<tr><td colspan=\"14\">"+msgs.getString("llamadaRegistro.tag.err.nodata")+"</td></tr>");
                }
            }
        }catch(Exception e){
            error+="<br/>Error: "+e.toString();
            e.printStackTrace();
            System.out.println("Error buscando registros de llamadas: "+e);
            System.out.println("qry: "+"select * from "+SQLTabla+" "+SQLWhere+" "+SQLOrderBy+
                    " -> "+pst_duracion+" "+buscaFechaDesde+" "+buscaFechaHasta+" "+ringsMinimos+" "+ringsMaximos+" id: "+busca_idllamada);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
                psCont.close();
                rsCont.close();
            }catch(Exception e){}
        }
        
        Connection con1 = null;
        String comboPiloto = "";
        try{
            con1 = SQLConexion.conectar();
            comboPiloto = ComboQuery.comboPiloto(con1,buscaPiloto,user,sesionActual);
        }catch(Exception e){   
        }
        
        
        tipos_disponibles += (buscaTipo.equalsIgnoreCase("")) ? "<option selected value=\"\">"+msgs.getString("llamadaRegistro.tag.select.all")+"</option>" : 
                "<option value=\"\">"+msgs.getString("llamadaRegistro.tag.select.all")+"</option>";
        tipos_disponibles += (buscaTipo.equalsIgnoreCase("anexos")) ? "<option selected value=\"anexos\">"+msgs.getString("llamadaRegistro.tag.select.ext")+"</option>" : 
                "<option value=\"anexos\">"+msgs.getString("llamadaRegistro.tag.select.ext")+"</option>";
        tipos_disponibles += (buscaTipo.equalsIgnoreCase("entrante")) ? "<option selected value=\"entrante\">"+msgs.getString("llamadaRegistro.tag.select.in")+"</option>" : 
                "<option value=\"entrante\">"+msgs.getString("llamadaRegistro.tag.select.in")+"</option>";
        tipos_disponibles += (buscaTipo.equalsIgnoreCase("saliente")) ? "<option selected value=\"saliente\">"+msgs.getString("llamadaRegistro.tag.select.out")+"</option>" : 
                "<option value=\"saliente\">"+msgs.getString("llamadaRegistro.tag.select.out")+"</option>";
        
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/llamadasRegistros.html");
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
        t_menu = Plantillas.reemplazar(t_menu, "%class_ges%","botonesactive");
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
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%cantidad%",msgs.getString("llamadaRegistro.tag.regpag"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%id_llamada%",msgs.getString("llamadaRegistro.tag.id"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%extension%",msgs.getString("llamadaRegistro.tag.ext"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%contraparte%",msgs.getString("llamadaRegistro.tag.contra"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ult_red%",msgs.getString("llamadaRegistro.tag.redirec"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%num_final%",msgs.getString("llamadaRegistro.tag.numfin"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ring_min%",msgs.getString("llamadaRegistro.tag.ringmin"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%ring_max%",msgs.getString("llamadaRegistro.tag.ringmax"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tipo%",msgs.getString("llamadaRegistro.tag.tipo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%fecha_desde%",msgs.getString("llamadaRegistro.tag.fechdes"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%fecha_hasta%",msgs.getString("llamadaRegistro.tag.fechas"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%abandonada%",msgs.getString("llamadaRegistro.tag.aband"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%dur_min%",msgs.getString("llamadaRegistro.tag.durmin"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%abandonada%",checkAbandonada);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_id_call%",buscaIdCall);
        //t_contenido = Plantillas.reemplazar(t_contenido,"%valor_extension%",buscaExtension);
        t_contenido = Plantillas.reemplazar(t_contenido,"%num%",buscaNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_contraparte%",buscaContraparte);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_ult_red%",buscaUltRedireccion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_n_final%",buscaNumFinal);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_ring_min%",buscaRingMin);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_ring_max%",buscaRingMax);
        t_contenido = Plantillas.reemplazar(t_contenido,"%select_tipo%",tipos_disponibles);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_fecha_desde%",buscaFechaDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_fecha_hasta%",buscaFechaHasta);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_dur_min%",buscaDurMin);
        t_contenido = Plantillas.reemplazar(t_contenido,"%tablaLlamadas%",salidaTabla1.toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%paginado%",barra);
        t_contenido = Plantillas.reemplazar(t_contenido,"%total%",msgs.getString("msg.total"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%valor_total%",totalBusqueda);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_id%",msgs.getString("llamadaRegistro.tag.cabecera.id"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_extn%",msgs.getString("llamadaRegistro.tag.cabecera.ext"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_contraparte%",msgs.getString("llamadaRegistro.tag.cabecera.contr"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_ult_red%",msgs.getString("llamadaRegistro.tag.cabecera.ultred"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_num_final%",msgs.getString("llamadaRegistro.tag.cabecera.numfin"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_est_extn%",msgs.getString("llamadaRegistro.tag.cabecera.estex"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_est_lstred%",msgs.getString("llamadaRegistro.tag.cabecera.estultred"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_est_numfnl%",msgs.getString("llamadaRegistro.tag.cabecera.estnumfin"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_tipo%",msgs.getString("llamadaRegistro.tag.cabecera.tipo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_fecha%",msgs.getString("llamadaRegistro.tag.cabecera.fecha"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_inicio%",msgs.getString("llamadaRegistro.tag.cabecera.inicio"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_duracion%",msgs.getString("llamadaRegistro.tag.cabecera.durac"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_ring%",msgs.getString("llamadaRegistro.tag.cabecera.ring"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tbl_ring%",msgs.getString("llamadaRegistro.tag.cabecera.ring"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%piloto%", msgs.getString("reckall.piloto"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%queryExcel%", query);
        t_contenido = Plantillas.reemplazar(t_contenido, "%opciones_piloto%", comboPiloto);
        t_contenido = Plantillas.reemplazar(t_contenido,"%numeroRevisado%",msgs.getString("reckall.numero.revisado"));
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
