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

/******************************************************/
/******* Funcion para verificar datos eliminar  *******/
function eliminarRegistro(f) {
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
    f.action = 'virtualNumeroAgregar.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}

/*************************************************************/
/******* Funcion para verificar datos usuario agregar  *******/
function verForm_usuarioAgregar(f) {
    
    if (f.usuario_nick.value=='' || f.usuario_nombre.value=='' || f.usuario_clave1.value=='' || f.usuario_clave2.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    if (f.usuario_clave1.value!=f.usuario_clave2.value)	{
	alert('Error: El campo verificar clave no es correcto.');
	return false;
    }
    
    if (f.select_usuario_perfil.value!='administrador' && f.select_anexos_asignados.length==0) {
	alert('Error: Debe asignar como minimo un anexo al usuario.');
	return false;
    }
    
    for(i=0; i<f.select_anexos_asignados.length;i++) {
        f.select_anexos_asignados[i].selected=true;
    } 
    f.submit();    
}
function subirAnexo(){
    
    var asignado = document.getElementById('select_anexos_asignados');
    var seleccionado = asignado.selectedIndex;
    var elDeArriba = asignado.selectedIndex-1;
    if(seleccionado!==0){
        var anterior = asignado.options[elDeArriba].text;
        var anteriorid = asignado.options[elDeArriba].value;
        var siguiente = asignado.options[seleccionado].text;
        var siguienteid = asignado.options[seleccionado].value;
        asignado.options[seleccionado].text = anterior;
        asignado.options[seleccionado].value = anteriorid;
        asignado.options[elDeArriba].text = siguiente;
        asignado.options[elDeArriba].value = siguienteid;
        asignado.selectedIndex = elDeArriba;
    }
}
function bajarAnexo(){
    var asignado = document.getElementById('select_anexos_asignados');
    var seleccionado = asignado.selectedIndex;
    var elDeAbajo = asignado.selectedIndex+1;
    if(asignado.selectedIndex<asignado.options.length-1){
        var anterior = asignado.options[elDeAbajo].text;
        var anteriorid = asignado.options[elDeAbajo].value;
        var siguiente = asignado.options[seleccionado].text;
        var siguienteid = asignado.options[seleccionado].value;
        asignado.options[seleccionado].text = anterior;
        asignado.options[seleccionado].value = anteriorid;
        asignado.options[elDeAbajo].text = siguiente;
        asignado.options[elDeAbajo].value = siguienteid;
        asignado.selectedIndex = elDeAbajo;
    }
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

    for(i=0; i<f.select_anexos_disponibles.length;i++) {
        f.select_anexos_disponibles[i].selected=true;
    }
    f.submit();
}

/*******************************************************/
/****** Funcion para asignar anexos entre select  ******/
function selectAsignarAnexo(){
    // Accedemos a los 2 selects
    emisor = document.getElementById('select_anexos_disponibles');
    receptor = document.getElementById('select_anexos_asignados');
    // Obtenemos algunos datos necesarios
    seleccionado = emisor.selectedIndex;
    if(seleccionado != -1) {
        for(i=0; i<emisor.length; i++) {
            if (emisor[i].selected==true) {
                volcado = emisor.options[i];
                //Recorro si ya ha sido asignado, si no lo est� lo inserto
                posicion = receptor.options.length;
                receptor.options[posicion] = new Option(volcado.text, volcado.value);
                emisor.options[i] = null;
                i=-1;

            }
        }
    }
}

/*******************************************************/
/****** Funcion para asignar anexos entre select  ******/
function selectEliminarAnexo(){    
    selectAnexo = document.getElementById('select_anexos_asignados');
    emisor = document.getElementById('select_anexos_disponibles');
    seleccionado = selectAnexo.selectedIndex;
    if(seleccionado != -1) {
        for(i=0; i<selectAnexo.length; i++) {
            if (selectAnexo[i].selected==true) {
                volcado = selectAnexo.options[i];
                posicion = emisor.options.length;
                emisor.options[posicion] = new Option(volcado.text, volcado.value);
                selectAnexo.options[i] = null;
                i=-1;
            }
        }
    }
}