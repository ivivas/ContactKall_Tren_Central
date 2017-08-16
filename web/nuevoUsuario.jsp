<%-- 
    Document   : nuevoUsuario
    Created on : 05-08-2009, 11:59:26 AM
    Author     : max
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1" language = "java"
    import="java.sql.*"
    import="adportas.*"
    import="dtoVistas.*"
    import="query.*"
    import="java.util.*"
%>


<%
String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
if (sesionActual.equalsIgnoreCase("adm_general") || sesionActual.equalsIgnoreCase("ggee") || sesionActual.equalsIgnoreCase("cap") || sesionActual.equalsIgnoreCase("inmobiliaria") || sesionActual.equalsIgnoreCase("pacifico")) {
    String mensage_error="";
    String inicio_form="";
    String fin_form="";
    String busqueda="";
    String contenido="";
    String dato_guardar=null;
    
    dato_guardar= request.getParameter("dato_guardar");

    if(dato_guardar!=null)
        {
             //dato_clave  dato_usuario selecion_tipo
            String dato_clave=request.getParameter("dato_clave");
            String dato_usuario=request.getParameter("dato_usuario");
            String dato_tipo=request.getParameter("selecion_tipo");
            if(dato_clave!=null && dato_clave!="" && dato_usuario!=null && dato_tipo!=null && dato_usuario!="" && dato_tipo!="")
                {
                    Connection conexion = SQLConexion.conectar();
                    SesionQuery query=new SesionQuery(conexion);
                    if(!query.buscar(dato_usuario))
                        {
                            if(query.insertar(dato_usuario, dato_clave, dato_tipo))
                                {
                                 mensage_error="Los datos est&aacute;n ingresados correctamente ";
                                }else{  //& acute;
                                 mensage_error="Estos datos no se pudieron ingresar,  int&eacute;ntelo de nuevo o m&aacute;s tarde ";
                                }
                        }else{
                            mensage_error="Este usuario \""+dato_usuario+"\" ya se encuentra registrado ";
                        }
                    query=null;
                    conexion.close();
                }else{
                    mensage_error="Complete todos los campos";
                }
        }

    inicio_form="<form action = \"nuevoUsuario.jsp\" name=\"usuario\" >";
    fin_form = "</form>";

   
    String botones="<input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/guardar.jpg\" value=\"true\" onclick=\"document.getElementById('dato_guardar').value='true';\" />" +
                   "<input name=\"dato_guardar\" type=\"hidden\" id=\"dato_guardar\" value=\"\" />"+
                   "<a href=\"usuarios.jsp\"> <img src=\"botones/cancelar.jpg\"  border=\"0\"> </a>";
  
    contenido= "<div id=\"cajon2\"><div id=\"content_cajon_2\"><div id=\"datos\">"+
			   "<table width=\"450\" border=\"0\" >" +
               "<tr><td>Datos</td>" +
               "</tr></dt>";
   
    contenido = contenido +
                    "<tr><td>Usuario</td>" +
                    "    <td><input type=\"text\" name=\"dato_usuario\" />  </td>" +
                    "</tr>" +
                    "<tr><td>Clave</td>" +
                    "    <td><input type=\"text\" name=\"dato_clave\" />  </td>" +
                    "</tr>" +
                    "<tr><td>Tipo</td>" +
                    "    <td>" +
                    "    <SELECT  size=\"1\" name=\"selecion_tipo\"> "+
                    "      <OPTION selected value=\"adm_general\">Administrador General</OPTION>" +
                    "      <OPTION selected value=\"adm_pool\">Administrador del pool</OPTION>" +
                    "      <OPTION selected value=\"usuario\">Usuario normal</OPTION>" +
                    "    </SELECT >" +
                    "    </td>" +
                    "</tr>";
 

    //<input type="text" name="" value="" />
    contenido= contenido +
               "</table>" +
               "</div></div></div>";



    String ruta = getServletConfig().getServletContext().getRealPath("");
    String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
    t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");
    String t_contenido = Plantillas.leer(ruta + "/plantillas/platilla_contenido_configuracion.html");
    t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
    t_maestra = Plantillas.reemplazar(t_maestra, "%titulo%", "Nuevo Usuario");
    t_maestra = Plantillas.reemplazar(t_maestra, "%inicio_form%", inicio_form);
    t_maestra = Plantillas.reemplazar(t_maestra, "%busqueda%", busqueda);
    t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", contenido);
    t_maestra = Plantillas.reemplazar(t_maestra, "%fin_form%", fin_form);
    t_maestra = Plantillas.reemplazar(t_maestra, "%botones%", botones);
    t_maestra = Plantillas.reemplazar(t_maestra, "%mensage_error%", mensage_error);




    out.println(t_maestra);
} else {
    out.println("<script>");
    out.println("function regresar() { window.top.location.href=\'index.jsp\'; }");
    out.println("</script>");
    out.println("<body onload=\'regresar()\';>");
}
%>
