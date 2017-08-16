/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package query;

import DTO.Configuracion;
import DTO.EstadisticaIVR;
import adportas.Postgres;
import adportas.SQLConexion;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Jose
 */
public class EstadisticaIVRQuery {
    private String fechaDesde;
    private String fechaHasta;
    private int nivel;
    
    public EstadisticaIVRQuery(String fechaDesde,String fechaHasta,int nivel){
        this.fechaDesde = fechaDesde;
        this.fechaHasta = fechaHasta;
        this.nivel = nivel;
    }
    
    public EstadisticaIVR obtenerEstadisticaIVR(boolean mostrarInvalida){
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        EstadisticaIVR eivr = new EstadisticaIVR();
        Configuracion confIVR = Ivr.configuracionIVR();
        String whereInvalida = " and accion_inicial != 42 ";
        try{
            String query = "select id_accion,accion_inicial, boton_accion,  e.tipo_accion as tipo_accion, nivel_subrutina,nombre_subrutina, count(*) as cantidad_opcion, (select count(*) as cantidad_opcion from estadistica e, head_estadistica  h, acciones_subrutina a where id_header != 0  and e.fecha > '"+fechaDesde+"' and e.fecha <= '"+fechaHasta+"' and h.id = e.id_header and a.id = e.id_accion) as total,(select descripcion from acciones_subrutina where id = id_accion) as descripcion_accion from estadistica e, head_estadistica  h, acciones_subrutina a where id_header != 0 and h.id = e.id_header and a.id = e.id_accion and e.fecha > '"+this.fechaDesde+"' and e.fecha <= '"+this.fechaHasta+"' "+(mostrarInvalida?"":whereInvalida)+" and nivel_subrutina = "+this.nivel+" group by id_accion, boton_accion,  e.tipo_accion ,nivel_subrutina, nombre_subrutina, accion_inicial  order by 5,2 ";
            //con = Postgres.conectar("localhost", "ivr", "postgres", "adp2016");
            con = Postgres.conectar(confIVR.getIpServidor(), confIVR.getBaseDatos(), confIVR.getUsuarioBD(), confIVR.getClaveBD());
            st = con.createStatement();
            rs = st.executeQuery(query);
            while(rs.next()){
                eivr.getIdAccion().add(rs.getInt("id_accion"));
                eivr.getBotonAccion().add(rs.getString("boton_accion"));
                eivr.getTipoAccion().add(rs.getInt("tipo_accion"));
                eivr.getNivelSubrutina().add(rs.getInt("nivel_subrutina"));
                eivr.getNombreSubrutina().add(rs.getString("nombre_subrutina"));
                eivr.getCantidadOpcion().add(rs.getInt("cantidad_opcion"));
                eivr.getTotal().add(rs.getInt("total"));
                eivr.getDescripcionAccion().add(rs.getString("descripcion_accion"));
                eivr.getAccionInicial().add(rs.getInt("accion_inicial"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                st.close();
                rs.close();
                con.close();
            }
            catch(Exception e){}
        }
        return eivr;
    }

}
