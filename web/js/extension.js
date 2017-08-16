var ncheckbox=%ncheckbox%;

/******************************************************/
/********** Funcion para seleccionar checkbox *********/
function checkboxSeleccionar(obj,ncheckbox) {
    if (obj.checked==true) for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=true; 
    else for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=false;     
}

/********************************************************/
/********** Funcion para ingresar solo numeros *********/
/**************en el acckall no se aplica *************/
function soloNumeros(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;
    if((tecla>=48 && tecla <=57) || (tecla==46) || (tecla==8) || (tecla==0)) return true;		
    return false;
}
function ctiportAgregar(f) {
    if (f.musica_nombre.value=='') {
	alert('%m%');
	return false;
    }
    f.target = '_self';
    f.submit();
}
function ctiportEliminar(f){
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) {
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('%e%');
       return false;
    }

    if (!confirm('%c%')) {
        return false;
    }
    f.action = 'ctiportRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();  
}
function ctiportModificar(f) {
    if (f.musica_nombre.value=='') {
	alert('%m%');
	return false;
    }if(f.largo.value !== ''){
        var largo = f.largo.value.trim();
        if(!/^([0-9])*$/.test(largo)){
            alert('%format_num%');
            return false;
        }
    }
    f.submit();
}

/*****************************************************************/
/******* Funcion para verificar datos eliminar extension  *******/
function extensionEliminar(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('%js_nodata_del1%');
       return false;
    }

    if (!confirm('%js_conf_del1%')) {
        return false;
    }
    f.action = 'extensionRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}
function monitorEliminar(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('%js_nodata_del1%');
       return false;
    }

    if (!confirm('%js_conf_del1%')) {
        return false;
    }
    f.action = 'monitorRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}

/*************************************************************/
/******* Funcion para verificar datos extension agregar  *******/
function extensionAgregar(f) {
    if (f.extension_numero.value=='') {
	alert('%js_err_datainc%');
	return false;
    }
    f.target = '_self';
    f.submit();
}
function monitorAgregar(f) {
    if (f.extension_numero.value=='') {
	alert('%js_err_datainc%');
	return false;
    }
    f.target = '_self';
    f.submit();
}

/*************************************************************/
/****** Funcion para verificar extension anexo modificar  ******/
function extensionModificar(f) {
    if (f.extension_numero.value=='') {
	alert('%js_err_datainc1%');
	return false;
    }
    f.submit();
}
function monitorModificar(f) {
    if (f.extension_numero.value=='') {
	alert('%js_err_datainc1%');
	return false;
    }
    f.submit();
}

function usuarioModificar(f) {
    if (f.modificar_usuario.value=='') {
	alert('%js_err_datainc2%');
	return false;
    }
    f.submit();
}

/******* Funcion para verificar numero virtual  *******/

function virtualAgregar(f) {
    if (f.virtual_numero.value==='') {
	alert('%js_err_datainc3%');
	return false;
    }
    f.target = '_self';
    f.submit();
}

/*************************************************************/
/****** Funcion para verificar extension anexo modificar  ******/
function virtualModificar(f) {
    if (f.virtual_numero.value==='') {
	alert('%js_err_datainc4%');
	return false;
    }
    f.submit();
}




/******* Funcion para verificar datos eliminar extension  *******/
function virtualEliminar(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) {
        if (document.getElementById('check'+ i ).checked===true) {
           ticket=true;
           break;
        }
    }
    if (ticket===false) {
       alert('%js_nodata_del2%');
       return false;
    }

    if (!confirm('%js_conf_del2%')) {
        return false;
    }
    f.action = 'virtualRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}

function cambiaTipo(combo){
    if(combo.value==='adm_pool'||combo.value==='usuario'){
        document.getElementById('cmb_extn').style.visibility='visible';
    }else{
        document.getElementById('cmb_extn').style.visibility='hidden';
    }
}

function agregaReckall(){
    document.getElementById('modificar_Reck').value = 'true';
    document.adminForm_extensionModificar.submit();
}

function mostrarToolKit(target){
    target.style.visibility = "visible";
    target.style.display = "block";
}
function ocultarToolKit(target){
    target.style.visibility = "hidden";
    target.style.display = "none";
}