package DTO;

public class Opcion
{
  private int id;
  private String valor;
  private String texto;

  public int getId()
  {
    return this.id;
  }

  public void setId(int id)
  {
    this.id = id;
  }

  public String getValor()
  {
    return this.valor;
  }

  public void setValor(String valor)
  {
    this.valor = valor;
  }

  public String getTexto(){
    return this.texto;
  }

  public void setTexto(String texto)
  {
    this.texto = texto;
  }
}