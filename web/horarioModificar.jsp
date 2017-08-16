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
        int idExtension = 0;
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
        try {
            idExtension = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            //Redirecciono ya que el id anexo no es numerico
            out.println("error 1 :"+e.toString());
            response.sendRedirect("virtualRegistro.jsp");
        }

        Connection conexion = SQLConexion.conectar();
        Statement st = conexion.createStatement();

        String requestTrim_extensionNumero = (request.getParameter("virtual_numero")!=null) ? (request.getParameter("virtual_numero").trim()) : ("");

        DiaQuery diaQuery = new DiaQuery(conexion);
         
        String seleccionarHorario = request.getParameter("seleccionar_horario");
         
        Horario horario = null;
        if(seleccionarHorario != null  ){
            idHorario = request.getParameter("opciones_horarios");
            //out.println("horario id :: " + idHorario);
            id = Integer.parseInt(idHorario);
            horario = diaQuery.getHorarioXIdHorario(id);
            //out.println("id del horario 1 " + horario.getId());
        }else if(request.getParameter("modificar_horario") != null  ){
            idHorario = request.getParameter("id_horario");
            //out.println("horario id :: " + idHorario);
            id = Integer.parseInt(idHorario);
            horario = diaQuery.getHorarioXIdHorario(id);
            //out.println("id del horario 1 " + horario.getId());
        }else{
            horario = diaQuery.getHorarioXIdPiloto(idExtension);
        }
        //out.println("id del horario 2 " + horario.getId());
        /////////////////////Llenar combo de horarios/////////////////////////////////////////////////

        String opcionesHorarios = "";

        List listaHorarios =  diaQuery.getTodosLosHorarios();
        String selected = "";
        for(int i = 0 ; i < listaHorarios.size() ; i ++){
            Horario aux = (Horario)listaHorarios.get(i);
         
            if(horario.getId()==aux.getId()){
                idHorario = horario.getId()+"";
                selected = "selected=\"selected\"";
            }else{
                selected="";
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
            String mensajeErrorFormato = "Los datos deben ser ingresados con el formato correcto. Formato : HH:mm , Ejemplo 22:30";
            ////////////////////////Lunes///////////////////////////////////
            boolean err = false;

            idHorario = request.getParameter("id_horario");

            id = Integer.parseInt(idHorario);
            horario = diaQuery.getHorarioXIdHorario(id);
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

            try{
                //int auxId = Integer.parseInt(idHorarioGrabar);
                if(err==false){
                    PreparedStatement pst = conexion.prepareStatement("UPDATE pilotos SET id_horarios=? WHERE id=?;");
                    //out.println("id_horarios = " + horario.getId() + " , idPiloto = " + idExtension );
                    pst.setInt(1,horario.getId() );
                    pst.setInt(2, idExtension);
                    pst.executeUpdate();
                    pst.close();
                    //out.println("Se ha grabado");
                    out.println("<script>alert('Los datos se han ingresado correctamente');</script>");
                }
            }
            catch(Exception ex){

            }

     
        }
        try {

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

                if (erroresEncontrados==false) {
                    PreparedStatement pst = conexion.prepareStatement("UPDATE pilotos SET piloto=?, descripcion = ?, anexo_rebalse = ? WHERE id=?;");
                    try {
                        PreparedStatement pst2 = conexion.prepareStatement("SELECT * from pilotos WHERE id=?;");
                        pst2.setInt(1, idExtension);
                        ResultSet rsPilotoAnterior = pst2.executeQuery();
                        rsPilotoAnterior.next();
                        String pilotoAnterior = rsPilotoAnterior.getString("piloto");

                        pst2.close();
                        pst.setString(1, requestTrim_extensionNumero);
                        pst.setString(2, requestTrim_extensionNombre);
                        pst.setString(3, requestTrim_extensionPickup);
                        pst.setInt(4, idExtension);
                        pst.execute();
                        PreparedStatement pst3 = conexion.prepareStatement("UPDATE secretaria SET piloto_asociado = ? WHERE piloto_asociado=?;");

                        pst3.setString(1,requestTrim_extensionNumero );
                        pst3.setString(2, pilotoAnterior);
                        pst3.execute();

                        response.sendRedirect("virtualRegistro.jsp?pg=" + pgAnterior);
                    } catch (Exception e) {
                        error = e.toString();
                        System.out.println("error ::: " ); e.printStackTrace();
                    }
                    pst.close();
                }
            }
            
            /***************** VERIFICAMOS QUE EL ANEXO EXISTA Y RECUPERAMOS DATOS ******************/
            ResultSet rsAnexo = st.executeQuery("SELECT * FROM pilotos WHERE id=" + idExtension);
            if (rsAnexo.next()) {
                virtualNumero= rsAnexo.getString("piloto").trim();
                virtualDescripcion = rsAnexo.getString("descripcion")!=null ? rsAnexo.getString("descripcion").trim() : "";
                virtualPickup = rsAnexo.getString("anexo_rebalse")!=null ? rsAnexo.getString("anexo_rebalse").trim() : "";
            } else {
                response.sendRedirect("virtualRegistro.jsp");
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
        String t_contenido = Plantillas.leer(ruta + "/plantillas/horarioModificar.html");
        t_contenido = Plantillas.reemplazar(t_contenido,"%error_jsp%",error);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualNumero%",virtualNumero);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualDescripcion%",virtualDescripcion);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualPickup%",virtualPickup);
        t_contenido = Plantillas.reemplazar(t_contenido,"%id%", String.valueOf(idExtension).toString());
        t_contenido = Plantillas.reemplazar(t_contenido,"%pg%", pgAnterior);
        t_contenido = Plantillas.reemplazar(t_contenido,"%virtualHorario%", String.valueOf(idExtension).toString());
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

}
else {
    out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
}
%>

