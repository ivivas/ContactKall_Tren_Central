package DTO;

public class Dia
{
  private int id;
  private String nombreDia;
  private String horaMinima = "00:00";
  private String horaMaxima = "23:59";
  private boolean habil;
  private boolean excepcionalmenteNoHabil;
  private Horario horario;
  private String fechaExcepcionalMenteNoHabil;

  public String getHoraMinima()
  {
    return this.horaMinima;
  }

  public void setHoraMinima(String horaMinima)
  {
    this.horaMinima = horaMinima;
  }

  public String getHoraMaxima()
  {
    return this.horaMaxima;
  }

  public void setHoraMaxima(String horaMaxima)
  {
    this.horaMaxima = horaMaxima;
  }

  public boolean isHabil()
  {
    return this.habil;
  }

  public void setHabil(boolean habil)
  {
    this.habil = habil;
  }

  public String getNombreDia()
  {
    return this.nombreDia;
  }

  public void setNombreDia(String nombreDia)
  {
    this.nombreDia = nombreDia;
  }

  public int getId()
  {
    return this.id;
  }

  public void setId(int id)
  {
    this.id = id;
  }

  public boolean isExcepcionalmenteNoHabil()
  {
    return this.excepcionalmenteNoHabil;
  }

  public void setExcepcionalmenteNoHabil(boolean excepcionalmenteNoHabil)
  {
    this.excepcionalmenteNoHabil = excepcionalmenteNoHabil;
  }

  public Horario getHorario()
  {
    return this.horario;
  }

  public void setHorario(Horario horario)
  {
    this.horario = horario;
  }

  public String getFechaExcepcionalMenteNoHabil()
  {
    return this.fechaExcepcionalMenteNoHabil;
  }

  public void setFechaExcepcionalMenteNoHabil(String fechaExcepcionalMenteNoHabil)
  {
    this.fechaExcepcionalMenteNoHabil = fechaExcepcionalMenteNoHabil;
  }
}