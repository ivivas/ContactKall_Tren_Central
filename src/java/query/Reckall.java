/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package query;

import DTO.Configuracion;
import DTO.Grabacion;
import adportas.Fechas;
import adportas.SQLConexion;
import java.sql.*;
import java.util.*;

/**
 *
 * @author Jose
 */
public class Reckall {
    
    public static Configuracion conf;
    
    public static List<Grabacion> listaGrabaciones(Connection con,int limit,int offset,String numero,String contraparte,String fechaDesde,String fechaHasta,int uso,String piloto, String id){
        List<Grabacion> lista = new ArrayList();
        String numeroMasIn = "";
        if(conf == null){
            conf = configuracionReckall();
        }
        String like="";
        
        if(numero.equals("-1")){
            numeroMasIn = ComboQuery.listaAnexosPool(con,piloto);
            like = "numero_revisado IN ("+numeroMasIn+")";
        }else{
            like = "numero_revisado='"+numero+"'";
        }
            offset = hacerOffset(limit, offset);
            Grabacion grabacion =  null;
            String query = null;
            if(uso==0){
                query = generarQuery(false,fechaDesde,fechaHasta,numero,contraparte,limit,offset,like,id);
            }
            else{
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" ORDER BY inicio DESC LIMIT "+limit+" OFFSET  "+offset;
            }
            //System.out.println("query: "+query);
            Connection conexion =  null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try{
                conexion = SQLConexion.conectaRecKall(conf.getIpServidor(),conf.getBaseDatos(),conf.getUsuarioBD(),conf.getClaveBD());
                ps = conexion.prepareStatement(query);
                rs = ps.executeQuery();
                if(!numero.equals("-1")){
                    while(rs.next()){
                        grabacion = new Grabacion();
                        grabacion.setInicio(Fechas.TimetoString(rs.getTimestamp("inicio")));
                        grabacion.setId(rs.getInt("pk_id"));
                        if(rs.getString("numero_emisor").trim().equals(numero)){
                            grabacion.setNumeroRevisado(rs.getString("numero_emisor"));
                            grabacion.setContraparte(rs.getString("numero_receptor"));
                        }
                        else if(rs.getString("numero_receptor").trim().equals(numero)){
                            grabacion.setNumeroRevisado(rs.getString("numero_receptor"));
                            grabacion.setContraparte(rs.getString("numero_emisor"));
                        }
                        grabacion.setTipoLlamada(rs.getString("tipo_llamada"));
                        grabacion.setTermino(Fechas.TimetoString(rs.getTimestamp("termino")));
                        grabacion.setDuracion(rs.getInt("duracion"));
                        grabacion.setArchivo(rs.getString("archivo"));
                        lista.add(grabacion);
                        grabacion = null;
                    }
                }else{
                    Object[] numeros = ComboQuery.listaSecretariaArray(con,piloto).toArray();
                    while(rs.next()){
                        grabacion = new Grabacion();
                        if(exisiteDentroDeArray(numeros, rs.getString("numero_emisor").trim())){
                            grabacion.setNumeroRevisado(rs.getString("numero_emisor"));
                            grabacion.setContraparte(rs.getString("numero_receptor"));
                        }else if(exisiteDentroDeArray(numeros, rs.getString("numero_receptor").trim())){
                            grabacion.setNumeroRevisado(rs.getString("numero_receptor"));
                            grabacion.setContraparte(rs.getString("numero_emisor"));
                        }else{
                            continue;
                        }
                        grabacion.setId(rs.getInt("pk_id"));
                        grabacion.setInicio(Fechas.TimetoString(rs.getTimestamp("inicio")));
                        grabacion.setTipoLlamada(rs.getString("tipo_llamada"));
                        grabacion.setTermino(Fechas.TimetoString(rs.getTimestamp("termino")));
                        grabacion.setDuracion(rs.getInt("duracion"));
                        grabacion.setArchivo(rs.getString("archivo"));
                        lista.add(grabacion);
                        grabacion = null;
                    }
                }
            }catch(Exception ex){
                //ex.printStackTrace();
                System.out.println("Error en listaGrabaciones: "+ex);
            }finally{
                try{
                    conexion.close();
                    ps.close();
                    rs.close();
                }catch(Exception e){}
            
        }
        return lista;
    }
     public static List<Grabacion> listaGrabaciones2(Connection con,int limit,int offset,String numero,String contraparte,String fechaDesde,String fechaHasta,int uso,String piloto, String id){
        List<Grabacion> lista = new ArrayList();
        String numeroMasIn = "";
        if(conf == null){
            conf = configuracionReckall();
        }
        String like="";
        
        if(numero.equals("-1")){
            numeroMasIn = ComboQuery.listaAnexosPool(con,piloto);
            like = "numero_revisado IN ("+numeroMasIn+")";
        }else{
            like = "numero_revisado='"+numero+"'";
        }
            
            Grabacion grabacion =  null;
            String query = null;
            if(uso==0){
                query = generarQuery(false,fechaDesde,fechaHasta,numero,contraparte,limit,offset,like,id);
            }
            else{
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" ORDER BY inicio DESC LIMIT "+limit+" OFFSET  "+offset;
            }
            //System.out.println("query: "+query);
            Connection conexion =  null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try{
                conexion = SQLConexion.conectaRecKall(conf.getIpServidor(),conf.getBaseDatos(),conf.getUsuarioBD(),conf.getClaveBD());
                ps = conexion.prepareStatement(query);
                rs = ps.executeQuery();
                if(!numero.equals("-1")){
                    while(rs.next()){
                        grabacion = new Grabacion();
                        grabacion.setInicio(Fechas.TimetoString(rs.getTimestamp("inicio")));
                        grabacion.setId(rs.getInt("pk_id"));
                        if(rs.getString("numero_emisor").trim().equals(numero)){
                            grabacion.setNumeroRevisado(rs.getString("numero_emisor"));
                            grabacion.setContraparte(rs.getString("numero_receptor"));
                        }
                        else if(rs.getString("numero_receptor").trim().equals(numero)){
                            grabacion.setNumeroRevisado(rs.getString("numero_receptor"));
                            grabacion.setContraparte(rs.getString("numero_emisor"));
                        }
                        grabacion.setTipoLlamada(rs.getString("tipo_llamada"));
                        grabacion.setTermino(Fechas.TimetoString(rs.getTimestamp("termino")));
                        grabacion.setDuracion(rs.getInt("duracion"));
                        grabacion.setArchivo(rs.getString("archivo"));
                        lista.add(grabacion);
                        grabacion = null;
                    }
                }else{
                    Object[] numeros = ComboQuery.listaSecretariaArray(con,piloto).toArray();
                    while(rs.next()){
                        grabacion = new Grabacion();
                        if(exisiteDentroDeArray(numeros, rs.getString("numero_emisor").trim())){
                            grabacion.setNumeroRevisado(rs.getString("numero_emisor"));
                            grabacion.setContraparte(rs.getString("numero_receptor"));
                        }else if(exisiteDentroDeArray(numeros, rs.getString("numero_receptor").trim())){
                            grabacion.setNumeroRevisado(rs.getString("numero_receptor"));
                            grabacion.setContraparte(rs.getString("numero_emisor"));
                        }else{
                            continue;
                        }
                        grabacion.setId(rs.getInt("pk_id"));
                        grabacion.setInicio(Fechas.TimetoString(rs.getTimestamp("inicio")));
                        grabacion.setTipoLlamada(rs.getString("tipo_llamada"));
                        grabacion.setTermino(Fechas.TimetoString(rs.getTimestamp("termino")));
                        grabacion.setDuracion(rs.getInt("duracion"));
                        grabacion.setArchivo(rs.getString("archivo"));
                        lista.add(grabacion);
                        grabacion = null;
                    }
                }
            }catch(Exception ex){
                //ex.printStackTrace();
                System.out.println("Error en listaGrabaciones: "+ex);
            }finally{
                try{
                    conexion.close();
                    ps.close();
                    rs.close();
                }catch(Exception e){}
            
        }
        return lista;
    }

    public static Configuracion configuracionReckall (){
        Configuracion conf = new Configuracion();
        String query = "select * from configuracion_integracion where clave = 0 ";
        Connection conexion =  null;
        try{
            conexion = SQLConexion.conectar();
            PreparedStatement ps = conexion.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                conf.setIpServidor(rs.getString("ip_servidor"));
                conf.setBaseDatos(rs.getString("nombre_bd"));
                conf.setUsuarioBD(rs.getString("user_bd"));
                conf.setClaveBD(rs.getString("clave_bd"));
                conf.setIntegrado(rs.getInt("tiene_integracion")==1);
                conf.setRutaPortal(rs.getString("ruta_portal"));
                conf.setRutaGrabacion(rs.getString("ruta_grabaciones"));
            }
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        finally{
            try{
                conexion.close();
            }
            catch(Exception e){
               e.printStackTrace();
            }
        }
        return conf;
    }
    public static int totalBusquedaGrabaciones(String limit,String offset,String numero,String contraparte,String fechaDesde,String fechaHasta,String like,String id){
        int total = 0;
        String query = generarQuery(true, fechaDesde, fechaHasta, numero, contraparte, Integer.parseInt(limit), Integer.parseInt(offset),like,id);
        Connection conexion =  null;
        try{
            conexion = SQLConexion.conectaRecKall(conf.getIpServidor(),conf.getBaseDatos(),conf.getUsuarioBD(),conf.getClaveBD());
            PreparedStatement ps = conexion.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                total = rs.getInt("total");
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }finally{
            try{
                conexion.close();
            }catch(Exception e){}
        }
        return total;
    }
    
    public static String tablaGrabaciones(Connection con, String limit,String offset,String numero,String contraparte,String fechaDesde,String fechaHasta,String mensajeVacio,String piloto,boolean[] titulos,String id){
        StringBuilder sB = new StringBuilder();
        boolean estaVacio = true;
        List<Grabacion> grabaciones = listaGrabaciones(con,Integer.parseInt(limit),Integer.parseInt(offset),numero,contraparte,fechaDesde,fechaHasta,0,piloto,id);
        for(Grabacion grabacion : grabaciones){
            estaVacio = false;
            sB.append("<tr>");
            sB.append("<td>");
            sB.append(grabacion.getId());
            sB.append("</td>");
            if(titulos[0]){
                sB.append("<td>");
                sB.append(grabacion.getNumeroRevisado());
                sB.append("</td>");
            }
            if(titulos[1]){
                sB.append("<td>");
                sB.append(grabacion.getContraparte());
                sB.append("</td>");
            }
            if(titulos[2]){
                sB.append("<td>");
                sB.append(grabacion.getTipoLlamada());
                sB.append("</td>");
            }
            if(titulos[3]){
                sB.append("<td>");
                sB.append(grabacion.getInicio());
                sB.append("</td>");
                sB.append("<td>");
                sB.append(grabacion.getTermino());
                sB.append("</td>");
            }
            if(titulos[4]){
                sB.append("<td>");
                sB.append(grabacion.getDuracion());
                sB.append("</td>");
            }
            sB.append("<td>");
            sB.append("<a href='#' onclick=\"reproducir('"+conf.getRutaGrabacion()+grabacion.getArchivo().trim()+"','"+grabacion.getArchivo().trim()+"',"+grabacion.getId()+")\">");
            sB.append("<img src='img/play2.gif'>");
            sB.append("</a>");
            sB.append("</td>");
            sB.append("</tr>");
        }
        if(estaVacio){
            sB.append("<tr>");
            sB.append("<td colspan=\"7\">");
            sB.append(mensajeVacio);
            sB.append("</td>");
            sB.append("</tr>");
        }
        return sB.toString();
    }
    
    public static int totalGrabaciones(Connection con,String buscar, int limit,int offset,int cantidad,String numero,String contraparte,String piloto,String fechaDesde,String fechaHasta, String id){
        String like="";
        
        if(numero.equals("-1")){
            String numeroMasIn = ComboQuery.listaAnexosPool(con,piloto);
            like = "numero_revisado IN ("+numeroMasIn+")";
        }
        else{
            like = "numero_revisado='"+numero+"'";
        }
        int total = totalBusquedaGrabaciones(limit+"",offset+"", numero, contraparte,fechaDesde,fechaHasta,like,id);
        return total;
    }

    public static String paginado(Connection con,String buscar, int limit,int offset,int cantidad,String numero,String contraparte,String piloto,String fechaDesde,String fechaHasta, String id){
        String like="";
        
        if(numero.equals("-1")){
            String numeroMasIn = ComboQuery.listaAnexosPool(con,piloto);
            like = "numero_revisado IN ("+numeroMasIn+")";
        }
        else{
            like = "numero_revisado='"+numero+"'";
        }
        int total = totalBusquedaGrabaciones(limit+"",offset+"", numero, contraparte,fechaDesde,fechaHasta,like,id);
        StringBuilder paginado = new StringBuilder();
        
        if(total>19){
            int totalPaginado = (total/limit) +1;
            if(cantidad==10){
                paginado.append("");
            }
            else{
                paginado.append("<a class='flecha' href='grabaciones.jsp?buscar=buscar&cantidad=");
                paginado.append(cantidad-10);
                paginado.append("&numero_=");
                paginado.append(numero);
                paginado.append("&piloto=");
                paginado.append(piloto);
                paginado.append("&contraparte=");
                paginado.append(contraparte);
                paginado.append("&desde=");
                paginado.append(fechaDesde);
                paginado.append("&hasta=");
                paginado.append(fechaHasta);
                paginado.append("&limit=");
                paginado.append(limit);
                paginado.append("&offset=");
                paginado.append(offset-1);
                paginado.append("&index=0");
                paginado.append("'><<</a>&nbsp;");
            }
            for(int i = 0 ; i< totalPaginado ; i ++){
                if(i>=(cantidad-10) & i<cantidad){
                    if((i+1)==offset | buscar==null){
                        paginado.append("<span style='font-size:20px;color:red;'>");
                        paginado.append(i+1);
                        paginado.append("</span>&nbsp;");
                        buscar = "0";
                    }
                    else{
                        paginado.append("<a class='numero' href='grabaciones.jsp?buscar=buscar&numero_=");
                        paginado.append(numero);
                        paginado.append("&cantidad=");
                        paginado.append(cantidad);
                        paginado.append("&piloto=");
                        paginado.append(piloto);
                        paginado.append("&contraparte=");
                        paginado.append(contraparte);
                        paginado.append("&desde=");
                        paginado.append(fechaDesde);
                        paginado.append("&hasta=");
                        paginado.append(fechaHasta);
                        paginado.append("&limit=");
                        paginado.append(limit);
                        paginado.append("&offset=");
                        paginado.append(i+1);
                        paginado.append("&index=0");
                        paginado.append("'>");
                        paginado.append(i+1);
                        paginado.append("</a>&nbsp;");
                    }
                }
            }
            if(cantidad*limit>=total){
                paginado.append("");
            }
            else{
                paginado.append("<a class='flecha' href='grabaciones.jsp?buscar=buscar&cantidad=");
                paginado.append((cantidad+10));
                paginado.append("&numero_=");
                paginado.append(numero);
                paginado.append("&piloto=");
                paginado.append(piloto);
                paginado.append("&contraparte=");
                paginado.append(contraparte);
                paginado.append("&desde=");
                paginado.append(fechaDesde);
                paginado.append("&hasta=");
                paginado.append(fechaHasta);
                paginado.append("&limit=");
                paginado.append(limit);
                paginado.append("&offset=");
                paginado.append(offset+1);
                paginado.append("'>>></a>");
            }
        }
        return paginado.toString();
    }
    public static String filtro(String numero,String contraparte,String fechaDesde,String fechaHssta){
        StringBuilder filtro = new StringBuilder();
        if(!numero.equals("") & contraparte.equals("") & fechaDesde.equals("") & fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') ");
        }
        else if(!contraparte.equals("") & !numero.equals("") & fechaDesde.equals("") & fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') and numero_receptor like ('%"+contraparte+"%')");
        }
        else if(!numero.equals("") & contraparte.equals("") & !fechaDesde.equals("") & !fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHssta+"'");
        }
        else if(!contraparte.equals("") & !numero.equals("") & !fechaDesde.equals("") & !fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') and numero_receptor like ('%"+contraparte+"%') AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHssta+"'");
        }
        else if(!numero.equals("") & contraparte.equals("") & !fechaDesde.equals("") & fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') AND inicio>='"+fechaDesde+"'");
        }
        else if(!contraparte.equals("") & !numero.equals("") & fechaDesde.equals("") & !fechaHssta.equals("")){
            filtro.append(" where numero_revisado like ('%"+numero+"%') and numero_receptor like ('%"+contraparte+"%') AND inicio<='"+fechaHssta+"'");
        }
        return filtro.toString();
    }
    public static int hacerOffset(int limit,int offset){
        if(offset==0){
            offset=1;
        }
        offset = (offset-1) * limit;
        
        return offset;
    }

    private static String generarQuery(boolean esCount,String fechaDesde, String fechaHasta, String numero, String contraparte, int limit, int offset,String like, String id) {
        String query = null;
        if(esCount){
            if(fechaDesde.equals("") & fechaHasta.equals("") & contraparte.equals("")){
               query =  "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like;
            }
            else if(fechaDesde.equals("") & fechaHasta.equals("") & !contraparte.equals("")){
               query =  "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) ";
            }
            else if(!fechaDesde.equals("") & !fechaHasta.equals("") & !contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"'";
            }
            else if(!fechaDesde.equals("") & !fechaHasta.equals("") & contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"'";
            }
            else if(!fechaDesde.equals("") & fechaHasta.equals("") & contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"'";
            }
            else if(fechaDesde.equals("") & !fechaHasta.equals("") & contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio<='"+fechaHasta+"'";
            }
            else if(!fechaDesde.equals("") & fechaHasta.equals("") & !contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"'";
            }
            else if(fechaDesde.equals("") & !fechaHasta.equals("") & !contraparte.equals("")){
                query = "SELECT COUNT(*) AS total FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio<='"+fechaHasta+"'";
            }
            if(!id.equals("")){
                query += " and pk_id = "+id;
            }
        }else{
            //query = "SELECT * FROM vista_llamadas WHERE 1=1 "+like;
            if(fechaDesde.equals("") & fechaHasta.equals("") & contraparte.equals("")){
               //query =  "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query =  "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like;
            }else if(fechaDesde.equals("") & fechaHasta.equals("") & !contraparte.equals("") ){
               //query =  "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query =  "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"'))";
            }else if(!fechaDesde.equals("") & !fechaHasta.equals("") & !contraparte.equals("") ){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"'";
            }else if(!fechaDesde.equals("") & !fechaHasta.equals("") & contraparte.equals("")){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"' AND inicio<='"+fechaHasta+"'";
            }else if(!fechaDesde.equals("") & fechaHasta.equals("") & contraparte.equals("")){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio>='"+fechaDesde+"'";
            }else if(fechaDesde.equals("") & !fechaHasta.equals("") & contraparte.equals("")){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio<='"+fechaHasta+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND inicio<='"+fechaHasta+"'";
            }else if(!fechaDesde.equals("") & fechaHasta.equals("") & !contraparte.equals("")){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio>='"+fechaDesde+"'";
            }else if(fechaDesde.equals("") & !fechaHasta.equals("") & !contraparte.equals("")){
                //query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio<='"+fechaHasta+"' ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
                query = "SELECT * FROM vista_llamadas WHERE 1=1 AND "+like+" AND ((tipo_llamada='Saliente' AND TRIM(numero_receptor) LIKE '"+contraparte+"') OR (tipo_llamada='Entrante' AND TRIM(numero_emisor) LIKE '"+contraparte+"')) AND inicio<='"+fechaHasta+"'";
            }
            
            if(!id.equals("")){
                query += " and pk_id = "+id;
            }
            
            query += "ORDER BY inicio DESC LIMIT "+limit+" OFFSET "+offset;
            
        }
        return query;
    }
    public static boolean exisiteDentroDeArray(Object[] array,String target){
        for(int i = 0; i < array.length ; i++){
            if(array[i].toString().equals(target.trim())){
                return true;
            }
        }
        return false;
    }

    public static String titulosGenerados(boolean[] titulos,ResourceBundle msgs){
        Connection conexion = null;
        StringBuilder titulosGenerados = new StringBuilder();
        try{
            conexion = SQLConexion.conectaRecKall(conf.getIpServidor(),conf.getBaseDatos(),conf.getUsuarioBD(),conf.getClaveBD());
            Statement st = conexion.createStatement();
            ResultSet rsEstatico = st.executeQuery("SELECT * FROM tbl_ws_schema_reckall ORDER BY pk_schema_reckall ASC");
            titulosGenerados.append("<th>"+msgs.getString("reckall.id")+"</th>");
            while (rsEstatico.next()) {
                String nombreCampo = rsEstatico.getString("campo").trim();
                if (rsEstatico.getBoolean("mostrar_en_resultado") == true) {
                    if (nombreCampo.compareTo("anx") == 0) {
                        titulos[0] = true;
                        titulosGenerados.append("<th>"+msgs.getString("reckall.numero.revisado")+"</th>");
                    } else if (nombreCampo.compareTo("ctp") == 0) {
                        titulos[1] = true;
                        titulosGenerados.append("<th>"+msgs.getString("reckall.contraparte")+"</th>");
                    } else if (nombreCampo.compareTo("tipo") == 0) {
                        titulos[2] = true;
                        titulosGenerados.append("<th>"+msgs.getString("reckall.tipo.llamada")+"</th>");
                    } else if (nombreCampo.compareTo("fecha") == 0) {
                        titulos[3] = true;
                        titulosGenerados.append("<th>"+msgs.getString("reckall.inicio")+"</th><th>"+msgs.getString("reckall.termino")+"</th>");
                    } else if (nombreCampo.compareTo("duracion") == 0) {
                        titulos[4] = true;
                        titulosGenerados.append("<th>"+msgs.getString("reckall.duracion")+"</th>");
                    } 
                }
            }
            titulosGenerados.append("<th></th>");
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                conexion.close();
            }catch(Exception e){}
        }
        return titulosGenerados.toString();
    }

}
