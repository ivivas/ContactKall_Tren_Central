<%@page import="java.util.ResourceBundle"%>
<%@page import="query.ComboQuery"%>
<%@page import="query.AgenteQuery"%>
<%@page import="java.util.Calendar"%>
<%@page import="adportas.Fechas"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%


 response.setContentType ("application/vnd.ms-excel"); //Tipo de fichero.

            response.setHeader ("Content-Disposition", "attachment;filename=\"reporte.xls\"");
            try{

                String prueba = session.getAttribute("tabla").toString();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Reporte</title>

</head>

<body>
    <table border="1" class="caja">
                    <thead>
                        <tr>
                            <th>Id Cliente</th>
                            <th >Rut Cliente</th>
                            <th >Nombre Cliente</th>
                            <th >Apellido Cliente</th>
                            <th >Telefono Cliente</th>
                            <th >Fecha Ultimo Contacto</th>
                            <th >Campaña</th>
                            <th >Estado</th>
                            
                        </tr>
                        
                    </thead>
                    <tbody>
                       <%=session.getAttribute("tabla")%>
                    </tbody>
                </table>
                
</body>

</html>
<%
                                }
            catch(Exception e){
                response.sendRedirect("index.jsp");
            }
%>
