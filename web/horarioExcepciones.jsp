<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"
        import = "query.*"
        import = "DTO.*"
%>

<% response.setHeader("Pragma","no-cache"); %>
<% response.setHeader("Cache-Control","no-cache"); %>
<% response.setDateHeader("Expires",0); %>
<% response.setDateHeader("max-age",0); %>


<%
    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if(sesionActual.equalsIgnoreCase("adm_general")) {
        
        /****************** Variables Globales **************************/
        String error = "";
        String virtualNumero = "";
        String virtualDescripcion = "";
        String virtualPickup = "";
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";

        int id=0;
        
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        /***************************************************************/
        String nombreHorario="";
        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();

        String requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");

        DiaQuery diaQuery = new DiaQuery(conexion);
        String idHorario="";
        idHorario=request.getParameter("id_horario");

        DTO.Horario horario = diaQuery.getHorarioXIdHorario(Integer.parseInt(idHorario));
        List listaExcepciones = horario.getListaDiasExcepcionalmenteNoHabilesList();
        String registrosExcepciones ="";
        for(int i =0 ; i < listaExcepciones.size() ; i++){
            Dia aux = (Dia)listaExcepciones.get(i);
            registrosExcepciones += "<tr><td>"+(i+1)+"</td><td><input type=\"checkbox\" name=\"dias\" value=\""+aux.getId()+"\" id=\""+aux.getId()+"\"</td><td>"+aux.getFechaExcepcionalMenteNoHabil()+"</td></tr>";
        }

        String fechaExcepcion="";
        if(request.getParameter("agregar_excepcion_horario")!=null){
            String fecha = request.getParameter("fecha_excepcion");
            if( diaQuery.insertarFechaExcepcionalmenteNoHabil(horario.getId(), fecha.trim())){
            } else{
                out.print("<script>alert('Debe ingresar una fecha valida')</script>");
            }
            horario = diaQuery.getHorarioXIdHorario(Integer.parseInt(idHorario));
            listaExcepciones = horario.getListaDiasExcepcionalmenteNoHabilesList();
            registrosExcepciones ="";
            for(int i =0 ; i < listaExcepciones.size() ; i++){
                Dia aux = (Dia)listaExcepciones.get(i);
                registrosExcepciones += "<tr><td>"+(i+1)+"</td><td><input type=\"checkbox\" name=\"dias\" value=\""+aux.getId()+"\" id=\""+aux.getId()+"\"</td><td>"+aux.getFechaExcepcionalMenteNoHabil()+"</td></tr>";
            }
        }
        if(request.getParameter("eliminar_excepcion_horario")!=null){
            if(request.getParameter("dias")!=null){
                diaQuery.eliminarDiaXId(Integer.parseInt(request.getParameter("dias")));
            }
            horario = diaQuery.getHorarioXIdHorario(Integer.parseInt(idHorario));
            listaExcepciones = horario.getListaDiasExcepcionalmenteNoHabilesList();
            registrosExcepciones ="";
            for(int i =0 ; i < listaExcepciones.size() ; i++){
                Dia aux = (Dia)listaExcepciones.get(i);
                registrosExcepciones += "<tr><td>"+(i+1)+"</td><td><input type=\"checkbox\" name=\"dias\" value=\""+aux.getId()+"\" id=\""+aux.getId()+"\"</td><td>"+aux.getFechaExcepcionalMenteNoHabil()+"</td></tr>";
            }
        }
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/horarioExcepciones.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualNumero%",virtualNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDescripcion%",virtualDescripcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualPickup%",virtualPickup);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_ingr_date%",msgs.getString("horario.exepc.adddate"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_format%",msgs.getString("horario.exepc.format"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_btn_add%",msgs.getString("horario.exepc.btn.add"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_tbl_del%",msgs.getString("horario.exepc.del"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_tbl_dateexp%",msgs.getString("horario.exepc.date"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_btn_del%",msgs.getString("horario.exepc.btn.del"));

        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);     
        t_contenido = Plantillas.reemplazar(t_contenido,"%fecha_excepcion%", fechaExcepcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id_horario%", idHorario);
        t_contenido = Plantillas.reemplazar(t_contenido,"%registros_excepciones%", registrosExcepciones);
        t_contenido = Plantillas.reemplazar(t_contenido,"%horexp_btn_exit%", msgs.getString("menu.adm.txt.salir"));

        
        String t_javascript = Plantillas.leer(ruta + "/js/horario.js");
        
        t_javascript = Plantillas.reemplazar(t_javascript, "%msg_empty%", msgs.getString("msg.err.empty"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%msg_err_format%", msgs.getString("encuesta.format.date"));
        
        //String t_javascript = Plantillas.leer(ruta + "/js/extension.js");
        
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del1%", msgs.getString("error.msgs.principal.nodata"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del1%", msgs.getString("error.msgs.principal.confdel"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_nodata%", msgs.getString("error.msgs.principal.confdel"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc%", msgs.getString("error.data.inc"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc1%", msgs.getString("error.data.inc"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc2%", msgs.getString("error.data.inc"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc3%", msgs.getString("error.data.inc"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc4%", msgs.getString("error.data.inc"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del2%", msgs.getString("error.msgs.principal.nodata"));
        //t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del2%", msgs.getString("error.msgs.principal.confdel"));
        //t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%","0");
        
        //String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_cc_pop.html");
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%",t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "");

        out.println(t_maestra);
    }else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

