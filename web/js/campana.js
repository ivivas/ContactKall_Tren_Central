$(document).ready(function () {
    $.ajaxSetup({cache: false});
    $("#panelModificar").hide();
    $("#panelAgregar").hide();
    $("#panelAgente").hide();
    //$("#panelCliente").hide();
    $("#modificarCampaña").click(function () {
        //alert($(this).attr("name"));
        $("#panelModificar").load("ModificarCampana?campana=" + $(this).attr("name"));
        $("#panelModificar").show();
    });
    $("#botonAgregarCampana").click(function () {
        $("#panelAgregar").show();
        $("#panelAgente").show();
        $("#panelAgente").load("AgentesDisponibles?id=0&accion=listar");
        $("#panelCliente").html("<h4>Clientes</h4>");
    });
    $("#panelCliente div").click(function () {
        $(this).remove();
    });
    $("#asignarAgente").click(function () {
//        $("#panelAgente").show();
//        $("#panelAgente").load("AgentesDisponibles?id=0&accion=listar");
    });
    $("#asignarCliente").click(function () {
        window.open('subirCSV.jsp', 'clientes', 'status=yes,width=600,height=350,menubar=yes,scrollbars=yes');
    });

    $("#botonEliminarCampana").click(function () {
        var ids = "";
        $(":checkbox:checked").each(function () {
            ids += $(this).val() + "-";
        });
        var session_name = $("#session_name").val();
        if(session_name === 'usuario'){
            alert("%session_name_no_autorizado%");
        }else{
            if (ids !== "") {
                window.location.href = "EliminarCampana?ids=" + ids.substring(0, ids.length - 1);
            } else {
                alert("%seleccione_algo%");
            }
        }
    });
    $("#sincronizarAgentes").click(function () {
        $("#ventanaEspera").ajaxStart(function () {
            $("ventanaEspera").text("%cargando%");
        });
        $("#ventanaEspera").load("Sincronizar");
    });

    $("#agregarCampana").click(function () {
        var ids = "";
        var name = $("#addNombre").val();
        var des = $("#addDescripcion").val();
        var inicio = $("#addInicio").val();
        var fin = $("#addFin").val();
        var estado = $("#addEstado").val();
        //alert(1);
        if (name !== '' && des !== '' && inicio !== '' && fin !== '' && estado !== '') {
            if (valForm(inicio) && valForm(fin)) {
                $("#panelAgente :checkbox:checked").each(function () {
                    ids += $(this).val() + "-";
                });
                var cli = "";
                $("#panelCliente :checkbox:checked").each(function () {
                    cli += $(this).attr("id") + "--";
                });
                $.ajax({
                    async: true,
                    type: "POST",
                    dataType: "html",
                    contentType: "application/x-www-form-urlencoded",
                    url: 'AgregarCampana',
                    data: 'nombre=' + $("#addNombre").val() + '&descripcion=' + $("#addDescripcion").val() +
                            '&inicio=' + $("#addInicio").val() + '&fin=' + $("#addFin").val() + '&estado=' + $("#addEstado").val() + "&ids=" + ids + "&clientes=" + cli,
                    //timeout: 4000,
                    success:
                            function (datos) {
                                //alert(2);
                                if (datos === 'ok') {
                                    location.reload();
                                    $("#respuestaAgregar").html(datos);
                                } else {
                                    $("#respuestaAgregar").html(datos);
//                                    alert(datos);
                                }
                            }
                });
//                $("#addNombre").val("");
//                $("#addDescripcion").val("");
//                $("#addInicio").val("");
//                $("#addFin").val("");
//                $("#addEstado").val("");
//                $("#panelAgregar").hide();
            } else {
                alert('%alrt_frmt_add% ');
            }
        } else {
            alert('%alrt_empty_add%');
        }
    });

    $("#cerrarDiv").click(function () {
        $("#panelAgregar").hide();
        location.reload();
    });
});

function cerrar() {
    $("#panelModificar").hide();
    location.reload();
}
function modificar() {
    var id = $(this).attr("name");
    if (id === "") {
        id = $("#id").val();
    }
    var name = $("#nombre").val();
    var desc = $("#descripcion").val();
    var inicio = $("#addInicio").val();
    var fin = $("#addFin").val();
    var estado = $("#estado").val();
    if (name !== '' && desc !== '' && inicio !== '' && fin !== '' && estado !== '') {
        if (valForm(inicio) && valForm(fin)) {
            var ids = "";
            $("#panelAgente :checkbox:checked").each(function () {
                ids += $(this).val() + "-";
            });
            var cli = "";
            $("#panelCliente :checkbox:checked").each(function () {
                cli += $(this).attr("id") + "--";
                //alert(cli);
            });
            $.ajax({
                async: true,
                type: "POST",
                dataType: "html",
                contentType: "application/x-www-form-urlencoded",
                url: 'ModificarCampana',
                data: 'campana=' + id + '&modificar=x&nombre=' + $("#nombre").val() + '&descripcion=' + $("#descripcion").val() +
                        '&inicio=' + $("#addInicio").val() + '&fin=' + $("#addFin").val() + '&estado=' + $("#estado").val() + "&ids=" + ids + "&clientes=" + cli,
//                timeout: 4000,
                success:
                        function (datos) {
                            //alert(datos);
//                            location.reload();
//                            $("#respuestaAgregar").text("datos");--
                            if (datos === 'ok') {
                                location.reload();
                                $("#respuestaAgregar").html(datos);
                            } else {
                                $("#respuestaAgregar").html(datos);
                            }
                        }
            });
//            $("#addNombre").val("");
//            $("#addDescripcion").val("");
//            $("#addInicio").val("");
//            $("#addFin").val("");
//            $("#addEstado").val("");
//            $("#panelModificar").hide();
        } else {
            alert('%alrt_frmt_mod% ');
        }
    } else {
        alert('%alrt_empty_mod%');
    }

}
function agentes() {
    $("#panelAgente").show();
    $("#panelAgente").load("AgentesDisponibles?id=" + $("#id").val());
}
function subir() {
    window.open('subirCSV.jsp', 'clientes', 'status=yes,width=633,height=405,menubar=yes,scrollbars=yes');
}
function quitar(obj) {
    $(obj).remove();
}
function logOut() {
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'LogOut',
        data: 'anexo=' + $("#usuario").val(),
        timeout: 4000,
        success:
                function (datos) {
                    window.location.href = "index.jsp";
                }
    });
}

function valForm(fecha) {
    var valida = false;
    //alert(fecha);
    fecha = fecha.replace("/", "-");
    fecha = fecha.replace("/", "-");
    //alert(fecha);
//        var reg = /([0-9]{4})\-([0-9]{2})\-([0-9]{2})\s([0-9]{2})\:([0-9]{2})/;
//        var reg2 = /([0-9]{4})\-([0-9]{2})\-([0-9]{2})\s([0-9]{2})\:([0-9]{2})\:([0-9]{2})/;
    var reg = /([0-9]{2})\-([0-9]{2})\-([0-9]{4})\s([0-9]{2})\:([0-9]{2})/;
    var reg2 = /([0-9]{2})\-([0-9]{2})\-([0-9]{4})\s([0-9]{2})\:([0-9]{2})\:([0-9]{2})/;
    if (fecha.length === 16) {
        //alert('largo 16');
        if (reg.test(fecha)) {
            //alert('exp ok');
            valida = fechaReal(fecha);
        }
    } else if (fecha.length === 19) {
        //alert('largo 19');
        if (reg2.test(fecha)) {
            valida = fechaReal(fecha);
        }
    }
    return valida;
}
function fechaReal(fecha) {
    var dias = fecha.split(' ')[0];
    var horas = fecha.split(' ')[1];
    var valida = false;
    var year = dias.split('-')[2];
    var month = dias.split('-')[1];
    var day = dias.split('-')[0];
    if (month < 13) {
        //alert('month ok');
        var date = new Date(year, month, 0);
        if ((day - 0) <= (date.getDate() - 0)) {
            if (fecha.length === 19) {
                var hora = horas.split(':')[0];
                var minuto = horas.split(':')[1];
                var segundo = horas.split(':')[2];
                valida = (hora < 24 && minuto < 60 && segundo < 60);
            } else {
                var hora = horas.split(':')[0];
                var minuto = horas.split(':')[1];
                valida = (hora < 24 && minuto < 60);
            }
        }
    }
    return valida;
}

    