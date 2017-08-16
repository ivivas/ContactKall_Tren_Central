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
function eliminaPatron(f) {
    var ticket=false;
    for(i=1;i<=ncheckbox;i++) { 
        if (document.getElementById('check'+ i ).checked==true) {
           ticket=true;
           break;
        }
    }
    if (ticket==false) {
       alert('No hay particiones seleccionados para eliminar');
       return false;
    }

    if (!confirm('Esta seguro que desea eliminar las particiones seleccionadas?')) {
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
    
    if (f.patron_nombre.value=='' || f.patron_costo.value=='') {
	alert('Debe llenar todos los campos obligatorios.');
	return false;
    }
    f.submit();
}



/*************************************************************/
/****** Funcion para verificar datos usuario modificar  ******/
function verForm_patronModificar(f) {
    if (f.patron_nombre.value=='') {
	alert('Debe llenar el campo nombre particion.');
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

/******************************************************/
/********** Funcion para ingresar solo numeros *********/
function soloNumeros(e) {
    var tecla;
    if(navigator.appName=='Netscape') tecla=e.which;
    else tecla=e.keyCode;
    if((tecla>=48 && tecla <=57) || (tecla==46) || (tecla==8) || (tecla==0)) return true;		
    return false;
}

