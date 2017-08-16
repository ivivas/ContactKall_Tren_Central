
var ncheckbox=%ncheckbox%;

/* Funcion para seleccionar checkbox */
function checkboxSeleccionar(obj,ncheckbox) {
    if (obj.checked==true) for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=true; 
    else for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=false;     
}

/* Funcion para ingresar solo numeros */
function soloNumeros(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;    
    else tecla=e.keyCode;    
    if((tecla>=48 && tecla <=57) || (tecla==8) || (tecla==0) || (tecla==13)) return true;		
    return false;
}

/* Funcion para ingresar solo Fecha Hora */
function soloFechaHora(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;    
    if((tecla>=47 && tecla <=58) || (tecla==8) || (tecla==0) || (tecla==13) || (tecla==32) || (tecla==118) || (tecla==99)) return true;
    return false;
}


/* Funcion para ingresar solo numeros */
function soloFecha(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;
    if((tecla>=47 && tecla <=57) || (tecla==8) || (tecla==0) || (tecla==13)) return true;		
    return false;
}


/* Funcion para ingresar solo numeros */
function soloHora(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;    
    if((tecla>=48 && tecla <=58) || (tecla==8) || (tecla==0) || (tecla==13)) return true;		
    return false;
}


/* Funcion para verificar datos eliminar  */
function eliminarRegistro() {
    ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
            ticket=true;
            break;
        }
    }
    if (ticket==false) {
        alert('No hay grabaciones seleccionados para eliminar');
        return false;
    }
    
    if (!confirm('¿Está seguro que desea eliminar las grabaciones seleccionadas?')) {
        return false;
    }    
    document.forms.adminForm_eliminar.submit();    
}


/* Funcion para verificar datos eliminar Busqueda  */
function eliminarRegistroBusqueda() {
    var numero_grabaciones_busqueda = %numero_grabaciones_busqueda%;
    if (numero_grabaciones_busqueda == 0) {
        alert('No hay grabaciones en la búsqueda para eliminar');
        return false;
    }
    if  (numero_grabaciones_busqueda>1) texto = ' grabaciones';
    else texto = ' grabación';
    if (!confirm('Va a eliminar ' + numero_grabaciones_busqueda + texto + '.\n¿Desea continuar?')) {
        return false;
    }    
    document.getElementById('ncheckbox_eliminar').value = -1;
    document.forms.adminForm_eliminar.submit();    
}

/* Funciones para crear un tooltipbox */
var theObj="";
function toolTip(text,me) {
    theObj=me;
    theObj.onmousemove=updatePos;
    document.getElementById('toolTipBox').innerHTML=text;
    document.getElementById('toolTipBox').style.display="block";
    window.onscroll=updatePos;
}
function updatePos() {
    var ev=arguments[0]?arguments[0]:event;
    var x=ev.clientX;
    var y=ev.clientY;
    diffX=0;
    diffY=4;
    document.getElementById('toolTipBox').style.top  = y-2+diffY+document.body.scrollTop+ "px";
    document.getElementById('toolTipBox').style.left = x-2+diffX+document.body.scrollLeft+"px";
    theObj.onmouseout=hideMe;
}

function hideMe() {
    document.getElementById('toolTipBox').style.display="none";
}

/* Funciones para crear un tooltipbox 2 */
var theObj2="";
function toolTip2(text,me) {
    theObj2=me;
    theObj2.onmousemove=updatePos2;
    document.getElementById('toolTipBox').innerHTML=text;
    document.getElementById('toolTipBox').style.display="block";
    window.onscroll=updatePos2;
}
function updatePos2() {
    var ev=arguments[0]?arguments[0]:event;
    var x=ev.clientX;
    var y=ev.clientY;
    diffX=0;
    diffY=4;
    document.getElementById('toolTipBox').style.top  = y-48+diffY+document.body.scrollTop+ "px";                
    document.getElementById('toolTipBox').style.left = x-100+diffX+document.body.scrollLeft+"px";
    theObj2.onmouseout=hideMe2;
}

function hideMe2() {
    document.getElementById('toolTipBox').style.display="none";
}

/* Funcion para verificar datos eliminar Busqueda */
function abrirArchivoRespaldado(archivoID, archivoUnidad, archivoEtiqueta) {
    alert('Para escuchar esta grabación inserte el ' + archivoUnidad + ' con etiqueta ' + archivoEtiqueta + "\n" + 'Luego haga una búsqueda del Nº de registro ' + archivoID);
}

/* Funcion para verificar datos eliminar Busqueda */
function editarContenido(pkLlamada, idMatch) {
    ventanaEditar = window.open('grabacionEditar.jsp?pkLlamada=' + pkLlamada + '&idMatch=' + idMatch, 'grabacionEditar', 'top=250px,left=500px,width=420px,height=200px,resizable=false,scrollbars=yes');
    ventanaEditar.focus();
}

// siendo anx el ID del combo
new YAHOO.Hack.FixIESelectWidth('anx');