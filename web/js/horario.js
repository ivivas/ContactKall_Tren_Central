/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function guardaFecha(){
    var fecha = document.getElementById('fecha_excepcion').value;
    //alert(fecha);
    
    if(fecha === ''){
        alert('%msg_empty%');
    }else{
        if(valForm(fecha)){
            //alert('ok');
            document.adminForm_horarioModificar.submit();
        }else{
            alert('%msg_err_format%');
        }
    }
    
}

function valForm(fecha) {
    var valida = false;
    
    //alert(fecha);
    var reg = /([0-9]{2})\-([0-9]{2})\-([0-9]{4})/;

    if (fecha.length === 10) {
        //alert('largo 10');
        if (reg.test(fecha)) {
            //alert('exp ok');
            valida = fechaReal(fecha);
        }
    }
    return valida;
}

function fechaReal(fecha) {
    var valida = false;
    var year = fecha.split('-')[2];
    var month = fecha.split('-')[1];
    var day = fecha.split('-')[0];
    if (month < 13) {
        //alert('month ok');
        var date = new Date(year, month, 0);
        valida = (day - 0) <= (date.getDate() - 0);
    }
    return valida;
}