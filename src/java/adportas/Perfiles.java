package adportas;

public class Perfiles
{
  public static Boolean numeroVirtual(String perfil, String numero)
  {
    boolean esta = false;
    if ((perfil.trim().equalsIgnoreCase("adm_general")) || (perfil.trim().equalsIgnoreCase("usuario")) || (perfil.trim().equalsIgnoreCase("supervisor")) || (perfil.trim().equalsIgnoreCase("adm_pool")))
      esta = true;
    else if ((perfil.equalsIgnoreCase("ggee_asistencia")) && (numero.trim().equalsIgnoreCase("85367")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("ggee_secretaria")) && (numero.trim().equalsIgnoreCase("85369")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("cap")) && (numero.trim().equalsIgnoreCase("85398")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("imb_asistencia")) && (numero.trim().equalsIgnoreCase("85391")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("imb_secretaria")) && (numero.trim().equalsIgnoreCase("85392")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("pac_asistencia")) && (numero.trim().equalsIgnoreCase("85396")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("pac_secretaria")) && (numero.trim().equalsIgnoreCase("85397")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("may1")) && (numero.trim().equalsIgnoreCase("85443")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("may2")) && (numero.trim().equalsIgnoreCase("85442")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("may3")) && (numero.trim().equalsIgnoreCase("85450")))
      esta = true;
    else if ((perfil.trim().equalsIgnoreCase("may4")) && (numero.trim().equalsIgnoreCase("85460"))) {
      esta = true;
    }
    return Boolean.valueOf(esta);
  }
}