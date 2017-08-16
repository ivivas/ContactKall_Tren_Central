package query;

import adportas.SQLConexion;
import dtoVistas.SesionDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SesionQuery{
    private Connection con = null;
    private String query = null;

    public SesionQuery(Connection con) { 
        this.con = con;
    }

    public boolean eliminar(String usuario){
        boolean resp = false;
        try{
            this.query = "delete from sesion where usuario = ?";
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, usuario);
            ps.executeUpdate();
            ps.close();
            resp = true;
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return resp;
    }

    public boolean insertar(String usuario, String clave, String tipo){
        boolean resp = false;
        try {
            this.query = "insert into sesion (usuario,clave,tipo) values (?,?,?)";
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            ps.setString(3, tipo);
            ps.executeUpdate();
            ps.close();
            resp = true;
        }catch (Exception ex){
            ex.printStackTrace();
            resp = false;
        }
        return resp;
    }

    public String buscar(String usuario, String clave){
        String tipo = null;
        try {
            this.query = "select tipo from sesion where usuario=? and clave=?";
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            ResultSet rs = ps.executeQuery();
            if (rs.next()){
                tipo = rs.getString("tipo").trim();
            }
            ps.close();
            rs.close();
        }catch (Exception ex){
          ex.printStackTrace();
        }
        return tipo;
    }

    public boolean actualizar(SesionDto sesionDto){
        boolean resp = false;
        this.query = "update sesion set usuario=?,clave=?,tipo=? where id = ? ";
        try {
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, sesionDto.getUsuario());
            ps.setString(2, sesionDto.getClave());
            ps.setString(3, sesionDto.getTipo());
            ps.setInt(4, sesionDto.getId());
            ps.executeUpdate();
            ps.close();
            resp = true;
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return resp;
    }

    public SesionDto buscarUsuario(String usuario){
        SesionDto dto = null;
        try {
            this.query = "select id,usuario,tipo,clave from sesion where usuario=? ";
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()){
                dto = new SesionDto();
                if (rs.getString("usuario") != null){
                    dto.setUsuario(rs.getString("usuario").trim());
                }else {
                    dto.setUsuario("");
                }
                if (rs.getString("clave") != null){
                    dto.setClave(rs.getString("clave").trim());
                }else {
                    dto.setClave("");
                }
                if (rs.getString("tipo") != null){
                    dto.setTipo(rs.getString("tipo").trim());
                }else {
                    dto.setTipo("");
                }
                if (rs.getString("id") != null){
                    dto.setId(rs.getInt("id"));
                }else {
                    dto.setId(0);
                }
            }
            rs.close();
            ps.close();
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return dto;
    }

    public boolean buscar(String usuario){
        boolean resp = false;
        try {
            this.query = "select tipo from sesion where usuario=? ";
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                resp = true;
            }
            rs.close();
            ps.close();
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return resp;
    }

    public List<SesionDto> list(){
        List list = null;
        this.query = "select usuario,clave,tipo  from sesion order by usuario ASC";
        try {
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ResultSet rs = ps.executeQuery();
            list = new ArrayList();
            while (rs.next()){
                SesionDto dto = new SesionDto();
                if (rs.getString("usuario") != null){
                  dto.setUsuario(rs.getString("usuario").trim());
                }else {
                  dto.setUsuario("");
                }
                if (rs.getString("clave") != null){
                  dto.setClave(rs.getString("clave").trim());
                }else {
                  dto.setClave("");
                }
                if (rs.getString("tipo") != null){
                  dto.setTipo(rs.getString("tipo").trim());
                }else {
                  dto.setTipo("");
                }
                list.add(dto);
            }
            rs.close();
            ps.close();
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return list;
    }
    
    private static int getIdUsuario(String usuario){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int id = 0;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select id from sesion where usuario = ? ");
            ps.setString(1,usuario);
            rs = ps.executeQuery();
            while(rs.next()){
                id = rs.getInt("id");
            }
        }catch(Exception e){
            System.out.println("Error en getIdUsuario: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return id;
    }
    
    public static int idPilotoSesion(String usuario){
        int idPool = 0;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection con = null;
        int idSesion = getIdUsuario(usuario);
        try{
            con = SQLConexion.conectar();
            ps= con.prepareStatement("select id_piloto from pilotos_sesion where id_sesion = ? ");
            ps.setInt(1,idSesion);
            rs = ps.executeQuery();
            while(rs.next()){
                idPool= rs.getInt("id_piloto"); 
            }
        }catch(Exception e){
            System.out.println("Error en idPilotoSesion: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return idPool;
    }
    
    public static String pilotoById(int id){
        String piloto="";
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection con = null;
        try{
            con = SQLConexion.conectar();
            ps= con.prepareStatement("select piloto from pilotos where id = ? ");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            while(rs.next()){
                piloto = rs.getString("piloto").trim();
            }
        }catch(Exception e){
            System.out.println("Error en pilotoById: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return piloto;
    }
    public static Object obtenerPuerto(String opcion) {//devuelve un array de string que contiene los numeros de anexos habilitados y que pertenecen al pool del routepoint ingresado por parametro
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select valor from configuraciones where dato = '"+opcion+"'";
            PreparedStatement ps2 = con.prepareStatement(consulta);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                return rs2.getString("valor");
            }
            rs2.close();
            ps2.close();
        } catch (Exception ex) {
            //String numeroError = numero != null ? numero : " null_";
ex.printStackTrace();
            //MensajesLog.logger.error("error al hacer consulta SQL  CallRouteObservation Numero router = " + numeroError + " anexo a = " + numerAnexo);
         //   SQLConexion.reconectar();
            ex.printStackTrace();
        }
        finally{
            try {
                con.close();
            } catch (SQLException ex) {
            }
        }

        return "";
    }
}