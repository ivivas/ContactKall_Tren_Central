package query;

import adportas.Postgres;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author felipe
 */
public class ConfQuery {
   
    public static String patron = "@#@#@#";
      
    public static boolean transformarAWav() {
        boolean respuesta = false;
        PreparedStatement pst = null;
        Connection conn = null;
        ResultSet rs = null;
        try {
            conn = Postgres.conectar();
            String query =  "select valor  from control_configuracion where dato = 'transformar_a_wav';" ;
            pst = conn.prepareStatement(query);
            rs = pst.executeQuery();
            while (rs.next()) {
                respuesta = rs.getBoolean("valor");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            cerrar(conn, pst, rs);
        }
        return respuesta;
    }
    
    public static int cerrar(Connection conn, PreparedStatement pst, ResultSet rs) {
        int respuesta = 0;
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return respuesta;
    }
    
    public static boolean monitorBorrar(){
        boolean valida = true;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = Postgres.conectar();
            ps = con.prepareStatement("select valor from control_configuracion where dato = 'monitor_borrar'");
            rs = ps.executeQuery();
            while(rs.next()){
                valida = rs.getBoolean("valor");
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return valida;
    }
    public static void agregarMemo(Connection con,int idGrabacion, String mensaje,String usuario,int segundo){
        PreparedStatement ps = null;
        try{
            ps = con.prepareStatement("INSERT INTO tbl_memo (id_grabacion,mensaje,usuario_creador, fecha_creacion,fecha_ultima_creacion,segundo, usuario_ultima_modificacion, flag_borrado) VALUES (?,?,?,NOW(),NOW(),?,?,FALSE)");
            ps.setInt(1, idGrabacion);
            ps.setString(2, mensaje);
            ps.setString(3, usuario);
            ps.setInt(4, segundo);
            ps.setString(5, usuario);
            ps.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public static List<Integer> getMemo(Connection con,int idGrabacion){
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList lista = new ArrayList();
        try{
            ps = con.prepareStatement("SELECT segundo FROM tbl_memo WHERE id_grabacion = ? and flag_borrado = FALSE");
            ps.setInt(1, idGrabacion);
            rs = ps.executeQuery();
            while(rs.next()){
                lista.add(rs.getInt("segundo"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return lista;
    }
    public static void updateMemo(Connection con,int idGrabacion,String mensaje,int segundo,String usuario){
        PreparedStatement ps = null;
        try{
            ps = con.prepareStatement("UPDATE tbl_memo SET mensaje = ?,usuario_ultima_modificacion = ?,fecha_ultima_creacion = NOW() WHERE id_grabacion = ? and flag_borrado = FALSE AND segundo = ?");
            ps.setString(1, mensaje);
            ps.setString(2, usuario);
            ps.setInt(3, idGrabacion);
            ps.setInt(4, segundo);
            ps.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    public static String getMemo(Connection con,int idGrabacion,int segundo){
        PreparedStatement ps = null;
        ResultSet rs = null;
        StringBuilder sB = new StringBuilder();
        try{
            ps = con.prepareStatement("SELECT * FROM tbl_memo WHERE id_grabacion = ? and flag_borrado = FALSE and segundo = ?");
            ps.setInt(1, idGrabacion);
            ps.setInt(2, segundo);
            rs = ps.executeQuery();
            while(rs.next()){
                sB.append("<input type='hidden' id='idMemo' value='"+rs.getInt("id")+"'>");
                sB.append("<b>Creado:</b>"+rs.getString("usuario_creador"));
                sB.append("<br><b>Fecha: </b>"+rs.getString("fecha_creacion"));
                sB.append("<br><b>Modificado : </b>"+rs.getString("fecha_ultima_creacion"));
                sB.append("<br><b> Por: </b>"+rs.getString("usuario_ultima_modificacion"));
                sB.append("<br><input type='hidden' id='segundo' value='"+rs.getInt("segundo")+"'>");
                sB.append("<textarea style=\"resize: none;\"  id='msj' cols='30' maxlength=\"50\" rows='1'>"+rs.getString("mensaje")+"</textarea>");
                //sB.append("<a href='#' id='addInfo' onclick='modificarMemo()'><img src='reproductor/edit.png'></a>");
                sB.append("<br><a href='#' id='addInfo' onclick='modificarMemo()'><i style=\"color:black;margin:1%;\" class='fa fa-pencil-square-o'></i></a>");
                //sB.append("<a href='#' id='addInfo' onclick='eliminarMemo()'><img src='reproductor/delete.png'></a>");
                sB.append("<a href='#' id='addInfo' onclick='eliminarMemo()'><i style=\"color:black;margin:1%;\" class='fa fa-trash'></i></a>");
                //sB.append("<a href='#' id='cancelar' onclick='cancelar()'><img src='reproductor/exit.png'></a>");
                sB.append("<a href='#' id='cancelar' onclick='cancelar()'><i style=\"color:black;margin:1%;\" class='fa fa-times'></i></a>");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return sB.toString();

    }
    
    public static int cantidadMemosXGrabacion(Connection con,int idGrabacion) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = con.prepareStatement("SELECT COUNT(*) AS total FROM tbl_memo WHERE id_grabacion = ?");
            ps.setInt(1, idGrabacion);
            rs = ps.executeQuery();
            if(rs.next()){
                return rs.getInt("total");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    public static ResultSet eliminarMemo(Connection con, int idMemo) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = con.prepareStatement("DELETE FROM tbl_memo WHERE id = ? returning *");
            ps.setInt(1, idMemo);
            rs = ps.executeQuery();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return rs;
    }
    public static String formatear(int second){
        int hours = ((int)Math.floor( second / 3600 ));  
        int minutes = ((int)Math.floor( (second % 3600) / 60 ));
        int seconds = second % 60;
        minutes = minutes < 10 ? 0 + minutes : minutes;
        seconds = seconds < 10 ? 0 + seconds : seconds;
        return hours + ":" + minutes + ":" + seconds;
    }
    
    public static boolean segundoDisponible(Connection con,int segundo,int idGrabacion) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = con.prepareStatement("SELECT COUNT(*) AS total FROM tbl_memo WHERE segundo = ? and id_grabacion = ?");
            ps.setInt(1, segundo);
            ps.setInt(2, idGrabacion);
            rs = ps.executeQuery();
            if(rs.next()){
                if(rs.getInt("total")==0){
                    return true;
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }
   
}
