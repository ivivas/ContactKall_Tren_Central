<%@page import="BO.CargaMenu"%>
<%@page import="query.ComboQuery"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="BO.Horario"%>
<%@page import="DTO.Dia"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1" language="java"
        import="java.sql.*"
        import="java.util.Vector"
        import="java.util.List"
        import="java.util.ArrayList"
        import="adportas.*"%><%
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (!sesionActual.equalsIgnoreCase("adm_general") && !sesionActual.equalsIgnoreCase("adm_pool")
            && !sesionActual.equalsIgnoreCase("usuario") && !sesionActual.equalsIgnoreCase("supervisor") && !sesionActual.equalsIgnoreCase("ggee_asistencia") && !sesionActual.equalsIgnoreCase("ggee_secretaria")
            && !sesionActual.equalsIgnoreCase("cap") && !sesionActual.equalsIgnoreCase("imb_secretaria")
            && !sesionActual.equalsIgnoreCase("imb_asistencia")
            && !sesionActual.equalsIgnoreCase("pac_asistencia") && !sesionActual.equalsIgnoreCase("pac_secretaria")
            && !sesionActual.equalsIgnoreCase("may1") && !sesionActual.equalsIgnoreCase("may2") && !sesionActual.equalsIgnoreCase("may3") && !sesionActual.equalsIgnoreCase("may4")) {
        out.println("<script>");
        out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
        out.println("</script>");
        out.println("<body onload=\'regresar()\';>");
    } else {
        /*********************VARIABLES GLOBALES************************/
        HabilitadorSecretarias2 secretarias = new HabilitadorSecretarias2();
        String salidaTabla = "";
        String nombre = "";
        String centroCostoPlantilla = "";
        String extension = "";
        String piloto = "";
        String comboPilotos = "";
        String paginado = "";
        String guardar = "";
        int nsecretarias = 0;

        /********************************REQUEST************************/
        nsecretarias = request.getParameter("nsecretarias") != null ? Integer.parseInt(request.getParameter("nsecretarias")) : 0;

        /*try {
            id_centrocosto = request.getParameter("idCentroCosto") != null ? Integer.parseInt(request.getParameter("idCentroCosto")) : 1;
        } catch (Exception ex) {
            id_centrocosto = 1;
        }*/

        extension = request.getParameter("extension") != null ? request.getParameter("extension").trim() : "";
        nombre = request.getParameter("nombre") != null ? request.getParameter("nombre").trim() : "";
        piloto = request.getParameter("piloto") != null ? request.getParameter("piloto").trim() : "";
        //registrosPorPagina = request.getParameter("registrosPorPagina") != null ? request.getParameter("registrosPorPagina").trim() : "";
        guardar = request.getParameter("guardar") != null ? request.getParameter("guardar").trim() : "";

        ResourceBundle msgs;
        if(session.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }else{
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }

        //****************************CONEXION***************************/
        Connection conexion = SQLConexion.conectar();

        /********************************MODIFICAR***********************/
        if (guardar.equalsIgnoreCase("true")) {
            //System.out.println("guardar true");
            PreparedStatement   pstGuardarHistorico=null;
                     
            PreparedStatement pstGuardar = conexion.prepareStatement("UPDATE secretaria set estado = ?,motivo_de_deshabilitacion = ?,fecha_deshabilitacion= ? WHERE nombre = ? and estado != ?");

            for (int i = 0; i < nsecretarias; i++) {
                if (request.getParameter("radio" + String.valueOf(i)) != null) {

                    String valor = request.getParameter("radio" + String.valueOf(i));
                    String nombreX = valor.substring(valor.indexOf("&") + 1).trim();
                    String valor2=request.getParameter(nombreX);

                    String anexo=valor2.split("-")[0].trim();

                    int estado = Integer.parseInt(valor.substring(0, valor.indexOf("&")));
                    String motivoDeshabilitacion = "";
                    Timestamp fechaDeshabilitacion = null;
                    if (estado == 0) {
                        motivoDeshabilitacion = request.getParameter("motivo_deshabilitacion-" + nombreX);
                        java.util.Date d = new java.util.Date();
                        fechaDeshabilitacion = new Timestamp(d.getTime());
                    }
                    if(Horario.mapaDeLosHorarios.size()==0){
                        BO.Horario horario = new BO.Horario();
                    }
                    System.out.println("piloto: "+piloto);
                    DTO.Horario horarioDto = (DTO.Horario)Horario.mapaDeLosHorarios.get(piloto);
                    Dia dia = Horario.obtenerDia(horarioDto);
                    pstGuardar.setInt(1, estado);
                    pstGuardar.setString(2, motivoDeshabilitacion);
                    pstGuardar.setTimestamp(3, fechaDeshabilitacion);
                    pstGuardar.setString(4, nombreX);
                    pstGuardar.setInt(5, estado);
                    int retornoUpdate = pstGuardar.executeUpdate();
                    //System.out.println(pstGuardar.toString());
                    if (retornoUpdate == 1) {
                        String stringLugarAccion="";
                        if(estado==0){
                            stringLugarAccion="lugar_deshabilitacion";
                        }else{
                            stringLugarAccion="lugar_habilitacion";
                        }
                        String lugarAccionMasFechaHD="";
                        if(Horario.verificarDiaHabil(horarioDto)){
                         lugarAccionMasFechaHD = "portal_"+dia.getHoraMinima()+"_"+dia.getHoraMaxima()+"_"+"1" ;
                        }else{
                            lugarAccionMasFechaHD = "portal_"+dia.getHoraMinima()+"_"+dia.getHoraMaxima()+"_"+"0" ;
                        }
                        java.util.Date d = new java.util.Date();
                        fechaDeshabilitacion = new Timestamp(d.getTime());
                        pstGuardarHistorico = conexion.prepareStatement("INSERT INTO historico_estados (fecha,estado,motivo_de_deshabilitacion,anexo,nombre,"+stringLugarAccion+") VALUES(?,?,?,?,?,?)");

                        pstGuardarHistorico.setTimestamp(1, fechaDeshabilitacion);
                        pstGuardarHistorico.setInt(2, estado);
                        pstGuardarHistorico.setString(3, motivoDeshabilitacion);
                        pstGuardarHistorico.setString(4, anexo);
                        pstGuardarHistorico.setString(5, nombreX);
                        pstGuardarHistorico.setString(6, lugarAccionMasFechaHD);
                        pstGuardarHistorico.executeUpdate();
                    }
                }
            }
            pstGuardar.close();
            if(pstGuardarHistorico != null){
                pstGuardarHistorico.close();
            }
        }
        /***************************RESCATAR DATOS************************/
        ///////////llenar select CentroCosto////////////
        PreparedStatement pstPilotos = null;
        int idSesion=0;
        String tipoSesion = sesionActual;
        String usuario =(String) session.getAttribute("usuario");

        if(tipoSesion.equalsIgnoreCase("usuario")){
            pstPilotos =  conexion.prepareStatement("Select distinct(piloto_asociado) FROM secretaria,pilotos as p where p.piloto = piloto_asociado and p.id in(select id_piloto from pilotos_sesion where id_sesion = (select id from sesion where usuario = '"+usuario+"'))");
        }
        else if(tipoSesion.equalsIgnoreCase("adm_general")){
            pstPilotos = conexion.prepareStatement("Select distinct(piloto_asociado) FROM secretaria");
        }
        else{
            pstPilotos = conexion.prepareStatement("Select distinct(piloto_asociado) FROM secretaria");
        }
                
        ResultSet rsPiloto = pstPilotos.executeQuery();
        while (rsPiloto.next()) {
            if (rsPiloto.getString("piloto_asociado") == null) {
                continue;
            }
            if (piloto.equalsIgnoreCase("")) {
                if (Perfiles.numeroVirtual(sesionActual, rsPiloto.getString("piloto_asociado").trim())) {
                    comboPilotos += "<option selected>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                    piloto = rsPiloto.getString("piloto_asociado").trim();
                }
            } else if (rsPiloto.getString("piloto_asociado").trim().equalsIgnoreCase(piloto)) {
                if (Perfiles.numeroVirtual(sesionActual, rsPiloto.getString("piloto_asociado").trim())) {
                    comboPilotos += "<option selected>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                }

            } else {
                if (Perfiles.numeroVirtual(sesionActual, rsPiloto.getString("piloto_asociado").trim())) {
                    comboPilotos += "<option>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                }
            }
        }
        pstPilotos.close();
        rsPiloto.close();

        ////////////llenar la tabla secretarias//////////////
        PreparedStatement pst = conexion.prepareStatement("SELECT nombre,estado,anexo,motivo_de_deshabilitacion FROM secretaria WHERE anexo LIKE ? AND lower(nombre) LIKE lower(?) and piloto_asociado LIKE ? and estado!=2 ");
        pst.setString(1, extension + "%");
        pst.setString(2, nombre + "%");
        if (piloto.equalsIgnoreCase("")) {
            System.out.println("vacio");
            pst.setString(3, "xxxx");
        } else {
            pst.setString(3, piloto + "%");
        }
        ResultSet rs = pst.executeQuery();
        nsecretarias = 0;
        while (rs.next()) {
            salidaTabla += secretarias.agregarSecretaria(rs.getString("nombre"), rs.getString("anexo"), rs.getInt("estado"), String.valueOf(nsecretarias), rs.getString("motivo_de_deshabilitacion"));
            nsecretarias++;
        }

        conexion.close();
        /*********************PLANTILLAS************************/
        String ruta = getServletConfig().getServletContext().getRealPath("");
        //String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        
        //t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");
        
        String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
        t_menu = Plantillas.reemplazar(t_menu, "%class_hab%","botonesactive");
        t_menu = Plantillas.reemplazar(t_menu, "%class_disp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_grab%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_agente%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_camp%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%","botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_enc%","botones");

        String t_contenido = Plantillas.leer(ruta + "/plantillas/habilitador.html");
        t_contenido = Plantillas.reemplazar(t_contenido, "%nombre%", nombre);
        t_contenido = Plantillas.reemplazar(t_contenido, "%extension%", extension);
        t_contenido = Plantillas.reemplazar(t_contenido, "%combo_piloto%", comboPilotos);
        t_contenido = Plantillas.reemplazar(t_contenido, "%nsecretarias%", String.valueOf(nsecretarias));
        t_contenido = Plantillas.reemplazar(t_contenido, "%centroCostoPlantilla%", centroCostoPlantilla);
        t_contenido = Plantillas.reemplazar(t_contenido, "%salidaTabla%", salidaTabla);
        t_contenido = Plantillas.reemplazar(t_contenido, "%paginado%", paginado);

        t_contenido = Plantillas.reemplazar(t_contenido, "%habilt_tabla_title%", msgs.getString("habilit.tabla.title"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_tabla_name%", msgs.getString("habilit.tabla.name"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_tabla_extn%", msgs.getString("habilit.tabla.extn"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_btn_find%", msgs.getString("habilit.tabla.btn.serach"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%hablit_btn_save%", msgs.getString("habilit.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%menu%", ComboQuery.menu());                 
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu) ;
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "") ;
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

        out.println(t_maestra);
    }
%>