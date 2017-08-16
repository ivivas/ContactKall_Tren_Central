/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function mostrarToolKit(target){
    target.style.visibility = "visible";
    target.style.display = "block";
}
function ocultarToolKit(target){
    target.style.visibility = "hidden";
    target.style.display = "none";
}
function enviar(){
    document.getElementById("idms").submit();
}