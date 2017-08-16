<%@page import="query.SesionQuery"%>
<%@page import="BO.CargaMenu"%>
<%@page import="query.ComboQuery"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="query.AgenteQuery"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.Plantillas"%>
<%
    try {

        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        ResourceBundle msgs = null;
        if (session.getAttribute("msgs") == null) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        } else {
            msgs = (ResourceBundle) session.getAttribute("msgs");
        }
        String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
        String usuario = session.getAttribute("usuario").toString();
        if (sesionActual.equals("adm_general") | sesionActual.equals("supervisor")) {
            ComboQuery ii = new ComboQuery();
            Connection con = null;
            String supervisor = session.getAttribute("usuario").toString();
            String datosSupervisor;
            String anexo;
            String deviceName;
            try {
                con = SQLConexion.conectar();
                datosSupervisor = ComboQuery.getAnexoSupervisor(con, supervisor);
                anexo = datosSupervisor.split("-")[0];
                deviceName = datosSupervisor.split("-")[1];
            } catch (Exception e) {
                datosSupervisor = "";
                anexo = "";
                deviceName = "";
            }
            String menuTipoArbol;
            String tablaEstadisticas;
            try {
                if (sesionActual.equals("adm_general")) {
                    menuTipoArbol = AgenteQuery.generarMenu(con);
                } else {
                    int idPool = SesionQuery.idPilotoSesion(usuario);
                    menuTipoArbol = AgenteQuery.generarMenu(con, idPool);
                }
                //tablaEstadisticas = AgenteQuery.getTablaEstadisticasPool(con,msgs,pilotos);
                tablaEstadisticas = "";
                String ruta = getServletConfig().getServletContext().getRealPath("");
                String t_contenido = Plantillas.leer(ruta + "/plantillas/qos.html");
                String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
                String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
                String t_css = Plantillas.leer(ruta + "/css/qos.css");

                t_menu = Plantillas.reemplazar(t_menu, "%class_hab%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_disp%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_grab%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_agente%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_camp%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%", "botonesactive");
                t_menu = Plantillas.reemplazar(t_menu, "%class_enc%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_ges%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
                t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

                t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%", supervisor);
                t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
                t_contenido = Plantillas.reemplazar(t_contenido, "%devicename%", deviceName);
                t_contenido = Plantillas.reemplazar(t_contenido, "%datosSupervisor%", datosSupervisor);
                t_contenido = Plantillas.reemplazar(t_contenido, "%supervisor%", msgs.getString("agente.supervisor"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%anx%", msgs.getString("agente.supervisor.anexo"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%devname%", msgs.getString("agente.supervisor.devicename"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%cerrar_sesion%", msgs.getString("agente.cerrar.sesion"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%lista_tipo_arbol%", menuTipoArbol);
                t_contenido = Plantillas.reemplazar(t_contenido, "%tabla_estadistica%", tablaEstadisticas);
                t_contenido = Plantillas.reemplazar(t_contenido, "%seleccione.opcion.info%", msgs.getString("seleccione.opcion.info"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%qos.comboLapso.diaro%", msgs.getString("qos.comboLapso.diaro"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%qos.comboLapso.semanal%", msgs.getString("qos.comboLapso.semanal"));
                t_contenido = Plantillas.reemplazar(t_contenido, "%qos.comboLapso.mensual%", msgs.getString("qos.comboLapso.mensual"));

                String tieneTitulos = ii.getTieneTitulos(msgs);
                if (tieneTitulos != "") {
                    t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "<div id=\"titulo\"><h2>" + msgs.getString("menu.adm.txt.calidadServicio") + "</h2></div>");
                } else {
                    t_contenido = Plantillas.reemplazar(t_contenido, "%div_titulo%", "");
                }

                String t_javascript = Plantillas.leer(ruta + "/js/qos.js");
                t_javascript = Plantillas.reemplazar(t_javascript, "%sin.pilotos.asociados%", msgs.getString("sin.info.piloto"));
                t_maestra = Plantillas.reemplazar(t_maestra, "%menu%", t_menu);
                t_maestra = Plantillas.reemplazar(t_maestra, "%css%", t_css);
                t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
                t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);

                //out.println(t_contenido);
                out.println(t_maestra);
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect("index.jsp");
            } finally {
                con.close();
            }
        } else {
            String sesion = request.getSession().toString();
            out.print(sesion);
            response.sendRedirect("index.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("index.jsp");
    }
%>