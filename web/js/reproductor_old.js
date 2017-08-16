    var duration = 0;
    var pause = false;
    var width = 0;
    var audio;
    var timeActual = 0;
    var id;
    var stop = false;
    var destroy = false;
    var volumenActual = 0;
    var http_request_add_memo;
    var http_request_get_memo;
    var http_request_mostrar;
    var http_request_updateMemo;
    var http_request_deleteMemo;
    var colorTag  = "red";
    var colorAvance = "#ff6600";
    var color = "white";
    
    addEventListener("load",function(){
        document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(width);
        document.getElementById("player").addEventListener("click",function(){
            var foto = document.getElementById("foto");
            try{
                if(foto.getAttribute("name") === "play"){
                    pause = false;
                    
                    foto.setAttribute("name","pause");
                    //width = 0;
                    audio.currentTime = timeActual;
                    audio.play();
                    if(stop){
                        id = setInterval(modificarProgressBar, 1000);
                        stop = false;
                    }
                    foto.src = "imagenes/pause.png";
                    return false;
                }
                else if(foto.getAttribute("name") === "pause"){
                    audio.pause();
                    pause = true;
                    timeActual = audio.currentTime;
                    foto.src = "imagenes/play.png";
                    foto.setAttribute("name","play");
                    return false;
                }
            }
            catch(e){}
        });
        
        document.getElementById("stop").addEventListener("click",function(){
            stop = true;
            clearInterval(id);
            foto.src = "imagenes/play.png";
            pause = true;
            timeActual = 0;
            try{
                audio.pause();
                audio.currentTime = 0;
            }
            catch(e){}
            var linea = document.getElementsByClassName("linea");
            for(i =0 ; i < linea.length ; i++){
                if(linea[i].getAttribute("name") !== colorTag){
                    linea[i].style.background = color;
                    linea[i].setAttribute("name",color);
                }
            }
            width = 0;
            document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
           
        });

        document.getElementById("addTag").addEventListener("click",function(){
            try{
                
                http_request_add_memo = false;
                if (window.XMLHttpRequest) {
                    http_request_add_memo = new XMLHttpRequest();
                    if (http_request_add_memo.overrideMimeType) {
                        http_request_add_memo.overrideMimeType('text/html');
                    }
                }
                else if (window.ActiveXObject) {
                    try {
                        http_request_add_memo = new ActiveXObject("Msxml2.XMLHTTP");
                    }
                    catch (e) {
                        try {
                            http_request_add_memo = new ActiveXObject("Microsoft.XMLHTTP");
                        }
                        catch(e) {}
                    }
                }
                if (!http_request_add_memo) {
                    alert('Falla :( No es posible crear una instancia XMLHTTP');
                    return false;
                }
                http_request_add_memo.onreadystatechange = alertContents;
                http_request_add_memo.open('POST', "agregarMemo?idGrabacion="+document.getElementById("idGrabacion").value+"&mensaje=&usuario="+document.getElementById("usuario").value+"&segundo="+parseInt(audio.currentTime), true);
                http_request_add_memo.send(null);
            }    
            catch(e){document.write(e)}
        }
    );
        
        document.getElementById("rewind").addEventListener("click",function(){
            try{
            var pruebaAudio = audio.duration;
            document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
            var linea = document.getElementsByClassName("linea");
            timeActual = audio.currentTime;
            if(timeActual<19){
                width = 0;
                document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
                foto.src = "imagenes/play.png";
                pause = true;
                timeActual = 0;
                audio.pause();
                var linea = document.getElementsByClassName("linea");
                for(i =0 ; i < linea.length ; i++){
                    if(linea[i].getAttribute("name") !== colorTag){
                        linea[i].style.background = color;
                        linea[i].setAttribute("name",color);
                    }
                }
                width = 0;
            }
            else{
                audio.currentTime -= 20.0;
                width = parseInt(audio.currentTime);
                document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
                for(i =0 ; i <= linea.length ; i++){
                    if(i >= width){
                        try{
                            if(linea[i].getAttribute("name") !== colorTag){
                                linea[i].style.background = color;
                                linea[i].setAttribute("name",color);
                            }
                        }
                        catch(e){}
                    }
                    else{
                        if(!linea[i].getAttribute("name") === colorTag){
                            linea[i].style.background = colorAvance;
                            linea[i].setAttribute("name",colorAvance);
                        }
                    }
                }
            }
            }
            catch(e){}
        });
        
        document.getElementById("reward").addEventListener("click",function(){
            try{
                var pruebaAudio = audio.duration;
                var linea = document.getElementsByClassName("linea");
                if(width+20 > audio.duration){
                    width = 0;
                    document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
                    foto.src = "imagenes/play.png";
                    pause = true;
                    timeActual = 0;
                    audio.pause();
                    var linea = document.getElementsByClassName("linea");
                    for(i =0 ; i < linea.length ; i++){
                        if(linea[i].getAttribute("name") !== colorTag){
                            linea[i].style.background = color;
                            linea[i].setAttribute("name",color);
                        }
                    }

                }
                else{
                    audio.currentTime += 20.0;
                    timeActual = audio.currentTime;
                    width += 20;
                    for(i =0 ; i < linea.length ; i++){
                    document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
                    if(i <= audio.currentTime){
                        if(linea[i].getAttribute("name") !== colorTag){
                            linea[i].style.background = colorAvance;
                            linea[i].setAttribute("name",colorAvance);
                        }
                    }
                    else{
                        if(!linea[i].getAttribute("name") === colorTag){
                            linea[i].style.background = color;
                            linea[i].setAttribute("name", color);
                        }
                    }
                }
                }
            }
            catch(e){}
});  
        
        document.getElementById("volumen").addEventListener("change",function(){
            try{
                var pruebaAudio = audio.duration;
                audio.volume = Math.abs(document.getElementById("volumen").value / 10);
            }
            catch(e){}
        });  
        document.getElementById("mute").addEventListener("click",function(){
            try{
                var pruebaAudio = audio.duration;
                var fotoVolumen = document.getElementById("fotoVolumen");
                if(fotoVolumen.getAttribute("name") === "mute"){
                    audio.volume = volumenActual;
                    document.getElementById("volumen").value = volumenActual*10;
                    fotoVolumen.src = "imagenes/music.png";
                    fotoVolumen.setAttribute("name","music");
                }
                else if(fotoVolumen.getAttribute("name") === "music"){
                    volumenActual = audio.volume;
                    audio.volume = 0;
                    document.getElementById("volumen").value = 0;
                    fotoVolumen.src = "imagenes/mute.png";
                    fotoVolumen.setAttribute("name","mute");
                }
            }
            catch(e){}
        });  
    });

    function tamanio(){
        var tamanio = document.getElementById('myBar').offsetWidth / audio.duration;
        return tamanio;
    }
    
    function cargarLineaTiempo(){
        document.getElementById("myBar").innerHTML = "";
        var divs="";
        for(i = 1 ; i < audio.duration ; i++){
            divs+="<div id='"+i+"' class='linea' name='"+color+"' style='width:"+tamanio()+"px;height:10px;float:left;position:relative;' onmouseover='mostrar(this)' onclick='progressBar(this.id)'></div>";
        }
        document.getElementById('myBar').innerHTML = divs;
    }
    
    function formatear(second){
        var hours = Math.floor( second / 3600 );  
        var minutes = Math.floor( (second % 3600) / 60 );
        var seconds = second % 60;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;
        return hours + ":" + minutes + ":" + seconds;
    }
    
    function progressBar(second){
        var linea = document.getElementsByClassName("linea");
        for(i =0 ; i < linea.length ; i++){
            if(i < second){
                if(linea[i].getAttribute("name") !== colorTag){
                    linea[i].style.background = colorAvance;
                    linea[i].setAttribute("name",colorAvance);
                }
            }
            else{
                if(linea[i].getAttribute("name") !== colorTag){
                    linea[i].style.background = color;
                    linea[i].setAttribute("name",color);
                }
            }
        }
        audio.currentTime = parseFloat(second);
        width = second;
        timeActual = audio.currentTime;
        document.getElementById("por").innerHTML = formatear(width)+" / "+formatear(duration);
    }
    
    function modificarProgressBar() {
        if (width >= audio.duration) {
            clearInterval(id);
        }
        else {
            if(!pause){
                width++;
                if(document.getElementById(width).getAttribute("name") !== colorTag){
                    document.getElementById(width).style.background = colorAvance;
                    document.getElementById(width).setAttribute("name",colorAvance);
                }
                document.getElementById("por").innerHTML = formatear(width)+" / "+formatear(duration);
            }
        }
    }
    function alertContents() {
        if (http_request_add_memo.readyState === 4) {
            if (http_request_add_memo.status === 200) {
                if(http_request_add_memo.responseText !== "xxx"){
                    document.getElementById(parseInt(audio.currentTime)+"").style.background = colorTag;
                    document.getElementById(parseInt(audio.currentTime)+"").setAttribute("name",colorTag);
                    var string = http_request_add_memo.responseText.split(","); 
                    var linea = document.getElementsByClassName("linea");
                    for(i = 0; i <string.length;i++){
                        try{
                            linea[parseInt(string[i].split("%separador%")[1])].style.background = colorTag;
                            linea[parseInt(string[i].split("%separador%")[1])].setAttribute("name",colorTag);
                        }
                        catch(e){}
                    }
                }
                else{
                    document.getElementById("res").innerHTML="Limite de tags alcanzado";
                    setTimeout(function(){
                    document.getElementById("res").innerHTML="";
                },2000);
                }
            }
            else {
                alert('Hubo problemas con la petición.');
            }
        }
    }
    function alertContents2() {
        if (http_request_get_memo.readyState === 4) {
            if (http_request_get_memo.status === 200) {
                var string = http_request_get_memo.responseText.split(","); 
                var linea = document.getElementsByClassName("linea");
                for(i = 0; i <string.length;i++){
                    try{
                        linea[parseInt(string[i])-1].style.background = colorTag;
                        linea[parseInt(string[i])-1].setAttribute("name",colorTag);
                    }
                    catch(e){}
                }
            }
            else {
                alert('Hubo problemas con la petición.');
            }
        }
    } 
    function obtenerMemo(){
        http_request_get_memo = false;
            if (window.XMLHttpRequest) {
                http_request_get_memo = new XMLHttpRequest();
                if (http_request_get_memo.overrideMimeType) {
                    http_request_get_memo.overrideMimeType('text/html');
                }
            }
            else if (window.ActiveXObject) {
                try {
                    http_request_get_memo = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try {
                        http_request_get_memo = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch(e) {
                        
                    }
                }
            }
            if (!http_request_get_memo) {
                alert('Falla :( No es posible crear una instancia XMLHTTP');
                return false;
            }
            http_request_get_memo.onreadystatechange = alertContents2;
            http_request_get_memo.open('POST', "ObtenerMemo?idGrabacion="+document.getElementById("idGrabacion").value, true);
            http_request_get_memo.send(null);
    }
    
    function mostrar(obj){
        if(obj.getAttribute("name") === colorTag){
            http_request_mostrar = false;
            if (window.XMLHttpRequest) {
                http_request_mostrar = new XMLHttpRequest();
                if (http_request_mostrar.overrideMimeType) {
                    http_request_mostrar.overrideMimeType('text/html');
                }
            }
            else if (window.ActiveXObject) {
                try {
                    http_request_mostrar = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try {
                        http_request_mostrar = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch(e) {
                        
                    }
                }
            }
            if (!http_request_mostrar) {
                alert('Falla :( No es posible crear una instancia XMLHTTP');
                return false;
            }
            http_request_mostrar.onreadystatechange = alertContents3;
            http_request_mostrar.open('POST', "ObtenerInfoMemo?idGrabacion="+document.getElementById("idGrabacion").value+"&segundo="+obj.id, true);
            http_request_mostrar.send(null);
            document.getElementById("memo").style.visibility = "visible";
            document.getElementById("memo").style.display = "block";
        }
    }
    function alertContents3() {
        if (http_request_mostrar.readyState === 4) {
            if (http_request_mostrar.status === 200) {
                var datos = http_request_mostrar.responseText.split("%separador%");
                var datoFinal = "";
                for(var i = 0 ; i < datos.length ; i++){
                    datoFinal += datos[i];
                }
                document.getElementById("memo").innerHTML = datoFinal;
            }
            else {
                alert('Hubo problemas con la petición.');
            }
        }
    }
    function modificarMemo(){
            http_request_updateMemo = false;
            if (window.XMLHttpRequest) {
                http_request_updateMemo = new XMLHttpRequest();
                if (http_request_updateMemo.overrideMimeType) {
                    http_request_updateMemo.overrideMimeType('text/html');
                }
            }
            else if (window.ActiveXObject) {
                try {
                    http_request_updateMemo = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try {
                        http_request_updateMemo = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch(e) {
                        
                    }
                }
            }
            if (!http_request_updateMemo) {
                alert('Falla :( No es posible crear una instancia XMLHTTP');
                return false;
            }
            http_request_updateMemo.onreadystatechange = alertContents4;
            http_request_updateMemo.open('POST', "UpdateMemo?idGrabacion="+document.getElementById("idGrabacion").value+"&mensaje="+document.getElementById("msj").value+"&usuario="+document.getElementById("usuario").value+"&segundo="+document.getElementById("segundo").value, true);
            http_request_updateMemo.send(null);
        }
        function alertContents4(){
            if (http_request_updateMemo.readyState === 4) {
                if (http_request_updateMemo.status === 200) {
                    document.getElementById("res").innerHTML="Modificado!!!";
                    setTimeout(function(){
                    document.getElementById("res").innerHTML="";
                    document.getElementById("memo").style.visibility = "hidden";
                    document.getElementById("memo").style.display = "none";
                },2000);
                }
            }
        }
        
        function eliminarMemo(){
            http_request_deleteMemo = false;
            if (window.XMLHttpRequest) {
                http_request_deleteMemo = new XMLHttpRequest();
                if (http_request_deleteMemo.overrideMimeType) {
                    http_request_deleteMemo.overrideMimeType('text/html');
                }
            }
            else if (window.ActiveXObject) {
                try {
                    http_request_deleteMemo = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try {
                        http_request_deleteMemo = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch(e) {
                        
                    }
                }w
            }
            if (!http_request_deleteMemo) {
                alert('Falla :( No es posible crear una instancia XMLHTTP');
                return false;
            }
            http_request_deleteMemo.onreadystatechange = alertContents5;
            http_request_deleteMemo.open('POST', "EliminarMemo?idMemo="+document.getElementById("idMemo").value+"&usuario="+document.getElementById("usuario").value, true);
            http_request_deleteMemo.send(null);
        }
        
        function alertContents5(){
            if (http_request_deleteMemo.readyState === 4) {
                if (http_request_deleteMemo.status === 200) {
                    var segundo = http_request_deleteMemo.responseText;
                    document.getElementById("memo").style.visibility = "hidden";
                    document.getElementById("res").innerHTML="Eliminado!!!";
                    setTimeout(function(){
                    document.getElementById("res").innerHTML="";
                },1000);
                    var linea = document.getElementsByClassName("linea");
                    for(i=0;i<linea.length;i++){
                        if(i === segundo-1){
                            if(i <= audio.currentTime){
                                linea[i].style.background = colorAvance;
                                linea[i].setAttribute("name",colorAvance);
                            }
                            else{
                                linea[i].style.background = color;
                                linea[i].setAttribute("name",color);
                            }
                        }
                    }
                }
            }
        }
        function reproducir(grabacion,archivo,idLlamada){
            document.getElementById("memo").style.visibility = "hidden";
            document.getElementById("memo").innerHTML = "";
            try{
                audio.pause();
                audio.remove();
                destroy = true;
                document.getElementById('myBar').innerHTML = "";
                width = 0;
                pause = false;
                stop = false;
                timeActual = 0;
                duration = 0;
                clearInterval(id);
            }
            catch(e){}
            document.getElementById("idGrabacion").value=idLlamada;
            audio = new Audio("escucha?wav=1&rutaArchivo="+grabacion+"&archivo="+archivo);
            var foto = document.getElementById("foto");
            audio.addEventListener('loadedmetadata', function() {
                duration = Math.floor(audio.duration);
                audio.play();
                document.getElementById("nombreGrabacion").innerHTML = "ID Grabacion: "+idLlamada;
                //foto.src = "imagenes/pause.png";
                foto.classname="fa fa-pause";
                cargarLineaTiempo();
                obtenerMemo();
                id = setInterval(modificarProgressBar, 1000);
            });
        audio.addEventListener('error', function(e) {
             alert("OCURRIO UN ERROR "+e.target.error.code);
         });
        audio.addEventListener('ended',function(){
            //document.getElementById("memo").style.visibility = "hidden";
            if(!destroy){
                pause = true;
                destroy = false;
            }
            document.getElementById('myBar').innerHTML = "";
            document.getElementById('por').innerHTML = "";
            width = 0;
            stop = true;
            clearInterval(id);
            //foto.src = "imagenes/play.png";
            foto.classname="fa fa-pause";
            document.getElementById('por').innerHTML = formatear(width)+" / "+formatear(duration);
            timeActual = 0;
            cargarLineaTiempo();
            obtenerMemo();
        });
        //if(!isNaN(audio.duration)){
            
        //}
        }
        function cancelar(){
            document.getElementById("memo").style.visibility = "hidden";
        }