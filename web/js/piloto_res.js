    $(document).ready(function(){
        oncontextmenu = function(){
            return false;
            //alert("funco");
        };
        $("#asignarCampanaPool").hide();
        $("#panelAgenteCampana").hide();
        $("#navegador").hide();
        $("#pAgentes").hide();
        $("#loading").ajaxStart(function(){
            $(this).text("%cargando%");
        });
        
        $("#nuevaPestaña").click(function(){
            var cantidad = $("#aqui iframe").length;

            if(cantidad<5){
                $(".headers").append("<span class='head' id='head"+cantidad+"'  draggable='true' ondragstart='transferirPagina(event,this)' onclick='hacerVisible(this)'>%nueva_pestaña%<span onclick='cerrar(head"+cantidad+")'>X</span></span>");
                $("#aqui").append("</div><input class='caja' type='text' id='caja"+cantidad+"' onkeypress='navegar(event,this)'><iframe class='pestaña' id='pestaña"+cantidad+"'>");
            }
            $("#divGraficos").hide();
        });

        $("#loading").ajaxStop(function(){
            $(this).text("");
        });
        
        $("#salirCampana").click(function(){
            $("#panelAgenteCampana").hide();
        });
        $("#asignarCampanaPool").click(function(){
            $("#panelAgenteCampana").load("AgentesDisponibles?id="+$("[name='campana']:checked").val()+"&text=info");
            $("#panelAgenteCampana").show();    
        });
        obtenerPiloto();
        setInterval("obtenerPiloto()",20000);
        $("#ventanaWhispering").hide();
        $("#listaGrabaciones").hide();
        $("#listaGrabaciones").load("listaGrabaciones.jsp?anexo=0&offset=0");
        $("#caluga").click(function(){
            expandir(obj);
        });
        $("#panel").hide();
//        $("#llamadaPerdidaPool").hover(function(){
//            $("#panel").hide();
//            $("#panel").css("background-image","url('imagenes/llamadaPerdidaPool.jpg')")
//            $("#panel").show();
//        });
//        $("#llamadaPerdidaPool").mouseout(function(){
//            $("#panel").hide();
//        });
//        $("#llamadaContestadaPool").hover(function(){
//            $("#panel").hide();
//            $("#panel").css("background-image","url('imagenes/llamadaContestadaPool.jpg')");
//            $("#panel").show();
//        });
//        $("#llamadaContestadaPool").mouseout(function(){
//            $("#panel").hide();
//        });
        $("#llamadaGralPool").mouseover(function(){
                $("#panel").hide();
                $("#panel").css("background-image","url('imagenes/llamadaGralPool.jpg')");
                $("#panel").show();
        });
        $("#llamadaGralPool").mouseout(function(){
            $("#panel").hide();
        });
        $("#llamadaGralPool").click(function(){
            $("#divGraficosDetalle").css("display","block");
            $("#llamadaContestadaPool").css("visibility","visible");
            $("#llamadaPerdidaPool").css("visibility","visible");
        });
        $("[name='campana']").click(function(){
            $("#asignarCampanaPool").show();    
        });
        $("#promedioRingeoPool").hover(function(){
            $("#panel").hide();
            $("#panel").css("background-image","url('imagenes/promedioRingeoPool.jpg')");
            $("#panel").show();
        });
        $("#promedioRingeoPool").mouseout(function(){
            $("#panel").hide();
        });
        $("#promedioLlamadaPool").hover(function(){
            $("#panel").hide();
            $("#panel").css("background-image","url('imagenes/promedioLlamadaPool.jpg')");
            $("#panel").show();
        });
        $("#promedioLlamadaPool").mouseout(function(){
            $("#panel").hide();
        });
    });
    function obtenerPiloto(){
        getPiloto('ContenedorPiloto');
        setTimeout(function(){},1000);
    }
    function getPiloto(url) {
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:url,
            timeout:10000,
            success:
               function(datos){
                    $("#contenedor_pl").html(datos);
                }
        }); 
    }
    function verPool(pool){
        //$("#pAgentes").show();
        //$("#loading").ajaxStart(function(){
        //    $(this).text("%cargando%");
        //});
        //$("#rpHidden").val(pool);
        //$("#pAgentes").load("contenedorAgentes.jsp?piloto="+pool);
        //cargarMonitor(pool);0
        window.location.href="agentes.jsp?piloto="+pool;
    }
    function enlaceMonitioreoSilencioso(){
        return "<a href='#' onClick='abrir(1)'><img src='imagenes/monitor.gif'></a>";
    }
    function enlacePickup(){
        return "<br><a href='#' onClick='pickup()'>Pickup</a><br>";
    }
    function pickup(){
       $("#divPickup").load("recepcionPickup.jsp?numeroRoutePoint="+$("#rpHidden").val());
    }
    function enlaceGrabacion(){
        return "<br><a href='#' onClick='abrirGrabaciones()' ><img src='imagenes/rep.png'></a><br>";
    }
    function abrirGrabaciones(){
        $("#listaGrabaciones").show();
        $("#loading").ajaxStart(function(){
            $(this).text("%cargando%");
        });
        $("#loading").ajaxStop(function(){
            $(this).text("");
        });
        $("#listaGrabaciones").load("listaGrabaciones.jsp?anexo="+$("#ppal #numeroAgente").val()+"&offset=0");
    }
    function enlaceMonitoreowhispering(){
        return "<a href='#' onClick='abrir(2)'><img src='imagenes/couching.gif'></a>";
    }
    function enlaceCortarWhispering(){
        return "<a href='#' onClick='abrir(0)'><img src='imagenes/stop.gif'></a>";
    }
    function expandir(obj){
        var whispering = enlaceMonitoreowhispering();
        var silencioso = enlaceMonitioreoSilencioso();
        var cortar = enlaceCortarWhispering();
        var escuchar = enlaceGrabacion();
        var pickup = enlacePickup();
        $("#ppal").html(obj.innerHTML+"<div id='panelSalir'><a onclick='exit()' href='#'><img src=\"imagenes/salir.png\"></a></div><div id='silencioso'>"+silencioso+"</div><div id='whispering'>"+whispering+"</div><div id='cortar'>"+cortar+"</div><div id='escuchar'>"+escuchar+"</div><div id='pickup'>"+pickup+"</div>");
        $("#ppal").css("visibility","visible");
    }
    function abrir(accion){
        $("#ventanaWhispering").show();
        $("#ventanaWhispering").load("whispering_div.jsp?tipo="+accion+"&devNameAgente="+$("#devNameAgente").val()+"&numeroAgente="+$("#numeroAgente").val()+"&monitor="+$("#monitor").val());
        setTimeout(function(){
            $("#ventanaWhispering").html("");
            $("#ventanaWhispering").hide();
        },4000);
    }
    function cerrar(){
        $("#ventanaWhispering").hide();
    }
        function cerrarventana(){
        $("#listaGrabaciones").hide();
    }
    function exit(){
       $("#ppal").css("visibility","hidden");
    }  
        function cargarMonitor(param){
        getMonitor(param);
    }
    function getMonitor(param){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'obtenerMonitor.jsp',
            data:'piloto='+param,
            timeout:4000,
            success:
               function(datos){
                    $("#monitores").html(datos);
                }
        }); 
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
            var idPestaña = $(obj).attr("id").replace("head","pestaña");
            var idCaja = $(obj).attr("id").replace("head","caja");
            $(".pestaña").css("z-index","0");
            $(".caja").css("z-index","0");
            $("#"+idPestaña).css("z-index","1");
            $("#"+idCaja).css("z-index","1");
        }
    function transferirPagina(ev,obj){
        ev.dataTransfer.setData("text", $(obj).text().substring(0,$(obj).text().length-1));
    }
    function recibirData(ev,obj) {
        var data = ev.dataTransfer.getData("text");
        if(data!=="Nueva Pestaña"){
            ev.preventDefault();
            alert("enviando url "+data+" a "+$("#numeroPool",obj).val());
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
    function salirDetalle(obj){
        $("#divGraficosDetalle").css("display","none");
        $("#llamadaPerdidaPool").css("visibility","hidden");
        $("#llamadaContestadaPool").css("visibility","hidden");
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
                    $("#respuestaAgregar").text(datos);
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
    function logOut(){
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