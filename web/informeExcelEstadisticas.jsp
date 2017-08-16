<%-- 
    Document   : informeExcel
    Created on : 17-jun-2009, 17:10:23
    Author     : Maxbel
--%>


<%@page import="com.sun.org.apache.xerces.internal.impl.dv.util.Base64"%>
<%@page contentType="application/vnd.ms-excel"  pageEncoding="ISO-8859-1"  language = "java"

        import="java.text.*"
        %>


<%
    response.setHeader("Content-Disposition", "attachment; filename=ReporteExcel.xls");

    String tabla = request.getParameter("tablaEstadisticasExcelMagio");

    out.println("<html><body><table>");

    out.println(tabla);

    out.println("</html></body></table>");


%>