<%@page import="BO.GraficoBarraEncuesta"%>
<%@page import="DTO.EncuestaPreguntasDTO"%>
<%@page import="java.util.Map"%>
<%@page import="query.ComboQuery"%>
<%@page import="adportas.Paginado3"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="DTO.Configuracion"%>
<%@page import="query.IvrEncuestaQry"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="BO.CargaMenu"%>
<%@page import="adportas.Plantillas"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
    Connection con1 = null;
    Connection con = null;
        Connection con2 = null;
           PreparedStatement ps_barra = null;
           PreparedStatement ps1 = null;
              PreparedStatement ps = null;
              ResultSet rs1 = null;
              ResultSet rs = null;
              
    try {
  
        ResourceBundle msgs;
        if (session.getAttribute("msgs") == null) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        } else {
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
        if (sesionActual.equals("adm_general") | sesionActual.equals("supervisor")) {
            String user = session.getAttribute("usuario").toString().trim();
            String desde = request.getParameter("desde") != null ? request.getParameter("desde").trim() : "";
            String hasta = request.getParameter("hasta") != null ? request.getParameter("hasta").trim() : "";
            String anexo = request.getParameter("numero_") != null ? request.getParameter("numero_").trim() : "";
            String pagina = request.getParameter("pg") != null ? request.getParameter("pg").trim() : "";
            String piloto = request.getParameter("piloto") != null ? request.getParameter("piloto").trim() : "";
            String req_preguntas = request.getParameter("preguntas") != null ? request.getParameter("preguntas").trim() : "-1";
            int total_reg = 0;
            String data_encuesta = "";
            String salida_paginado = "";
            String variablesGet = "";
            int registrosMostrar = 15;
            String anexosBusqueda = "";
            String opciones_preguntas = "";
            //int registrosMostrar = 5;
            int pg = 1;
            ComboQuery ii = new ComboQuery();

            try {
                if (!pagina.equals("")) {
                    pg = Integer.parseInt(pagina);
                }
            } catch (Exception e) {
                pg = 1;

            }

            boolean err = false;
            String error = "";
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
            Date d_desde = null;
            Date d_hasta = null;

            if (desde.equals("")) {
                Calendar ca = Calendar.getInstance();
                desde += "01-";
                if ((ca.get(Calendar.MONTH) + 1) < 10) {
                    desde += "0" + (ca.get(Calendar.MONTH) + 1);
                } else {
                    desde += (ca.get(Calendar.MONTH) + 1);
                }
                desde += "-" + ca.get(Calendar.YEAR);
                d_desde = sdf2.parse(desde + " 00:00:00");
            } else {
                try {
                    sdf.parse(desde);
                    d_desde = sdf2.parse(desde + " 00:00:00");
                } catch (Exception e) {
                    err = true;
                    error += "Error en formato de fecha desde<br/>";
                }
            }

            if (hasta.equals("")) {
                Calendar ca = Calendar.getInstance();
                hasta += ca.getActualMaximum(Calendar.DAY_OF_MONTH) + "-";
                if ((ca.get(Calendar.MONTH) + 1) < 10) {
                    hasta += "0" + (ca.get(Calendar.MONTH) + 1);
                } else {
                    hasta += (ca.get(Calendar.MONTH) + 1);
                }
                hasta += "-" + ca.get(Calendar.YEAR);
                d_hasta = sdf2.parse(hasta + " 23:59:59");
            } else {
                try {
                    sdf.parse(hasta);
                    d_hasta = sdf2.parse(hasta + " 23:59:59");
                } catch (Exception e) {
                    err = true;
                    error += "Error en formato de fecha hasta<br/>";
                }
            }
            Configuracion conf = IvrEncuestaQry.getConfiguracion();

            session.setAttribute("desde", desde);
            session.setAttribute("hasta", hasta);
            session.setAttribute("anexo", anexo);
            session.setAttribute("piloto", piloto);
            session.setAttribute("pregunta", req_preguntas);

            variablesGet += "&desde=" + desde;
            variablesGet += "&hasta=" + hasta;
            variablesGet += (!piloto.equals("")) ? "&piloto=" + piloto : "";
            variablesGet += (!anexo.equals("")) ? "&numero_=" + anexo : "";
            variablesGet +=  "&pregunta=" + req_preguntas ;
            //System.out.println("anexo: "+anexo+" piloto: "+piloto);
            if (anexo.equals("-1")) {
               
                
                
                try {
                    con1 = SQLConexion.conectar();
                    ps1 = con1.prepareStatement("select anexo from secretaria where piloto_asociado = ? ");
                    ps1.setString(1, piloto);
                    rs1 = ps1.executeQuery();
                    int cont = 0;
                    while (rs1.next()) {
                        if (cont > 0) {
                            anexosBusqueda += ",";
                        }
                        cont++;
                        anexosBusqueda += "'" + rs1.getString("anexo").trim() + "'";
                        //System.out.println(rs1.getString("anexo").trim());
                    }
                } catch (Exception e) {
                    out.println("Error buscando secretarias: " + e.getMessage());
                    System.out.println("Error buscando secretarias: " + e);
                } finally {
                  
                }
            } else if (!anexo.equals("")) {
                anexosBusqueda = "'" + anexo + "'";
            }
            //System.out.println("rq_preguntas: "+req_preguntas);
            String plantillaGraficoAcumulado = "";
            String plantillaGrafico = "{"+
                            "type: \"bar\","+
                            "fillColor: \"color\","+
                            "strokeColor: \"color\","+
                            "highlightFill: \"color\","+
                            "highlightStroke: \"color\","+
                            "data: [%valores_grafico%]"+
                            "}";
            IvrEncuestaQry ivr = new IvrEncuestaQry();
            String lblGrafico = "";
            String dataGrafico = "";
            boolean esMultiple = false;
            Map<Integer,Object> mapa = GraficoBarraEncuesta.crearGraficoBarraEncuenta(desde, hasta, anexo, piloto, req_preguntas);
            for(Object llavaIdEnc : mapa.keySet()){

                lblGrafico = "'Nota "+ivr.getMinEncuesta()+"','Nota "+ivr.getMaxEncuesta()+"'";
                if(mapa.get(llavaIdEnc) instanceof Integer){
                    dataGrafico +=  mapa.get(llavaIdEnc)+",";
                    
                    //valorGrafico += llavaIdEnc+","
                }   
                else if(mapa.get(llavaIdEnc) instanceof Map){
                    esMultiple = true;
                    lblGrafico = ivr.getMinEncuesta()+","+ivr.getMaxEncuesta() +",";
                    for(Object llavaIdEnc2 : mapa.keySet()){
                        Map mapax = (Map) mapa.get(llavaIdEnc2);
                        for(Object dato : mapax.values()){
                            dataGrafico += dato+",";
                            
                        }
                        dataGrafico = dataGrafico.substring(0,dataGrafico.length()-1);
                        plantillaGrafico = plantillaGrafico.replace("%valores_grafico%", dataGrafico);
                        dataGrafico = "";
                        plantillaGraficoAcumulado += plantillaGrafico + ",";
                        plantillaGrafico = "{"+
                            "type: \"bar\","+
                            "fillColor: \"color\","+
                            "strokeColor: \"color\","+
                            "highlightFill: \"color\","+
                            "highlightStroke: \"color\","+
                            "data: [%valores_grafico%]"+
                            "}";
                    }
                    
                }
                if(esMultiple){
                    plantillaGrafico = plantillaGrafico.replace("%valores_grafico%", dataGrafico);
                break;
                }
                
            }
            if(!esMultiple && request.getParameter("buscar") != null){
                try{
                    dataGrafico = dataGrafico.substring(0,dataGrafico.length()-1);
                    plantillaGrafico = plantillaGrafico.replace("%valores_grafico%", dataGrafico);
                    
                        plantillaGrafico = plantillaGrafico.replaceAll("color", "green");
                }
                catch(Exception e){
                }
            }
            
            
            Map<Integer, EncuestaPreguntasDTO> mapaPreguntas = ivr.DescripPreg();
//        String lblPreguntas = "<table class=\"caja_\" ><thead style=\"border: 1px solid #000000\"><tr><th>"
            String lblPreguntas = "<table class=\"caja_\" ><thead style=\"border: 1px solid #cecdc8\"><tr><th><font color=\"white\">"
                    + msgs.getString("encusta.tbl2.preg")
                    + "</font></th><th><font color=\"white\">"
                    + msgs.getString("encusta.tbl2.ref")
                    + "</font></th><th></th></tr></thead><tbody>";


            for (Map.Entry<Integer, EncuestaPreguntasDTO> entry : mapaPreguntas.entrySet()) {
                lblPreguntas += "<tr><td>"
                        + entry.getKey()
                        + "</td>"
                        + "<td>"
                        + entry.getValue().getShortDesc()                        
                        + "</td>"
                        + "<td>"
                        + "<div><i class=\"fa fa-question-circle\" onmouseover=\"mostrarToolKit(document.getElementById('p" + entry.getKey() + "'),2)\" "
                        + "onmouseout=\"ocultarToolKit(document.getElementById('p" + entry.getKey() + "'))\" ></i></div> "
                        + "<div style=\"left:85%;\" id=\"p" + entry.getKey() + "\" class=\"toolkit\" >"
                        + entry.getValue().getDescripcion()
                        + "</div>"
                        + "</td></tr>";

                opciones_preguntas += req_preguntas.equals(entry.getKey().toString()) ? "<option value='" + entry.getKey() + "' selected >" + entry.getKey() + " - " + entry.getValue().getShortDesc() + "</option>"
                        : "<option value='" + entry.getKey() + "' >" + entry.getKey() + " - " + entry.getValue().getShortDesc() + "</option>";
            }
            lblPreguntas += "</tbody></table>";
//        System.out.println("anexosBusqueda: "+anexosBusqueda);

            if (!err && !piloto.equals("")) {
              
             
             
                
                String qry_count = "select count(*) from head_encuesta h , encuesta e where h.callid_head = e.callid_encuesta "
                        + " and h.num_contraparte = e.contraparte_encuesta and fecha_registro_head >= ? and fecha_registro_head <= ? "
                        //+ " and num_agente = ? ";
                        + " and num_agente in (" + anexosBusqueda + ") ";
                String qry_paginado = "select count(*) AS registrosTotalPaginado from head_encuesta h , encuesta e where h.callid_head = e.callid_encuesta "
                        + " and h.num_contraparte = e.contraparte_encuesta and fecha_registro_head >= ? and fecha_registro_head <= ? "
                        //+ " and num_agente = ? ";
                        + " and num_agente in (" + anexosBusqueda + ") ";
            
               
                String qry_tbl = "select h.id_head, h.callid_head, h.num_agente, h.num_contraparte, e.pregunta_encuesta, e.respuesta_encuesta , "
                        + " to_char(h.fecha_registro_head,'YYYY-MM-DD HH24:MI') as fecha , h.fecha_registro_head from head_encuesta h , encuesta e "
                        + " where h.callid_head = e.callid_encuesta and h.num_contraparte = e.contraparte_encuesta and fecha_registro_head >= ? "
                        + " and fecha_registro_head <= ? "
                        //+ " and num_agente = ? "
                        + " and num_agente in (" + anexosBusqueda + ") ";
                if (!req_preguntas.equals("-1") && !req_preguntas.equals("")) {
                    qry_count += " and pregunta_encuesta = " + req_preguntas ;
                    qry_paginado += " and pregunta_encuesta = " + req_preguntas ;
                    qry_tbl += " and pregunta_encuesta = " + req_preguntas ;
                }
                qry_tbl += " order by fecha_registro_head ";
                //+ 

                try {
                    con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
                    //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
                    try {
                        ps = con.prepareStatement(qry_count);
                        ps.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                        ps.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                        //ps.setString(3, anexo);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            total_reg = rs.getInt(1);
                        }
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                        System.out.println("Error en count encuestaIVR: " + e);
                        System.out.println("qry: " + qry_count);
                    }

                    ps_barra = con.prepareStatement(qry_paginado);
                    ps_barra.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                    ps_barra.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                    //ps_barra.setString(3, anexo);

                    Paginado3 paginado = new Paginado3(ps_barra, registrosMostrar, pg);
                    paginado.setMaximoTamanoBarra(10);
                    salida_paginado = paginado.getBarraPaginado2("encuestaIvr.jsp", variablesGet);

                    //System.out.println("barra_pag: "+salida_paginado);
                    ps1 = con.prepareStatement(qry_tbl + " limit " + registrosMostrar + " offset " + ((pg - 1) * registrosMostrar));
                    ps1.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                    ps1.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                    //ps1.setString(3, anexo);
                    //System.out.println("consulta tabla: "+ps1.toString());
                    rs1 = ps1.executeQuery();
                    while (rs1.next()) {
                        data_encuesta += "<tr>";
                        data_encuesta += "<td>" + rs1.getInt("id_head") + "</td>";
                        String num_agente = rs1.getString("num_agente") != null ? rs1.getString("num_agente").trim() : "";
                        String contr = rs1.getString("num_contraparte") != null ? rs1.getString("num_contraparte").trim() : "";
                        data_encuesta += "<td>" + num_agente + "</td>";
                        data_encuesta += "<td>" + contr + "</td>";
                        data_encuesta += "<td>"
                                + mapaPreguntas.get(rs1.getInt("pregunta_encuesta")).getShortDesc()
                                + "</td>";
                        data_encuesta += "<td>" + rs1.getInt("respuesta_encuesta") + "</td>";
                        String fecha = rs1.getString("fecha") != null ? rs1.getString("fecha").trim() : "";
                        data_encuesta += "<td>" + fecha + "</td>";
                        data_encuesta += "</tr>";
                    }

                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                    System.out.println("Error en encuestaIvr.jsp: " + e);
                    System.out.println("qry: " + e);
                } finally {
                   
                }
            }
          
            String comboPiloto = "";
            try {
                con2 = SQLConexion.conectar();
                comboPiloto = ComboQuery.comboPiloto(con2, request.getParameter("piloto") == null ? "" : request.getParameter("piloto"), user, sesionActual);
            } catch (Exception e) {
                out.println("ErrorPiloto: " + e.getMessage());
            } finally {
                try {
                  
                } catch (Exception e) {
                    out.print("Error SQL: " + e.getMessage());
                }
            }

            String ruta = getServletConfig().getServletContext().getRealPath("");
            String t_contenido = Plantillas.leer(ruta + "/plantillas/encuestaIvr.html");
            String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
            String t_javascript = Plantillas.leer(ruta + "/js/encuesta.js");

            String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);

            t_menu = Plantillas.reemplazar(t_menu, "%class_hab%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_disp%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_grab%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_agente%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_camp%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_enc%", "botonesactive");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ges%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
            t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

            t_contenido = Plantillas.reemplazar(t_contenido, "%desde%", desde);
            t_contenido = Plantillas.reemplazar(t_contenido, "%hasta%", hasta);
            t_contenido = Plantillas.reemplazar(t_contenido, "%fechaDesde%", msgs.getString("reckall.fecha.desde"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%fechaHasta%", msgs.getString("reckall.fecha.hasta"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
            t_contenido = Plantillas.reemplazar(t_contenido, "%total%", total_reg + "");
            t_contenido = Plantillas.reemplazar(t_contenido, "%error%", error);
            t_contenido = Plantillas.reemplazar(t_contenido, "%data_encuesta%", data_encuesta);
            t_contenido = Plantillas.reemplazar(t_contenido, "%paginado%", salida_paginado);
            t_contenido = Plantillas.reemplazar(t_contenido, "%numeroRevisado%", msgs.getString("reckall.numero.revisado"));

            t_contenido = Plantillas.reemplazar(t_contenido, "%numpiloto%", msgs.getString("reckall.piloto"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%opcion_piloto%", comboPiloto);
            t_contenido = Plantillas.reemplazar(t_contenido, "%num%", anexo);
            t_contenido = Plantillas.reemplazar(t_contenido, "%tag_min%", msgs.getString("tag.encuesta.pag.minimo"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tag_max%", msgs.getString("tag.encuesta.pag.maximo"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%reg_min%", ivr.getMinEncuesta() + "");
            t_contenido = Plantillas.reemplazar(t_contenido, "%reg_max%", ivr.getMaxEncuesta() + "");
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_id%", msgs.getString("encuesta.tabla.id"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_anexo%", msgs.getString("encuesta.tabla.anexo"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_contr%", msgs.getString("encuesta.tabla.contr"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_pregunta%", msgs.getString("encuesta.tabla.preg"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_respuesta%", msgs.getString("encuesta.tabla.resp"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%tbl_fecha%", msgs.getString("encuesta.tabla.fecha"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%lbl_preguntas%", lblPreguntas);
            t_contenido = Plantillas.reemplazar(t_contenido, "%opcion_preguntas%", opciones_preguntas);
            t_contenido = Plantillas.reemplazar(t_contenido, "%num_preg%", msgs.getString("encusta.tbl2.preg"));
            t_contenido = Plantillas.reemplazar(t_contenido, "%valorGrafico%", dataGrafico);
            t_contenido = Plantillas.reemplazar(t_contenido, "%lblGraficos%", lblGrafico);
            if(esMultiple){
                t_contenido = Plantillas.reemplazar(t_contenido, "%datasets%", plantillaGraficoAcumulado);
            }
            else{
                t_contenido = Plantillas.reemplazar(t_contenido, "%datasets%", plantillaGrafico);
            }
            
            

            String tieneTitulos = ii.getTieneTitulos(msgs);
            if (tieneTitulos != "") {
                t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "<div id=\"titulo\"><h2>" + msgs.getString("menu.adm.txt.encuesta") + "</h2></div>");
            } else {
                t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "");
            }

            t_javascript = Plantillas.reemplazar(t_javascript, "%empty_data%", msgs.getString("ctiport.alerta.falta"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%empty_data2%", msgs.getString("ctiport.alerta.falta"));
            t_javascript = Plantillas.reemplazar(t_javascript, "%tag_fecha%", msgs.getString("encuesta.format.date"));

            t_maestra = Plantillas.reemplazar(t_maestra, "%menu%", t_menu);
            t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
            t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
            t_maestra = Plantillas.reemplazar(t_maestra, "%css%", "");

            out.println(t_maestra);
        } else {
            response.sendRedirect("index.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
//        response.sendRedirect("index.jsp");
    }
    finally{
        SQLConexion.cerrar(ps, rs);
        SQLConexion.cerrar(ps1, rs1);
        SQLConexion.cerrar(ps_barra, null);
        
        SQLConexion.cerrarConexion(con1);
        SQLConexion.cerrarConexion(con2);
        SQLConexion.cerrarConexion(con);
    }
%>