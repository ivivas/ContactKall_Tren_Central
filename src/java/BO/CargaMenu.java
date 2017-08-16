/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BO;

import DTO.Configuracion;
import adportas.Plantillas;
import java.util.ResourceBundle;
import query.AcdKallGestion;
import query.IPKall;
import query.Ivr;
import query.IvrEncuestaQry;
import query.Reckall;

/**
 *
 * @author Ricardo Fuentes
 */
public class CargaMenu {
    
    public static String menuDinamico(String sesionActual,ResourceBundle msgs, String ruta){
        String menu="";
        Configuracion confReckall = Reckall.conf==null?Reckall.configuracionReckall():Reckall.conf;
        Configuracion confIPkall = IPKall.conf==null?IPKall.configuracionIPKall():IPKall.conf;
        Configuracion confGestion = AcdKallGestion.conf==null?AcdKallGestion.configuracionGestion():AcdKallGestion.conf;
        Configuracion confIVR = Ivr.configuracionIVR();
        
        IvrEncuestaQry encuesta = new IvrEncuestaQry();
        try{
            if (sesionActual.equalsIgnoreCase("adm_general")) {
                menu = Plantillas.leer(ruta + "/plantillas/menu_cc_admin.html");
                String men_grab = "";
                String men_ipkl="";
                String men_enc="";
                String men_ges="";
                String men_ivr="";
                if(confReckall.isIntegrado()){
                    men_grab = "<a href=\"grabaciones.jsp\" title=\"%menu.adm.txt.grabaciones%\"> <div class=\"%class_grab%\"><i class=\"fa fa-microphone\"></i></div></a>";
                }
                if(confIPkall.isIntegrado()){
                    men_ipkl = "<a href=\"campana.jsp\" title=\"%menu.adm.txt.discador%\" ><div class=\"%class_camp%\"><i class=\"fa fa-building-o\"></i></div>  </a>"+
                    "<a href=\"callBack.jsp\" title=\"%menu.adm.txt.callback%\" ><div class=\"%class_callback%\"><i class=\"fa fa-phone\"></i></div>  </a>";
                }
                if(encuesta.getIntegracion()){
                    men_enc = "<a href=\"encuestaIvr.jsp\" title=\"%menu.adm.txt.encuesta%\" ><div class=\"%class_enc%\"><i class=\"fa fa-bar-chart\"></i></div>  </a>";
                }
                if(confGestion.isIntegrado()){
                    men_ges = "<a href=\"llamadasRegistros.jsp\" title=\"%menu.adm.txt.registro%\" ><div class=\"%class_ges%\"><i class=\"fa fa-list\"></i></div>  </a>";
                }
                if(confIVR.isIntegrado()){
                    men_ivr = "<a href=\"estadisticaIVR.jsp\" title=\"%menu.adm.txt.ivr%\"> <div class=\"%class_ivrchart%\"><i class=\"fa fa-pie-chart\"></i></div></a>";
                }
                
                menu = Plantillas.reemplazar(menu,"%grabaciones%",men_grab);
                menu = Plantillas.reemplazar(menu,"%campanias%",men_ipkl);
                menu = Plantillas.reemplazar(menu,"%encuesta%",men_enc);
                menu = Plantillas.reemplazar(menu,"%gestion%",men_ges);
                menu = Plantillas.reemplazar(menu,"%ivr%",men_ivr);
                
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.habilitacion%",msgs.getString("menu.adm.txt.habilitacion"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.grabaciones%",msgs.getString("menu.adm.txt.grabaciones"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.pilotos%",msgs.getString("menu.adm.txt.pilotos"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.agentes%",msgs.getString("menu.adm.txt.agentes"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.discador%",msgs.getString("menu.adm.txt.discador"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.calidadServicio%",msgs.getString("menu.adm.txt.calidadServicio"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.encuesta%",msgs.getString("menu.adm.txt.encuesta"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.configuracion%",msgs.getString("menu.adm.txt.configuracion"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.registro%",msgs.getString("menu.adm.txt.registro"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.salir%",msgs.getString("menu.adm.txt.salir"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.ivr%",msgs.getString("menu.adm.txt.ivr"));
                
            }else if(sesionActual.equalsIgnoreCase("supervisor")){
                menu = Plantillas.leer(ruta + "/plantillas/menu_cc_super.html");
                String men_grab = "";
                String men_ipkl="";
                String men_enc = "";
                String men_ges="";
                String men_ivr="";
                if(confReckall.isIntegrado()){
                    men_grab = "<a href=\"grabaciones.jsp\" title=\"%menu.adm.txt.grabaciones%\"> <div class=\"%class_grab%\"><i class=\"fa fa-microphone\"></i></div></a>";
                }
                if(confIPkall.isIntegrado()){
                    men_ipkl = "<a href=\"campana.jsp\" title=\"%menu.adm.txt.discador%\" ><div class=\"%class_camp%\"><i class=\"fa fa-building-o\"></i></div>  </a>"+
                    "<a href=\"callBack.jsp\" title=\"%menu.adm.txt.callback%\" ><div class=\"%class_callback%\"><i class=\"fa fa-building-o\"></i></div>  </a>";
                }
                if(encuesta.getIntegracion()){
                    men_enc = "<a href=\"encuestaIvr.jsp\" title=\"%menu.adm.txt.encuesta%\" ><div class=\"%class_enc%\"><i class=\"fa fa-bar-chart\"></i></div>  </a>";
                }
                if(confGestion.isIntegrado()){
                    men_ges = "<a href=\"llamadasRegistros.jsp\" title=\"%menu.adm.txt.registro%\" ><div class=\"%class_ges%\"><i class=\"fa fa-list\"></i></div>  </a>";
                }
                if(confIVR.isIntegrado()){
                    men_ivr = "<a href=\"estadisticaIVR.jsp\" title=\"%menu.adm.txt.ivr%\"> <div class=\"%class_ivrchart%\"><i class=\"fa fa-pie-chart\"></i></div></a>";
                }
                
                menu = Plantillas.reemplazar(menu,"%grabaciones%",men_grab);
                menu = Plantillas.reemplazar(menu,"%campanias%",men_ipkl);
                menu = Plantillas.reemplazar(menu,"%encuesta%",men_enc);
                menu = Plantillas.reemplazar(menu,"%gestion%",men_ges);
                menu = Plantillas.reemplazar(menu,"%ivr%",men_ivr);
                
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.habilitacion%",msgs.getString("menu.adm.txt.habilitacion"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.grabaciones%",msgs.getString("menu.adm.txt.grabaciones"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.pilotos%",msgs.getString("menu.adm.txt.pilotos"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.agentes%",msgs.getString("menu.adm.txt.agentes"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.discador%",msgs.getString("menu.adm.txt.discador"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.calidadServicio%",msgs.getString("menu.adm.txt.calidadServicio"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.encuesta%",msgs.getString("menu.adm.txt.encuesta"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.salir%",msgs.getString("menu.adm.txt.salir"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.ivr%",msgs.getString("menu.adm.txt.ivr"));
                menu = Plantillas.reemplazar(menu, "%menu.adm.txt.registro%",msgs.getString("menu.adm.txt.registro"));
                
            }else if(sesionActual.equalsIgnoreCase("usuario")){
                menu = Plantillas.leer(ruta + "/plantillas/menu_cc_user.html");
            }
        }catch(Exception e){
            System.out.println("Error en CargaMenu: "+e);
        }
        return menu;
    }
    
    
}
