package adportas;

import java.io.PrintStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Postgres
{
  public static synchronized Connection conectar()
    throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException
  {
    Connection conexion = null;
    Class.forName("org.postgresql.Driver").newInstance();
    conexion = DriverManager.getConnection("jdbc:postgresql://192.168.100.130:5432/acdkall", "user_acdkall", "acdkall2012");

    return conexion;
  }

  public static synchronized Connection conectar(String PostgresIP, String PostgresBD, String PostgresUsuario, String PostgresClave) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
    Connection conexion = null;
    Class.forName("org.postgresql.Driver").newInstance();
    conexion = DriverManager.getConnection("jdbc:postgresql://" + PostgresIP + ":5432/" + PostgresBD, PostgresUsuario, PostgresClave);
    return conexion;
  }

  public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
    Connection c = null;
    c = conectar();

    if (c != null)
      System.out.println("Conectado a la base de datos");
    else
      System.out.println("No conectado a la base de datos");
  }
}