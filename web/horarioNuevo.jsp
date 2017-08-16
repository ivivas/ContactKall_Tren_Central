<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@page import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"
        import = "query.*"
        import = "DTO.*"%>
<% response.setHeader("Pragma","no-cache"); 
 response.setHeader("Cache-Control","no-cache"); 
 response.setDateHeader("Expires",0); 
 response.setDateHeader("max-age",0); 
 
    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    if(sesionActual.equalsIgnoreCase("adm_general")) {

        /****************** Variables Globales **************************/
        String error = "";
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";
        
        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        ComboQuery ii = new ComboQuery();
        /***************************************************************/

        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();

        DiaQuery diaQuery = new DiaQuery(conexion);
        Horario horario = null;
        horario = new Horario();
        ////////////////////////Lunes///////////////////////////////////
        Object objectLunes =horario.getListaDiasSemana().get("Lunes");
        Dia lunes = new Dia();
        if(objectLunes != null){
            lunes = (Dia)objectLunes;
        }
        String lunesDesde=lunes!= null ? lunes.getHoraMinima() : "";
        String lunesHasta=lunes!= null ? lunes.getHoraMaxima() : "";
        boolean lunesIsHabil = lunes!= null ? lunes.isHabil() : false;

        //////////////////////////////////Martes///////////////////////////////////////
        Object objectMartes =horario.getListaDiasSemana().get("Martes");
        Dia martes = new Dia();
        if(objectMartes != null){
             martes = (Dia)objectMartes;
        }
        String martesDesde=martes!= null ? martes.getHoraMinima() : "";
        String martesHasta=martes!= null ? martes.getHoraMaxima() : "";
        boolean martesIsHabil = martes!= null ? martes.isHabil() : false;

        //////////////////////////////////Miercoles///////////////////////////////////////
        Object objectMiercoles =horario.getListaDiasSemana().get("Miercoles");
        Dia miercoles = new Dia();
        if(objectMiercoles != null){
             miercoles = (Dia)objectMiercoles;
        }
        String miercolesDesde=miercoles!= null ? miercoles.getHoraMinima() : "";
        String miercolesHasta=miercoles!= null ? miercoles.getHoraMaxima() : "";
        boolean miercolesIsHabil =miercoles!= null ? miercoles.isHabil() : false;

        //////////////////////////////////Jueves///////////////////////////////////////
        Object objectJueves =horario.getListaDiasSemana().get("Jueves");
        Dia jueves = new Dia();
        if(objectJueves != null){
             jueves = (Dia)objectJueves;
        }
        String juevesDesde=jueves!= null ? jueves.getHoraMinima() : "";
        String juevesHasta=jueves!= null ? jueves.getHoraMaxima() : "";
        boolean juevesIsHabil = jueves!= null ? jueves.isHabil() : false;

         //////////////////////////////////Viernes///////////////////////////////////////
        Object objectViernes =horario.getListaDiasSemana().get("Viernes");
        Dia viernes = new Dia();
        if(objectViernes != null){
             viernes = (Dia)objectViernes;
        }
        String viernesDesde=viernes!= null ? viernes.getHoraMinima() : "";
        String viernesHasta=viernes!= null ? viernes.getHoraMaxima() : "";
        boolean viernesIsHabil =viernes!= null ? viernes.isHabil() : false;

         //////////////////////////////////Sabado///////////////////////////////////////
        Object objectSabado =horario.getListaDiasSemana().get("Sabado");
        Dia sabado = new Dia();
        if(objectSabado != null){
             sabado= (Dia)objectSabado;
        }
        String sabadoDesde=sabado!= null ? sabado.getHoraMinima() : "";
        String sabadoHasta=sabado!= null ? sabado.getHoraMaxima() : "";
        boolean sabadoIsHabil =sabado!= null ? sabado.isHabil() : false;

         //////////////////////////////////Domingo///////////////////////////////////////
        Object objectDomingo =horario.getListaDiasSemana().get("Domingo");
        Dia domingo = new Dia();
        if(objectDomingo != null){
             domingo = (Dia)objectDomingo;
        }

        String domingoDesde=domingo!= null ? domingo.getHoraMinima() : "";
        String domingoHasta=domingo!= null ? domingo.getHoraMaxima() : "";
        boolean domingoIsHabil =domingo!= null ? domingo.isHabil() : false;

        if (request.getParameter("nuevo_horario")!=null) {
            boolean isPredeterminado =request.getParameter("es_predefinido") != null ? true : false;
            horario.setPredeterminado(isPredeterminado);
            String nombreHorario = request.getParameter("nombre_horario");
            horario.setNombre(nombreHorario.trim());

            ////////////////////////Lunes///////////////////////////////////
            List listaDias= new ArrayList();
            lunes.setNombreDia("Lunes");
            lunesDesde=request.getParameter("Lunes_desde")!=null ? request.getParameter("Lunes_desde") : "";
            lunesHasta=request.getParameter("Lunes_hasta")!=null ? request.getParameter("Lunes_hasta") : "";
            lunesIsHabil = request.getParameter("Lunes_valido") != null ? true : false;
            lunes.setHoraMinima(lunesDesde);
            lunes.setHoraMaxima(lunesHasta);
            lunes.setHabil(lunesIsHabil);
            //////////////////////////////////Martes///////////////////////////////////////
            martes.setNombreDia("Martes");
            martesDesde=request.getParameter("Martes_desde")!=null ? request.getParameter("Martes_desde") : "";
            martesHasta=request.getParameter("Martes_hasta")!=null ? request.getParameter("Martes_hasta") : "";
            martesIsHabil = request.getParameter("Martes_valido") != null ? true : false;
            martes.setHoraMinima(martesDesde);
            martes.setHoraMaxima(martesHasta);
            martes.setHabil(martesIsHabil);
            //////////////////////////////////Miercoles///////////////////////////////////////
            miercoles.setNombreDia("Miercoles");
            miercolesDesde=request.getParameter("Miercoles_desde")!=null ? request.getParameter("Miercoles_desde") : "";
            miercolesHasta=request.getParameter("Miercoles_hasta")!=null ? request.getParameter("Miercoles_hasta") : "";
            miercolesIsHabil = request.getParameter("Miercoles_valido") != null ? true : false;
            miercoles.setHoraMinima(miercolesDesde);
            miercoles.setHoraMaxima(miercolesHasta);
            miercoles.setHabil(miercolesIsHabil);
            //////////////////////////////////Jueves///////////////////////////////////////
            jueves.setNombreDia("Jueves");
            juevesDesde=request.getParameter("Jueves_desde")!=null ? request.getParameter("Jueves_desde") : "";
            juevesHasta=request.getParameter("Jueves_hasta")!=null ? request.getParameter("Jueves_hasta") : "";
            juevesIsHabil = request.getParameter("Jueves_valido") != null ? true : false;
            jueves.setHoraMinima(juevesDesde);
            jueves.setHoraMaxima(juevesHasta);
            jueves.setHabil(juevesIsHabil);
            //////////////////////////////////Viernes///////////////////////////////////////
            viernes.setNombreDia("Viernes");
            viernesDesde=request.getParameter("Viernes_desde")!=null ? request.getParameter("Viernes_desde") : "";
            viernesHasta=request.getParameter("Viernes_hasta")!=null ? request.getParameter("Viernes_hasta") : "";
            viernesIsHabil = request.getParameter("Viernes_valido") != null ? true : false;
            viernes.setHoraMinima(viernesDesde);
            viernes.setHoraMaxima(viernesHasta);
            viernes.setHabil(viernesIsHabil);
            //////////////////////////////////Sabado///////////////////////////////////////
            sabado.setNombreDia("Sabado");
            sabadoDesde=request.getParameter("Sabado_desde")!=null ? request.getParameter("Sabado_desde") : "";
            sabadoHasta=request.getParameter("Sabado_hasta")!=null ? request.getParameter("Sabado_hasta") : "";
            sabadoIsHabil = request.getParameter("Sabado_valido") != null ? true : false;
            sabado.setHoraMinima(sabadoDesde);
            sabado.setHoraMaxima(sabadoHasta);
            sabado.setHabil(sabadoIsHabil);
            //////////////////////////////////Domingo///////////////////////////////////////
            domingo.setNombreDia("Domingo");
            domingoDesde=request.getParameter("Domingo_desde")!=null ? request.getParameter("Domingo_desde") : "";
            domingoHasta=request.getParameter("Domingo_hasta")!=null ? request.getParameter("Domingo_hasta") : "";
            domingoIsHabil = request.getParameter("Domingo_valido") != null ? true : false;
            domingo.setHoraMinima(domingoDesde);
            domingo.setHoraMaxima(domingoHasta);
            domingo.setHabil(domingoIsHabil);
            listaDias.add(lunes);
            listaDias.add(martes);
            listaDias.add(miercoles);
            listaDias.add(jueves);
            listaDias.add(viernes);
            listaDias.add(sabado);
            listaDias.add(domingo);
            String mensajeErrorFormato = msgs.getString("error.format");

            if(!horario.getNombre().trim().equalsIgnoreCase("")){
                if(diaQuery.comprobarSiExisteNombreHorario(horario.getNombre())==false){
                    if(diaQuery.insertarHorario(horario,listaDias)){
                        out.println("<script>alert('"+msgs.getString("error.msgs.regok")+"');</script>");
                        response.sendRedirect("horarioModificarGeneral.jsp");
                    }else{
                        out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    }
                }else{
                    out.println("<script>alert('"+msgs.getString("error.msg.nomdif")+"');</script>");
                }
            }else{
                out.println("<script>alert('"+msgs.getString("error.data.inc")+"');</script>");
            }
        } 
        st.close();
        conexion.close();

        /******************************** Plantilla **************************************/
        error = (error == "") ? ("") : ("<center><div class=\"divError\">ERROR : " + error + "</div></center>");
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/horarioNuevo.html");
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.horario%</h2>" +
                        "</div>";
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.horario%", msgs.getString("menu.adm.txt.horario") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%horarioNombreToolkit%", msgs.getString("horario.nombre.toolkit"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%horarioPredToolkit%", msgs.getString("msg.horario.default"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_desde%", ""+lunesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_hasta%", ""+lunesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_valido%", lunesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_desde%", ""+martesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_hasta%", ""+martesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_valido%", martesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_desde%", ""+miercolesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_hasta%", ""+miercolesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_valido%", miercolesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_desde%", ""+juevesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_hasta%", ""+juevesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_valido%", juevesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_desde%", ""+viernesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_hasta%", ""+viernesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_valido%", viernesIsHabil==true? "checked" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_desde%", ""+sabadoDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_hasta%", ""+sabadoHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_valido%", sabadoIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_desde%", ""+domingoDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_hasta%", ""+domingoHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_valido%", domingoIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%nombre_horario%", ""+horario.getNombre());
        t_contenido = Plantillas.reemplazar(t_contenido,"%es_predefinido%",  horario.isPredeterminado()==true? "checked=\"checked\"" :"");
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_name%", msgs.getString("horario.new.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_def%", msgs.getString("horario.new.def"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_day%", msgs.getString("horario.new.tbl.day"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_from%", msgs.getString("horario.new.tbl.from"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_to%", msgs.getString("horario.new.tbl.to"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_tbl_val%", msgs.getString("horario.new.tbl.val"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_mon%", msgs.getString("horario.week.mon"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_tue%", msgs.getString("horario.week.tue"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_wed%", msgs.getString("horario.week.wed"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_thu%", msgs.getString("horario.week.thu"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_fri%", msgs.getString("horario.week.fri"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_sat%", msgs.getString("horario.week.sat"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_day_sun%", msgs.getString("horario.week.sun"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_btn_save%", msgs.getString("horario.new.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hornew_btn_cancel%", msgs.getString("horario.new.btn.cancel"));

        String t_javascript = Plantillas.leer(ruta + "/js/extension.js");
        
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del1%", msgs.getString("error.msgs.principal.nodata"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del1%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_nodata%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc1%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc2%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc3%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_err_datainc4%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_nodata_del2%", msgs.getString("error.msgs.principal.nodata"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%js_conf_del2%", msgs.getString("error.msgs.principal.confdel"));
        t_javascript = Plantillas.reemplazar(t_javascript,"%ncheckbox%","0");
        
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
        
        t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_monitor%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_cti%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_horario%","botonesactive");
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

    }else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }
%>

