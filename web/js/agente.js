    $(document).ready(function(){
        setInterval("getCola()",3000);
        if($("#tieneAutoRefresco").val()==="si"){
             refrescarDiv();
        }

        if($("#piloto").val() === ""){
            $("#infoCampanas").hide();
            $("#alertas").hide();
        }else{
            $("#alertas").show();
            $("#infoCampanas").show();
            getCola();
            getAgentes();
        }
        
        $("#panelAgenteCampana").hide();
        $("#ventanaWhispering").hide();
        $("#asignarCampanaPool").hide();
        $("#listaGrabaciones").hide();
        $("#navegador").hide();
        
        $("#llamadaGral").click(function(){
            $("#divGraficosDetalle").css("display","block");
            $("#llamadaContestada").css("visibility","visible");
            $("#llamadaPerdida").css("visibility","visible");
        });
        
        $("[name='campana']").click(function(){
            $("#asignarCampanaPool").show();    
        });
        
        $("#asignarCampanaPool").click(function(){
            $("#panelAgenteCampana").load("AgentesDisponibles?id="+$("[name='campana']:checked").val()+"&text=info");
            $("#panelAgenteCampana").show();    
        });
        
        $("#nuevaPestania").click(function(){
            var cantidad = $("#aqui iframe").length;
            if(cantidad<5){
                $(".headers").append("<span class='head' id='head"+cantidad+"' draggable='true' ondragstart='transferirPagina(event,this)' onclick='hacerVisible(this)'>%nueva_pestaña%<span onclick='cerrar(head"+cantidad+")'>X</span></span>");
                $("#aqui").append("</div><input class='caja' type='text' id='caja"+cantidad+"' onkeypress='navegar(event,this)'><iframe class='pestaña' id='pestaña"+cantidad+"'>");
            }
            $("#divGraficos").hide();
        });
        $("#panel").hide();
        
        
        $("#llamadaGral").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/diario/promedioGralLlamada"+$("#piloto").val()+".jpg')");
                $("#panel").show();
            }
        });
        $("#llamadaGral").mouseout(function(){
            $("#panel").hide();
        });
        $("#salirCampana").click(function(){
            $("#panelAgenteCampana").hide();
        });
        $("#promedioRingeo").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/mensual/promedioRingeo"+$("#piloto").val()+".jpg')");
                $("#panel").show();
            }
        });
        $("#promedioRingeo").mouseout(function(){
            $("#panel").hide();
        });
        $("#promedioLlamada").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/mensual/promedioLlamada"+$("#piloto").val()+".jpg')");
                $("#panel").show();
            }
        });
        $("#promedioLlamada").mouseout(function(){
            $("#panel").hide();
        });
        $("#piloto").change(function(){
            if($("#piloto").val()!==""){
                $("#infoCampanas").show();
                $("#alertas").show();
                $("#llamadaGral").attr("src","imagenes/diario/promedioGralLlamada"+$("#piloto").val()+".jpg");
                $("#llamadaPerdida").attr("src","imagenes/diario/llamadaPerdida"+$("#piloto").val()+".jpg");
                $("#llamadaContestada").attr("src","imagenes/diario/llamadaContestada"+$("#piloto").val()+".jpg");
                $("#promedioRingeo").attr("src","imagenes/mensual/promedioRingeo"+$("#piloto").val()+".jpg");
                $("#promedioLlamada").attr("src","imagenes/mensual/promedioLlamada"+$("#piloto").val()+".jpg");
                getCola();
                getAgentes();
            }else{                
                $("#infoCampanas").hide();
                $("#alertas").hide();
                $("#llamadaPerdida").attr("src","imagenes/nada.jpg");
                $("#llamadaContestada").attr("src","imagenes/nada.jpg");
                $("#promedioRingeo").attr("src","imagenes/nada.jpg");
                $("#promedioLlamada").attr("src","imagenes/nada.jpg");
            }
        });
        if($("#piloto").val()!==""){
            $("#llamadaPerdida").attr("src","imagenes/diario/llamadaPerdida"+$("#piloto").val()+".jpg");
            $("#llamadaGral").attr("src","imagenes/diario/promedioGralLlamada"+$("#piloto").val()+".jpg");
            $("#llamadaContestada").attr("src","imagenes/diario/llamadaContestada"+$("#piloto").val()+".jpg");
            $("#promedioRingeo").attr("src","imagenes/mensual/promedioRingeo"+$("#piloto").val()+".jpg");
            $("#promedioLlamada").attr("src","imagenes/mensual/promedioLlamada"+$("#piloto").val()+".jpg");
        }
    });
    
    function refrescarDiv(){
        setInterval("getAgentes()",3000);
    }
    function expandir(obj){
        var whispering = enlaceMonitoreowhispering();
        var silencioso = enlaceMonitioreoSilencioso();
        var escuchar = enlaceGrabacion();
        var conferecia = enlaceConferencia();
        var robar = enlaceRobarLlamada();
        var hd = enlaceEnableDisable();
        
        $("#ppal").html(obj.innerHTML+"<div id='panelSalir'><a onclick='exit()' href='#'><img src=\"imagenes/salir.png\"></a></div>"
                    +"<div id='silencioso' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +silencioso
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_silence%</div>"
                    +"</div>"
                    +"<div id='whispering' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +whispering
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_coach%</div>"
                    +"</div>"
                    +"<div id='conf' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +conferecia
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_conf%</div>"
                    +"</div>"
                    +"<div id='robar' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +robar
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_robar%</div>"
                    +"</div>"
                    +"<div id='hd' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +hd
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_habili%</div>"
                    +"</div>"
                    +"<div id='escuchar' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>"
                    +escuchar
                    +"<div id='t1' class='toolkit' style='font-size:15px;' >%msg_grab%</div>"
                    +"</div>");
            var nombre = obj.getAttribute('nombre').split("-")[1];
            var numero = obj.getAttribute('nombre').split("-")[0];
                    
        $("#ppal").children(".encabezado").html($("#ppal").children(".imagenEst").html()+"<div style='margin: 0px auto; width: 60%;padding-top:3%;line-height:140%;'>"+nombre+" <br> "+numero+"</div>");
        $("#ppal").children(".encabezado").children("img").css("float","left");
        $("#ppal").children(".encabezado").children("img").css("margin","3% 0 0 20%");
        $("#ppal").children(".encabezado").children("img").css("width","auto");
        //$("#ppal").children(".encabezado").children("img").css("padding-top","3%");
        $("#ppal").children(".imagenEst").html("");
        
        $("#ppal").children(".indicador").children("#perdida_ag").children("img").attr("src","imagenes/perdida_gr.png");
        $("#ppal").children(".indicador").children("#recibida_ag").children("img").attr("src","imagenes/recibida_gr.png");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children("img").attr("src","imagenes/performance_gr.png");
        $("#ppal").children(".indicador").children("#ringeo_ag").children("img").attr("src","imagenes/ring_gr.png");
        $("#ppal").children(".indicador").children("#contesto_ag").children("img").attr("src","imagenes/call_gr.png");
        
        $("#ppal").children(".encabezado").css("border-top-left-radius","1%");
        $("#ppal").children(".encabezado").css("border-top-right-radius","1%");
        $("#ppal").children(".encabezado").css("height","33%");
        $("#ppal").children(".imagenEst").css("height","33%");
        $("#ppal").children(".imagenEst").css("width","0");
        $("#ppal").children(".indicador").css("height","33%");
        $("#ppal").children(".indicador").css("width","99.8%");
        $("#ppal").children(".imagenEst").children("img").css("margin-top","5%");
        
        $("#ppal").children(".indicador").children("#perdida_ag").css("border-bottom","none");
        $("#ppal").children(".indicador").children("#perdida_ag").css("border-right","1px solid #c6c6c5");
        $("#ppal").children(".indicador").children("#perdida_ag").css("height","70%");
        $("#ppal").children(".indicador").children("#perdida_ag").css("margin-top","3%");
        $("#ppal").children(".indicador").children("#perdida_ag").css("width","20%");
        $("#ppal").children(".indicador").children("#perdida_ag").css("margin-left","0");
        $("#ppal").children(".indicador").children("#perdida_ag").children("img").css("float","none");
        $("#ppal").children(".indicador").children("#perdida_ag").children(".texto").css("float","none");
        $("#ppal").children(".indicador").children("#perdida_ag").children(".texto").css("width","90%");
        $("#ppal").children(".indicador").children("#perdida_ag").children(".texto").css("margin-top","10%");
        $("#ppal").children(".indicador").children("#perdida_ag").children("#t1").css("font-size","15px");

        $("#ppal").children(".indicador").children("#recibida_ag").css("border-bottom","none");
        $("#ppal").children(".indicador").children("#recibida_ag").css("border-right","1px solid #c6c6c5");
        $("#ppal").children(".indicador").children("#recibida_ag").css("height","70%");
        $("#ppal").children(".indicador").children("#recibida_ag").css("margin-top","3%");
        $("#ppal").children(".indicador").children("#recibida_ag").css("width","20%");
        $("#ppal").children(".indicador").children("#recibida_ag").css("margin-left","0");
        $("#ppal").children(".indicador").children("#recibida_ag").children("img").css("float","none");
        $("#ppal").children(".indicador").children("#recibida_ag").children(".texto").css("float","none");
        $("#ppal").children(".indicador").children("#recibida_ag").children(".texto").css("width","90%");
        $("#ppal").children(".indicador").children("#recibida_ag").children(".texto").css("margin-top","10%");
        $("#ppal").children(".indicador").children("#recibida_ag").children("#t1").css("font-size","15px");
        

        $("#ppal").children(".indicador").children("#rendimiento_ag").css("border-bottom","none");
        $("#ppal").children(".indicador").children("#rendimiento_ag").css("border-right","1px solid #c6c6c5");
        $("#ppal").children(".indicador").children("#rendimiento_ag").css("height","70%");
        $("#ppal").children(".indicador").children("#rendimiento_ag").css("margin-top","4%");
        $("#ppal").children(".indicador").children("#rendimiento_ag").css("width","20%");
        $("#ppal").children(".indicador").children("#rendimiento_ag").css("margin-left","0");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children("img").css("float","none");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children(".texto").css("float","none");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children(".texto").css("width","90%");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children(".texto").css("margin-top","10%");
        $("#ppal").children(".indicador").children("#rendimiento_ag").children("#t1").css("font-size","15px");

        $("#ppal").children(".indicador").children("#ringeo_ag").css("border-bottom","none");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("border-right","1px solid #c6c6c5");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("height","70%");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("margin-top","3%");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("width","19%");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("margin-left","0");
        $("#ppal").children(".indicador").children("#ringeo_ag").css("float","left");
        $("#ppal").children(".indicador").children("#ringeo_ag").children("img").css("float","none");
        $("#ppal").children(".indicador").children("#ringeo_ag").children(".texto").css("float","none");
        $("#ppal").children(".indicador").children("#ringeo_ag").children(".texto").css("width","90%");
        $("#ppal").children(".indicador").children("#ringeo_ag").children(".texto").css("margin-top","10%");

        $("#ppal").children(".indicador").children("#contesto_ag").css("border-bottom","none");
        $("#ppal").children(".indicador").children("#contesto_ag").css("height","70%");
        $("#ppal").children(".indicador").children("#contesto_ag").css("margin-top","3%");
        $("#ppal").children(".indicador").children("#contesto_ag").css("width","19%");
        $("#ppal").children(".indicador").children("#contesto_ag").css("margin-left","0");
        $("#ppal").children(".indicador").children("#contesto_ag").css("float","left");
        $("#ppal").children(".indicador").children("#contesto_ag").children("img").css("float","none");
        $("#ppal").children(".indicador").children("#contesto_ag").children(".texto").css("float","none");
        $("#ppal").children(".indicador").children("#contesto_ag").children(".texto").css("width","90%");
        $("#ppal").children(".indicador").children("#contesto_ag").children(".texto").css("margin-top","10%");
        
        $("#ppal").css("visibility","visible");
    }
    function cerrarventana(){
        $("#realListaGrabaciones").text("Cargando...");
        $("#listaGrabaciones").hide();
    }
    function robar(){
        //$("#robar").load("InterceptarLlamada?numeroLadron="+$("#supervisor").val()+"&numeroVictima="+$("#ppal #numeroAgente").val());
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'InterceptarLlamada',
            data:"numeroLadron="+$("#supervisor").val()+"&numeroVictima="+$("#ppal #numeroAgente").val(),
            timeout:4000,
            success:
                function(datos){
                }
        });
    }
    function hd(dato){
        if(dato==="super"){
            //$("#hd").load("HabilitarDesabilitar?anexo="+$("#ppal #numeroAgente").val());
            var texto = habilitaAjax($("#ppal #numeroAgente").val());
            //alert('texto: '+texto);
            if(texto === 'true'){
                alert($("#respuestaPaso").val());
            }else{
                alert('Error...');
            }
            
            
            var img = $("#ppal .encabezado img").attr("src");
            if(img === 'imagenes/on.png'){
                $("#ppal .encabezado img").attr("src",'imagenes/off.png');
            }else if(img === 'imagenes/off.png'){
                $("#ppal .encabezado img").attr("src",'imagenes/on.png');
            }   
        }else{
            $("#hd").load("HabilitarDesabilitar?anexo="+$("#anexo").val()+"&op=op");
            if($("#estadox").text() === "Habilitado"){
                $("#estadox").text("Desabilitado");
            }
            else{
                $("#estadox").text("Habilitado");
            }
            
        }
    }
    function habilitaAjax(anexo){
        var retorno = '';
        $.ajax({
            async:false,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'HabilitarDesabilitar',
            data:"anexo="+anexo,
            timeout:4000,
            success:
                function(datos){
                    //retorno = datos.html();
                    $("#respuestaPaso").val(datos);
                    retorno = 'true';
                }
        });
        return retorno;
    }
    function getCola(){
        if($("#piloto") !== ""){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'Cola',
            data:"piloto="+$("#piloto").val(),
            timeout:4000,
            success:
                function(datos){
                    //location.reload();
                    $("#colaLlamadas").html(datos);
                }
        });
    }
    }
    function getAgentes(){
        $("#carga").ajaxStart(function(){
            $(this).text("%cargando%");
        });
        $("#carga").ajaxStop(function(){
            $(this).text("");
        });
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'ContenedorAgente',
            data:'piloto='+$('#piloto').val()+"&multiple=true",
            timeout:4000,
            success:
               function(datos){
                    $("#contenedor_ag").html(datos);
                }
        });
        setTimeout(function(){},1000);
    }
    function enlaceRobarLlamada(){
        return "<a href='#' id='robar_' onClick='robar()'><img style=\"width:100%\" src='imagenes/robar.png'></a>";
    }
    function enlaceEnableDisable(){
        return "<a href=\"#\" onClick=\"hd('super')\"><img style=\"width:100%\" src='imagenes/habilitar.png'></a>";
    }
    function enlaceMonitioreoSilencioso(){
        return "<a href='#' onClick='abrir(1)'><img style=\"width:100%\" src='imagenes/monitor.png'></a>";
    }
    function enlaceConferencia(){
        return "<a href='#' id='conferencia' onClick='conferencia()'><img style=\"width:100%\" src='imagenes/conferencia.png'></a>";
    }
    function enlacePickup(){
        return "<br><a href='#' id='pickup' onClick='pickup()'>Pickup</a><br>";
    }
    function enlaceDeshabilitar(){
        return "<a href='#' onClick='desabilitar()'><img src='imagenes/x.gif'></a>";
    }
    function pickup(){
       $("#divPickup").load("recepcionPickup.jsp?numeroRoutePoint="+$("#piloto").val()+"&numeroSupervisor="+$("#anexo").val());
    }
    function conferencia(){
       $("#divConf").load("Conferencia?numeroAgente="+$("#ppal #numeroAgente").val()+"&monitor="+$("#supervisor").val());
    }
    function enlaceGrabacion(){
        return "<a href='#' onClick='abrirGrabaciones()' ><img style=\"width:100%\" src='imagenes/rep.png'></a><br>";
    }
    function abrirGrabaciones(){
        $("#realListaGrabaciones").load("listaGrabaciones.jsp?anexo="+$("#ppal #numeroAgente").val()+"&offset=0&piloto="+$("#piloto").val());
        $("#listaGrabaciones").show();
        $("#realListaGrabaciones").show();
        $("#loading").ajaxStart(function(){
            $(this).text("%cargando%");
        });
    }
    function enlaceMonitoreowhispering(){
        return "<a href='#' onClick='abrir(2)'><img style=\"width:100%\" src='imagenes/couching.png'></a>";
    }
    function enlaceCortarWhispering(){
        return "<a href='#' onClick='abrir(0)'><img src='imagenes/stop.gif'></a>";
    }
    
    
    function abrir(accion){
        var img = $("#ppal #silencioso a img").attr("src");
        var img2 = $("#ppal #whispering a img").attr("src");
        //alert('img2: '+img2);
        if(accion === 1){
            if(img === 'imagenes/monitor.png'){
                $("#ppal #silencioso a img").attr("src","imagenes/monitor_over.png");
            }else{
               accion = '0'; 
               $("#ppal #silencioso a img").attr("src","imagenes/monitor.png");
            }
        }else if(accion === 2){
            if(img2 === 'imagenes/couching.png'){
                $("#ppal #whispering a img").attr("src","imagenes/couching_over.png");
            }else{
               accion = '0'; 
               $("#ppal #whispering a img").attr("src","imagenes/couching.png");
            }
        }
        
        $("#ventanaWhispering").show();
        $("#ventanaWhispering").load("Whispering?tipo="+accion+"&devNameAgente="+$("#ppal #devNameAgente").val()+"&numeroAgente="+$("#ppal #numeroAgente").val()+"&monitor="+$("#supervisor").val());
        setTimeout(function(){
            $("#ventanaWhispering").html("");
            $("#ventanaWhispering").hide();
        },4000);
    }
    function cerrar(){
        $("#ventanaWhispering").hide();
    }
    function exit(){
       $("#ppal").css("visibility","hidden");
    }  
    function siguiente(offset){
        $("#realListaGrabaciones").load("listaGrabaciones.jsp?anexo="+$("#ppal #numeroAgente").val()+"&offset="+offset);
    }
    function anterior(offset){
        $("#realListaGrabaciones").load("listaGrabaciones.jsp?anexo="+$("#ppal #numeroAgente").val()+"&offset="+offset);
    }
    function navegar(e,obj){
        if($(obj).val()!==""){
            var id = $(obj).attr("id").replace("caja","pestaña");
            var head = $(obj).attr("id").replace("caja","head");
            if(e.keyCode===13){
                if($(obj).val().contains("www")){
                    $("#"+head).html($(obj).val()+" <span onclick='cerrar("+head.toString()+")'>X</span>");
                    $("#"+id).attr("src","http://"+$(obj).val());   
                }
                else{
                    $("#"+head).html("www."+$(obj).val()+" <span onclick='cerrar("+head.toString()+")'>X</span>");
                    $("#"+id).attr("src","http://www."+$(obj).val());
                }
            }
        }
    }
    function cerrar(obj){
        obj.remove();
        var idPestana = $(obj).attr("id").replace("head","pestaña");
        var idCaja = $(obj).attr("id").replace("head","caja");
        $("#"+idPestana).remove();
        $("#"+idCaja).remove();
        var pestanas = $(".pestaña").length;
        if(pestanas===0){
            $("#divGraficos").show();
        }
    }
    function hacerVisible(obj){
        var idPestana = $(obj).attr("id").replace("head","pestaña");
        var idCaja = $(obj).attr("id").replace("head","caja");
        $(".pestaña").css("z-index","0");
        $(".caja").css("z-index","0");
        $("#"+idPestana).css("z-index","1");
        $("#"+idCaja).css("z-index","1");
    }
    function transferirPagina(ev,obj){
        ev.dataTransfer.setData("text", $(obj).text().substring(0,$(obj).text().length-1));
    }
    function recibirData(ev,obj) {
        var data = ev.dataTransfer.getData("text");
        if(data.contains("www")){
            ev.preventDefault();
            alert("enviando url "+data+" a "+$("#numeroAgente",obj).val());
        }
        else{
            ev.preventDefault();
        }
    }
    function allowDrop(ev) {
        ev.preventDefault();
    }
    function refrescarUrl(){
        var x = document.getElementById("pestaña0").src;
        alert(x);
        $("#caja0").text(x);
    }
    function cargarCola(){
        $("#alertas").load("Cola?piloto="+$("#piloto").val());
    }
    function salirDetalle(obj){
        $("#divGraficosDetalle").css("display","none");
        $("#llamadaPerdida").css("visibility","hidden");
        $("#llamadaContestada").css("visibility","hidden");
    }
    function modificar(xxx){
        var id = $(this).attr("name");
        if(id===""){
            id=$("#id").val();
        }
        var ids = "";
        $("#panelAgenteCampana :checkbox:checked").each(function(){
           ids += $(this).val()+"-"; 
        });
        var cli = "";
        $("#panelAgenteCampana div").each(function(){
            cli += $(this).attr("id")+"--";
        });
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'ModificarCampana',
            data:'campana='+xxx+'&modificar=agente&ids='+ids+'&clientes='+cli,
            timeout:4000,
            success:
                function(datos){
                    location.reload();
                    $("#respuestaAgregar").text("datos");
                }
        });
        $("#contenedorCampana").hide();
    }
    function abrirVentana(){
        window.open('subirCSV.jsp','clientes','status=yes,width=300,height=250,menubar=yes,scrollbars=yes');
    }
    function quitar(obj){
        $(obj).remove();
    }
    function ocultar(){
        $("#panelAgenteCampana").hide();
    }
    function pruebaLogOut(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'LogOut',
            data:'anexo='+$("#usuario").val(),
            timeout:4000,
            success:
                function(datos){
                    window.location.href="index.jsp";
                }
        });
    }
    
    function mostrarToolKit(target){
        var elemnet = target.firstChild;
        while(elemnet.id !== 't1'){
            elemnet = elemnet.nextSibling;
        }
        elemnet.style.visibility = "visible";
        elemnet.style.display = "block";
    }

    function ocultarToolKit(target){
        var elemnet = target.firstChild;
        while(elemnet.id !== 't1'){
            elemnet = elemnet.nextSibling;
        }
        elemnet.style.visibility = "hidden";
        elemnet.style.display = "none";
    }
