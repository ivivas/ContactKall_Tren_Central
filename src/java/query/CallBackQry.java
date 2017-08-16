/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package query;

import adportas.SQLConexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ricardo Fuentes
 */
public class CallBackQry {
    
    public static int buscaCallBack(){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int cant = 0;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from configuraciones where dato = 'maximoCallBack'");
            rs = ps.executeQuery();
            while(rs.next()){
                String valor = rs.getString("valor") != null ? rs.getString("valor").trim() : "";
                try{
                    cant = Integer.parseInt(valor);
                }catch(Exception e){}
            }
        }catch(Exception e){
            System.out.println("Error en buscaCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return cant;
    }
    
    public static void guardaCallBack(int maximo){
        if(cuentaConfCallBack() >0){
            updateCallBack(maximo);
        }else{
            insertCallBack(maximo);
        }
    }
    
    public static int cuentaConfCallBack(){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int cuenta = 0;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select count(*) cuenta from configuraciones where dato = 'maximoCallBack'");
            rs = ps.executeQuery();
            while(rs.next()){
                cuenta = rs.getInt("cuenta");
            }
        }catch(Exception e){
            System.out.println("Error en cuentaConfCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return cuenta;
    }
    
    private static void insertCallBack(int callBack){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("insert into configuraciones(valor, dato) values('"+callBack+"','maximoCallBack')");
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println("Error en insertCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
            }catch(Exception e){}
        }
    }
    
    public static List<String> listaCampania(){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> valor = new ArrayList();
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from campania");
            rs = ps.executeQuery();
            while(rs.next()){
                valor.add(rs.getInt("id_campania") + "@" + rs.getString("nombre_campania"));
            }
        }catch(Exception e){
            System.out.println("Error en buscaCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return valor;
    }
    
    public static String nombreCampania(int idCampania){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> valor = new ArrayList();
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select nombre_campania from campania where id_campania = ?");
            ps.setInt(1, idCampania);
            rs = ps.executeQuery();
            while(rs.next()){
                return rs.getString("nombre_campania");
            }
        }catch(Exception e){
            System.out.println("Error en buscaCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return "";
    }
    
    private static void updateCallBack(int callBack){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("update configuraciones set valor = '"+callBack+"' where dato = 'maximoCallBack'");
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println("Error en updateCallBack: "+e);
        }finally{
            try{
                con.close();
                ps.close();
            }catch(Exception e){}
        }
    }
}
