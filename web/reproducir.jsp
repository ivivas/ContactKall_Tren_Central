<%@page import="query.AgenteQuery"%>
<%
    String datos;
%>
<html>
    <head>
        <title>.:: Contact Center ::.</title>
        <script>
            function navegador(){
        if(navigator.appVersion.indexOf("MSIE")!==-1){
            return 1;
        }
        else{
            return 0;
        }
    }
    if(navegador() === 0){
            <%
        datos = "escucha?wav=wav&rutaArchivo="+request.getParameter("ruta")+"&archivo="+request.getParameter("archivo");
            %>
        }else{
            <%
            datos = "escucha?rutaArchivo="+request.getParameter("ruta")+"&archivo="+request.getParameter("archivo");
        
            %>
                }
        </script>
    </head>
    <body>
    <%
//    out.print("<audio src='http://192.168.100.130:8080/RecKallPortal/Attachments/"+request.getParameter("archivo") +"'><p>Tu navegador no implementa el elemento audio.</p></audio>");
out.print("<audio controls=\"controls\" autoplay><source src='"+datos+"' type=\"audio/wav\" /></audio>");
%>
    </body>
</html>
