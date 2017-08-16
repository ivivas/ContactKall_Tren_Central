<%@page import="adportas.Plantillas"%>
<%@page import="query.IvrEncuestaQry"%>
<%@page import="query.CallBackQry"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="query.ComboQuery"%>
<%
    ComboQuery ii = new ComboQuery();
    ResourceBundle msgs;
    if(session.getAttribute("msgs")==null){
        Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
        ResourceBundle.clearCache();
        msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
    }
    else{
        msgs = (ResourceBundle) session.getAttribute("msgs");
    }
    String sesionActual = (session.getAttribute("tipo") != null) ? session.getAttribute("tipo").toString() : "";
    if(sesionActual.equals("adm_general") | sesionActual.equals("supervisor")){
        
        IvrEncuestaQry ivrEn = new IvrEncuestaQry();
        String error ="";
        if(request.getParameterValues("datos")!=null){
            boolean validaEspera = true;
            String espera = request.getParameter("valors") != null ? request.getParameter("valors").trim() : "";
            if(!espera.equals("")){
                try{
                    Integer.parseInt(espera);
                }catch(Exception e){
                    validaEspera = false;
                }
            }else{
                validaEspera = false;
            }
            if(validaEspera){
                ii.modificarEspera(espera);
            }else{
                error += "Error en campo Intervalo Espera <br>";
            }
            String tiene = request.getParameter("tiene")==null?"off":request.getParameter("tiene");
            ii.modificarBienvenida(tiene);
            
            String tieneTitulos = request.getParameter("tieneTitulos")==null?"off" : request.getParameter("tieneTitulos");
            ii.modificarTitulos(tieneTitulos);
            
            String cbk = request.getParameter("callback") != null ? request.getParameter("callback").trim() : "";
            int intCbk = 0;
            boolean validaCbk=false;
            if(!cbk.equals("")){
                try{
                    intCbk = Integer.parseInt(cbk);
                }catch(Exception e){
                    validaCbk = true;
                }
            }else{
                validaCbk = true;
            }
            if(!validaCbk){
                CallBackQry.guardaCallBack(intCbk);
            }else{
                error += "Error en campo Callback <br>";
            }
            
            String encMin = request.getParameter("encMin") != null ? request.getParameter("encMin").trim() : "";
            String encMax = request.getParameter("encMax") != null ? request.getParameter("encMax").trim() : "";
            int iEncMin=0;
            int iEncMax=0;
            if(ivrEn.getIntegracion()){
                boolean validaIVR=true;
                if(!encMin.equals("") && !encMax.equals("")){
                    try{
                        iEncMin = Integer.parseInt(encMin);
                        iEncMax = Integer.parseInt(encMax);
                        if(iEncMin>=iEncMax){
                            validaIVR = false;
                        }
                    }catch(Exception e){
                        validaIVR = false;
                    }
                }else{
                    validaIVR = false;
                }
                if(validaIVR){
                    ivrEn.guardaRango(iEncMin, iEncMax);
                }else{
                    error+="Error en campo Intervalo IVR <br>";
                }
            }
        }
        
        String datos = ii.getEspera(msgs)[0];
        int maxCallBack = CallBackQry.buscaCallBack();
        String minMaxIvr="";
        if(ivrEn.getIntegracion()){
            minMaxIvr = "<div class=\"tabla_fondo\" style=\"margin-top: 1%;height: 14%;width:100%\">"
                        + "<div  style=\"float:left;width: 20%; padding-right: 1%;\" >"+msgs.getString("tag.encuesta.rango")+"</div>"
                    +"<div style=\"float:left;padding: 1%;\" class=\"answer\" onmouseover=\"mostrarToolKit(document.getElementById('t5'))\" onmouseout=\"ocultarToolKit(document.getElementById('t5'))\">"
                    +"<i class=\"fa fa-question-circle\"></i></div><div id=\"t5\" class=\"toolkit\" style=\"top:360px;left:600px;\">"
                    +msgs.getString("msg.otros.encuesta")+"</div>"
                    + "<div style=\"float:left;width:25%\"><div style=\"width:30%;float:left;\">"
                    + msgs.getString("tag.encuesta.minimo")+"</div><input style=\"width:auto\" size='3' type='text' name='encMin' id='encMin' value='"+ivrEn.getMinEncuesta()+"'> <br/>"
                    +"<div style=\"width:30%;float:left;\">"+ msgs.getString("tag.encuesta.maximo")+"</div><input style=\"width:auto\" size='3' type='text' name='encMax' id='encMax' value='"+ivrEn.getMaxEncuesta()+"'> </div></div>";
            
        }
        
        String tieneMusica = ii.getTieneMusica(msgs);
        String tieneTitulos = ii.getTieneTitulos(msgs);
        String divTitulos="<div id=\"titulo\">" + 
                        "<h2>%menu.adm.txt.otros%</h2>" +
                        "</div>";
        
        
        String ruta 	= getServletConfig().getServletContext().getRealPath("");
        String t_contenido = Plantillas.leer(ruta + "/plantillas/intervalo.html");
        
        if(!tieneTitulos.equals("")){
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", divTitulos );
            t_contenido = Plantillas.reemplazar(t_contenido,"%menu.adm.txt.otros%", msgs.getString("menu.adm.txt.otros") );
        }else{
            t_contenido = Plantillas.reemplazar(t_contenido,"%div_titulo%", "" );
        }
        
        t_contenido = Plantillas.reemplazar(t_contenido,"%dato1%",datos.split("&")[1]);
        t_contenido = Plantillas.reemplazar(t_contenido,"%dato0%",datos.split("&")[0]);
        t_contenido = Plantillas.reemplazar(t_contenido,"%lapso_seg%",msgs.getString("lapso.segundos"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tiene_musica%",msgs.getString("tiene.musica"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%check_musica%",tieneMusica);
        t_contenido = Plantillas.reemplazar(t_contenido,"%callback%",msgs.getString("tag.intervalo.callback"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%maxcallback%",maxCallBack+"");
        t_contenido = Plantillas.reemplazar(t_contenido,"%minmax_ivr%",minMaxIvr);
        t_contenido = Plantillas.reemplazar(t_contenido,"%btn_save%",msgs.getString("virtual.mod.btn.save"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%tiene_titulo%",msgs.getString("tiene.titulo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%check_musica%",tieneMusica);
        t_contenido = Plantillas.reemplazar(t_contenido,"%check_titulo%",tieneTitulos);
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_intervalo%",msgs.getString("msg.otros.intervalo"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_bienvenida%",msgs.getString("msg.otros.bienvenida"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_titulo%",msgs.getString("msg.otros.titulos"));
        t_contenido = Plantillas.reemplazar(t_contenido,"%msg_callback%",msgs.getString("msg.otros.callback"));
        
        
        String t_menu = Plantillas.leer(ruta + "/plantillas/menu_cc_config.html");
        
        t_menu = Plantillas.reemplazar(t_menu,"%class_user%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_extn%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_nvirtual%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_monitor%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_cti%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_horario%","botones");
        t_menu = Plantillas.reemplazar(t_menu,"%class_otros%","botonesactive");
        
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.usuarios%",msgs.getString("menu.adm.txt.usuarios"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.extensiones%",msgs.getString("menu.adm.txt.extensiones"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.numeroVirtual%",msgs.getString("menu.adm.txt.numeroVirtual"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.monitores%",msgs.getString("menu.adm.txt.monitores"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.ctiPort%",msgs.getString("menu.adm.txt.ctiPort"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.horario%",msgs.getString("menu.adm.txt.horario"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.otros%",msgs.getString("menu.adm.txt.otros"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.volver%",msgs.getString("menu.adm.txt.volver"));
        t_menu = Plantillas.reemplazar(t_menu,"%menu.adm.txt.salir%",msgs.getString("menu.adm.txt.salir"));
        
        String t_javascript = Plantillas.leer(ruta + "/js/intervalo.js");
        
        String t_maestra = Plantillas.leer(ruta + "/plantillas/plantilla_contact.html");
        
        t_maestra = Plantillas.reemplazar(t_maestra,"%javascript%",t_javascript);
        t_maestra = Plantillas.reemplazar(t_maestra,"%contenido%",t_contenido);
        t_maestra = Plantillas.reemplazar(t_maestra,"%menu%", t_menu);
        t_maestra = Plantillas.reemplazar(t_maestra,"%css%", "");
        
        out.println(t_maestra);
    }else{
        response.sendRedirect("index.jsp");
    }
%>