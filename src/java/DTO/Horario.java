package DTO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Horario
{
  private int id;
  private String nombre = "";
  private Map listaDiasSemana = new HashMap();
  private Map listaDiasExcepcionalmenteNoHabiles = new HashMap();
  private List listaDiasExcepcionalmenteNoHabilesList = new ArrayList();
  private boolean predeterminado = false;

  public Map getListaDiasSemana()
  {
    return this.listaDiasSemana;
  }

  public void setListaDiasSemana(Map listaDiasSemana)
  {
    this.listaDiasSemana = listaDiasSemana;
  }

  public Map getListaDiasExcepcionalmenteNoHabiles()
  {
    return this.listaDiasExcepcionalmenteNoHabiles;
  }

  public void setListaDiasExcepcionalmenteNoHabiles(Map listaDiasExcepcionalmenteNoHabiles)
  {
    this.listaDiasExcepcionalmenteNoHabiles = listaDiasExcepcionalmenteNoHabiles;
  }

  public int getId()
  {
    return this.id;
  }

  public void setId(int id)
  {
    this.id = id;
  }

  public String getNombre()
  {
    return this.nombre;
  }

  public void setNombre(String nombre)
  {
    this.nombre = nombre;
  }

  public boolean isPredeterminado()
  {
    return this.predeterminado;
  }

  public void setPredeterminado(boolean predeterminado)
  {
    this.predeterminado = predeterminado;
  }

  public List getListaDiasExcepcionalmenteNoHabilesList()
  {
    return this.listaDiasExcepcionalmenteNoHabilesList;
  }

  public void setListaDiasExcepcionalmenteNoHabilesList(List listaDiasExcepcionalmenteNoHabilesList)
  {
    this.listaDiasExcepcionalmenteNoHabilesList = listaDiasExcepcionalmenteNoHabilesList;
  }
}