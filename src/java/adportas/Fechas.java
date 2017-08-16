package adportas;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class Fechas{
    public static String formatoddmmaa(Timestamp ts){
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        String s = df.format(ts);
        return s;
    }

    public static String TimetoString(Timestamp ts) {
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        String s = df.format(ts);
        return s;
    }
    
    public static Timestamp ddmmaa2time(String fecha) throws ParseException{
        String format="";
        if(fecha.length()==10){
            format = "dd/MM/yyyy";
        }else if(fecha.length()==16){
            format = "dd/MM/yyyy HH:mm";
        }else if(fecha.length()==19){
            format = "dd/MM/yyyy HH:mm:ss";
        }
        DateFormat df = new SimpleDateFormat(format);
        Date d = df.parse(fecha);
        return new Timestamp(d.getTime());
    }
    
    public static Timestamp ddmmaa2timePostgres(String fecha) throws ParseException{
        String format="";
        if(fecha.length()==10){
            format = "dd/MM/yyyy";
        }else if(fecha.length()==16){
            format = "dd/MM/yyyy HH:mm";
        }else if(fecha.length()==19){
            format = "dd/MM/yyyy HH:mm:ss";
        }
        
        DateFormat df = new SimpleDateFormat(format);
        Date d = df.parse(fecha.replaceAll("-", "/"));
        return new Timestamp(d.getTime());
    }

    public static String DiaAnterior(){
        String anno = "1980";
        String mes = "01";
        String dia = "01";
        Calendar calendario = Calendar.getInstance();
        if (calendario.get(7) == 1) {
          calendario.add(5, -2);
        }else if (calendario.get(7) == 2){
          calendario.add(5, -3);
        }else{
          calendario.add(5, -1);
        }
        anno = String.valueOf(calendario.get(1));
        if (calendario.get(2) + 1 < 10){
          mes = "0" + String.valueOf(calendario.get(2) + 1);
        }else{
          String.valueOf(calendario.get(2) + 1);
        }
        if (calendario.get(5) < 10){
          dia = "0" + String.valueOf(calendario.get(5));
        }else{
          dia = String.valueOf(calendario.get(5));
        }
        return dia + "/" + mes + "/" + anno;
    }

    public static String SemanaAnteriorDesde(){
        String anno = "1980";
        String mes = "01";
        String dia = "01";
        Calendar calendario = Calendar.getInstance();
        int dia_actual = calendario.get(7);
        switch (dia_actual){
        case 2:
            calendario.add(5, -7);
            break;
        case 3:
            calendario.add(5, -8);
            break;
        case 4:
            calendario.add(5, -9);
            break;
        case 5:
            calendario.add(5, -10);
            break;
        case 6:
            calendario.add(5, -11);
            break;
        case 7:
            calendario.add(5, -12);
            break;
        case 1:
            calendario.add(5, -13);
        }

        anno = String.valueOf(calendario.get(1));
        if (calendario.get(2) + 1 < 10)
          mes = "0" + String.valueOf(calendario.get(2) + 1);
        else
          mes = String.valueOf(calendario.get(2) + 1);
        if (calendario.get(5) < 10)
          dia = "0" + String.valueOf(calendario.get(5));
        else
          dia = String.valueOf(calendario.get(5));
        return dia + "/" + mes + "/" + anno;
    }

  public static String SemanaAnteriorHasta()
  {
    String anno = "1980";
    String mes = "01";
    String dia = "01";
    Calendar calendario = Calendar.getInstance();
    int dia_actual = calendario.get(7);
    switch (dia_actual)
    {
    case 2:
      calendario.add(5, -3);
      break;
    case 3:
      calendario.add(5, -4);
      break;
    case 4:
      calendario.add(5, -5);
      break;
    case 5:
      calendario.add(5, -6);
      break;
    case 6:
      calendario.add(5, -7);
      break;
    case 7:
      calendario.add(5, -8);
      break;
    case 1:
      calendario.add(5, -9);
    }

    anno = String.valueOf(calendario.get(1));
    if (calendario.get(2) + 1 < 10)
      mes = "0" + String.valueOf(calendario.get(2) + 1);
    else
      mes = String.valueOf(calendario.get(2) + 1);
    if (calendario.get(5) < 10)
      dia = "0" + String.valueOf(calendario.get(5));
    else
      dia = String.valueOf(calendario.get(5));
    return dia + "/" + mes + "/" + anno;
  }

  public static String MesAnteriorMaximo()
  {
    String anno = "1980";
    String mes = "01";
    String dia = "01";
    Calendar calendario = Calendar.getInstance();
    calendario.add(2, -1);
    anno = String.valueOf(calendario.get(1));
    if (calendario.get(2) + 1 < 10)
      mes = "0" + String.valueOf(calendario.get(2) + 1);
    else
      String.valueOf(calendario.get(2) + 1);
    if (calendario.getActualMaximum(5) < 10)
      dia = "0" + String.valueOf(calendario.getActualMaximum(5));
    else
      dia = String.valueOf(calendario.getActualMaximum(5));
    return dia + "/" + mes + "/" + anno;
  }

  public static String MesAnteriorMinimo(){
    String anno = "1980";
    String mes = "01";
    String dia = "01";
    Calendar calendario = Calendar.getInstance();
    calendario.add(2, -1);
    anno = String.valueOf(calendario.get(1));
    if (calendario.get(2) + 1 < 10)
      mes = "0" + String.valueOf(calendario.get(2) + 1);
    else
      String.valueOf(calendario.get(2) + 1);
    if (calendario.getActualMinimum(5) < 10)
      dia = "0" + String.valueOf(calendario.getActualMinimum(5));
    else
      dia = String.valueOf(calendario.getActualMinimum(5));
    return dia + "/" + mes + "/" + anno;
  }
  
    public static boolean valida(String fecha){
        if(fecha == null){
            return false;
        }
        boolean valida = false;
        String formato = "dd/MM/yyyy";
        fecha = fecha.trim();
        if (fecha.length() == 10) {
            formato = "dd/MM/yyyy";
        }else if (fecha.length() == 16) {
            formato = "dd/MM/yyyy HH:mm";
        } else if (fecha.length() == 19) {
            formato = "dd/MM/yyyy HH:mm:ss";
        }else{
            return false;
        }
        try{
            fecha = fecha.replaceAll("-", "/");
            SimpleDateFormat formatoFecha = new SimpleDateFormat(formato);
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
            valida = true;
        }catch(Exception e){
             valida = false;
        }
        return valida;
    }
    
    public static String segundos2HMS_2(long segundos){
        String duracion;
        long horas;
        long minutos;
        if(segundos >= 3600l){
            horas = segundos / 3600L;
            duracion = String.valueOf(horas).length() <= 1 ? "0" + String.valueOf(horas) : String.valueOf(horas);
            duracion += ":";
            segundos -= horas * 3600L;
        }else{
            duracion = "00:";
        }
        if (segundos >= 60L){
            minutos = segundos / 60L;
            duracion = duracion + (String.valueOf(minutos).length() <= 1 ? "0" + String.valueOf(minutos) : String.valueOf(minutos));
            duracion += ":";
            segundos -= minutos * 60L;
        }else{
            duracion += "00:";
        }
        if (segundos > 0L) {
            duracion = duracion + (String.valueOf(segundos).length() <= 1 ? "0" + String.valueOf(segundos) : String.valueOf(segundos));
        }else{
            duracion += "00";
        }
        return duracion;
    }
}