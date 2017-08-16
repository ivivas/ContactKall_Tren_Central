<%-- 
    Document   : usuarios
    Created on : 03-08-2009, 11:16:42 AM
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
    String inicio_form="";
    String mensage_error="";
    String fin_form = "";
    String busqueda="";
    String contenido="";
    String botones= "";

    String dato_eliminar=request.getParameter("dato_eliminar");
    String dato_modificar=request.getParameter("dato_modificar");
    String dato_tipo="";
    String dato_eliminar_confirmado=request.getParameter("dato_eliminar_confirmado");
    String dato_modificar_confirmado=request.getParameter("dato_modificar_confirmado");
    inicio_form="<form action = \"usuarios.jsp\" name=\"usuario\" >";
    fin_form = "</form>";

           if(dato_eliminar_confirmado!=null) // eliminar usuario
               {
                    Connection conexion = Postgres.conectar();
                    SesionQuery query=new SesionQuery(conexion);
                    if(query.eliminar(dato_eliminar_confirmado))
                    mensage_error="Registro \""+dato_eliminar_confirmado+"\" eliminado";
                    else
                    mensage_error="No se ha eliminador el registro \""+dato_eliminar_confirmado+"\"";
                    
                    query=null;
                    conexion.close();
               }

            if(dato_modificar_confirmado!=null)
            {
                String dato_modificar_usuario = request.getParameter("dato_modificar_usuario");
                String dato_modificar_clave = request.getParameter("dato_modificar_clave");
                String dato_modificar_tipo = request.getParameter("dato_modificar_tipo");

                int dato_modificar_id=0;

                try{
                    dato_modificar_id = Integer.parseInt(request.getParameter("dato_modificar_id"));
                }catch(Exception ex)
                {
                   dato_modificar_id =0;
                }
                if(dato_modificar_usuario!=null && dato_modificar_usuario!="" && dato_modificar_clave!=null && dato_modificar_clave!="" && dato_modificar_tipo!=null && dato_modificar_tipo!="")
                {
                    Connection conexion = Postgres.conectar();
                    SesionQuery query=new SesionQuery(conexion);
                    if(query.buscar(dato_modificar_usuario))
                     {
                        if(query.actualizar(new SesionDto(dato_modificar_usuario, dato_modificar_clave, dato_modificar_tipo, dato_modificar_id)))
                        {
                             mensage_error="Datos actualizados";
                        }else{
                             mensage_error="Los datos no se pudieron modificar ";
                             request.setAttribute("dato_modificar",dato_modificar_confirmado);
                        }
                      }
                    conexion.close();
                }else{
                    mensage_error="Complete los campos";
                    request.setAttribute("dato_modificar",dato_modificar_confirmado );
                }
            }
           if(dato_eliminar!=null && dato_eliminar!="") // CONFIRMA LA ELIMINACION
           {
                Connection conexion = Postgres.conectar();
                SesionQuery query=new SesionQuery(conexion);
                SesionDto dto=query.buscarUsuario(dato_eliminar.trim());
                if(dto!=null)
                {
                        if(dto.getTipo().equals("adm_general"))
                         dato_tipo="Administrador General";
                         else if(dto.getTipo().equals("adm_pool"))
                         dato_tipo="Administrador del pool";
                         else if(dto.getTipo().equals("usuario"))
                         dato_tipo="Usuario normal";
                         else
                         dato_tipo="";
                        
                   contenido= "<div id=\"cajon2\"><div id=\"content_cajon_2\"><div id=\"datos\">"+
                              "<table width=\"450\" border=\"0\" >" +
                              "<tr><td>Usuario</td>" +
                              "    <td>"+dto.getUsuario()+"</td>" +
                              "</tr>"+
                              "<tr><td>Clave</td>" +
                              "    <td>"+dto.getClave()+"</td>" +
                              "</tr>"+
                              "<tr>" +
                              "    <td>Tipo</td>" +
                              "    <td>"+dato_tipo+"</td>" +
                              "</tr>"+
                              "</table>" +
                              "</div></div></div>";
                   mensage_error="Esta seguro que desea eliminar el Usuario \"" + dto.getUsuario() +"\"";

                   botones="<input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/eliminar.jpg\" value=\"true\" onclick=\"document.getElementById('dato_eliminar_confirmado').value='"+dto.getUsuario()+"';\" />" +
                   "<input name=\"dato_eliminar_confirmado\" type=\"hidden\" id=\"dato_eliminar_confirmado\" value=\"\" />"+
                   "<a href=\"usuarios.jsp\"> <img src=\"botones/cancelar.jpg\"  border=\"0\"> </a>";
                 }
                conexion.close();
           }else if(dato_modificar!=null && dato_modificar!="") // modifica los campos
               {

                Connection conexion = Postgres.conectar();
                SesionQuery query=new SesionQuery(conexion);
                SesionDto dto=query.buscarUsuario(dato_modificar.trim());
                if(dto!=null)
                {
                        if(dto.getTipo().equals("adm_general"))
                         dato_tipo="Administrador General";
                         else if(dto.getTipo().equals("adm_pool"))
                         dato_tipo="Administrador del pool";
                         else if(dto.getTipo().equals("usuario"))
                         dato_tipo="Usuario normal";
                         else
                         dato_tipo="";

                         contenido= "<div id=\"cajon2\"><div id=\"content_cajon_2\"><div id=\"datos\">"+
                           "<table width=\"450\" border=\"0\" >" ;
                           //"<tr><td>Datos</td>" +
                           //"</tr></dt>";
   
                         contenido = contenido +
                            "<tr><td>Usuario</td>" +
                            "    <td><input type=\"text\" name=\"dato_modificar_usuario\" value=\""+dto.getUsuario()+"\" />  </td>" +
                            "</tr>" +
                            "<tr><td>Clave</td>" +
                            "    <td><input type=\"text\" name=\"dato_modificar_clave\" value=\""+dto.getClave()+"\" />  </td>" +
                            "</tr>" +
                            "<tr><td>Tipo</td>" +
                            "    <td>" +
                            "    <SELECT  size=\"1\" name=\"dato_modificar_tipo\"> "+
                            "      <OPTION selected value=\"adm_general\">Administrador General</OPTION>" +
                            "      <OPTION selected value=\"adm_pool\">Administrador del pool</OPTION>" +
                            "      <OPTION selected value=\"usuario\">Usuario normal</OPTION>" +
                            "    </SELECT >" +
                            "    </td>" +
                            "    <input name=\"dato_modificar_id\" type=\"hidden\" id=\"dato_modificar_id\" value=\""+dto.getId()+"\" />  " +
                            "</tr>";

                         contenido= contenido +
                           "</table>" +
                           "</div></div></div>";

                        mensage_error="Esta seguro que desea modificar el Usuario \"" + dto.getUsuario() +"\"";

                        botones="<input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/aceptar.jpg\" value=\"true\" onclick=\"document.getElementById('dato_modificar_confirmado').value='"+dto.getUsuario()+"';\" />" +
                        "<input name=\"dato_modificar_confirmado\" type=\"hidden\" id=\"dato_modificar_confirmado\" value=\"\" />"+
                        "<a href=\"usuarios.jsp\"> <img src=\"botones/cancelar.jpg\"  border=\"0\"> </a>";
                     }
                    conexion.close();

               }else{

                   
                   busqueda="<div id=\"cajon1\">"+
                            "<table  border=\"0\" align=\"left\" class=\"titulo_content_cajon\">"+
                            "<tr><td>Usuario</td><td><label>"+
                            "<input name=\"usuario\" type=\"text\"  id=\"textfield\" size=\"7\"/>"+
                            "</label></td></tr>"+
                            "<tr><td height=\"34\">&nbsp;</td>"+
                            "<td><input name=\"buscar\" type=\"image\" id=\"buscar\" src=\"botones/buscar.jpg\" /></td></tr>"+
                            "</table>"+
                            "</div>";

                   botones= "<a href=\"nuevoUsuario.jsp\"> <img src=\"botones/nuevo.jpg\"  border=\"0\"> </a>";  //"<input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"imagenes/nuevo.jpg\" value=\"true\" />";
                            //<a href=\"modificar.jsp\"> <img src=\"botones/nuevo.jpg\"  border=\"0\"> </a>
                   Connection conexion = Postgres.conectar();

                   SesionQuery query=new SesionQuery(conexion);
                   List<SesionDto> list=query.list();
                   // "<table width=\"450\" height=\"150\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">" +

                   contenido= "<div id=\"cajon2\"><div id=\"content_cajon_2\"><div id=\"datos\">"+
                              "<table width=\"450\" border=\"0\" >" +
                              "<tr><td>Usuario</td>" +
                              "    <td>Clave</td>" +
                              "    <td>Tipo</td>" +
                              "</tr>";

                    if(list!=null);
                    {
                        for(int i=0;i<list.size();i++)
                        {
                         if(list.get(i).getTipo().equals("adm_general"))
                         dato_tipo="Administrador General";
                         else if(list.get(i).getTipo().equals("adm_pool"))
                         dato_tipo="Administrador del pool";
                         else if(list.get(i).getTipo().equals("usuario"))
                         dato_tipo="Usuario normal";
                         else
                         dato_tipo="";

                             contenido = contenido +
                                    "<tr><td>"+list.get(i).getUsuario()+"</td>" +
                                    "    <td>"+list.get(i).getClave()+"</td>" +
                                    "    <td>"+dato_tipo+"</td>" +
                                    "    <td><input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/modificar.gif\" value=\"true\" onclick=\"document.getElementById('dato_modificar').value='"+list.get(i).getUsuario()+"';\" />" +
                                    "    <input name=\"dato_modificar\" type=\"hidden\" id=\"dato_modificar\" value=\"\" />" +
                                    "    </td>" +
                                    "    <td></td>   " +
                                    "    <td><input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/eliminar.gif\" value=\"true\" onclick=\"document.getElementById('dato_eliminar').value='"+list.get(i).getUsuario()+"';\" />" +
                                    "    <input name=\"dato_eliminar\" type=\"hidden\" id=\"dato_eliminar\" value=\"\" />" +
                                    "    </td>" +
                                    "</tr>";
                        }
                    }
                                    // "<input name=\"imagen\" type=\"image\" id=\"imagen\" src=\"botones/guardar.jpg\" value=\"true\" onclick=\"document.getElementById('dato_guardar').value='true';\" />" +
                                    // "<input name=\"dato_guardar\" type=\"hidden\" id=\"dato_guardar\" value=\"\" />"+
                                    // "<a href=\"usuarios.jsp\"> <img src=\"botones/cancelar.jpg\"  border=\"0\"> </a>";

                    //<input type="text" name="" value="" />
                    contenido= contenido +
                               "</table>" +
                               "</div></div></div>";

                    query=null;
                    conexion.close();

    } // fin del else
    
    String ruta = getServletConfig().getServletContext().getRealPath("");
    String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_centro.html");
    t_maestra = Plantillas.reemplazar(t_maestra, "%javascript%", "");
    String t_contenido = Plantillas.leer(ruta + "/plantillas/platilla_contenido_configuracion.html");
    t_maestra = Plantillas.reemplazar(t_maestra, "%contenido%", t_contenido);
    t_maestra = Plantillas.reemplazar(t_maestra, "%titulo%", "Gestion de Usuario");
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
