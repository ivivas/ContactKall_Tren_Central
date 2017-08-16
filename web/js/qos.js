$(document).ready(function () {
    mostrarPilotos();

    $.ajaxSetup({cache: false});

    $("#panelGraficoGrande").hide();
    $("#panelGraficoGrande").click(function () {
        $(this).hide();
    });
    $("#marcadores").load("RankingExcelencia");
    $("#mostrarAgentes").click(function () {
        mostrarAgentes();
        $.ajax({
            async: true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url: 'TablaEstadistica',
            cache: false,
            data: 'opcionTabla=1&lapso=' + $("#lapso").val(),
            timeout: 4000,
            success:
                    function (datos) {
                        $("#datosEstadisticos").html(datos);
                    }
        });
    });

    $("#mostrarMensaje").click(function () {
        $("#datosEstadisticos").html("%sin.pilotos.asociados%");
    });

    $("#mostrarPilotos").click(function () {
        mostrarPilotos();
        $.ajax({
            async: true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url: 'TablaEstadistica',
            cache: false,
            data: 'opcionTabla=0&lapso=' + $("#lapso").val(),
            timeout: 4000,
            success:
                    function (datos) {
                        $("#datosEstadisticos").html(datos);
                    }
        });
        recargarGraficosPilotos();
    });
    $("#mostrarAgentes").click(function () {
        $.ajax({
            async: true,
            type: "POST",
            dataType: "html",
            cache: false,
            contentType: "application/x-www-form-urlencoded",
            url: 'TablaEstadistica',
            data: 'opcionTabla=1&lapso=' + $("#lapso").val(),
            timeout: 4000,
            success:
                    function (datos) {
                        $("#datosEstadisticos").html(datos);
                    }
        });
        recargarGraficosTodosLosAgentes();
    });
});

function exportarTablaExcel() {
    //A exportar se ha dicho....
    tabla = document.getElementById('tabla_exp_excel').innerHTML;
    document.getElementById("tablaEstadisticasExcelMagio").value = tabla;
    document.forms.formExcelMagio.submit();
}

function mostrarDatosAgente(agente) {
    $("#graficos").css("display", "block");
    $(".agentes" + agente).css("display", "block");
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'TablaEstadistica',
        cache: false,
        data: 'opcionTabla=3&anexo=' + agente + "&lapso=" + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#datosEstadisticos").html(datos);
                }
    });
    recargarGraficosAgentesUnico(agente);
}
function mostrarAgentes2(piloto) {
    $("." + piloto).css("display", "block");
    $("#graficos").css("display", "block");
    $(".agentes" + piloto).css("display", "block");
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'TablaEstadistica',
        cache: false,
        data: 'opcionTabla=2&piloto=' + piloto + "&lapso=" + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#datosEstadisticos").html(datos);
                }
    });
    recargarGraficosAgentesXPilotos(piloto);

}
function mostrarPilotos() {
    $(".pilotos").css("display", "block");
}
function mostrarOpciones() {
    $(".opciones").css("display", "block");
}
function mostrarAgentes() {
    $(".agentes").css("display", "block");
    $("#graficos").css("display", "block");
}
function recargarGraficosTodosLosAgentes() {
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'QosGrafico',
        data: 'seleccion=2&lapso=' + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#graficos").html(datos);
                    agregarListenersAgente();
                }
    });
}
function recargarGraficosPilotos() {
    $("#graficos").css("display", "block");
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'QosGrafico',
        data: 'seleccion=0&lapso=' + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#graficos").html(datos);
                    agregarListenersPool();
                }
    });
}
function recargarGraficosAgentesXPilotos(piloto) {
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'QosGrafico',
        data: 'seleccion=1&piloto=' + piloto + "&lapso=" + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#graficos").html(datos);
                    agregarListenersAgenteXPool(piloto);
                }
    });
}
function recargarGraficosAgentesUnico(piloto) {
    $.ajax({
        async: true,
        type: "POST",
        dataType: "html",
        contentType: "application/x-www-form-urlencoded",
        url: 'QosGrafico',
        data: 'seleccion=3&anexo=' + piloto + "&lapso=" + $("#lapso").val(),
        timeout: 4000,
        success:
                function (datos) {
                    $("#graficos").html(datos);
                    agregarListenersAgenteUnico(piloto);
                }
    });
}
function agrandarGrafico1() {
    $("#panelGraficoGrande").css("background-color", "url('imagenes/mensual/" + url + "')");
    $("#panelGraficoGrande").show();
}
function agregarListenersPool() {
    $("#uno").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaPerdidaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaPerdidaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaPerdidaPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#dos").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaContestadaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaContestadaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaContestadaPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#tres").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioRingeoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioRingeoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioRingeoPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cuatro").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioLlamadaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioLlamadaPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioLlamadaPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cinco").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaGralPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaGralPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaGralPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#seis").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoActivoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoActivoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoActivoPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#siete").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoInactivoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoInactivoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoInactivoPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#ocho").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoPool.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoPool.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
}
function agregarListenersAgenteUnico(piloto) {
    $("#uno").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadasPerdidas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadasPerdidas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadasPerdidas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#dos").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaContestadas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaContestadas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaContestadas" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#tres").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cuatro").click(function () {

        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cinco").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#seis").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#siete").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#ocho").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
}
function agregarListenersAgenteXPool(piloto) {
    $("#uno").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaPerdida" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaPerdida" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaPerdida" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#dos").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaContestada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaContestada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaContestada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#tres").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioRingeo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cuatro").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cinco").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioGralLlamada" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#seis").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioGralEstadistica" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#siete").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoActivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#ocho").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoInactivo" + piloto + ".jpg')");
            $("#panelGraficoGrande").show();
        }
    });
}
function agregarListenersAgente() {
    $("#uno").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadasPerdidas.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadasPerdidas.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadasPerdidas.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#dos").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/llamadaContestadas.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/llamadaContestadas.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/llamadaContestadas.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#tres").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioGralLlamada.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioGralLlamada.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioGralLlamada.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cuatro").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioRingeo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioRingeo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioRingeo.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#cinco").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/promedioLlamada.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/promedioLlamada.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/promedioLlamada.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#seis").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoTotal.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoTotal.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoTotal.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#siete").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoInactivo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoInactivo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoInactivo.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
    $("#ocho").click(function () {
        if ($("#lapso").val() === '0') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/diario/tiempoActivo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '1') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/semanal/tiempoActivo.jpg')");
            $("#panelGraficoGrande").show();
        } else if ($("#lapso").val() === '2') {
            $("#panelGraficoGrande").css("background-image", "url('imagenes/mensual/tiempoActivo.jpg')");
            $("#panelGraficoGrande").show();
        }
    });
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

