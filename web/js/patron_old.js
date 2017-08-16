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
       alert('No hay usuarios seleccionadas para eliminar');
       return false;
    }

    if (!confirm('Esta seguro que desea eliminar los usuarios seleccionados?')) {
        return false;
    }
    f.action = 'usuarios_registro.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}

/******************************************************/
/******* Funcion para verificar datos eliminar  *******/
function eliminarPatron(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('No hay patrones seleccionados para eliminar');
       return false;
    }

    if (!confirm('Esta seguro que desea eliminar los patrones seleccionados?')) {
        return false;
    }
    f.action = 'patronRegistros.jsp%variablesGetMasPg%';
    f.target = '_self';
    f.ncheckbox_eliminar.value=ncheckbox;
    f.submit();
}





/*************************************************************/
/******* Funcion para verificar datos usuario agregar  *******/
function verForm_patronAgregar(f) {
    
    if (f.patron_patron.value=='' || f.patron_nombre.value=='' || f.patron_costo.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    f.submit();
}



/*************************************************************/
/****** Funcion para verificar datos usuario modificar  ******/
function verForm_patronModificar(f) {
    if (f.patron_nombre.value=='') {
	alert('Debe llenar el campo nombre usuario.');
	return false;
    }
    /*if (f.usuario_clave1.value!=f.usuario_clave2.value)	{
	alert('Error: El campo verificar clave no es correcto.');
	return false;
    }*/
    
    /*if (f.select_usuario_perfil.value!='administrador' && f.select_anexos_asignados.length==0) {
	alert('Error: Debe asignar como m�nimo un anexo al usuario.');
	return false;
    }*/
    
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
                var estaInsertado = false;
                for(j=0; j<receptor.length; j++) {
                    if (receptor.options[j].value==volcado.value) {
                        estaInsertado=true;
                        break;
                    }
                }
                if (estaInsertado==false) {
                    posicion = receptor.options.length;
                    receptor.options[posicion] = new Option(volcado.text, volcado.value);
                }
            }
        }
    }
}

/*******************************************************/
/****** Funcion para asignar anexos entre select  ******/
function selectEliminarAnexo(){    
    selectAnexo = document.getElementById('select_anexos_asignados');    
    seleccionado = selectAnexo.selectedIndex;
    if(seleccionado != -1) {
        for(i=0; i<selectAnexo.length; i++) {
            if (selectAnexo[i].selected==true) {                
                selectAnexo.options[i] = null;
                i=-1; 
            }
        }
    }
}

