<%-- 
    Document   : whispering
    Created on : 28-11-2014, 07:13:23 PM
    Author     : Felipe
--%>

<%@page import="clienteSocket.ClienteWhispering"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String extensionAgente = request.getParameter("numeroAgente");
            String devNameAgente = request.getParameter("devNameAgente");
            String extensionMonitor = request.getParameter("numeroMonitor");
            String devNameMonitor = request.getParameter("devNameMonitor");
            int tipo = request.getParameter("tipo") != null ? Integer.parseInt(request.getParameter("tipo").trim()): -1;
//soliencioso = 1,no sielncioso = 2, cortar= 0
            ClienteWhispering cliente = new ClienteWhispering( extensionMonitor, devNameMonitor, extensionAgente, devNameAgente, tipo);

        %>
    </body>
</html>
