package dtoVistas;

public class SesionDto
{
  String usuario;
  String clave;
  String tipo;
  int id;

  public SesionDto(String usuario, String clave, String tipo)
  {
    this.usuario = usuario;
    this.clave = clave;
    this.tipo = tipo;
  }

  public SesionDto()
  {
  }

  public String getClave()
  {
    return this.clave;
  }

  public int getId() {
    return this.id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public SesionDto(String usuario, String clave, String tipo, int id) {
    this.usuario = usuario;
    this.clave = clave;
    this.tipo = tipo;
    this.id = id;
  }

  public void setClave(String clave)
  {
    this.clave = clave;
  }

  public String getTipo() {
    return this.tipo;
  }

  public void setTipo(String tipo) {
    this.tipo = tipo;
  }

  public String getUsuario() {
    return this.usuario;
  }

  public void setUsuario(String usuario) {
    this.usuario = usuario;
  }
}