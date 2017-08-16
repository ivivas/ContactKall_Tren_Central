<%@page import="SocketServer.ServidorMapaPilotos"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1" language = "java"
        import="java.sql.*"
        import="adportas.*"
        import="query.*" %>
<%!
    public void jspInit() {
        SocketServer.ManejadorSockets.iniciarServidor();
        if (BO.Horario.mapaDeLosHorarios.size() == 0) {
            BO.Horario horario = new BO.Horario();
        }
        System.out.println("inicio");
    }

    public void jspDestroy() {
        SocketServer.ManejadorSockets.terminarServidor();
        System.out.println("fin");
    }%>
<% response.setHeader("Pragma", "no-cache");%>
<% response.setHeader("Cache-Control", "no-cache");%>
<% response.setDateHeader("Expires", 0);%>
<% response.setDateHeader("max-age", 0);%>
<%

    String error = "";
    String localereq = "";
    String region = "";
    ResourceBundle msgs = null;

    try {
        localereq = request.getLocale().getLanguage();
        region = request.getLocale().getCountry();
    } catch (Exception e) {
        System.out.println("Error obteniendo lenguaje y region: " + e);
    }
    String selEs = "";
    String selPt = "";

    if (session.getAttribute("msgs") == null) {
        if (localereq.equalsIgnoreCase("es") && region.equalsIgnoreCase("CL")) {
            Locale locale = new Locale.Builder().setLanguageTag(localereq).setRegion(region).build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", locale);
            selEs = "selected";
            selPt = "";
        } else if (localereq.equalsIgnoreCase("pt") && region.equalsIgnoreCase("BR")) {
            Locale locale = new Locale.Builder().setLanguageTag(localereq).setRegion(region).build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", locale);
            selEs = "";
            selPt = "selected";
        } else {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            selEs = "selected";
            selPt = "";
        }
    } else {
        msgs = (ResourceBundle) session.getAttribute("msgs");
        if (msgs.getLocale().getLanguage().equals("pt")) {
            selEs = "";
            selPt = "selected";
        } else {
            selEs = "selected";
            selPt = "";
        }
    }
    session.setAttribute("msgs", msgs);

    String languaje = request.getParameter("idioma") != null ? request.getParameter("idioma") : "";

    if (!languaje.equals("")) {
        if (languaje.equalsIgnoreCase("es")) {
            Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            selEs = "selected";
            selPt = "";
            session.setAttribute("msgs", msgs);
        } else if (languaje.equalsIgnoreCase("pt")) {
            Locale lEs = new Locale.Builder().setLanguageTag("pt").setRegion("BR").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            selEs = "";
            selPt = "selected";
            session.setAttribute("msgs", msgs);
        }
    } else if (session.getAttribute("tipo") == null) {

        if (request.getParameter("user") != null && request.getParameter("password") != null) {
            if (!request.getParameter("user").equalsIgnoreCase("")) {
                try {
                    try {
                        String tipo = null;
                        String usuario = request.getParameter("user").trim().toLowerCase();
                        String password = request.getParameter("password").trim().toLowerCase();
                        Connection conexion = SQLConexion.conectar();
                        if (conexion != null) {
                            PreparedStatement pst = conexion.prepareStatement("SELECT tipo, usuario FROM sesion WHERE usuario = ? and clave = ?");
                            pst.setString(1, usuario);
                            pst.setString(2, password);
                            ResultSet rs = pst.executeQuery();
                            if (rs.next()) {
                                session.setAttribute("usuario", rs.getString("usuario"));
                                session.setAttribute("tipo", rs.getString("tipo"));
                                tipo = rs.getString("tipo");
                            }
                        }
                        if (tipo != null) {
                            if (request.getParameter("area") != null) {
                                String ar = request.getParameter("area");
                                if (ar.equalsIgnoreCase("es")) {
                                    Locale locale = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                                    ResourceBundle.clearCache();
                                    msgs = ResourceBundle.getBundle("bundle.fichero", locale);
                                    session.setAttribute("msgs", msgs);
                                } else if (ar.equalsIgnoreCase("pt")) {
                                    Locale locale = new Locale.Builder().setLanguageTag("pt").setRegion("BR").build();
                                    ResourceBundle.clearCache();
                                    msgs = ResourceBundle.getBundle("bundle.fichero", locale);
                                    session.setAttribute("msgs", msgs);
                                }
                            }
                            if (tipo.equals("supervisor")) {
                                //if(AgenteQuery.noEstaLogueado(conexion, usuario)){
                                AgenteQuery.logIn(conexion, usuario);
                                response.sendRedirect("habilitador2.jsp");
                                /*}
                                else{
                                     error = "ud tiene otra sesion activa";
                                }*/
                            } else if (tipo.equals("usuario")) {
                                //if(AgenteQuery.noEstaLogueado(conexion, usuario)){
                                AgenteQuery.logIn(conexion, usuario);
                                response.sendRedirect("disponibilidad.jsp");
                                /*}else{
                                     error = "ud tiene otra sesion activa";
                                }*/
                            } else {
                                response.sendRedirect("habilitador2.jsp");
                            }
                            if (conexion != null) {
                                conexion.close();
                            }
                        } else {
                            if (request.getParameter("area") != null) {
                                String ar = request.getParameter("area");
                                if (ar.equalsIgnoreCase("es")) {
                                    Locale locale = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                                    ResourceBundle.clearCache();
                                    msgs = ResourceBundle.getBundle("bundle.fichero", locale);
                                    session.setAttribute("msgs", msgs);
                                } else if (ar.equalsIgnoreCase("pt")) {
                                    Locale locale = new Locale.Builder().setLanguageTag("pt").setRegion("BR").build();
                                    ResourceBundle.clearCache();
                                    msgs = ResourceBundle.getBundle("bundle.fichero", locale);
                                    session.setAttribute("msgs", msgs);
                                }
                            }
                            error = msgs.getString("login.error");
                        }
                        if (conexion != null) {
                            conexion.close();
                        }
                    } catch (Exception ee) {
                        error = ee.toString();
                    }
                } catch (Exception e) {
                    error = e.toString();
                }
            }
        }
    } else {
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String usuario = session.getAttribute("usuario").toString();
            AgenteQuery.logOut(con, usuario);
        } catch (Exception e) {
        } finally {
            try {
                con.close();
            } catch (Exception e) {
            }
        }
        session.invalidate();
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>.:: :: Adportas ContactKall :: ::.</title>
        <link href="css/style.css" rel="stylesheet" type="text/css" />
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css"></link>
        <style type="text/css">

            a.btnmenu{
                color: #666666;
                border: 2px #CCCCCC solid;
                padding: 5px 15px 5px 15px;
                background-color: #F6F6F6;
                font-size: 12px;
                font-weight: bold;
                text-decoration: none;
                border-radius: 5px;
                box-shadow: 3px 3px 5px #888888;
                font-weight: bold;
                font-family:Tahoma;
            }
            a.btnmenu:hover{
                box-shadow: 0px 0px 0px #000000;
            }

            a.btnlogin{
                background-image: url("imagenes/entrar_ico.png");
                background-repeat: no-repeat;
                padding: 5px 25px 5px 25px;
            }

            a.btnclear{
                background-image: url("imagenes/borrar_ico.png");
                background-repeat: no-repeat;
                padding: 5px 25px 5px 25px;
            }
            .boxlogin{
                box-shadow: 3px 3px 20px #151515;
                border-radius: 25px;
                border: 1px #1C1C1C solid;
            }
        </style>
        <script type="text/javascript">
            function validar(e) {
                tecla = (document.all) ? e.keyCode : e.which;
                if (tecla === 13) {
                    document.form1.submit();
                }
            }
            function cambiaIdioma() {
                var idm = document.getElementById('area').value;
                document.getElementById('idioma').value = idm;
                document.form1.submit();
            }
        </script>
    </head>
    <body class="contenedor_index">
        <form action="index.jsp" method="post" name="form1" id="form1">
            <div id="contenedor">
                <div id="titulo">
                    <h1><img src="images/logo2_blanco2.png" alt="logo" style="width:12%"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/logo-tren-central-rgb.png"/></h1>
                    
                </div>
                <div style="color:white;">
                    <center>
                        <%=error%>
                    </center>
                </div>
                <div id="info3">
                    <div id="tabla2">
                        <span><%=msgs.getString("login.idioma.lang")%></span>&nbsp;&nbsp;
                        <select name="area" id="area" onchange="cambiaIdioma()">
                            <option value="es" <%=selEs%> ><%=msgs.getString("login.idioma.esp")%></option>
                            <option value="pt" <%=selPt%> ><%=msgs.getString("login.idioma.ptg")%></option>
                        </select><br/><br/>
                        <input type="hidden" name="idioma" id="idioma" value=""/>

                        <div style="width:100%;"><%=msgs.getString("login.usuario")%></div>

                        <input style="width: 80%;margin: 0 auto;" name="user" type="text" class="box" size="20" onkeypress="validar(event)"/><br/>

                        <div style="width: 100%;"><%=msgs.getString("login.psw")%></div>

                        <input style="width: 80%;margin: 0 auto;" name="password" type="password" class="box" size="20" onkeypress="validar(event)"/><br/><br/>

                        <a href="#" onclick="document.form1.submit();" > <div class="btn_lgn"><i class="fa fa-chevron-circle-right"></i></div></a>  
                        <a href="#" onclick="document.form1.reset();
                                return false;" > <div class="btn_lgn"><i class="fa fa-close"></i></div></a>
                    </div>
                </div>
            </div>

        </form>
    </body>
</html>
