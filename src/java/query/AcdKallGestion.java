/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package query;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Ricardo
 */
public class AcdKallGestion {
    
    public static Configuracion conf;
    
    public static Configuracion configuracionGestion(){
        Configuracion conf = new Configuracion();
        String query = "select * from configuracion_integracion where clave = 3 ";
        Connection conexion =  null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            conexion = SQLConexion.conectar();
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            while(rs.next()){
                conf.setIpServidor(rs.getString("ip_servidor"));
                conf.setBaseDatos(rs.getString("nombre_bd"));
                conf.setUsuarioBD(rs.getString("user_bd"));
                conf.setClaveBD(rs.getString("clave_bd"));
                conf.setIntegrado(rs.getInt("tiene_integracion")==1);
                conf.setRutaPortal(rs.getString("ruta_portal"));
            }
        }catch(Exception e){
            System.out.println("Error en configuracionGestion: "+e);
        }finally{
            try{
                conexion.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return conf;
    }
}
