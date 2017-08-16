/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function(){
    setInterval('getAgente()',2500);
        $("#llamar").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&destino='+$("#destino").val()+'&accion=4',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
    $("#contestar").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&accion=5',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
    $("#espera").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&accion=6',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
    $("#noespera").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&accion=7',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
    $("#conferenciar").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&destino='+$("#destino").val()+'&accion=8',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
    
    $("#redirect").click(function(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'AccionesAgente',
            data:'anexo='+$("#anexo").val()+'&destino='+$("#destino").val()+'&accion=9',
            timeout:4000,
            success:
                function(datos){

                }
        });
    });
});
    function getAgente(){
        $.ajax({
            async:true,
            type: "POST",
            dataType: "html",
            contentType: "application/x-www-form-urlencoded",
            url:'ContenedorAgente',
            data:'anexo='+$('#anexo').val()+"&multiple=false",
            timeout:4000,
            success:
               function(datos){
                    $("#controlPanel").html(datos);
                }
        });
        setTimeout(function(){},1000);
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