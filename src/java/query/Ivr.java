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
public class Ivr {
    
    public static Configuracion configuracionIVR(){
        Configuracion conf = new Configuracion();
        String query = "select * from configuracion_integracion where clave = 4 ";
        Connection conexion =  null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String ipServer="";
        String bd="";
        String userBd="";
        String claveBd="";
        boolean integrado=false;
        try{
            conexion = SQLConexion.conectar();
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            while(rs.next()){
                ipServer = rs.getString("ip_servidor");
                bd = rs.getString("nombre_bd");
                userBd = rs.getString("user_bd");
                claveBd = rs.getString("clave_bd");
                integrado = rs.getInt("tiene_integracion")==1;
            }
        }catch(Exception e){
            System.out.println("Error en configuracionIVR: "+e);
        }finally{
            try{
                conexion.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        conf.setIpServidor(ipServer);
        conf.setBaseDatos(bd);
        conf.setUsuarioBD(userBd);
        conf.setClaveBD(claveBd);
        conf.setIntegrado(integrado);
        return conf;
    }
}
