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
        String virtualNumero = "";
        String virtualDescripcion = "";
        String virtualPickup = "";
        String pgAnterior = (request.getParameter("pg")!=null) ? request.getParameter("pg") : "";
        String idHorario="";

        int id=0;
        
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

        String nombreHorario="";

        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();
        
        String requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");

        DiaQuery diaQuery = new DiaQuery(conexion);
        String botonBorrar="";
        String seleccionarHorario = request.getParameter("seleccionar_horario");
         
        Horario horario = null;
        if(seleccionarHorario != null  ){
            idHorario = request.getParameter("opciones_horarios");
            id = Integer.parseInt(idHorario);
            horario = diaQuery.getHorarioXIdHorario(id);
            int idHorarioABorrar = id;

            if(diaQuery.getIdHorarioPredeterminado()!=idHorarioABorrar){
                //botonBorrar = "<input type=\"button\" value=\""+msgs.getString("horario.reg.btn.del")+"\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\"/>";
                botonBorrar = "<a href=\"#\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\" class=\"botones btnadddel\">"+msgs.getString("horario.reg.btn.del")+"</a>";
                        //"<input type=\"button\" value=\""+"\" />";
            }
        }
        
        if(request.getParameter("modificar_horario") != null  ){
            idHorario = request.getParameter("id_horario");
            id = Integer.parseInt(idHorario);
            horario = diaQuery.getHorarioXIdHorario(id);
        }
      
        /////////////////////Llenar combo de horarios/////////////////////////////////////////////////

        String opcionesHorarios = "";

        List listaHorarios =  diaQuery.getTodosLosHorarios();
        String selected = "";
        for(int i = 0 ; i < listaHorarios.size() ; i ++){
            Horario aux = (Horario)listaHorarios.get(i);
            selected="";
            if(i==0 && seleccionarHorario == null && request.getParameter("modificar_horario") == null ){
                idHorario=aux.getId()+"";
                int idHorarioABorrar = aux.getId();
                  
                if(diaQuery.getIdHorarioPredeterminado()!=idHorarioABorrar){
                    //botonBorrar = "<input type=\"button\" value=\""+msgs.getString("horario.reg.btn.del")+"\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\"/>";
                    botonBorrar = "<a href=\"#\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\" class=\"botones btnadddel\">"+msgs.getString("horario.reg.btn.del")+"</a>";
                }
                id = Integer.parseInt(idHorario);
                horario = diaQuery.getHorarioXIdHorario(id);
        
                selected="selected=\"selected\"";
            }else if(horario != null && horario.getId()==aux.getId()){
                idHorario=aux.getId()+"";
                id = Integer.parseInt(idHorario);  
                selected="selected=\"selected\"";
            }
            opcionesHorarios += "<option id = " +aux.getId()+ " value= " +aux.getId()+ " "+selected+" >"+aux.getNombre()+"</option>";
        }
        ////////////////////////Lunes///////////////////////////////////
        Object objectLunes =horario.getListaDiasSemana().get("Lunes");
        Dia lunes = null;
        if(objectLunes != null){
             lunes = (Dia)objectLunes;
        }
        String lunesDesde=lunes!= null ? lunes.getHoraMinima() : "";
        String lunesHasta=lunes!= null ? lunes.getHoraMaxima() : "";
        boolean lunesIsHabil = lunes!= null ? lunes.isHabil() : false;

        //////////////////////////////////Martes///////////////////////////////////////
        Object objectMartes =horario.getListaDiasSemana().get("Martes");
        Dia martes = null;
        if(objectMartes != null){
            martes = (Dia)objectMartes;
        }
        String martesDesde=martes!= null ? martes.getHoraMinima() : "";
        String martesHasta=martes!= null ? martes.getHoraMaxima() : "";
        boolean martesIsHabil = martes!= null ? martes.isHabil() : false;

        //////////////////////////////////Miercoles///////////////////////////////////////
        Object objectMiercoles =horario.getListaDiasSemana().get("Miercoles");
        Dia miercoles = null;
        if(objectMiercoles != null){
             miercoles = (Dia)objectMiercoles;
        }
        String miercolesDesde=miercoles!= null ? miercoles.getHoraMinima() : "";
        String miercolesHasta=miercoles!= null ? miercoles.getHoraMaxima() : "";
        boolean miercolesIsHabil =miercoles!= null ? miercoles.isHabil() : false;

        //////////////////////////////////Jueves///////////////////////////////////////
        Object objectJueves =horario.getListaDiasSemana().get("Jueves");
        Dia jueves = null;
        if(objectJueves != null){
             jueves = (Dia)objectJueves;
        }
        String juevesDesde=jueves!= null ? jueves.getHoraMinima() : "";
        String juevesHasta=jueves!= null ? jueves.getHoraMaxima() : "";
        boolean juevesIsHabil = jueves!= null ? jueves.isHabil() : false;

         //////////////////////////////////Viernes///////////////////////////////////////
        Object objectViernes =horario.getListaDiasSemana().get("Viernes");
        Dia viernes = null;
        if(objectViernes != null){
             viernes = (Dia)objectViernes;
        }
        String viernesDesde=viernes!= null ? viernes.getHoraMinima() : "";
        String viernesHasta=viernes!= null ? viernes.getHoraMaxima() : "";
        boolean viernesIsHabil =viernes!= null ? viernes.isHabil() : false;

         //////////////////////////////////Sabado///////////////////////////////////////
        Object objectSabado =horario.getListaDiasSemana().get("Sabado");
        Dia sabado = null;
        if(objectSabado != null){
            sabado= (Dia)objectSabado;
        }
        String sabadoDesde=sabado!= null ? sabado.getHoraMinima() : "";
        String sabadoHasta=sabado!= null ? sabado.getHoraMaxima() : "";
        boolean sabadoIsHabil =sabado!= null ? sabado.isHabil() : false;

         //////////////////////////////////Domingo///////////////////////////////////////
        Object objectDomingo =horario.getListaDiasSemana().get("Domingo");
        Dia domingo = null;
        if(objectDomingo != null){
            domingo = (Dia)objectDomingo;
        }

        String domingoDesde=domingo!= null ? domingo.getHoraMinima() : "";
        String domingoHasta=domingo!= null ? domingo.getHoraMaxima() : "";
        boolean domingoIsHabil =domingo!= null ? domingo.isHabil() : false;

        if (request.getParameter("modificar_horario")!=null) {
            nombreHorario = request.getParameter("nombre_horario_grabar");

            if(nombreHorario != null && nombreHorario.equalsIgnoreCase("")){
                nombreHorario = nombreHorario != null ? nombreHorario : request.getParameter("nombre_horario");
            }
            if((!nombreHorario.trim().equalsIgnoreCase("") && nombreHorario.equalsIgnoreCase(horario.getNombre())) || (!nombreHorario.trim().equalsIgnoreCase("") && diaQuery.comprobarSiExisteNombreHorario(nombreHorario.trim())==false) ){
                String mensajeErrorFormato = msgs.getString("error.format");
                ////////////////////////Lunes///////////////////////////////////
                boolean err = false;
                idHorario = request.getParameter("id_horario");

                id = Integer.parseInt(idHorario);
                horario = diaQuery.getHorarioXIdHorario(id);
                horario.setNombre(nombreHorario);
                lunesDesde=request.getParameter("Lunes_desde")!=null ? request.getParameter("Lunes_desde") : "";
                lunesHasta=request.getParameter("Lunes_hasta")!=null ? request.getParameter("Lunes_hasta") : "";
                lunesIsHabil = request.getParameter("Lunes_valido") != null ? true : false;
                lunes.setHoraMinima(lunesDesde);
                lunes.setHoraMaxima(lunesHasta);
                lunes.setHabil(lunesIsHabil);
                if(diaQuery.modificarDia(lunes)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Martes///////////////////////////////////////

                martesDesde=request.getParameter("Martes_desde")!=null ? request.getParameter("Martes_desde") : "";
                martesHasta=request.getParameter("Martes_hasta")!=null ? request.getParameter("Martes_hasta") : "";
                martesIsHabil = request.getParameter("Martes_valido") != null ? true : false;
                martes.setHoraMinima(martesDesde);
                martes.setHoraMaxima(martesHasta);
                martes.setHabil(martesIsHabil);
                if(diaQuery.modificarDia(martes)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Miercoles///////////////////////////////////////
                miercolesDesde=request.getParameter("Miercoles_desde")!=null ? request.getParameter("Miercoles_desde") : "";
                miercolesHasta=request.getParameter("Miercoles_hasta")!=null ? request.getParameter("Miercoles_hasta") : "";
                miercolesIsHabil = request.getParameter("Miercoles_valido") != null ? true : false;
                miercoles.setHoraMinima(miercolesDesde);
                miercoles.setHoraMaxima(miercolesHasta);
                miercoles.setHabil(miercolesIsHabil);
                if(diaQuery.modificarDia(miercoles)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Jueves///////////////////////////////////////
                juevesDesde=request.getParameter("Jueves_desde")!=null ? request.getParameter("Jueves_desde") : "";
                juevesHasta=request.getParameter("Jueves_hasta")!=null ? request.getParameter("Jueves_hasta") : "";
                juevesIsHabil = request.getParameter("Jueves_valido") != null ? true : false;
                jueves.setHoraMinima(juevesDesde);
                jueves.setHoraMaxima(juevesHasta);
                jueves.setHabil(juevesIsHabil);
                if(diaQuery.modificarDia(jueves)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Viernes///////////////////////////////////////
                viernesDesde=request.getParameter("Viernes_desde")!=null ? request.getParameter("Viernes_desde") : "";
                viernesHasta=request.getParameter("Viernes_hasta")!=null ? request.getParameter("Viernes_hasta") : "";
                viernesIsHabil = request.getParameter("Viernes_valido") != null ? true : false;
                viernes.setHoraMinima(viernesDesde);
                viernes.setHoraMaxima(viernesHasta);
                viernes.setHabil(viernesIsHabil);
                if(diaQuery.modificarDia(viernes)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Sabado///////////////////////////////////////
                sabadoDesde=request.getParameter("Sabado_desde")!=null ? request.getParameter("Sabado_desde") : "";
                sabadoHasta=request.getParameter("Sabado_hasta")!=null ? request.getParameter("Sabado_hasta") : "";
                sabadoIsHabil = request.getParameter("Sabado_valido") != null ? true : false;
                sabado.setHoraMinima(sabadoDesde);
                sabado.setHoraMaxima(sabadoHasta);
                sabado.setHabil(sabadoIsHabil);
                if(diaQuery.modificarDia(sabado)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                //////////////////////////////////Domingo///////////////////////////////////////
                domingoDesde=request.getParameter("Domingo_desde")!=null ? request.getParameter("Domingo_desde") : "";
                domingoHasta=request.getParameter("Domingo_hasta")!=null ? request.getParameter("Domingo_hasta") : "";
                domingoIsHabil = request.getParameter("Domingo_valido") != null ? true : false;
                domingo.setHoraMinima(domingoDesde);
                domingo.setHoraMaxima(domingoHasta);
                domingo.setHabil(domingoIsHabil);
                if(diaQuery.modificarDia(domingo)==false && err == false){
                    out.println("<script>alert('"+mensajeErrorFormato+"');</script>");
                    err = true;
                }
                /////////////////////////////////////////////////////////////
                int idHorarioABorrar = Integer.parseInt(request.getParameter("id_horario"));
                if(diaQuery.getIdHorarioPredeterminado()!=idHorarioABorrar){
                    //botonBorrar = "<input type=\"button\" value=\""+msgs.getString("horario.reg.btn.del")+"\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\"/>";
                    botonBorrar = "<a href=\"#\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\" class=\"botones btnadddel\">"+msgs.getString("horario.reg.btn.del")+"</a>";
                }
                try{
                    boolean esPredefinido = request.getParameter("es_predefinido")!= null ? true :false;
                    horario.setPredeterminado(esPredefinido);
                
                    if(err==false && diaQuery.modificarHorario(horario)){
                        out.println("<script>alert('"+msgs.getString("error.msgs.regok")+"');</script>");
                    }
                }
                catch(Exception ex){
                }
                opcionesHorarios="";
                listaHorarios =  diaQuery.getTodosLosHorarios();

                for(int i = 0 ; i < listaHorarios.size() ; i ++){
                    Horario aux = (Horario)listaHorarios.get(i);
                    selected="";
                    if(i==0 && seleccionarHorario == null && request.getParameter("modificar_horario") == null ){
                        idHorario=aux.getId()+"";
                        if(diaQuery.getIdHorarioPredeterminado()!=idHorarioABorrar){
                            //botonBorrar = "<input type=\"button\" value=\""+msgs.getString("horario.reg.btn.del")+"\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\"/>";
                            botonBorrar = "<a href=\"#\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\" class=\"botones btnadddel\">"+msgs.getString("horario.reg.btn.del")+"</a>";
                        }
                        id = Integer.parseInt(idHorario);
                        horario = diaQuery.getHorarioXIdHorario(id);
                        selected="selected=\"selected\"";
                    }else if(horario != null && horario.getId()==aux.getId()){
                        idHorario=aux.getId()+"";
                        id = Integer.parseInt(idHorario);
                        selected="selected=\"selected\"";
                    }
                    opcionesHorarios += "<option id = " +aux.getId()+ " value= " +aux.getId()+ " "+selected+" >"+aux.getNombre()+"</option>";
                }
            }else{
                out.println("<script>alert('"+msgs.getString("error.msg.nomdif")+"');</script>");
            }
        }
        if(request.getParameter("borrar_horario") != null){
            int idHorarioABorrar = Integer.parseInt(request.getParameter("id_horario"));
            if(diaQuery.getIdHorarioPredeterminado()==idHorarioABorrar){
                
            }else{
                Horario horarioABorrar = new Horario();
                horarioABorrar.setId(idHorarioABorrar);
                diaQuery.eliminarHorario(horarioABorrar);
                out.println("<script>alert('"+msgs.getString("error.msg.del")+"');</script>");
                opcionesHorarios="";
                listaHorarios =  diaQuery.getTodosLosHorarios();
                for(int i = 0 ; i < listaHorarios.size() ; i ++){
                    Horario aux = (Horario)listaHorarios.get(i);
                    selected="";
                    if(i==0 && seleccionarHorario == null && request.getParameter("modificar_horario") == null ){
                        idHorario=aux.getId()+"";
                        if(diaQuery.getIdHorarioPredeterminado()!=idHorarioABorrar){
                            //botonBorrar = "<input type=\"button\" value=\""+msgs.getString("horario.reg.btn.del")+"\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\"/>";
                            botonBorrar = "<a href=\"#\" onclick=\"javascript:document.adminForm_borrar_horario.submit()\" class=\"botones btnadddel\">"+msgs.getString("horario.reg.btn.del")+"</a>";
                        }
                        id = Integer.parseInt(idHorario);
                        horario = diaQuery.getHorarioXIdHorario(id);
                        selected="selected=\"selected\"";
                    }else if(horario != null && horario.getId()==aux.getId()){
                        idHorario=aux.getId()+"";
                        id = Integer.parseInt(idHorario);
                        selected="selected=\"selected\"";
                    }
                    opcionesHorarios += "<option id = " +aux.getId()+ " value= " +aux.getId()+ " "+selected+" >"+aux.getNombre()+"</option>";
                }
            }
        }
        try{
            /************************** VERIFICAR DATOS Y AGREGAR ANEXO ****************************/
            if (request.getParameter("modificar_virtual")!=null) {
                boolean erroresEncontrados = false;
                //String requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");
                String requestTrim_extensionNombre = (request.getParameter("virtual_descripcion")!=null) ? (request.getParameter("virtual_descripcion").trim()) : ("");
                String requestTrim_extensionPickup = (request.getParameter("virtual_pickup")!=null) ? (request.getParameter("virtual_pickup").trim()) : ("");
                if (requestTrim_extensionNumero.compareTo("")==0) {
                    erroresEncontrados = true;
                    error = msgs.getString("error.data.inc");
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
        String t_contenido = Plantillas.leer(ruta + "/plantillas/horarioModificarGeneral.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualNumero%",virtualNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDescripcion%",virtualDescripcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualPickup%",virtualPickup);
        
        
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.horario%</h2>" +
                        "</div>" ;
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.horario%", msgs.getString("menu.adm.txt.horario") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }

        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
                      
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_desde%", lunesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_hasta%", lunesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Lunes_valido%", lunesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_desde%", martesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_hasta%", martesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Martes_valido%", martesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_desde%", miercolesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_hasta%", miercolesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Miercoles_valido%", miercolesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_desde%", juevesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_hasta%", juevesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Jueves_valido%", juevesIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_desde%", viernesDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_hasta%", viernesHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Viernes_valido%", viernesIsHabil==true? "checked" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_desde%", sabadoDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_hasta%", sabadoHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Sabado_valido%", sabadoIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_desde%", domingoDesde);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_hasta%", domingoHasta);
        t_contenido = Plantillas.reemplazar(t_contenido,"%Domingo_valido%", domingoIsHabil==true? "checked=\"checked\"" :"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%opciones_horarios%", opcionesHorarios);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id_horario%", idHorario);
        t_contenido = Plantillas.reemplazar(t_contenido,"%nombre_horario%", horario.getNombre());
        t_contenido = Plantillas.reemplazar(t_contenido,"%es_predefinido%", horario.isPredeterminado() == true ? "checked=\"checked\"" : "");
        t_contenido = Plantillas.reemplazar(t_contenido,"%boton_borrar%", botonBorrar);
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_selhor%", msgs.getString("horario.reg.tbl.selc"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_name%", msgs.getString("horario.reg.tbl.name"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_def%", msgs.getString("horario.reg.tbl.def"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_day%", msgs.getString("horario.reg.tbl.day"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_from%", msgs.getString("horario.reg.tbl.from"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_to%", msgs.getString("horario.reg.tbl.to"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_tbl_val%", msgs.getString("horario.reg.tbl.val"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_mon%", msgs.getString("horario.week.mon"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_tue%", msgs.getString("horario.week.tue"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_wed%", msgs.getString("horario.week.wed"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_tur%", msgs.getString("horario.week.thu"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_fri%", msgs.getString("horario.week.fri"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_sat%", msgs.getString("horario.week.sat"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_day_sun%", msgs.getString("horario.week.sun"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_btn_save%", msgs.getString("horario.reg.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_btn_new%", msgs.getString("horario.reg.btn.new"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%hormod_btn_addexp%", msgs.getString("horario.reg.btn.addexp"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_check_def%", msgs.getString("msg.horario.default"));

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

