package adportas;

public class HabilitadorSecretarias
{
  public String agregarSecretaria(int id_usuario, String nombre, String estado, String valor)
  {
    String radio1 = "";
    String radio2 = "";
    if (estado.trim().equalsIgnoreCase("habilitada")) {
      radio1 = "<input name=\"radio" + valor + "\" type=\"radio\" value=\"habilitada&" + String.valueOf(id_usuario) + "\" checked onClick=\"cambiarEstado(this)\" />";
      radio2 = "<input name=\"radio" + valor + "\" type=\"radio\" value=\"deshabilitada&" + String.valueOf(id_usuario) + "\" onClick=\"cambiarEstado(this)\" />";
    }
    else if (estado.trim().equalsIgnoreCase("deshabilitada")) {
      radio1 = "<input name=\"radio" + valor + "\" type=\"radio\" value=\"habilitada&" + String.valueOf(id_usuario) + "\" onClick=\"cambiarEstado(this)\" />";
      radio2 = "<input name=\"radio" + valor + "\" type=\"radio\" value=\"deshabilitada&" + String.valueOf(id_usuario) + "\" checked onClick=\"cambiarEstado(this)\" />";
    }
    String secretaria = "<tr><td><label><input name=\"" + nombre + "\" type=\"text\" class=\"titulo_" + estado + "\" id=\"" + nombre + "\" size=\"40\" value='" + nombre + "' onClick=\"cambiarEstado(this)\" />" + "</label></td>" + "<td width=\"1\">&nbsp;</td><td width=\"43\">" + radio1 + "</td>" + "<td width=\"3\">&nbsp;</td><td><label>" + "<input name=\"habilitada\" type=\"text\" class=\"titulo_habilitada\" id=\"habilitada\" size=\"13\" value=\"habilitada\" />" + "</label></td>" + "<td width=\"1\">&nbsp;</td><td width=\"43\">" + radio2 + "<td width=\"3\">&nbsp;</td>" + "<td><label><input name=\"deshabilitada\" type=\"text\" class=\"titulo_deshabilitada\" id=\"deshabilitada\" size=\"13\" value=\"deshabilitada\" />" + "</label></td>" + "<td width=\"1\">&nbsp;</td></tr>";

    return secretaria;
  }
}