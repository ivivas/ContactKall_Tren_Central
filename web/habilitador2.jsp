<%@page import="query.SesionQuery"%>
<%@page import="DTO.Opcion"%>
<%@page import="DTO.Combo"%>
<%@page import="query.ComboQuery"%>
<%@page import="DTO.Dia"%>
<%@page import="BO.Horario"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="adportas.Perfiles"%>
<%@page import="BO.CargaMenu"%>
<%@page import="adportas.Plantillas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="adportas.HabilitadorSecretarias2"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equals("adm_general") | sesionActual.equals("supervisor")) {
        /**
         * *******************VARIABLES GLOBALES***********************
         */
        ComboQuery ii = new ComboQuery();
        String user = session.getAttribute("usuario").toString().trim();
        HabilitadorSecretarias2 secretarias = new HabilitadorSecretarias2();
        String salidaTabla = "";
        String nombre = "";
        String centroCostoPlantilla = "";
        String extension = "";
        String piloto = "";
        String comboPilotos = "";
        String paginado = "";
        String guardar = "";
        String combo_est_ag = "";
        String req_combo_est_ag;
        String comboDeshab = "";
        int nsecretarias = 0;

        nsecretarias = request.getParameter("nsecretarias") != null ? Integer.parseInt(request.getParameter("nsecretarias")) : 0;
        extension = request.getParameter("extension") != null ? request.getParameter("extension").trim() : "";
        nombre = request.getParameter("nombre") != null ? request.getParameter("nombre").trim() : "";
        piloto = request.getParameter("piloto") != null ? request.getParameter("piloto").trim() : "";
        guardar = request.getParameter("guardar") != null ? request.getParameter("guardar").trim() : "";
        req_combo_est_ag = request.getParameter("est_ag") != null ? request.getParameter("est_ag").trim() : "";

        ResourceBundle msgs;
        if (session.getAttribute("msgs") == null) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        } else {
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }

        Connection conexion = null;
        PreparedStatement pstPilotos = null;
        ResultSet rsPiloto = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conexion = SQLConexion.conectar();
            ComboQuery comboQuery = new ComboQuery(conexion);
            Combo combo = comboQuery.getComboXNombre("combo_deshabilitacion_anexos");

            comboDeshab += "<option value=\"\" >" + msgs.getString("opcion.desh.opt.def") + "</option>";
            for (Opcion opcion : combo.getListaOpciones()) {
                comboDeshab += "<option value=\"" + opcion.getValor() + "\" >" + opcion.getTexto() + "</option>";
            }

            if (guardar.equalsIgnoreCase("true")) {
                PreparedStatement pstGuardarHistorico = null;
                PreparedStatement pstGuardar = conexion.prepareStatement("UPDATE secretaria set estado = ?,motivo_de_deshabilitacion = ?,fecha_deshabilitacion= ? WHERE nombre = ? and estado != ?");
                for (int i = 0; i < nsecretarias; i++) {
                    try {
                        String valCombo = request.getParameter("estado_" + i);
                        String nombreX = request.getParameter("info_" + i);
                        String valor2 = request.getParameter(nombreX);
                        String anexo = valor2.split("-")[0].trim();
                        int estado = Integer.parseInt(valCombo);
                        String motivoDeshabilitacion = "";
                        Timestamp fechaDeshabilitacion = null;
                        if (estado == 0) {
                            motivoDeshabilitacion = request.getParameter("motivo_deshab") != null ? request.getParameter("motivo_deshab").trim() : "";
                            java.util.Date d = new java.util.Date();
                            fechaDeshabilitacion = new Timestamp(d.getTime());
                        }
                        if (Horario.mapaDeLosHorarios.size() == 0) {
                            BO.Horario horario = new BO.Horario();
                        }
                        DTO.Horario horarioDto = (DTO.Horario) Horario.mapaDeLosHorarios.get(piloto);
                        Dia dia = Horario.obtenerDia(horarioDto); 
                        pstGuardar.setInt(1, estado);
                        pstGuardar.setString(2, motivoDeshabilitacion);
                        pstGuardar.setTimestamp(3, fechaDeshabilitacion);
                        pstGuardar.setString(4, nombreX);
                        pstGuardar.setInt(5, estado);
                        int retornoUpdate = pstGuardar.executeUpdate();

                        if (retornoUpdate == 1) {
                            String stringLugarAccion = "";
                            if (estado == 0) {
                                stringLugarAccion = "lugar_deshabilitacion";
                            } else {
                                stringLugarAccion = "lugar_habilitacion";
                            }
                            String lugarAccionMasFechaHD = "";
                            if (Horario.verificarDiaHabil(horarioDto)) {
                                lugarAccionMasFechaHD = "portal_" + dia.getHoraMinima() + "_" + dia.getHoraMaxima() + "_" + "1";
                            } else {
                                lugarAccionMasFechaHD = "portal_" + dia.getHoraMinima() + "_" + dia.getHoraMaxima() + "_" + "0";
                            }
                            java.util.Date d = new java.util.Date();
                            fechaDeshabilitacion = new Timestamp(d.getTime());
                            pstGuardarHistorico = conexion.prepareStatement("INSERT INTO historico_estados (fecha,estado,motivo_de_deshabilitacion,anexo,nombre," + stringLugarAccion + ") VALUES(?,?,?,?,?,?)");

                            pstGuardarHistorico.setTimestamp(1, fechaDeshabilitacion);
                            pstGuardarHistorico.setInt(2, estado);
                            pstGuardarHistorico.setString(3, motivoDeshabilitacion);
                            pstGuardarHistorico.setString(4, anexo);
                            pstGuardarHistorico.setString(5, nombreX);
                            pstGuardarHistorico.setString(6, lugarAccionMasFechaHD);
                            pstGuardarHistorico.executeUpdate();
                        }
                    } catch (Exception e) {
                        System.out.println("Error actualizando estado secretaria: " + e);
                        e.printStackTrace(System.out);
                    }
                }
                try {
                    pstGuardar.close();
                    pstGuardarHistorico.close();
                } catch (Exception e) {
                }
            }

            if (sesionActual.equals("adm_general")) {
                pstPilotos = conexion.prepareStatement("Select distinct(piloto_asociado) FROM secretaria order by 1");
                rsPiloto = pstPilotos.executeQuery();

                while (rsPiloto.next()) {
                    if (rsPiloto.getString("piloto_asociado") == null) {
                        continue;
                    }
                    if (piloto.equalsIgnoreCase("")) {
                        comboPilotos += "<option selected>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                        piloto = rsPiloto.getString("piloto_asociado").trim();
                    } else if (rsPiloto.getString("piloto_asociado").trim().equalsIgnoreCase(piloto)) {
                        comboPilotos += "<option selected>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                    } else {
                        comboPilotos += "<option>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                    }
                }
            }
            else {
                int idPool = SesionQuery.idPilotoSesion(user);
                pstPilotos = conexion.prepareStatement("Select distinct(piloto_asociado) FROM secretaria s, pilotos p where p.piloto = s.piloto_asociado and p.id = ? order by 1");
                pstPilotos.setInt(1, idPool);
                rsPiloto = pstPilotos.executeQuery();
                while (rsPiloto.next()) {
                    comboPilotos += "<option>" + rsPiloto.getString("piloto_asociado").trim() + "</option>";
                    piloto = rsPiloto.getString("piloto_asociado").trim();
                }
            }

            String qry = "SELECT id,nombre,estado,anexo,motivo_de_deshabilitacion FROM secretaria WHERE anexo LIKE ? AND lower(nombre) LIKE lower(?) and piloto_asociado LIKE ? and estado!=2 ";

            if (!req_combo_est_ag.equals("") && !req_combo_est_ag.equals("-1")) {
                qry += " and estado = " + req_combo_est_ag + " ";
            }
            qry += " order by id";

            pst = conexion.prepareStatement(qry);
            pst.setString(1, extension + "%");
            pst.setString(2, nombre + "%");
            if (piloto.equalsIgnoreCase("")) {
                pst.setString(3, "xxxx");
            } else {
                pst.setString(3, piloto + "%");
            }
            rs = pst.executeQuery();
            nsecretarias = 0;
            while (rs.next()) {
                String motivoDeshabilitacion = (rs.getInt("estado") == 0 ? secretarias.obtenerMotivoDesabilitacionAnexo(conexion, rs.getString("anexo")) : "") ;
//                salidaTabla += secretarias.agregarSecretaria2(rs.getString("nombre"), rs.getString("anexo"), rs.getInt("estado"), String.valueOf(nsecretarias), rs.getString("motivo_de_deshabilitacion"), msgs);
//                salidaTabla += secretarias.agregarSecretaria2_1(rs.getString("nombre"), rs.getString("anexo"), rs.getInt("estado"), String.valueOf(nsecretarias), rs.getString("motivo_de_deshabilitacion"), msgs, conexion, piloto);
                salidaTabla += secretarias.agregarSecretaria2_1(rs.getString("nombre"), rs.getString("anexo"), rs.getInt("estado"), String.valueOf(nsecretarias), motivoDeshabilitacion, msgs, conexion, piloto);
                nsecretarias++;
            }
        } catch (Exception e) {
            System.out.println("Error en habilitador2: " + e);
        } finally {
            try {
                conexion.close();
                pstPilotos.close();
                rsPiloto.close();
                pst.close();
                rs.close();
            } catch (Exception e) {
            }
        }

        combo_est_ag += req_combo_est_ag.equals("-1") ? "<option value=\"-1\" selected>" + msgs.getString("llamadaRegistro.tag.select.all") + "</option>"
                : "<option value=\"-1\" >" + msgs.getString("llamadaRegistro.tag.select.all") + "</option>";
        combo_est_ag += req_combo_est_ag.equals("0") ? "<option value=\"0\" selected>" + msgs.getString("agente.nook") + "</option>"
                : "<option value=\"0\" >" + msgs.getString("agente.nook") + "</option>";
        combo_est_ag += req_combo_est_ag.equals("1") ? "<option value=\"1\" selected>" + msgs.getString("agente.ok") + "</option>"
                : "<option value=\"1\" >" + msgs.getString("agente.ok") + "</option>";
        combo_est_ag += req_combo_est_ag.equals("3") ? "<option value=\"3\" selected>" + msgs.getString("agente.camp") + "</option>"
                : "<option value=\"3\" >" + msgs.getString("agente.camp") + "</option>";

        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        
        String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
        t_menu = Plantillas.reemplazar(t_menu, "%class_hab%", "botonesactive");
        t_menu = Plantillas.reemplazar(t_menu, "%class_disp%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_grab%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_agente%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_camp%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_enc%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ges%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

        String t_contenido = Plantillas.leer(ruta + "/plantillas/habilitador2.html");
        t_contenido = Plantillas.reemplazar(t_contenido, "%nombre%", nombre);
        t_contenido = Plantillas.reemplazar(t_contenido, "%extension%", extension);
        t_contenido = Plantillas.reemplazar(t_contenido, "%combo_piloto%", comboPilotos);
        t_contenido = Plantillas.reemplazar(t_contenido, "%nsecretarias%", String.valueOf(nsecretarias));
        t_contenido = Plantillas.reemplazar(t_contenido, "%centroCostoPlantilla%", centroCostoPlantilla);
        t_contenido = Plantillas.reemplazar(t_contenido, "%salidaTabla%", salidaTabla);
        t_contenido = Plantillas.reemplazar(t_contenido, "%paginado%", paginado);

        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_tabla_name%", msgs.getString("habilit.tabla.name"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_tabla_extn%", msgs.getString("habilit.tabla.extn"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%habilit_tabla_estado%", msgs.getString("extension.reg.tabla.est"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%combo_est_ag%", combo_est_ag);
        t_contenido = Plantillas.reemplazar(t_contenido, "%opcion_deshab%", comboDeshab);
        t_contenido = Plantillas.reemplazar(t_contenido, "%tag_motivo%", msgs.getString("opcion.desh.tagtabla"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%alert_empty%", msgs.getString("habilit.alrt.empty"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%titl_save%", msgs.getString("usuario.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%titl_cncl%", msgs.getString("usuario.mod.btn.cancel"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%titl_search%", msgs.getString("extension.reg.btn.find"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%tag_piloto%", msgs.getString("qos.piloto"));

        String tieneTitulos = ii.getTieneTitulos(msgs);
        if(tieneTitulos != ""){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%","<div id=\"titulo\"><h1>"+msgs.getString("menu.adm.txt.habilitacion")+"</h1></div>" );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }
        
        t_maestra = Plantillas.reemplazar(t_maestra, "%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra, "%css%", "");
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");

        out.println(t_maestra);

    } else {
        response.sendRedirect("index.jsp");
    }
%>