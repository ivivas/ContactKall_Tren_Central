

function enviar(){
    if(document.getElementById('piloto').value === "" || document.getElementById('numero_').value === ''){
        alert("%sel.piloto%");
    }else{ 
        var f1 = document.getElementById('desde').value;
        var f2 = document.getElementById('hasta').value;
        if(f1 !== ''){
            if(valFecha(f1)){
                if(f2 !== ''){
                    if(valFecha(f2)){
                        document.getElementById('form').submit();
                    }else{
                        alert('%fecha_no_valida1%') ;
                    }
                }else{
                    document.getElementById('form').submit();
                }
            }else{
               alert('%fecha_no_valida2%') ;
            }
        }else{
            if(f2 !== ''){
                if(valFecha(f2)){
                    document.getElementById('form').submit();
                }else{
                    alert('%fecha_no_valida3%') ;
                }
            }else{
                document.getElementById('form').submit();
            }
        }
    }
}

function makeRequest(url) {
    http_request = false;
    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        if (http_request.overrideMimeType) {
        http_request.overrideMimeType('text/xml');
    // Ver nota sobre esta linea al final
        }
    }
    else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
        }
    }
    if (!http_request) {
        alert('Falla :( No es posible crear una instancia XMLHTTP');
        return false;
    }
    http_request.onreadystatechange = alertContents;
    http_request.open('POST', url, true);
    http_request.send(null);
}

function alertContents() {
    if (http_request.readyState === 4) {
        if (http_request.status === 200) {
            document.getElementById("numero_").innerHTML = http_request.responseText;
        } 
        else {
            alert('Hubo problemas con la petición.');
        }
    }
}

function llenarSecretaria(){
    makeRequest("ComboSecretaria?piloto="+document.getElementById("piloto").value+"&numero="+document.getElementById("numeroX").value);

}

function mostrarToolKit(target){
    target.style.visibility = "visible";
    target.style.display = "block";
}

function ocultarToolKit(target){
    target.style.visibility = "hidden";
    target.style.display = "none";
}

function valFecha(fecha){
    var valida = false;
    var reg = /([0-9]{2})\/([0-9]{2})\/([0-9]{4})/;
    var reg2 = /([0-9]{2})\/([0-9]{2})\/([0-9]{4})\s([0-9]{2})\:([0-9]{2})/;
    if(fecha.length === 10){
        if(reg.test(fecha)){
            valida = fechaReal(fecha);
        }
    }else if(fecha.length === 16){
        if(reg2.test(fecha)){
            valida = fechaReal(fecha);
        }
    }
    return valida;
}

function fechaReal(fecha){
    var valida = false;
    if(fecha.length === 10){
        
        var day = fecha.split('/')[0];
        var month = fecha.split('/')[1];
        var year = fecha.split('/')[2];
        if(month<13){
            var date = new Date(year,month,0);
            valida = (day - 0) <= (date.getDate()-0);
        }
    }else{
        var dias = fecha.split(' ')[0];
        var horas = fecha.split(' ')[1];
        var day = dias.split('/')[0];
        var month = dias.split('/')[1];
        var year = dias.split('/')[2];
        if(month<13){
            var date = new Date(year,month,0);
            if((day - 0) <= (date.getDate()-0)){
                var hora = horas.split(':')[0];
                var minuto = horas.split(':')[1];
                valida = (hora < 24 && minuto < 60);
            }
        }
    }
    return valida;
}