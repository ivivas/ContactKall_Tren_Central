<%@page contentType="text/html" pageEncoding="ISO-8859-1" language = "java"
        import="java.sql.*"
        import="adportas.*"
        import="query.*" %>

<% response.setHeader("Pragma", "no-cache");%>
<% response.setHeader("Cache-Control", "no-cache");%>
<% response.setDateHeader("Expires", 0);%>
<% response.setDateHeader("max-age", 0);%>
<%

            String error = "";

            if (session.getAttribute("tipo") == null) {

                String ip_cliente = request.getRemoteAddr();
                String sistema_operativo = "";
                String navegador = "";
                String referencia = request.getHeader("referer");

                String userAgent = request.getHeader("user-agent");

                //Si ha submitido el formulario, valido los campos
                if (request.getParameter("user") != null && request.getParameter("password") != null) {
                    try {
                        try {
                            String tipo = null;
                            String usuario = request.getParameter("user").trim().toLowerCase();
                            String password = request.getParameter("password").trim().toLowerCase();
                            Connection conexion = SQLConexion.conectar();
                            if (conexion != null) {
                                PreparedStatement pst = conexion.prepareStatement("SELECT tipo, usuario FROM sesion WHERE usuario = ? and clave = ?");
                                pst.setString(1, usuario);
                                pst.setString(2, password);
                                ResultSet rs = pst.executeQuery();
                                if (rs.next()) {
                                    session.setAttribute("usuario", rs.getString("usuario"));
                                    session.setAttribute("tipo", rs.getString("tipo"));
                                    tipo = rs.getString("tipo");
                                }
                                /*if (tipo != null) {
                                    //session.setAttribute("id_usuario", "1");
                                    session.setAttribute("usuario", usuario);
                                    session.setAttribute("tipo", tipo);
                                    session.setMaxInactiveInterval(-600); // no expira

                                }*/
                            }
                            if (conexion != null) {
                                conexion.close();
                            }

                            //System.out.println(tipo);

                            if (tipo != null) {
                                response.sendRedirect("principal.jsp");
                                //out.println("<script>"); out.println("function regresar() { window.top.location.href=\'index.jsp\'; }"); out.println("</script>"); out.println("<body onload=\'regresar()\';>");
                            } else {
                                error = "Usuario y/o contrase&ntilde;a inv&aacute;lido(s)";
                                //out.println(userAgent.length());
                            }
                        } catch (Exception ee) {
                            error = ee.toString();
                        }
                    } catch (Exception e) {
                        error = e.toString();
                    }
                }
            } else {
                //Cierro la sesion, si ya estaba Iniciada.
                session.invalidate();
            }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <meta http-equiv="refresh" content="5;URL=http://172.16.56.158:8080/AcdKallControl"></meta>
        <title>.:: ::: Adportas AcdKall ::: ::.</title>
        <style type="text/css">
            <!--
            body {
                margin-left: 0px;
                margin-top: 0px;
                margin-right: 0px;
                margin-bottom: 0px;
                background-image: url(imagenes/franja.jpg);
            }
            .css {
            }
            .texto {
                font-family:Tahoma, Verdana, Arial;
                font-size:12px;
                color:#000000;
                font-weight:bold
            }
            .box {
                font-family: Tahoma, Verdana, Arial;
                font-size: 11px;
                color: #000000;
                border: 1px solid #999999;
            }
            -->
        </style>
        <script type="text/JavaScript">
            <!--
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }

            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                }

                function MM_findObj(n, d) { //v4.01
                    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                    if(!x && d.getElementById) x=d.getElementById(n); return x;
                }

                function MM_swapImage() { //v3.0
                    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                }
                //-->
        </script>
    </head>
    <body onLoad="MM_preloadImages('imagenes/entrar-over.jpg','imagenes/borrar-over.jpg'); document.forms.form1.user.focus()">

        <div style="margin:200px">
            <h3> En éste momento debido a un cambio en la aplicación, usted será redirigido a la nueva URL de la aplicación
            <a href="http://172.16.56.158:8080/AcdKallControl">AcdKallControl</a>
            </h3>
        </div>
    </body>
</html>
