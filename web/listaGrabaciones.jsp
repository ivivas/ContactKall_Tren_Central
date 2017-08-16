<%@page import="DTO.Configuracion"%>
<%@page import="java.sql.Connection"%>
<%@page import="adportas.SQLConexion"%>
<%@page import="query.AgenteQuery"%>
<%@page import="DTO.Grabacion"%>
<%@page import="java.util.List"%>
<%@page import="query.Reckall"%>
<%
    Configuracion conf = Reckall.configuracionReckall();
%>
<html>
    <head>
<script>
    function reproducir(ruta,archivo){
        
        window.open("reproducir.jsp?ruta="+ruta+"&archivo="+archivo,'','height=70','width=150','resizable=no','location=no','toolbar=no','directories=no','menubar=no','status=no');
    }
</script>
    </head>
    <body>
        <a onclick="cerrarventana()" style="cursor:pointer;"><img src="imagenes/salir_bl.png"></a>
        <div id='loading' style='width:50px;height:30px;'></div>
<%
    Connection con = SQLConexion.conectar();
    String piloto = request.getParameter("piloto");
    String anexo = request.getParameter("anexo");
    int offset = Integer.valueOf(request.getParameter("offset"))<0?0:Integer.valueOf(request.getParameter("offset"));
        System.out.print("este es el offset: "+offset);

    List<Grabacion> grabaciones = Reckall.listaGrabaciones2(con,10, offset, anexo, "", "", "",1,piloto,"");

    StringBuilder sB = new StringBuilder();
    if(grabaciones.isEmpty()){
        sB.append("Sin Grabaciones");
    }
    else{
        sB.append("<table id='tabla'><th width='50'><img src='imagenes/numero.png'></th><th width='50'><img src='imagenes/contra.png'></th><th width='50'><img src='img/time.png'></th><th width='50'><img src='img/download.png'></th><th width='50'><img src='img/play2.gif'></th>");
        for(Grabacion grabacion : grabaciones){
            sB.append("<tr><td align='center'>");
            sB.append(grabacion.getNumeroRevisado());
            sB.append("</td><td align='center'>");
            sB.append(grabacion.getContraparte());
            sB.append("</td><td align='center'>");
            sB.append(grabacion.getDuracion());
            sB.append("</td><td align='center'>");
            sB.append("<a href='http://"+conf.getRutaPortal());
            sB.append(grabacion.getArchivo());
            sB.append("'><img src='img/download.png'></a>");
            sB.append("</td><td align='center'>");
            sB.append("<a href=\"#\" onclick='reproducir(\"");
            sB.append(conf.getRutaPortal()+"\",\""+grabacion.getArchivo());
            sB.append("\")'><img src='img/play2.gif'></a>");
            sB.append("</td></tr>");
        }
        sB.append("</table>");
    }
    out.print(sB.toString());
    out.print("<div id='next'><a onclick='anterior("+(offset-10)+")'><img src='imagenes/previous.png'></a>&nbsp;");
    out.print("<a onclick='siguiente("+(offset+10)+")'><img src='imagenes/next.png'></a></div>");
    sB = null;
    try{
    con.close();
    }
    catch(Exception e){}

    
%>
    </body>
</html>