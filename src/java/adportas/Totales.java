package adportas;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class Totales
{
  int totales;
  int abandonada_cantidad;
  int AbandonadaCeroring_cantidad;
  int AbandonadaUnDosring_cantidad;
  int AbandonadaMenosTresring_cantidad;
  int AbandonadaMayor3ring_cantidad;
  int contestadas_cantidad;
  int desvioNoContesta;
  int desvioProgramado;
  int desvioOcupado;
  long desviada_cantidad;
  int contestadaSecretaria_cantidad;
  int noContestadaSecretaria_cantidad;
  Timestamp primer_registro;
  Timestamp ultimo_registro;
  Connection conexion;
  PreparedStatement pst1;
  int cont;

  public Totales()
  {
    this.totales = 0;
    this.abandonada_cantidad = 0;
    this.AbandonadaCeroring_cantidad = 0;
    this.AbandonadaUnDosring_cantidad = 0;
    this.AbandonadaMenosTresring_cantidad = 0;
    this.AbandonadaMayor3ring_cantidad = 0;
    this.contestadas_cantidad = 0;
    this.desvioNoContesta = 0;
    this.desvioProgramado = 0;
    this.desvioOcupado = 0;
    this.desviada_cantidad = 0L;
    this.contestadaSecretaria_cantidad = 0;
    this.noContestadaSecretaria_cantidad = 0;
    this.primer_registro = null;
    this.ultimo_registro = null;
    this.conexion = null;
    this.pst1 = null;
    this.cont = 0;
  }

  public void obtenerTotales(ResultSet rs)
    throws Exception
  {
    for (; rs.next(); this.cont += 1)
    {
      if (this.cont == 0)
        this.primer_registro = rs.getTimestamp("tiempo_origen");
      this.ultimo_registro = rs.getTimestamp("tiempo_origen");
      this.totales += 1;
      if (rs.getString("estado1").trim().equalsIgnoreCase("contestada")) {
        this.contestadas_cantidad += 1;
      }
      else {
        if (rs.getString("estado1").trim().equalsIgnoreCase("no contestada")) {
          this.desvioNoContesta += 1;
          if ((rs.getString("estado2").trim().equalsIgnoreCase("contestada")) || (rs.getString("estado3").trim().equalsIgnoreCase("contestada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.contestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.contestadaSecretaria_cantidad += 1; continue;
          }

          if ((rs.getString("estado2").trim().equalsIgnoreCase("abandonada")) || (rs.getString("estado3").trim().equalsIgnoreCase("abandonada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.noContestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.noContestadaSecretaria_cantidad += 1; continue;
          }

        }

        if (rs.getString("estado1").trim().equalsIgnoreCase("derivada"))
        {
          this.desvioProgramado += 1;
          if ((rs.getString("estado2").trim().equalsIgnoreCase("contestada")) || (rs.getString("estado3").trim().equalsIgnoreCase("contestada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.contestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.contestadaSecretaria_cantidad += 1; continue;
          }

          if ((rs.getString("estado2").trim().equalsIgnoreCase("abandonada")) || (rs.getString("estado3").trim().equalsIgnoreCase("abandonada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.noContestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.noContestadaSecretaria_cantidad += 1; continue;
          }
        }

        if (rs.getString("estado1").trim().equalsIgnoreCase("ocupada"))
        {
          this.desvioOcupado += 1;
          if ((rs.getString("estado2").trim().equalsIgnoreCase("contestada")) || (rs.getString("estado3").trim().equalsIgnoreCase("contestada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.contestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.contestadaSecretaria_cantidad += 1; continue;
          }

          if ((rs.getString("estado2").trim().equalsIgnoreCase("abandonada")) || (rs.getString("estado3").trim().equalsIgnoreCase("abandonada")))
          {
            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) && (!rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())))
            {
              if ((!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente"))) continue;
              this.noContestadaSecretaria_cantidad += 1; continue;
            }

            if ((rs.getString("extension").trim().equalsIgnoreCase(rs.getString("ultima_redireccion").trim())) || (rs.getString("extension").trim().equalsIgnoreCase(rs.getString("numero_final").trim())) || ((!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("asistente")) && (!rs.getString("cargo_usuario2").trim().equalsIgnoreCase("secretaria")) && (!rs.getString("cargo_usuario3").trim().equalsIgnoreCase("secretaria"))))
              continue;
            this.noContestadaSecretaria_cantidad += 1; continue;
          }
        }

        if (!rs.getString("estado1").trim().equalsIgnoreCase("abandonada")) {
          if (rs.getInt("rings") == 0) {
            this.AbandonadaCeroring_cantidad += 1;
          }
          else if ((rs.getInt("rings") == 1) || (rs.getInt("rings") == 2)) {
            this.AbandonadaUnDosring_cantidad += 1;
          }
          else if (rs.getInt("rings") >= 3) {
            this.AbandonadaMayor3ring_cantidad += 1;
          }
        }

      }

    }

    this.abandonada_cantidad = (this.AbandonadaCeroring_cantidad + this.AbandonadaMayor3ring_cantidad + this.AbandonadaMenosTresring_cantidad + this.AbandonadaUnDosring_cantidad);
  }

  public Timestamp getPrimer_registro()
  {
    return this.primer_registro;
  }

  public void setPrimer_registro(Timestamp primer_registro)
  {
    this.primer_registro = primer_registro;
  }

  public Timestamp getUltimo_registro()
  {
    return this.ultimo_registro;
  }

  public void setUltimo_registro(Timestamp ultimo_registro)
  {
    this.ultimo_registro = ultimo_registro;
  }

  public void limpiar()
  {
    this.totales = 0;
    this.abandonada_cantidad = 0;
    this.AbandonadaCeroring_cantidad = 0;
    this.AbandonadaUnDosring_cantidad = 0;
    this.AbandonadaMenosTresring_cantidad = 0;
    this.AbandonadaMayor3ring_cantidad = 0;
    this.contestadas_cantidad = 0;
    this.desvioNoContesta = 0;
    this.desvioProgramado = 0;
    this.desvioOcupado = 0;
    this.desviada_cantidad = 0L;
    this.contestadaSecretaria_cantidad = 0;
    this.noContestadaSecretaria_cantidad = 0;
    this.cont = 0;
  }

  public int getAbandonadaCeroring_cantidad()
  {
    return this.AbandonadaCeroring_cantidad;
  }

  public int getAbandonadaMayor3ring_cantidad()
  {
    return this.AbandonadaMayor3ring_cantidad;
  }

  public int getAbandonadaMenosTresring_cantidad()
  {
    return this.AbandonadaMenosTresring_cantidad;
  }

  public int getAbandonadaUnDosring_cantidad()
  {
    return this.AbandonadaUnDosring_cantidad;
  }

  public int getAbandonada_cantidad()
  {
    return this.abandonada_cantidad;
  }

  public int getContestadaSecretaria_cantidad()
  {
    return this.contestadaSecretaria_cantidad;
  }

  public int getContestadas_cantidad()
  {
    return this.contestadas_cantidad;
  }

  public long getDesviada_cantidad()
  {
    return this.desviada_cantidad;
  }

  public int getDesvioNoContesta()
  {
    return this.desvioNoContesta;
  }

  public int getDesvioOcupado()
  {
    return this.desvioOcupado;
  }

  public int getDesvioProgramado()
  {
    return this.desvioProgramado;
  }

  public int getNoContestadaSecretaria_cantidad()
  {
    return this.noContestadaSecretaria_cantidad;
  }

  public int getTotales()
  {
    return this.totales;
  }
}