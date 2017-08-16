
window.onload = function(){
    llenarSecretaria();
};

function buscar(){
    var desde = document.getElementById('desde').value;
    var hasta = document.getElementById('hasta').value;
    var anexo = document.getElementById('numero_').value;
    var piloto = document.getElementById('piloto').value;
    var pregunta = document.getElementById('preguntas').selectedIndex;
    if(desde!=='' && hasta !== '' && anexo !== '' && piloto !== '' && pregunta !== 0){
        document.encuestaIvr.submit();
    }else{
        alert('%empty_data2%');
    }
}

function descargaExcel(){
    var desde = document.getElementById('desde').value;
    var hasta = document.getElementById('hasta').value;
    var anexo = document.getElementById('numero_').value;
    var piloto = document.getElementById('piloto').value;
    
    if(desde!=='' && hasta !== '' && anexo !== '' && piloto !== ''){
        location.href = 'ExcelEncuestaIvr?desde='+desde+"&hasta="+hasta+'&anexo='+anexo+'&piloto='+piloto;
//        window.open('./ExcelEncuestaIvr?desde='+desde+"&hasta="+hasta+'&anexo='+anexo+'&piloto='+piloto,'_blank','heigth= 100, width=600');
    }else{
        alert('%empty_data%');
    }
}

function llenarSecretaria(){
    makeRequest("ComboSecretaria?piloto="+document.getElementById("piloto").value+"&numero="+document.getElementById("numeroX").value);
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
function mostrarToolKit(target,nro){
    target.style.visibility = "visible";
    target.style.display = "block";
    
    if(nro === 1){
        target.innerHTML = "%tag_fecha%";
    }
}

function ocultarToolKit(target){
    target.style.visibility = "hidden";
    target.style.display = "none";
}
