package adportas;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.List;
import java.util.ResourceBundle;
import query.ComboQuery;
import static query.ComboQuery.getRuteoEnPalabras;

public class Plantillas
{
  public static String leer(String ruta)
    throws FileNotFoundException, IOException
  {
    File f = new File(ruta);
    long len = f.length();
    char[] cdata = new char[(int)len];
    FileInputStream fis = new FileInputStream(f);
    InputStreamReader isr = new InputStreamReader(fis, "ISO-8859-1");
    isr.read(cdata);
    String data = new String(cdata);
    return data;
  }

  public static String leer2(String ruta)
    throws FileNotFoundException, IOException
  {
    String archivo = System.getProperty("user.dir") + "/" + ruta;
    File f = new File(archivo);
    long len = f.length();
    char[] cdata = new char[(int)len];
    FileReader fr = new FileReader(f);
    fr.read(cdata);
    String data = new String(cdata);
    return data;
  }

  public static String reemplazar(String texto, String[] areemplazar, String[] reemplazo)
  {
    String resultado = texto;
    for (int i = 0; i < reemplazo.length; i++) {
      resultado = reemplazar(resultado, areemplazar[i], reemplazo[i]);
    }
    return resultado;
  }

  public static String reemplazar(String texto, String areemplazar, String reemplazo)
  {
    int areemplazarLength = areemplazar.length();
    if (areemplazarLength == 0)
      throw new IllegalArgumentException("String to be replaced must not be empty");
    int start = texto.indexOf(areemplazar);
    if (start == -1)
      return texto;
    boolean greaterLength = reemplazo.length() >= areemplazarLength;
    StringBuffer buffer;
//    StringBuffer buffer;
    if (greaterLength)
    {
      if (areemplazar.equals(reemplazo))
        return texto;
      buffer = new StringBuffer(texto.length());
    }
    else {
      buffer = new StringBuffer();
    }
    char[] textoChars = texto.toCharArray();
    int copyFrom = 0;
    for (; start != -1; start = texto.indexOf(areemplazar, copyFrom))
    {
      buffer.append(textoChars, copyFrom, start - copyFrom);
      buffer.append(reemplazo);
      copyFrom = start + areemplazarLength;
    }

    buffer.append(textoChars, copyFrom, textoChars.length - copyFrom);
    return buffer.toString();
  }

  public static void main(String[] Args)
    throws IOException
  {
    String path = System.getProperty("user.dir");
    System.out.println(path);
    BufferedReader i = new BufferedReader(new InputStreamReader(System.in));
    System.out.println("Indique la ruta del archivo a visualizar:");
    String ruta = i.readLine();
    String archivo = leer(ruta);
    System.out.println(archivo);
  }
  public static String comboRuteo(String id,ResourceBundle idioma){
       String seleccion = "";
       StringBuilder sB = new StringBuilder();
       List<String> lista = ComboQuery.getComboRuteo();
       for(String ruteo : lista){
           if(ruteo.equals(id)){
               seleccion = "selected";
           }
           else{ 
               seleccion = "";
           }
           sB.append("<option value='");
           sB.append(ruteo);
           sB.append("' ");
           sB.append(seleccion);
           sB.append(" >");
           sB.append(getRuteoEnPalabras(Integer.parseInt(ruteo),idioma));
           sB.append("</option>");
       }
      return sB.toString();
  }
}