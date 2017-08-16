package BO;

import DTO.Dia;
import adportas.SQLConexion;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import query.DiaQuery;

public class Horario
  implements Runnable
{
  static String[] dias = { "", "Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado" };
  private Thread th = new Thread(this);
  public static Map mapaDeLosHorarios = new HashMap();

  public Horario() {
    this.th.start();
  }

  public static boolean verificarFueraHora(String numeroRP) {
    boolean fueraHora = false;
    Date fecha = new Date();
    GregorianCalendar calendario = new GregorianCalendar();
    calendario.setTime(fecha);
    DiaQuery diaQuery = null;
    try {
      diaQuery = new DiaQuery(SQLConexion.conectar());
    } catch (Exception ex) {
    }
    DTO.Horario horario = diaQuery.getHorarioXNumeroPiloto(numeroRP);

    String nombreDia = dias[calendario.get(7)];

    Dia dtoDia = (Dia)horario.getListaDiasSemana().get(nombreDia);
    System.out.println("Id :::: " + dtoDia.getId());
    String h1 = dtoDia.getHoraMinima();
    String h2 = dtoDia.getHoraMaxima();
    System.out.println("hora minima :: " + h1);
    System.out.println("hora maxima :: " + h2);
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    Date f1 = null;
    Date f2 = null;
    Date actual = null;

    int hora = calendario.get(11);
    int dia = calendario.get(5);
    int minutos = calendario.get(12);

    if (!dtoDia.isHabil()) {
      try {
        fueraHora = true;
      }
      catch (Exception ex) {
        ex.printStackTrace();
      }
    }
    try
    {
      f1 = sdf.parse(h1);
      f2 = sdf.parse(h2);
      actual = sdf.parse(sdf.format(fecha));
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    if ((actual.getTime() < f1.getTime()) || ((actual.getTime() >= f2.getTime()) && (dtoDia.isHabil() == true))) {
      try
      {
        fueraHora = true;
      }
      catch (Exception ex) {
        ex.printStackTrace();
      }
    }
    System.out.println("fueeeeeeeeera hooora ==== " + fueraHora);
    return fueraHora;
  }

    public static Dia obtenerDia(DTO.Horario horario) {
        Dia dtoDia = null;
        Date fecha = new Date();
        GregorianCalendar calendario = new GregorianCalendar();
        calendario.setTime(fecha);

        String nombreDia = dias[calendario.get(7)];

        dtoDia = (Dia)horario.getListaDiasSemana().get(nombreDia);
        return dtoDia;
    }

  public static boolean verificarDiaHabil(DTO.Horario horario) {
    Date fecha = new Date();
    Calendar calendario = Calendar.getInstance();
    calendario.setTime(fecha);
    boolean diaHabil = false;
    String nombreDia = dias[calendario.get(7)];
    //System.out.println("nombre dia " + nombreDia);
    Dia dtoDia = (Dia)horario.getListaDiasSemana().get(nombreDia.trim());
    //System.out.println("dtoDia " + dtoDia);
    if (dtoDia.isHabil() == true)
    {
      diaHabil = true;
    }

    int dia = calendario.get(5);
    int mes = calendario.get(2) + 1;
    int anno = calendario.get(1);

    String diaString = "" + dia;
    String mesString = "" + mes;
    String annoString = "" + anno;
    try {
      String fechaCompleta = diaString + "-" + mesString + "-" + annoString;
      Object diaExcepcionalmenteNoHabil = horario.getListaDiasExcepcionalmenteNoHabiles().get(fechaCompleta);
      if (diaExcepcionalmenteNoHabil != null)
        diaHabil = false;
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }

    return diaHabil;
  }

  @Override
  public void run() {
    try {
      DiaQuery diaQuery = new DiaQuery(SQLConexion.conectar());
      List listaRP = diaQuery.obtenerTodosLosNumerosDeRoutePoint();
      for (int i = 0; i < listaRP.size(); i++) {
        String aux = (String)listaRP.get(i);
        DTO.Horario horario = diaQuery.getHorarioXNumeroPiloto(aux);

        mapaDeLosHorarios.put(aux, horario);
      }
      Thread.sleep(3600000L);
    }
    catch (Exception ex)
    {
        ex.printStackTrace();
    }
  }
}