<%-- 
    Document   : asignar_piloto
    Created on : 04-11-2015, 18:00:20
    Author     : Adportas
--%>

<%@page import="query.ComboQuery"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title></title>
        <link href="css/estilos1.css" rel="stylesheet" type="text/css"  />
        <script>
        </script>
    </head>
    <body  onunload="window.opener.location.reload()">
        <form action="asignar_piloto.jsp">
            <input type="hidden" value="<%=request.getParameter("id")%>" name="ids">
            <div id="popupMensaje">
        <% 
            String id = request.getParameter("id");
            Connection con = SQLConexion.conectar();
            if(request.getParameter("ok")!=null){
                String[] nuevos = request.getParameterValues("pilotos");
                if(nuevos!=null){
                    for(int i = 0 ;  i < nuevos.length ; i ++){
                        try{
                        PreparedStatement pst = con.prepareStatement("insert into pilotos_monitores (id,id_piloto,id_monitor) values (nextval('pilotos_monitores_id_seq'),"+nuevos[i]+","+request.getParameter("ids")+")");  
                        pst.execute();
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }
                    }
                }
            }
            String datosParaIN = ComboQuery.pilotosYaControldados();
            String query = "select * from pilotos where id not in("+datosParaIN+")";
            if(datosParaIN.equals("")){
                query = "select * from pilotos";
            }
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();
            boolean noHayPilotos = true;
            while(rs.next()){
                noHayPilotos =false;
                out.println("<input name='pilotos' type='checkbox' value='"+rs.getString("id")+"'> "+rs.getString("piloto")+" - "+rs.getString("descripcion") +"<br>");
            }
            pst.close();
            rs.close();
            con.close();
        %>
        <%
            if(noHayPilotos){
                out.print("No hay pilotos disponibles");
            }
            else{
                %>
        <input type="submit" name="ok" value="Agregar">
         <%  }     %>
            </div>
            
        </form>
    </body>
</html>
