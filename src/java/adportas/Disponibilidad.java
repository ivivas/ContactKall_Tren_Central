package adportas;

public class Disponibilidad
{
  public String agregar(String nombre, String extension, int estado)
  {
    String estadoCSS = "";
    if (estado == 0) estadoCSS = "titulo_habilitada";
    if (estado == 1) {
      estadoCSS = "titulo_ocupada";
    }
    if (estado == 2) estadoCSS = "titulo_deshabilitada";
    String secretaria = "";
    secretaria = secretaria + "<tr><td width='8' height='32' >&nbsp;</td><td width='235'  ><label><input name='" + nombre.trim() + "' type='text' class='" + estadoCSS + "' size='45' value='" + extension.trim() + " - " + nombre.trim() + "'/>" + "</label>" + "</td><td width='10' >&nbsp</td><td width='177'  >" + "<label>" + "<input name='" + nombre.trim() + "_estado' type='text' class='" + estadoCSS + "' size='20' value='" + estadoCSS.substring(estadoCSS.indexOf("_") + 1) + "' />" + "</label>" + "</td></tr>";

    return secretaria;
  }
}