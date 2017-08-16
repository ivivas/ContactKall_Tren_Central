package dtoVistas;

import adportas.Fechas;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Llamada
{
  public static RegistroLlamada registro(String pkid, Connection conexion)
    throws SQLException
  {
    String[] ncc = new String[4];
    PreparedStatement pst = conexion.prepareStatement("SELECT * FROM llamada2 WHERE pkid = ?");
    pst.setString(1, pkid);
    ResultSet rs = pst.executeQuery();
    RegistroLlamada llamada = null;
    if (rs.next()) {
      llamada = new RegistroLlamada();
      llamada.setIdLlamada(rs.getString("id_llamada").trim());
      llamada.setExtension(rs.getString("extension").trim());
      llamada.setNumeroInicial(rs.getString("numero_inicial"));
      llamada.setUltimaRedireccion(rs.getString("ultima_redireccion").trim());
      llamada.setNumeroFinal(rs.getString("numero_final").trim());
      llamada.setTipo(rs.getString("tipo").trim());
      llamada.setFechaOrigen(Fechas.TimetoString(rs.getTimestamp("tiempo_origen")).substring(0, 10));
      llamada.setHoraOrigen(Fechas.TimetoString(rs.getTimestamp("tiempo_origen")).substring(10, 19));
      llamada.setTiempoConexion(rs.getString("tiempo_conexion"));
      llamada.setTiempoDesconexion(rs.getString("tiempo_desconexion"));
      llamada.setDuracion(rs.getString("duracion").trim());
      llamada.setRings(rs.getString("rings").trim());
      llamada.setEstado1(rs.getString("estado1").trim());
      llamada.setEstado2(rs.getString("estado2") != null ? rs.getString("estado2").trim() : "");
      llamada.setEstado3(rs.getString("estado3") != null ? rs.getString("estado3").trim() : "");
      llamada.setHorario(rs.getString("horario"));
      ncc = nombreCargoCentro(conexion, llamada.getExtension());
      llamada.setUsuario1(ncc[0]);
      llamada.setCargo1(ncc[1]);
      llamada.setCentrocosto1(ncc[2]);
      llamada.setId_centrocosto1(ncc[3]);
      ncc = nombreCargoCentro(conexion, llamada.getUltimaRedireccion());
      llamada.setUsuario2(ncc[0]);
      llamada.setCargo2(ncc[1]);
      llamada.setCentrocosto2(ncc[2]);
      llamada.setId_centrocosto2(ncc[3]);
      ncc = nombreCargoCentro(conexion, llamada.getNumeroFinal());
      llamada.setUsuario3(ncc[0]);
      llamada.setCargo3(ncc[1]);
      llamada.setCentrocosto3(ncc[2]);
      llamada.setId_centrocosto3(ncc[3]);
    }

    return llamada;
  }

  private static String[] nombreCargoCentro(Connection conexion, String fono) throws SQLException {
    int cont = 0;
    String centrosDeCostos = "";
    String[] datos = new String[4];
    datos[0] = "";
    datos[1] = "";
    datos[2] = "";
    PreparedStatement pst = conexion.prepareStatement("SELECT nombre, id_centrocosto, nombre_centrocosto, cargo FROM vista_registrousuario WHERE extension = ?");
    pst.setString(1, fono);
    ResultSet rs = pst.executeQuery();
    while (rs.next()) {
      datos[0] = (rs.getString("nombre") != null ? rs.getString("nombre").trim() : "");
      datos[1] = (rs.getString("cargo") != null ? rs.getString("cargo").trim() : "");
      datos[3] = (rs.getString("id_centrocosto") != null ? rs.getString("id_centrocosto").trim() : "");
      if (cont > 0) centrosDeCostos = centrosDeCostos + "/";
      centrosDeCostos = centrosDeCostos + (rs.getString("nombre_centrocosto").trim() != null ? rs.getString("nombre_centrocosto").trim() : "");
      cont++;
    }
    rs.close();
    pst.close();
    datos[2] = centrosDeCostos;
    return datos;
  }
}