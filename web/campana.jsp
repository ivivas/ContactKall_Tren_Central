<%@page import="BO.CargaMenu"%>
<%@page import="query.Paginado"%>
<%@page import="query.IPKall"%>
<%@page import="query.AgenteQuery"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="query.ComboQuery"%>
<%@page import="adportas.Plantillas"%>

<%
    ResourceBundle msgs = null;
    if (session.getAttribute("msgs") == null) {
        Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
        ResourceBundle.clearCache();
        msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
    } else {
        msgs = (ResourceBundle) session.getAttribute("msgs");
    }
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if (sesionActual.equals("adm_general") | sesionActual.equals("supervisor")) {
        Connection con = null;
        Connection cone = null;
        try {
            cone = SQLConexion.conectar();
            if (IPKall.conf.getIpServidor() == null) {
                //es nulo
            }
        } catch (Exception e) {
            IPKall.conf = IPKall.configuracionIPKall();

        }
        String supervisor = session.getAttribute("usuario").toString();
        String datosSupervisor;
        String anexo;
        String deviceName;
        try {
            datosSupervisor = ComboQuery.getAnexoSupervisor(cone, supervisor);
            anexo = datosSupervisor.split("-")[0];
            deviceName = datosSupervisor.split("-")[1];
        } catch (Exception e) {
            datosSupervisor = "";
            anexo = "";
            deviceName = "";
        }
        System.out.println("IPKALL SERVER: " + IPKall.conf.getIpServidor());
        System.out.println("IPKALL BD: " + IPKall.conf.getBaseDatos());
        System.out.println("IPKALL USER: " + IPKall.conf.getUsuarioBD());
        System.out.println("IPKALL CLAVE: " + IPKall.conf.getClaveBD());
        con = SQLConexion.conectaIPKall(IPKall.conf.getIpServidor(), IPKall.conf.getBaseDatos(), IPKall.conf.getUsuarioBD(), IPKall.conf.getClaveBD());
        int limit = Integer.parseInt(request.getParameter("limit") == null ? "15" : request.getParameter("limit"));
        int offset = Integer.parseInt(request.getParameter("offset") == null ? "0" : request.getParameter("offset"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad") == null ? "10" : request.getParameter("cantidad"));
        String cadena = request.getParameter("cadena") == null ? "%" : "%" + request.getParameter("cadena") + "%";
        String reqCadena = request.getParameter("cadena") == null ? "" : request.getParameter("cadena");
        int total = IPKall.totalCampanas(con, cadena);

        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/campana.html");
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        String t_menu = CargaMenu.menuDinamico(sesionActual, msgs, ruta);
        String t_javascript = Plantillas.leer(ruta + "/js/campana.js");
        String t_css = Plantillas.leer(ruta + "/css/campana.css");

        t_menu = Plantillas.reemplazar(t_menu, "%class_hab%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_disp%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_grab%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_piloto%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_agente%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_camp%", "botonesactive");
        t_menu = Plantillas.reemplazar(t_menu, "%class_calidad%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_enc%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ges%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_ivrchart%", "botones");
        t_menu = Plantillas.reemplazar(t_menu, "%class_callback%", "botones");

        if (limit == 15) {
            t_contenido = Plantillas.reemplazar(t_contenido, "%15%", "selected");
        } else if (limit == 30) {
            t_contenido = Plantillas.reemplazar(t_contenido, "%30%", "selected");
        } else {
            t_contenido = Plantillas.reemplazar(t_contenido, "%50%", "selected");
        }
        t_contenido = Plantillas.reemplazar(t_contenido, "%session_name%", sesionActual);
        
        t_contenido = Plantillas.reemplazar(t_contenido, "%agregar_cargar_cliente%", msgs.getString("campana.agregar.asigar_cliente"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%guardar_campana%", msgs.getString("campana.agregar.guardar"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%cancelar_campana%", msgs.getString("campana.agregar.cancelar"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%nueva_campana%", msgs.getString("campana.registro.nueva"));
        
        t_contenido = Plantillas.reemplazar(t_contenido, "%eliminar_campana%", msgs.getString("campana.registro.eliminar"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%campanas_disponibles%", msgs.getString("campana.disponible"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%nombre%", msgs.getString("campana.nombre"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%descripcion%", msgs.getString("campana.desc"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%inicio%", msgs.getString("campana.inicio"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%fin%", msgs.getString("campana.fin"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%estado%", msgs.getString("campana.estado"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%reg%", msgs.getString("campana.reg.pag"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%asignar_agentes%", msgs.getString("campana.asignar.agentes"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%asignar_clientes%", msgs.getString("campana.asignar.clientes"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%agentes_asignados%", msgs.getString("campana.agentes.asignados"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%clientes_asignados%", msgs.getString("campana.clientes.asignados"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%lista_campanas%", IPKall.generarTablaCamapanas(con, cadena, limit, offset));
        t_contenido = Plantillas.reemplazar(t_contenido, "%paginado%", Paginado.paginado(limit, offset, cantidad, cadena, total));
        t_contenido = Plantillas.reemplazar(t_contenido, "%usuario%", supervisor);
        t_contenido = Plantillas.reemplazar(t_contenido, "%anexo%", anexo);
        t_contenido = Plantillas.reemplazar(t_contenido, "%devicename%", deviceName);
        t_contenido = Plantillas.reemplazar(t_contenido, "%datosSupervisor%", datosSupervisor);
        t_contenido = Plantillas.reemplazar(t_contenido, "%supervisor%", msgs.getString("agente.supervisor"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%anx%", msgs.getString("agente.supervisor.anexo"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%devname%", msgs.getString("agente.supervisor.devicename"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%cerrar_sesion%", msgs.getString("agente.cerrar.sesion"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%seleccione_algo%", msgs.getString("error.msgs.principal.nodata"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%session_name_no_autorizado%", msgs.getString("error.msgs.principal.no_autorizado"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%cargando%", msgs.getString("dashboard.cargando"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%valor_cadenna%", reqCadena);
        
        t_contenido = Plantillas.reemplazar(t_contenido, "%activa%", msgs.getString("campana.modificar.combo.activa"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%inactiva%", msgs.getString("campana.modificar.combo.inactiva"));
        t_contenido = Plantillas.reemplazar(t_contenido, "%completada%", msgs.getString("campana.modificar.combo.completada"));

        t_javascript = Plantillas.reemplazar(t_javascript, "%alrt_empty_add%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%alrt_empty_mod%", msgs.getString("error.data.inc"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%alrt_frmt_add%", msgs.getString("error.formatfh"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%alrt_frmt_mod%", msgs.getString("error.formatfh"));
        t_javascript = Plantillas.reemplazar(t_javascript, "%seleccione_algo%", msgs.getString("error.msgs.principal.nodata"));
        
        t_javascript = Plantillas.reemplazar(t_javascript, "%session_name_no_autorizado%", msgs.getString("error.msgs.principal.no_autorizado"));

        t_maestra = Plantillas.reemplazar(t_maestra, "%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra, "%css%", t_css);
        t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);

        out.print(t_maestra);
        cone.close();
        try {
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        response.sendRedirect("index.jsp");
    }

%>