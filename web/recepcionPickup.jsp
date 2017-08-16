

<%@page import="clienteSocket.Cliente"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>JSP Page</title>
    </head>
    <body>
         <%
        String numeroRoutePoint = request.getParameter("numeroRoutePoint");
        String numeroSupervisor = request.getParameter("numeroSupervisor");
        Cliente cliente = new Cliente(numeroRoutePoint+";"+numeroSupervisor);

         %>
    </body>
</html>
