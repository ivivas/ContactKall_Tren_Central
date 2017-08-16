    $(document).ready(function(){
        setInterval("cargarCola()",3000);
        if($("#tieneAutoRefresco").val()==="si"){
             //getAgentes();
             refrescarDiv();
        }

        if($("#piloto").val() === ""){
            $("#infoCampanas").hide();
            $("#alertas").hide();
        }
        else{
            $("#alertas").show();
            $("#infoCampanas").show();
        }
        $("#panelAgenteCampana").hide();
        $("#ventanaWhispering").hide();
        $("#asignarCampanaPool").hide();
        $("#listaGrabaciones").hide();
        //$("#listaGrabaciones").load("listaGrabaciones.jsp?anexo=0&offset=0");
        $("#caluga").click(function(){
            expandir(obj);
        });
        $("#llamadaGral").click(function(){
            $("#divGraficosDetalle").css("display","block");
            $("#llamadaContestada").css("visibility","visible");
            $("#llamadaPerdida").css("visibility","visible");
            //$("#llamadaGral").unbind("mouseover");
        });
        $("[name='campana']").click(function(){
            $("#asignarCampanaPool").show();    
        });
        $("#asignarCampanaPool").click(function(){
            $("#panelAgenteCampana").load("AgentesDisponibles?id="+$("[name='campana']:checked").val()+"&text=info");
            $("#panelAgenteCampana").show();    
        });
        $("#navegador").hide();
        $("#nuevaPestania").click(function(){
            var cantidad = $("#aqui iframe").length;
            if(cantidad<5){
                $(".headers").append("<span class='head' id='head"+cantidad+"' draggable='true' ondragstart='transferirPagina(event,this)' onclick='hacerVisible(this)'>%nueva_pestaña%<span onclick='cerrar(head"+cantidad+")'>X</span></span>");
                $("#aqui").append("</div><input class='caja' type='text' id='caja"+cantidad+"' onkeypress='navegar(event,this)'><iframe class='pestaña' id='pestaña"+cantidad+"'>");
            }
            $("#divGraficos").hide();
        });
        $("#panel").hide();
        
//        $("#llamadaPerdida").mouseover(function(){
//            if($("#piloto").val()!==""){
//                $("#panel").hide();
//                $("#panel").css("background-image","url('imagenes/llamadaPerdida"+$("#piloto").val()+".jpg')");
//                $("#panel").show();
//            }
//        });
//        $("#llamadaPerdida").mouseout(function(){
//            $("#panel").hide();
//        });
        $("#llamadaGral").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/promedioGralLlamada"+$("#piloto").val()+".jpg')");
                $("#panel").show();
            }
        });
        $("#llamadaGral").mouseout(function(){
            $("#panel").hide();
        });
//        $("#llamadaContestada").mouseover(function(){
//             if($("#piloto").val()!==""){
//                $("#panel").hide();
//                $("#panel").css("background-image","url('imagenes/llamadaContestada"+$("#piloto").val()+".jpg')");
//                $("#panel").show();
//            }
//        });
//        $("#llamadaContestada").mouseout(function(){
//            $("#panel").hide();
//        });
        $("#salirCampana").click(function(){
            $("#panelAgenteCampana").hide();
        });
        $("#promedioRingeo").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/promedioRingeo"+$("#piloto").val()+".jpg')");
                $("#panel").show();
            }
        });
        $("#promedioRingeo").mouseout(function(){
            $("#panel").hide();
        });
        $("#promedioLlamada").mouseover(function(){
            if($("#piloto").val()!==""){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/promedioLlamada"+$("#piloto").val()+".jpg')");
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
                $("#llamadaGral").attr("src","imagenes/promedioGralLlamada"+$("#piloto").val()+".jpg");
                $("#llamadaPerdida").attr("src","imagenes/llamadaPerdida"+$("#piloto").val()+".jpg");
                $("#llamadaContestada").attr("src","imagenes/llamadaContestada"+$("#piloto").val()+".jpg");
                $("#promedioRingeo").attr("src","imagenes/promedioRingeo"+$("#piloto").val()+".jpg");
                $("#promedioLlamada").attr("src","imagenes/promedioLlamada"+$("#piloto").val()+".jpg");
            }
            else{                
                $("#infoCampanas").hide();
                $("#alertas").hide();
                $("#llamadaPerdida").attr("src","imagenes/nada.jpg");
                $("#llamadaContestada").attr("src","imagenes/nada.jpg");
                $("#promedioRingeo").attr("src","imagenes/nada.jpg");
                $("#promedioLlamada").attr("src","imagenes/nada.jpg");
            }
        });
        if($("#piloto").val()!==""){
                //$("#divGraficos").load("grafico.jsp?piloto="+$("#piloto").val());
            $("#llamadaPerdida").attr("src","imagenes/llamadaPerdida"+$("#piloto").val()+".jpg");
            $("#llamadaGral").attr("src","imagenes/promedioGralLlamada"+$("#piloto").val()+".jpg");
            $("#llamadaContestada").attr("src","imagenes/llamadaContestada"+$("#piloto").val()+".jpg");
            $("#promedioRingeo").attr("src","imagenes/promedioRingeo"+$("#piloto").val()+".jpg");
            $("#promedioLlamada").attr("src","imagenes/promedioLlamada"+$("#piloto").val()+".jpg");
        }
//        if($("#piloto").val()!==""){
//            $("#divGraficos").load("grafico.jsp?piloto="+$("#piloto").val());
//        }
    });
    
    function refrescarDiv(){
        setInterval("getAgentes()",3000);
    }
    function expandir(obj){
        var whispering = enlaceMonitoreowhispering();
        var silencioso = enlaceMonitioreoSilencioso();
        var cortar = enlaceCortarWhispering();
        var escuchar = enlaceGrabacion();
        var pickup = enlacePickup();
        var conferecia = enlaceConferencia();
        var robar = enlaceRobarLlamada();
        var hd = enlaceEnableDisable();
        $("#ppal").html(obj.innerHTML+"<div id='panelSalir'><a onclick='exit()' href='#'><img src=\"imagenes/salir.png\"></a></div><div id='silencioso'>"+silencioso+"</div><div id='whispering'>"+whispering+"</div><div id='cortar'>"+cortar+"</div><div id='escuchar'>"+escuchar+"</div><div id='pickup'>"+pickup+"</div><div id='conf'>"+conferecia+"</div><div id='robar'>"+robar+"</div><div id='hd'>"+hd+"</div>");
        $("#ppal").css("visibility","visible");
    }
    function cerrarventana(){
        $("#realListaGrabaciones").text("Cargando...");
        $("#listaGrabaciones").hide();
    }
    function robar(){
        $("#robar").load("InterceptarLlamada?numeroLadron="+$("#supervisor").val()+"&numeroVictima="+$("#ppal #numeroAgente").val());
    }
    function hd(dato){
        if(dato==="super"){
            $("#hd").load("HabilitarDesabilitar?anexo="+$("#ppal #numeroAgente").val());
        }
        else{
            $("#hd").load("HabilitarDesabilitar?anexo="+$("#anexo").val()+"&op=op");
            if($("#estadox").text() === "Habilitado"){
                $("#estadox").text("Desabilitado");
            }
            else{
                $("#estadox").text("Habilitado");
            }
            
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
        return "<a href='#' id='robar' onClick='robar()'><img src='imagenes/robar.png'></a>";
    }
    function enlaceEnableDisable(){
        return "<a href=\"#\" onClick=\"hd('super')\">H/D</a>";
    }
    function enlaceMonitioreoSilencioso(){
        return "<a href='#' onClick='abrir(1)'><img src='imagenes/monitor.gif'></a>";
    }
    function enlaceConferencia(){
        return "<a href='#' id='conferencia' onClick='conferencia()'><img src='imagenes/conferencia.png'></a>";
    }
    function enlacePickup(){
        return "<br><a href='#' id='pickup' onClick='pickup()'>Pickup</a><br>";
    }
    function enlaceDeshabilitar(){
        return "<a href='#' onClick='desabilitar()'><img src='imagenes/x.gif'></a>";
    }
    function pickup(){
       $("#divPickup").load("recepcionPickup.jsp?numeroRoutePoint="+$("#piloto").val());
    }
    function conferencia(){
       $("#divConf").load("Conferencia?numeroAgente="+$("#ppal #numeroAgente").val()+"&monitor="+$("#supervisor").val());
    }
    function enlaceGrabacion(){
        return "<br><a href='#' onClick='abrirGrabaciones()' ><img src='imagenes/rep.png'></a><br>";
    }
    function abrirGrabaciones(){
        $("#realListaGrabaciones").load("listaGrabaciones.jsp?anexo="+$("#ppal #numeroAgente").val()+"&offset=0");
        $("#listaGrabaciones").show();
        $("#realListaGrabaciones").show();
        $("#loading").ajaxStart(function(){
            $(this).text("%cargando%");
        });
    }
    function enlaceMonitoreowhispering(){
        return "<a href='#' onClick='abrir(2)'><img src='imagenes/couching.gif'></a>";
    }
    function enlaceCortarWhispering(){
        return "<a href='#' onClick='abrir(0)'><img src='imagenes/stop.gif'></a>";
    }
    function abrir(accion){
        $("#ventanaWhispering").show();
        $("#ventanaWhispering").load("Whispering?tipo="+accion+"&devNameAgente="+$("#devNameAgente").val()+"&numeroAgente="+$("#numeroAgente").val()+"&monitor="+$("#supervisor").val());
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
