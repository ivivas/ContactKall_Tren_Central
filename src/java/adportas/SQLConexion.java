package adportas;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class SQLConexion {

//    public static Connection conectar() throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
//        Class.forName("org.postgresql.Driver").newInstance();
//        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/AcdKallControl","user_acdkall","acdkall2012");
//        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://192.168.100.132:5432/AcdkallControl_contact","user_acdkall","acdkall2012");
////        Connection conexion = DriverManager.getConnection("jdbc:postgresql://192.168.100.44:5432/AcdkallControl_contact", "user_acdkall", "acdkall2012");
////        Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/AcdkallControl_contact", "postgres", "adp2016");
//       Connection conexion = DriverManager.getConnection("jdbc:postgresql://192.168.100.132:5432/AcdKallControl_Contact_EFE","postgres","adp2015");//EFE
//        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://192.168.100.132:5432/AcdKallControl_Contact_EFE","postgres","adp2015");
// 
//        return conexion;
//    }
 public static Connection conectar()//pool de conexiones
            throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException,NamingException {
        Connection conexion = null;
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/PortalContactCenter");
        conexion = ds.getConnection();
        return conexion;
    }
    public static Connection conectaRecKall(String host, String db, String user, String clave) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
        Class.forName("org.postgresql.Driver").newInstance();
        //conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/reckall","user_reckall","reckall2007");
        Connection conexion = DriverManager.getConnection("jdbc:postgresql://" + host + ":5432/" + db, user, clave);
        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/acdkall","user_acdkall","acdkall2012");
        return conexion;
    }

    public static Connection conectaIPKall(String host, String db, String user, String clave) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
        Class.forName("org.postgresql.Driver").newInstance();
        //conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/reckall","user_reckall","reckall2007");
        Connection conexion = DriverManager.getConnection("jdbc:postgresql://" + host + ":5432/" + db, user, clave);
        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/acdkall","user_acdkall","acdkall2012");
        return conexion;
    }

    public static Connection conectaIVREncuesta(String host, String db, String user, String clave) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
        Class.forName("org.postgresql.Driver").newInstance();
        //conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/reckall","user_reckall","reckall2007");
        Connection conexion = DriverManager.getConnection("jdbc:postgresql://" + host + ":5432/" + db, user, clave);
        //Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/acdkall","user_acdkall","acdkall2012");
        return conexion;
    }

    public static Connection conectar(String IP, String BD, String usuario, String clave) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
        Connection conexion = null;
        try {
            Class.forName("org.postgresql.Driver").newInstance();
            conexion = DriverManager.getConnection("jdbc:postgresql://" + IP + ":5432/" + BD, usuario, clave);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return conexion;
    }
    public static void cerrar(PreparedStatement pst, ResultSet rs) {
        if (pst != null) {
            try {
                pst.close();
            } catch (Exception ex) {
               ex.printStackTrace(System.out);
            }
        }
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception ex) {
                ex.printStackTrace(System.out);
            }
        }
    }

    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try {
                boolean estaCerrada = conn.isClosed();
                conn.close();
                estaCerrada = conn.isClosed();
             System.out.println("esta cerrada = " + estaCerrada);
            } catch (Exception ex) {
               ex.printStackTrace(System.out);
            }
        }

    }
}
