<%@page contentType="text/html" pageEncoding="ISO-8859-1" 
  import = "adportas.*"
        import = "java.sql.*"
        import = "java.util.*"
        import = "query.*"
        import = "DTO.*"
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Deshabilitacion de Telefonos</title>
        <script type="text/javascript" src="js/jquery.js"></script>
        <link href="css/estilos1.css" rel="stylesheet" type="text/css"  />
        <%
            String nombre = request.getParameter("nombre");
            String anexo = request.getParameter("anexo");
            
            ResourceBundle msgs;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }else{
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }

            Connection conexion = SQLConexion.conectar();

            ComboQuery comboQuery = new ComboQuery(conexion);
            Combo combo = comboQuery.getComboXNombre("combo_deshabilitacion_anexos");
            String nombreCombo =   combo != null ? combo.getNombre():"";
        %>
        <script >

            function x()
            {

                $('#numeroAnexo').html(<%=anexo%>);
            }
            function guardarValorEnCampoEscondido(){

                var motivo = $('#<%=nombreCombo%>').val();

                if(motivo=='Seleccione'){
                    alert('Por favor, seleccione una de las alternativas')
                }
                else{
                    var idElemento = 'motivo_deshabilitacion-<%=nombre%>';

                    window.opener.document.getElementById(idElemento).value=motivo;

                    this.close();
                }
            }

        </script>
    </head>
    <!--<body style="background-image:url(img/popup_web.jpg);" onload="x()">-->
    <body  onload="x()">

        <div id="popupMensaje">
            <div class="popupMensajeTexto"><%=msgs.getString("opcion.desh.msg")%> <span id="numeroAnexo"></span></div>
            <%
                  

                     if (combo != null) {

                               ArrayList<Opcion> listaOpciones = combo.getListaOpciones();
            %>
            <select id="<%=nombreCombo%>" name="<%=nombreCombo%>">
                <option value="Seleccione" ><%=msgs.getString("opcion.desh.opt.def")%></option>
                <%
                    for(int i = 0 ; i < listaOpciones.size() ; i ++)
                        {
                        Opcion opcion = listaOpciones.get(i);
                        %>
                 <option value="<%=opcion.getValor()%>" ><%=opcion.getTexto()%></option>
                <%
                    }
                %>
            </select>

            <%
                        }

            %>


           <%-- <select id="motivo" name="motivo">
                <option value="Seleccione" >Seleccione...</option>
                <option value="Almuerzo" >Almuerzo</option>
                <option value="Colación">Colación</option>
                <option value="Baño">Baño</option>
            </select>--%>
            <input type="button" style="background-image: url(img/btn_popup.gif);width:76px;height:21px;background-color:transparent; border: 0;" value="<%=msgs.getString("opcion.desh.btn.acep")%>" onclick="guardarValorEnCampoEscondido()">
        </div>
    </body>
</html>
