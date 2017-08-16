<%-- 
    Document   : principal
    Created on : 15-04-2009, 06:03:58 PM
    Author     : max
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1" language = "java"
    import="java.sql.*"
    import="adportas.*"
%>

<%
    String sesionActual = (session.getAttribute("tipo")!=null) ? session.getAttribute("tipo").toString() : "";
    String usuario="";
    usuario =(String) session.getAttribute("usuario");

    Connection conexion = SQLConexion.conectar();
    Statement st = conexion.createStatement();

    int mIT=0;
    try{
        String query = "SELECT maximo_intervalo_inactividad FROM sesion WHERE usuario='" + usuario.trim() +"' limit 1";
        String nombreBDSQLServer = "Microsoft SQL Server";
        if(nombreBDSQLServer.equalsIgnoreCase(conexion.getMetaData().getDatabaseProductName()) ){
            query = "SELECT top(1) maximo_intervalo_inactividad FROM sesion WHERE usuario='" + usuario.trim();
        }
        ResultSet rsAnexo = st.executeQuery(query);
        if (rsAnexo.next()) {
            Object aux = rsAnexo.getInt("maximo_intervalo_inactividad");
            mIT = aux != null?(Integer)aux:0 ;
        }
        rsAnexo.close();

    } catch (Exception e) {
        e.toString();
    }
    st.close();
    conexion.close();

    if(mIT !=0 ){
        session.setMaxInactiveInterval(mIT);
    }
    if (sesionActual.equalsIgnoreCase("adm_general")) {
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/pagina.html");
        out.println(t_contenido);
    }else if(sesionActual.equalsIgnoreCase("adm_pool")){
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/pagina.html");
        out.println(t_contenido);
    }else if(sesionActual.compareTo("usuario")==0){
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/pagina.html");
        out.println(t_contenido);
    }else if(sesionActual.compareTo("supervisor")==0){
        String ruta = getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/pagina.html");
        out.println(t_contenido);
    }else {
        out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
    }


    


%>