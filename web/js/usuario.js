var ncheckbox=%ncheckbox%;

/******************************************************/
/********** Funcion para seleccionar checkbox *********/
function checkboxSeleccionar(obj,ncheckbox) {
    if (obj.checked==true) for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=true; 
    else for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=false;     
}

/******************************************************/
/********** Funcion para seleccionar checkbox *********/
function mostrarDivOpciones(obj) {
    if (obj.value==='administrador') {
        document.getElementById('pantalla_opcion1').style.display="none";
        document.getElementById('pantalla_opcion2').style.display="none";        
        document.getElementById('pantalla_monitor_asignar_anexos').style.display="none";
        document.getElementById('pantalla_monitor_asignar_info').style.display="block";
    } else if (obj.value==='monitor') {
        document.getElementById('pantalla_opcion1').style.display="block";
        document.getElementById('pantalla_opcion2').style.display="block";
        document.getElementById('pantalla_monitor_asignar_anexos').style.display="block";
        document.getElementById('pantalla_monitor_asignar_info').style.display="none";
    } else {
        document.getElementById('pantalla_opcion1').style.display="none";
        document.getElementById('pantalla_opcion2').style.display="block";
        document.getElementById('pantalla_monitor_asignar_anexos').style.display="block";
        document.getElementById('pantalla_monitor_asignar_info').style.display="none";
    }
}

/******************************************************/
/******* Funcion para verificar datos eliminar  *******/
function usuarioEliminar(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('%js_err_nodatadel1%');
       return false;
    }

    if (!confirm('%js_conf_del1%')) {
        return false;
    }
    f.action = 'usuarioRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}


/*************************************************************/
/******* Funcion para verificar datos usuario agregar  *******/
/*var f  */
function verForm_usuarioAgregar(f) {
    
    if (f.usuario.value==='' || f.clave.value===''  || f.repclave.value==='') {
	alert('%js_err_nodata_add%');
	return false;
    }else if(f.clave.value !== f.repclave.value){
        alert('%js_err_dist_pss%');
        return false;
    }
    //alert('combo: '+document.getElementById('agregar_tipo').value);
    if(document.getElementById('agregar_tipo').value===''){
        alert('%js_err_nodata_add%');
        return false;
    }else if(document.getElementById('agregar_tipo').value!=='adm_general'){
        
        //alert('combo_pool: '+document.getElementById('combo_pool').value+' combo_sep_sup: '+document.getElementById('combo_sep_sup').value);
        
        if(document.getElementById('combo_sep_sup').value=== '' || document.getElementById('combo_pool').value === ''){
            alert('%js_err_nodata_add%');
            return false;
        }
    }
    //alert('ok');
    f.submit();
}

/*************************************************************/
/****** Funcion para verificar datos usuario modificar  ******/
function verForm_usuarioModificar(f) {
    if (f.usuario_nombre.value=='') {
	alert('%js_err_datainc1%');
	return false;
    }
    
    for(i=0; i<f.select_anexos_asignados.length;i++) {
        f.select_anexos_asignados[i].selected=true;
    }
    f.submit();
}
