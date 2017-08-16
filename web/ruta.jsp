<%@page contentType="text/xml" 
        pageEncoding="UTF-8" 
        language="java"
        import="java.sql.*"
        import="java.util.Vector"
        import="java.util.List"
        import="java.util.ArrayList"
        import="adportas.*"
%>

<%
    /*Connection conexion = Postgres.conectar();
    //PreparedStatement pst = conexion.prepareStatement("SELECT * FROM secretaria order by estado desc, estado_uso asc, ultimo_uso desc");
    PreparedStatement pst = conexion.prepareStatement("SELECT * FROM pilotos");
    ResultSet rs = pst.executeQuery();*/
    String nombre = getServletConfig().getServletContext().getContextPath();
    String tipo = request.getProtocol();
    int puerto = request.getLocalPort();
    String ip = request.getLocalAddr();
    out.println("<rutas>");
    out.println("<protocolo>"+tipo+"</protocolo>");
    out.println("<ip>"+ip+"</ip>");
    out.println("<nombre>"+nombre+"</nombre>");
    out.println("<puerto>"+puerto+"</puerto>");
    out.println("</rutas>");
%>
