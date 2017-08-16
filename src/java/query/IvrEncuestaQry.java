/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package query;

import DTO.Configuracion;
import DTO.EncuestaPreguntasDTO;
import adportas.SQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.TreeMap;

/**
 *
 * @author Ricardo Fuentes
 */
public class IvrEncuestaQry {
    
    private Configuracion conf;
    
    public IvrEncuestaQry(){
        cargaConfiguracion();
    }
    
    public static boolean usaIvrEncuesta(){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean valida = false;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from configuracion_integracion where clave = 2");
            rs = ps.executeQuery();
            while(rs.next()){
                int usa = rs.getInt("tiene_integracion");
                valida = (usa == 1);
            }
        }catch(Exception e){
            System.out.println("Error en usaIvrEncuesta: "+e);
        }finally{
            try{
                  SQLConexion.cerrar(ps, rs);
                SQLConexion.cerrarConexion(con);
                
            }catch(Exception e){}
        }
        return valida;
    }
    
    private void cargaConfiguracion(){
        conf = new Configuracion();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from configuracion_integracion where clave = 2");
            rs = ps.executeQuery();
            while(rs.next()){
                conf.setIpServidor(rs.getString("ip_servidor"));
                conf.setBaseDatos(rs.getString("nombre_bd"));
                conf.setUsuarioBD(rs.getString("user_bd"));
                conf.setClaveBD(rs.getString("clave_bd"));
                conf.setIntegrado(rs.getInt("tiene_integracion")==1);
            }
        }catch(Exception e){
            System.out.println("error en cargaConfiguracion: "+e);
        }finally{
            try{
                 SQLConexion.cerrar(ps, rs);
                SQLConexion.cerrarConexion(con);
                
            }catch(Exception e){}
        }
    }
    
    public static Configuracion getConfiguracion(){
        Configuracion conf = new Configuracion();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from configuracion_integracion where clave = 2");
            rs = ps.executeQuery();
            while(rs.next()){
                conf.setIpServidor(rs.getString("ip_servidor"));
                conf.setBaseDatos(rs.getString("nombre_bd"));
                conf.setUsuarioBD(rs.getString("user_bd"));
                conf.setClaveBD(rs.getString("clave_bd"));
                conf.setIntegrado(rs.getInt("tiene_integracion")==1);
            }
        }catch(Exception e){
            System.out.println("error en getConfiguracion: "+e);
        }finally{
            try{
                  SQLConexion.cerrar(ps, rs);
                SQLConexion.cerrarConexion(con);
                
            }catch(Exception e){}
        }
        return conf;
    }
    
    public boolean getIntegracion(){
        return conf.isIntegrado();
    }
    
    public int getMinEncuesta(){
        int minimo=0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            //System.out.println("conexion: "+conf.getIpServidor()+" "+conf.getBaseDatos()+" "+ conf.getUsuarioBD()+" "+conf.getClaveBD());
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            ps = con.prepareStatement("select min_escala from escala");
            rs = ps.executeQuery();
            while(rs.next()){
                minimo = rs.getInt("min_escala");
            }
        }catch(Exception e){
            System.out.println("Error en getMinEncuesta: "+e);
        }finally{
            try{
               SQLConexion.cerrar(ps, rs);
               SQLConexion.cerrarConexion(con);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return minimo;
    }
    
    public int getMaxEncuesta(){
        int maximo=0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            ps = con.prepareStatement("select max_escala from escala");
            rs = ps.executeQuery();
            while(rs.next()){
                maximo = rs.getInt("max_escala");
            }
        }catch(Exception e){
            System.out.println("error en getMaxEncuesta: "+e);
        }
        finally{
            try{
               SQLConexion.cerrar(ps, rs);
               SQLConexion.cerrarConexion(con);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return maximo;
    }
    
    public void guardaRango(int min,int max){
        if(cuentaEscala()>0){
            updateEscala(min,max);
        }else{
            insertaEscala(min,max);
        }
    }
    
    private void updateEscala(int min,int max){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            ps = con.prepareStatement("update escala set min_escala = ?, max_escala = ?, fecha_registro_escala = now()");
            ps.setInt(1, min);
            ps.setInt(2, max);
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println("Error en updateEscala: "+e);
        }finally{
            try{
                SQLConexion.cerrar(ps, null);
                SQLConexion.cerrarConexion(con);
            }catch(Exception e){}
        }
    }
    
    private void insertaEscala(int min,int max){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            ps = con.prepareStatement("insert into escala(min_escala,max_escala, fecha_registro_escala) values(?,?,now())");
            ps.setInt(1, min);
            ps.setInt(2, max);
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println("Error en insertaEscala: "+e);
        }finally{
            try{
               SQLConexion.cerrar(ps, null);
                SQLConexion.cerrarConexion(con);
            }catch(Exception e){}
        }
    }
    
    private int cuentaEscala(){
        int cuenta = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            ps = con.prepareStatement("select count(*) cuenta from escala");
            rs = ps.executeQuery();
            while(rs.next()){
                cuenta = rs.getInt("cuenta");
            }
        }catch(Exception e){
            System.out.println("Error en cuentaEscala: "+e);
        }finally{
            try{
                SQLConexion.cerrar(ps, rs);
                SQLConexion.cerrarConexion(con);
            }catch(Exception e){}
        }
        return cuenta;
    }
    
    public Map DescripPreg(){
        Map<Integer,EncuestaPreguntasDTO> mapa = new TreeMap();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
            //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            ps = con.prepareStatement("select n_pregunta,short_desc, descripcion from detalle_preguntas ");
            rs = ps.executeQuery();
            while(rs.next()){
                EncuestaPreguntasDTO encuesta = new EncuestaPreguntasDTO();
                int numero = rs.getInt("n_pregunta");
                String shortDesc = rs.getString("short_desc") != null ? rs.getString("short_desc").trim() : "";
                String descripcion = rs.getString("descripcion") != null ? rs.getString("descripcion").trim() : "";
                encuesta.setNumero(numero);
                encuesta.setShortDesc(shortDesc);
                encuesta.setDescripcion(descripcion);
                mapa.put(numero, encuesta);
            }
        }catch(Exception e){
            System.out.println("Error en descPreg: "+e);
        }finally{
            try{
                  SQLConexion.cerrar(ps, rs);
                SQLConexion.cerrarConexion(con);
            }catch(Exception e){}
        }
        return mapa;
    }
}
