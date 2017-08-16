package DTO;

import java.util.ArrayList;

public class Combo
{
  private int id;
  private String nombre;
  private ArrayList<Opcion> listaOpciones;

  public String getNombre(){
    return this.nombre;
  }

  public void setNombre(String nombre){
    this.nombre = nombre;
  }

  public ArrayList<Opcion> getListaOpciones(){
    return this.listaOpciones;
  }

  public void setListaOpciones(ArrayList<Opcion> listaOpciones)
  {
    this.listaOpciones = listaOpciones;
  }

  public int getId()
  {
    return this.id;
  }

  public void setId(int id)
  {
    this.id = id;
  }
}