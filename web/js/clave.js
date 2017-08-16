var ncheckbox=%ncheckbox%;

/******************************************************/
/********** Funcion para seleccionar checkbox *********/
function checkboxSeleccionar(obj,ncheckbox) {
    if (obj.checked==true) for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=true; 
    else for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=false;     
}

/******************************************************/
/********** Funcion para ingresar solo numeros *********/
function soloNumeros(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;
    if((tecla>=48 && tecla <=57) || (tecla==46) || (tecla==8) || (tecla==0)) return true;		
    return false;
}

/******************************************************/
/******* Funcion para verificar datos eliminar  *******/
function claveEliminar(f) {
    ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('No hay claves seleccionadas para eliminar');
       return false;
    }

    if (!confirm('Esta seguro que desea eliminar las claves seleccionadas?')) {
        return false;
    }
 
    f.submit();
}

/*************************************************************/
/******* Funcion para verificar datos clave agregar  *******/
function verForm_claveAgregar(f) {
    if (f.clave_nombre.value=='' || f.clave_descripcion.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    f.submit();
}

/*************************************************************/
/****** Funcion para verificar datos clave modificar  ******/
function verForm_claveModificar(f) {
    if (f.clave_nombre.value=='' || f.clave_descripcion.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    f.submit();
}


