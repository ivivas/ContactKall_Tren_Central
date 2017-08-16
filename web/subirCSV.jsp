<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="query.IPKall"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%

    int cabecera = 1;
    String nombre = "";
    String apellido = "";
    String rut = "";
    String telefono1 = "";
    String telefono2 = "";
    int id_Centrocosto = 0;
    int ncheckbox = 0;
    int id_campania_actual = 0;
    int id_campania_actual2 = 0;
    String checkboxes = "";
    Connection conexion = null;%>
<html>
    <head>
        <title>.:: :: Adportas ContactKall :: ::.</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link href="css/campana.css" rel="stylesheet" type="text/css"/>
        <script language="JavaScript">
            function envia_clientes(n) {
                var i;
                var cont = 0;
//                alert("0");
                var receptor = opener.document.getElementById('panelCliente');
//                alert("00");
                var num_check = n;
                if (num_check === 0) {
                    num_check = document.getElementById('ncheckboxhide').value;
                }
                for (i = 0; i < num_check; i++) {
                    checkos = document.getElementById('checkoC' + i.toString());
                    if (checkos.checked === true) {
                        var op = opener.document.createElement("INPUT");
//                        alert("1");
                        var op2 = opener.document.createElement("BR");
                        var op3 = opener.document.createElement("LABEL");
//                        alert("2");
                        op.setAttribute("type", "checkbox"); // for type
                        op.setAttribute("value", checkos.value); // for value
                        op.setAttribute("checked", "checked"); // for value
                        op.id = checkos.value;
                        op.innerHTML = checkos.name;
                        op3.setAttribute("value", checkos.value + " - " + checkos.name);
//                        alert("7");
                        op3.innerHTML = checkos.name;
                        receptor.appendChild(op);
                        receptor.appendChild(op3);
                        receptor.appendChild(op2);

//                        alert("8");
                        cont++;
                    }
                }
                window.close();
            }
        </script>

    </head>
    <body class="subirClienteCampana">
        <%
            ResourceBundle msgs = null;
            if (request.getSession().getAttribute("msgs") == null) {
                Locale lEs = new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            } else {
                msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
            }
        %>
        <div>
            <form id="form1" name="form1" action="subirCSV.jsp" enctype="multipart/form-data" method="post">
                <input type="file" id="archivo" name="nombre_csv" id="nombre_csv"/>
                <input type="submit" id="cargarCSV" name="btn_subirCSV" value ="<%=msgs.getString("campana.subir_csv.cargar_archivo")%>" class="botones btnadddel" />
                <a  class="botones btnadddel" id="enviarCampana" onclick="envia_clientes(<%=ncheckbox%>)"><%=msgs.getString("campana.subir_csv.guardar")%></a>
            </form>
        </div>

    <!--<input type="button" class="botones btnadddel" id="enviarCampana" value="Guardar" onclick="envia_clientes(<%=ncheckbox%>)">-->
        <%
            boolean isMultipart = ServletFileUpload.isMultipartContent(request);
            if (isMultipart) {
                try {
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List items = upload.parseRequest(request);
                    for (Object item : items) {
                        FileItem uploaded = (FileItem) item;
                        if (!uploaded.isFormField()) {
                            File fichero = new File("C:\\Temp", uploaded.getName());
                            //                  File fichero = new File("/tmp", uploaded.getName());
                            BufferedReader entrada = null;
                            entrada = new BufferedReader(new InputStreamReader(uploaded.getInputStream()));
                            //                                entrada = new BufferedReader(new InputStreamReader(new FileInputStream(fichero)));
                            String texto = "";
                            while ((texto = entrada.readLine()) != null) {
                                if (cabecera > 1) {
                                    //                              texto = entrada.readLine();
                                    String resultados[] = texto.split(";\\s*");
                                    int largoCadena = resultados.length;
                                    if (largoCadena == 5) {
                                        nombre = resultados[0].toString().trim();
                                        apellido = resultados[1].toString().trim();
                                        rut = resultados[2].toString().trim();
                                        telefono1 = resultados[3].toString().trim();
                                        telefono2 = resultados[4].toString().trim();
                                        if (telefono1.equalsIgnoreCase("")) {
                                            telefono1 = telefono2;
                                            telefono2 = "";
                                        }
                                    } else if (largoCadena == 4) {
                                        nombre = resultados[0].toString().trim();
                                        apellido = resultados[1].toString().trim();
                                        rut = resultados[2].toString().trim();
                                        telefono1 = resultados[3].toString().trim();
                                    }
                                    checkboxes += "<input name=\"" + nombre + "\" checked value=\"" + nombre + ";" + apellido + ";" + rut + ";" + telefono1 + ";" + (telefono2 != null ? telefono2 : "") + "\" id=\"checkoC" + ncheckbox + "\" type=\"checkbox\">" + nombre + " " + apellido + "- Rut: " + rut + "- Tel 1: " + telefono1 + "- Tel 2: " + (telefono2 != null ? telefono2 : "s/tel") + "<br>";
                                    //                                                    checkboxes += "<tr><td><input name=\"" + rsClientesDisponibles.getString("nombre_cliente") + "\" checked value=\"" + rsClientesDisponibles.getInt("id_cliente") + "\" id=\"checkoC" + ncheckbox + "\" type=\"checkbox\">" + rsClientesDisponibles.getString("nombre_cliente") + " " + rsClientesDisponibles.getString("apellido_cliente") + "- Rut: " + rsClientesDisponibles.getString("rut_cliente") + "- Tel 1: " + rsClientesDisponibles.getString("telefono_cliente") + "- Tel 2: " + (rsClientesDisponibles.getString("telefono_cliente2") != null ? rsClientesDisponibles.getString("telefono_cliente2") : "S/Tel") + "</td></tr>";
                                    ncheckbox++;
                                }

                                cabecera++;
                                nombre = "";
                                apellido = "";
                                rut = "";
                                telefono1 = "";
                                telefono2 = "";
                            }
                            //uploaded.write(fichero);
                        } else {
                            String key = uploaded.getFieldName();
                            String valor = uploaded.getString();
                            if (key.trim().equalsIgnoreCase("id_campania_actual")) {
                                id_campania_actual2 = (valor != null) ? (Integer.parseInt(valor.trim())) : 0;
                            }
                            System.out.println("key= " + key + " valor= " + valor);
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace(System.out);
                }
            }
            try {
                if (request.getParameter("btn_subirCSV") != null) {
                    id_campania_actual = (request.getParameter("id_campania") != null) ? (Integer.parseInt(request.getParameter("id_campania").trim())) : id_campania_actual2;
                    conexion = SQLConexion.conectaIPKall(IPKall.conf.getIpServidor(), IPKall.conf.getBaseDatos(), IPKall.conf.getUsuarioBD(), IPKall.conf.getClaveBD());
                    Statement st = conexion.createStatement();
                    ResultSet rsUsuariosDisponibles = st.executeQuery("SELECT * FROM cliente ORDER BY nombre_cliente ASC ");
                    Statement stg = conexion.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsUsuario = stg.executeQuery("SELECT * FROM cliente");

                    while (rsUsuariosDisponibles.next()) {
                        boolean esta_ocupado = false;
                        String Usuario_poner = String.valueOf(rsUsuariosDisponibles.getInt("id_cliente"));
                        rsUsuario.beforeFirst();
                        //recorre tabla usuarios_extensiones y si el campo id_extension existe quiere decir que esta ocupado y no disponible
                        while (rsUsuario.next()) {
                            if (Usuario_poner.equalsIgnoreCase(rsUsuario.getString("id_cliente").trim())) {
                                esta_ocupado = true;
                                //                    ncheckbox++;
                                //                    checkboxes += "<tr><td><input name=\"" + rsUsuariosDisponibles.getString("nombre_cliente") + "\" value=\"" + Usuario_poner + "\" id=\"checko" + ncheckbox + "\" type=\"checkbox\" checked>" + rsUsuariosDisponibles.getString("nombre_cliente") + "</td></tr>";
                                break;
                            } else {
                                esta_ocupado = false;
                            }
                        }
                        if (esta_ocupado == false) {
                            checkboxes += "<input name=\"" + rsUsuariosDisponibles.getString("nombre_cliente") + "\" value=\"" + Usuario_poner + "\" id=\"checkoC" + ncheckbox + "\" type=\"checkbox\">" + rsUsuariosDisponibles.getString("nombre_cliente") + "<br>";
                            ncheckbox++;
                        } else if (rsUsuario.getInt("id_campania") == id_campania_actual && esta_ocupado == true) {
                            checkboxes += "<input name=\"" + rsUsuariosDisponibles.getString("nombre_cliente") + "\" value=\"" + Usuario_poner + "\" id=\"checkoC" + ncheckbox + "\" type=\"checkbox\" checked>" + rsUsuariosDisponibles.getString("nombre_cliente") + "</br>";
                            ncheckbox++;
                        }
                    }
                    rsUsuario.close();
                    rsUsuariosDisponibles.close();
                    stg.close();
                    conexion.close();
                }
            } catch (Exception e) {
                out.println(e.toString());
            }

            out.print(checkboxes);
        %>
        <input type="hidden" id="ncheckboxhide" name="ncheckboxhide" value="<%=ncheckbox%>" />
    </body>
</html>