var ncheckbox=%ncheckbox%;

/*******************************************************/
/********** Funcion para seleccionar checkbox *********/
function checkboxSeleccionar(obj,ncheckbox) {
    if (obj.checked==true) for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=true; 
    else for(i=1;i<=ncheckbox;i++) document.getElementById('check'+ i ).checked=false;     
}

/*******************************************************/
/********** Funcion para seleccionar checkbox *********/
function mostrarDivOpciones(obj) {
    if (obj.value=='administrador') {
        document.getElementById('pantalla_opcion1').style.display="none";
        document.getElementById('pantalla_opcion2').style.display="none";        
        document.getElementById('pantalla_monitor_asignar_anexos').style.display="none";
        document.getElementById('pantalla_monitor_asignar_info').style.display="block";
    } else if (obj.value=='monitor') {
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

/*******************************************************/
/******* Funcion para verificar datos eliminar  *******/
function ccostoEliminar(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('No hay centros de costos seleccionadas para eliminar');
       return false;
    }

    if (!confirm('Esta seguro que desea eliminar los centros de costos seleccionados?')) {
        return false;
    }
    f.action = 'centrocostoRegistro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}


/***************************************************************/
/****** Funcion para verificar datos centro costo nuevo  ******/
function verForm_ccostoAgregar(f) {
    
    if (f.centrocosto_nombre.value=='' || f.centrocosto_descripcion.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    
    for(i=0; i<f.select_usuarios_asignados.length;i++) {
        f.select_usuarios_asignados[i].selected=true;
    } 
    f.submit(); 
}

/*******************************************************************/
/****** Funcion para verificar datos centro costo modificar  ******/
function verForm_ccostoModificar(f) {
    if (f.centrocosto_nombre.value=='') {
	alert('Debe llenar el campo nombre del centro de costos.');
	return false;
    }
    
    for(i=0; i<f.select_usuarios_asignados.length;i++) {
        f.select_usuarios_asignados[i].selected=true;
    }
    f.submit();
}
