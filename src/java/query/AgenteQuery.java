/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package query;

import adportas.SQLConexion;
import clienteSocket.AgenteSocket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;


/**
 *
 * @author Jose
 */
public class AgenteQuery {
    
    public static String obtenerAgentesXPiloto(String piloto, ResourceBundle msgs) throws SQLException{
        Connection con = null;
        StringBuilder datos = new StringBuilder();
        try{
            con = SQLConexion.conectar();
            String campoOrdenar = getCampo(con,piloto);
            List secretarias = ComboQuery.listaSecretaria(con,piloto,campoOrdenar);
            String[] nombre = new String[secretarias.size()];
            for(int i = 0 ; i < nombre.length; i+=4){
                try{
                    nombre[i] = "uno";
                    nombre[i+1] = "dos";
                    nombre[i+2] = "tres";
                    nombre[i+3] = "cuatro";
                }
                catch(Exception e){}
            }
            int i = 0;
            datos.append("<table id='tabla'>");
            for(Object secretaria : secretarias){
                String[] datosSecretaria = secretaria.toString().split("%");
                if(nombre[i].equals("uno")){
                    datos.append("<tr>");
                }
                String tag = datosSecretaria[0]+" - "+datosSecretaria[1];
                datos.append("<td>");
                datos.append("<div class='columna");
                datos.append(nombre[i]);
                datos.append("' id='caluga' onClick='expandir(this)'  draggable='true' ondragstart='transferirPagina(event,this)' ondrop='recibirData(event,this)' ondragover=\"allowDrop(event)\" ");
                datos.append("nombre='");
                datos.append(tag);
                datos.append("' >");
                datos.append("<input type='hidden' id='numeroAgente' value='");
                datos.append(datosSecretaria[0]);
                datos.append("'>");
                datos.append("<input type='hidden' id='devNameAgente' value='");
                datos.append(datosSecretaria[4]);
                datos.append("'>");
                
                datos.append("<div class='encabezado' name='nombre'>");
                if(tag.length()>15){
                    tag = tag.substring(0, 15)+"...";
                }
                datos.append(tag);
                
                datos.append("</div>");
                datos.append("<div class=\"imagenEst\" style=\"float: left; width: 45%; height: 75%;text-align:center;\" >");
                if(Integer.parseInt(datosSecretaria[2])==0 & Integer.parseInt(datosSecretaria[3])==0){
                    datos.append("<img  src='imagenes/off.png' style=\"margin-top: 40%;width: 65%;\">");
                }else if(Integer.parseInt(datosSecretaria[2])==0 & Integer.parseInt(datosSecretaria[3])!=0){
                    datos.append("<img  src='imagenes/out.png' style=\"margin-top: 40%;width: 65%;\">");
                }else if(Integer.parseInt(datosSecretaria[2])==1 & Integer.parseInt(datosSecretaria[3])==0){
                    datos.append("<img  src='imagenes/on.png' style=\"margin-top: 40%;width: 65%;\">");
                }else if(Integer.parseInt(datosSecretaria[2])==1 & Integer.parseInt(datosSecretaria[3])!=0){
                    datos.append("<img  src='imagenes/out.png' style=\"margin-top: 40%;width: 65%;\">");
                }else if(Integer.parseInt(datosSecretaria[2])==2){
                    datos.append("<img  src='imagenes/sin.png' style=\"margin-top: 40%;width: 65%;\">");
                }else if(Integer.parseInt(datosSecretaria[2])==3){
                    datos.append("<img  src='imagenes/camp.png' style=\"margin-top: 40%;width: 65%;\">");
                }
                datos.append("</div>");
                datos.append("<div class=\"indicador\" style=\"width: 55%; float: left; height: 75%; background: white none repeat scroll 0% 0%;\">");
                int perdidas = contarTipoDeLlamadas(con,datosSecretaria[0],0,0);
                int contestadas = contarTipoDeLlamadas(con,datosSecretaria[0],1,0);
                int[] promedios = getPromedioLlamadas(con);
                if(perdidas<=promedios[0]){
                    datos.append("<div id='perdida_ag' class='ok' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\">");
                    datos.append("<img src='imagenes/perdida.png' style=\"float:left;margin-right:10%\"  >");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(perdidas);//bueno
                    datos.append("</div>");
                    datos.append("<div id=\"t1\" class=\"toolkit\" >");
                    datos.append(msgs.getString("qos.grafico.titulo.llamada.perdida"));
                    datos.append("</div>");
                    datos.append("</div>");
                }else{
                    datos.append("<div id='perdida_ag' class='malo' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\" >");
                    datos.append("<img src='imagenes/perdida.png' style=\"float:left;margin-right:10%\">");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(perdidas);
                    datos.append("</div>");
                    datos.append("<div id=\"t1\" class=\"toolkit\" >");
                    datos.append(msgs.getString("qos.grafico.titulo.llamada.perdida"));
                    datos.append("</div>");
                    datos.append("</div>");
                }
                if(contestadas<=promedios[1]){
                    datos.append("<div id='recibida_ag' class='ok' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\" >");
                    datos.append("<img src='imagenes/recibida.png' style=\"float:left;margin-right:10%\" >");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(contestadas);
                    datos.append("</div>");
                    datos.append("<div id=\"t1\" class=\"toolkit\" >");
                    datos.append(msgs.getString("qos.grafico.titulo.llamada.contestada"));
                    datos.append("</div>");
                    datos.append("</div>");
                }else{
                    datos.append("<div id='recibida_ag' class='malo' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\" >");
                    datos.append("<img src='imagenes/recibida.png' style=\"float:left;margin-right:10%\">");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(contestadas);
                    datos.append("</div>");
                    datos.append("<div id=\"t1\" class=\"toolkit\" >");
                    datos.append(msgs.getString("qos.grafico.titulo.llamada.contestada"));
                    datos.append("</div>");
                    datos.append("</div>");
                }
                int porcentaje =  getRendimiento(datosSecretaria[0],piloto,contestadas,perdidas);
                if(porcentaje<getPorcentajeIdeal(con)){
                    datos.append("<div id='rendimiento_ag' class='malo' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\" >");
                    datos.append("<img src='imagenes/performance.png' style=\"float:left;margin-right:10%\">");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(porcentaje);
                    datos.append(" %</div>");
                }
                else{
                    datos.append("<div id='rendimiento_ag' class='ok' onmouseover=\"mostrarToolKit(this)\" onmouseout=\"ocultarToolKit(this)\" >");
                    datos.append("<img src='imagenes/performance.png' style=\"float:left;margin-right:10%\">");
                    datos.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    datos.append(porcentaje);
                    datos.append(" %</div>");
                }
                //datos.append(" %");
                datos.append("<div id=\"t1\" class=\"toolkit\" >");
                datos.append(msgs.getString("msg.caluga.cuality"));
                datos.append("</div>");
                datos.append("</div>");
                datos.append(getEstadistica(con,datosSecretaria[0],msgs));
                datos.append("</div>");
                datos.append("</div>");
                datos.append("</td>");
                if(nombre[i].equals("cuatro")){
                    datos.append("</tr>");
                }
                i++;
            }
            datos.append("</table>");
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            con.close();
        }
        return datos.toString();
    }
    
    public static String obtenerAgentes(String agente,ResourceBundle msgs) throws SQLException{
        Connection con = null;
        StringBuilder datos = new StringBuilder();
        try{
            con = SQLConexion.conectar();
            String[] secretaria = ComboQuery.listaSecretariaUnica(con,agente).split("%");
                datos.append("<div id='calugaAgente'>");
                datos.append("<input type='hidden' id='numeroAgente' value='");
                datos.append(secretaria[0]);
                datos.append("'>");
                datos.append("<input type='hidden' id='devNameAgente' value='");
                datos.append(secretaria[4]);
                datos.append("'>");
                datos.append("<div class='encabezado'>");
                datos.append(secretaria[0]);
                datos.append(" - ");
                datos.append(secretaria[1]);
                datos.append("</div>");
                if(Integer.parseInt(secretaria[2])==0 & Integer.parseInt(secretaria[3])==0){
                    datos.append("<img src='imagenes/off.png'>");
                }
                else if(Integer.parseInt(secretaria[2])==0 & Integer.parseInt(secretaria[3])!=0){
                    datos.append("<img src='imagenes/out.png'>");
                }
                else if(Integer.parseInt(secretaria[2])==1 & Integer.parseInt(secretaria[3])==0){
                    datos.append("<img src='imagenes/on.png'>");
                }
                else if(Integer.parseInt(secretaria[2])==1 & Integer.parseInt(secretaria[3])!=0){
                    datos.append("<img src='imagenes/out.png'>");
                }
                else if(Integer.parseInt(secretaria[2])==2){
                    datos.append("<img src='imagenes/sin.png'>");
                }
                int perdidas = contarTipoDeLlamadas(con,secretaria[0],0,0);
                int contestadas = contarTipoDeLlamadas(con,secretaria[0],1,0);
                int[] promedios = getPromedioLlamadas(con);
                if(perdidas<=promedios[0]){
                    datos.append("<div id='perdida_ag' class='ok'>");
                    datos.append("<img src='imagenes/perdida.png'>&nbsp;");
                    datos.append(perdidas);//bueno
                    datos.append("</div>");
                }
                else{
                    datos.append("<div id='perdida_ag' class='malo'>");
                    datos.append("<img src='imagenes/perdida.png'>&nbsp;");
                    datos.append(perdidas);
                    datos.append("</div>");
                }
                if(contestadas<=promedios[1]){
                    datos.append("<div id='recibida_ag' class='ok'>");
                    datos.append("<img src='imagenes/recibida.png'>&nbsp;");
                    datos.append(contestadas);
                    datos.append("</div>");
                }
                else{
                    datos.append("<div id='recibida_ag' class='malo'>");
                    datos.append("<img src='imagenes/recibida.png'>&nbsp;");
                    datos.append(contestadas);
                    datos.append("</div>");
                }
                int porcentaje = getRendimiento(secretaria[0],"",contestadas,perdidas);
                if(porcentaje<getPorcentajeIdeal(con)){
                    datos.append("<div id='rendimiento_ag' class='malo'><img src='imagenes/performance.png'>");
                    datos.append(" ");
                    datos.append(porcentaje);
                }
                else{
                    datos.append("<div id='rendimiento_ag' class='ok'><img src='imagenes/performance.png'>");
                    datos.append(" ");
                    datos.append(porcentaje);
                }
                datos.append(" %</div>");
                datos.append("<div id='promedio'>");
                datos.append(getEstadistica(con,secretaria[0],msgs));
                datos.append("</div>");
               
                datos.append("</div>");            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            con.close();
        }
        return datos.toString();
    }
    
    public static String obtenerPilotos(String sesion, String idPiloto) throws SQLException{
        StringBuilder datosPool = new StringBuilder();       
        Connection con = null;
        try{
            con = SQLConexion.conectar();
            List pilotos = ComboQuery.listaPilotos2(con, sesion, idPiloto);
            String[] nombre = new String[pilotos.size()];
            for(int i = 0 ; i < nombre.length; i+=4){
                try{
                    nombre[i] = "uno";
                    nombre[i+1] = "dos";
                    nombre[i+2] = "tres";
                    nombre[i+3] = "cuatro";
                }
                catch(Exception e){}
            }
            int i = 0;
            datosPool.append("<table id='tabla'>");
            for(Object piloto : pilotos){
                if(nombre[i].equals("uno")){
                    datosPool.append("<tr>");
                }
                datosPool.append("<td>");
                datosPool.append("<div class='column"+nombre[i]+"' id='"+piloto.toString().split("%")[0]+"' ondragover=\"allowDrop(event)\" ondrop='recibirData(event,this)' onClick=\"verPool(this.id)\">");
                datosPool.append("<input type='hidden' id='numeroPool' value='");
                datosPool.append(piloto.toString().split("%")[0]);
                datosPool.append("'>");
                datosPool.append("<div class='encabezado' style=\"height:20%\">");
                String tag = piloto.toString().split("%")[0]+" - "+piloto.toString().split("%")[1];
                if(tag.length()>20){
                    tag = tag.substring(0, 15)+"...";
                }
                //datosPool.append(piloto.toString().split("%")[0]);
                //datosPool.append("");
                datosPool.append(tag);
                datosPool.append("</div>");
                datosPool.append("<div class=\"imagenEst\" style=\"float: left; width: 45%; height: 65%;text-align:center;\" >");
                datosPool.append("<img src='imagenes/pool.png' style=\"margin-top: 40%;\" >");
                datosPool.append("</div>");
                datosPool.append("<div class=\"indicador\" style=\"width: 55%; float: left; height: 65%; background: white none repeat scroll 0% 0%;\">");
                int perdidas = contarTotalTipoDeLlamadas(con,piloto.toString().split("%")[0],0,0);
                int contestadas = contarTotalTipoDeLlamadas(con,piloto.toString().split("%")[0],1,0);
                int[] promedios = getPromedioPoolLlamadas(con);
                if(perdidas<=promedios[0]){
                    datosPool.append("<div id='perdida' class='ok'>");
                    datosPool.append("<img src='imagenes/perdida.png' style=\"float:left;margin-right:10%\" >&nbsp;");
                    datosPool.append(perdidas);//bueno
                    datosPool.append("</div>");
                }else{
                    datosPool.append("<div id='perdida' class='malo'>");
                    datosPool.append("<img src='imagenes/perdida.png' style=\"float:left;margin-right:10%\">");
                    datosPool.append(perdidas);
                    datosPool.append("</div>");
                }
                if(contestadas<=promedios[1]){
                    datosPool.append("<div id='recibida' class='ok'>");
                    datosPool.append("<img src='imagenes/recibida.png' style=\"float:left;margin-right:10%\">");
                    datosPool.append(contestadas);
                    datosPool.append("</div>");
                }else{
                    datosPool.append("<div id='recibida' class='malo'>");
                    datosPool.append("<img src='imagenes/recibida.png' style=\"float:left;margin-right:10%\">");
                    datosPool.append(contestadas);
                    datosPool.append("</div>");
                }
                int porcentaje =  getRendimiento("",piloto.toString().split("%")[0],contestadas,perdidas);
                if(porcentaje<getPorcentajeIdeal(con)){
                    datosPool.append("<div id='rendimiento' class='malo'><img src='imagenes/performance.png' style=\"float:left;margin-right:10%\">");
                    //datosPool.append(" ");
                    datosPool.append(porcentaje+" %");
                }else{
                    datosPool.append("<div id='rendimiento' class='ok'><img src='imagenes/performance.png' style=\"float:left;margin-right:10%\">");
                    //datosPool.append(" ");
                    datosPool.append(porcentaje+" %");
                }
                datosPool.append("</div>");
                //datosPool.append("<div id='promedio'>");
                datosPool.append(getEstadisticaPool(con,piloto.toString().split("%")[0]));
                //datosPool.append("</div>");
                datosPool.append("</div>");
                datosPool.append("<div id='totAg'>total agentes: ");
                datosPool.append(totalAgentes(con,piloto.toString().split("%")[0]));
                datosPool.append("</div>");
                datosPool.append("</td>");
                if(nombre[i].equals("cuatro")){
                    datosPool.append("</tr>");
                }
                i++;
            }
            datosPool.append("</table>");
        }catch(Exception e){
            //e.printStackTrace();
            System.out.println("Error en obtenerPilotos: "+e);
        }finally{
            try{
                con.close();
            }catch(Exception e){}
        }
        return datosPool.toString();
    }
    
    public static String obtenerPilotos2() throws SQLException{
        StringBuilder datosPool = new StringBuilder();       
        Connection con = null;
        try{
            con = SQLConexion.conectar();
            List pilotos = ComboQuery.listaPilotos2(con);
            String[] nombre = new String[pilotos.size()];
            for(int i = 0 ; i < nombre.length; i+=4){
                try{
                    nombre[i] = "uno";
                    nombre[i+1] = "dos";
                    nombre[i+2] = "tres";
                    nombre[i+3] = "cuatro";
                }
                catch(Exception e){}
            }
            int i = 0;
            datosPool.append("<table id='tabla'>");
            for(Object piloto : pilotos){
                if(nombre[i].equals("uno")){
                    datosPool.append("<tr>");
                }
                datosPool.append("<td>");
                datosPool.append("<div class='column"+nombre[i]+"' id='"+piloto.toString().split("%")[0]+"' ondragover=\"allowDrop(event)\" ondrop='recibirData(event,this)' onClick=\"verPool(this.id)\">");
                datosPool.append("<input type='hidden' id='numeroPool' value='");
                datosPool.append(piloto.toString().split("%")[0]);
                datosPool.append("'>");
                datosPool.append("<div class='encabezado'>");
            datosPool.append(piloto.toString().split("%")[0]);
            datosPool.append(" - ");
            datosPool.append(piloto.toString().split("%")[1]);
            datosPool.append("</div>");
            datosPool.append("<img src='imagenes/pool.png'>");
            int perdidas = contarTotalTipoDeLlamadas(con,piloto.toString().split("%")[0],0,0);
            int contestadas = contarTotalTipoDeLlamadas(con,piloto.toString().split("%")[0],1,0);
            int[] promedios = getPromedioPoolLlamadas(con);
            if(perdidas<=promedios[0]){
                datosPool.append("<div id='perdida' class='ok'>");
                datosPool.append("<img src='imagenes/perdida.png'>&nbsp;");
                datosPool.append(perdidas);//bueno
                datosPool.append("</div>");
            }
            else{
                datosPool.append("<div id='perdida' class='malo'>");
                datosPool.append("<img src='imagenes/perdida.png'>&nbsp;");
                datosPool.append(perdidas);
                datosPool.append("</div>");
            }
            if(contestadas<=promedios[1]){
                datosPool.append("<div id='recibida' class='ok'>");
                    datosPool.append("<img src='imagenes/recibida.png'>&nbsp;");
                    datosPool.append(contestadas);
                    datosPool.append("</div>");
                }
                else{
                    datosPool.append("<div id='recibida' class='malo'>");
                    datosPool.append("<img src='imagenes/recibida.png'>&nbsp;");
                    datosPool.append(contestadas);
                    datosPool.append("</div>");
                }
                int porcentaje =  getRendimiento("",piloto.toString().split("%")[0],contestadas,perdidas);
                if(porcentaje<getPorcentajeIdeal(con)){
                    datosPool.append("<div id='rendimiento' class='malo'><img src='imagenes/performance.png'>");
                    datosPool.append(" ");
                    datosPool.append(porcentaje);
                }
                else{
                    datosPool.append("<div id='rendimiento' class='ok'><img src='imagenes/performance.png'>");
                    datosPool.append(" ");
                    datosPool.append(porcentaje);
                }
            datosPool.append(" %</div>");
            datosPool.append("<div id='promedio'>");
            datosPool.append(getEstadisticaPool(con,piloto.toString().split("%")[0]));
            datosPool.append("</div>");
            datosPool.append("<div id='totAg'>total agentes: ");
            datosPool.append(totalAgentes(con,piloto.toString().split("%")[0]));
            datosPool.append("</div>");
            datosPool.append("<div id='colaPiloto'>");
            datosPool.append("Cola:");
            datosPool.append(AgenteQuery.listarCola(con,piloto.toString().split("%")[0]));
            datosPool.append("</div>");
            datosPool.append("</td>");
            if(nombre[i].equals("cuatro")){
                datosPool.append("</tr>");
            }
            i++;
        }
        datosPool.append("</table>");
            }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            con.close();
        }
        return datosPool.toString();
    }
    
    private static int[] getPromedioIdeal(Connection con){
        int promedios[] = new int[2];
        String query = "select * from promedio_conf";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                promedios[0] = rs1.getInt("promedio_ringeo");
                promedios[1] = rs1.getInt("promedio_llamada");
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return promedios;
    }
    
    public static String obtenerMonitor(String piloto){
        StringBuilder monitor = new StringBuilder();
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select extension,devicename from monitores m join pilotos_monitores on m.id = id_monitor where id_piloto = (select id from pilotos where piloto = ?);";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                monitor.append("<input type='hidden' id='monitor' value='");
                monitor.append(rs.getString("extension"));
                monitor.append("-");
                monitor.append(rs.getString("devicename"));
                monitor.append("'>");
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            try{
                con.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return monitor.toString();
    }
    
    public static int[] getPromedioLlamadas(Connection con){
        int promedios[] = new int[2];
        String query = "select * from promedio_conf";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                promedios[0] = rs1.getInt("promedio_perdidas");
                promedios[1] = rs1.getInt("promedio_contestadas");
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return promedios;
    }
    
    public static int[] getPromedioPoolLlamadas(Connection con){
        int promedios[] = new int[2];
        String query = "select * from promedio_conf";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                promedios[0] = rs1.getInt("promedio_perdida_pool");
                promedios[1] = rs1.getInt("promedio_contestada_pool");
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return promedios;
    }
    public static String obtenerMusicaBienvenida(Connection con) {//devuelve un array de string que contiene los numeros de anexos habilitados y que pertenecen al pool del routepoint ingresado por parametro
        try {
            String consulta = "select descripcion from ctiports where tipo_ctiport = 'bienvenida'";
            PreparedStatement ps2 = con.prepareStatement(consulta);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                return rs2.getString("descripcion").trim();
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


        return "";
    }
    public static int contarTipoDeLlamadas(Connection con,String anexo,int tipo, int lapso) throws SQLException{
         int total = 0;
        try {
            String numeroBienvenida = obtenerMusicaBienvenida(con);
            String consulta="";
            if(lapso == 0){
                consulta = "select count (*) as total from estadistica where anexo = ? and estado = ? and ringeo >='"+getFecha(true)+"' and ringeo <='"+getFecha(false)+"'  and ultima_redireccion = '"+numeroBienvenida+"'";
            }
            else if(lapso == 1){
                consulta = "select count (*) as total from estadistica where anexo = ? and estado = ? and ringeo >='"+getFechaSemanal(true)+"' and ringeo <='"+getFechaSemanal(false)+"'  and ultima_redireccion = '"+numeroBienvenida+"'";
            }
            else if(lapso == 2){            
                consulta = "select count (*) as total from estadistica where anexo = ? and estado = ? and ringeo >='"+getFechaMensual(true)+"' and ringeo <='"+getFechaMensual(false)+"'  and ultima_redireccion = '"+numeroBienvenida+"'";
            }
            PreparedStatement ps2 = con.prepareStatement(consulta);
            ps2.setString(1, anexo);
            ps2.setInt(2, tipo);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                total = rs2.getInt("total");
            }
            rs2.close();
            ps2.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return total;
    }
    
    public static int contarTotalTipoDeLlamadas(Connection con,String piloto,int tipo,int lapso) throws SQLException{
        int total = 0;
        try {
            String numeroBienvenida = obtenerMusicaBienvenida(con);
            String consulta="";
            if(lapso == 0){
                consulta = "select count(distinct(cisco_call_id)) as total from estadistica where pool = ? and ringeo >= '"+getFecha(true)+"' and ringeo <= '"+getFecha(false)+"' and estado = ?   and ultima_redireccion = '"+numeroBienvenida+"'";
            }
            else if(lapso == 1){
                consulta = "select count(distinct(cisco_call_id)) as total from estadistica where pool = ? and ringeo >= '"+getFechaSemanal(true)+"' and ringeo <= '"+getFechaSemanal(false)+"' and estado = ?  and ultima_redireccion = '"+numeroBienvenida+"'";                        
            }
            else if(lapso == 2){
                consulta = "select count(distinct(cisco_call_id)) as total from estadistica where pool = ? and ringeo >= '"+getFechaMensual(true)+"' and ringeo <= '"+getFechaMensual(false)+"' and estado = ?   and ultima_redireccion = '"+numeroBienvenida+"'";
            }
            PreparedStatement ps2 = con.prepareStatement(consulta);
            ps2.setString(1, piloto);
            ps2.setInt(2, tipo);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                total = rs2.getInt("total");
            }
            rs2.close();
            ps2.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return total;
    }
    public static int[] promedioPool(Connection con,String piloto,int lapso){
        int[] promedio = new int[2];
        String query = "select * from promedio_pool where pool = ?; ";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setString(1, piloto);
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                if(lapso == 0){
                    promedio[0] = rs1.getInt("promedio_ringeo_pool");
                    promedio[1] = rs1.getInt("promedio_llamada_pool");
                }
                else if(lapso == 1){
                    promedio[0] = rs1.getInt("promedio_ringeo_semanal_pool");
                    promedio[1] = rs1.getInt("promedio_llamada_semanal_pool");
                }
                else if(lapso == 2){
                    promedio[0] = rs1.getInt("promedio_ringeo_mensual_pool");
                    promedio[1] = rs1.getInt("promedio_llamada_mensual_pool");
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return promedio;
    }
    public static String getEstadisticaPool(Connection con,String pool){
        StringBuilder resultado = new StringBuilder();
        int[] promedioIdeal = getPromedioIdeal(con);
        int promedioRingeoTotal = 0;
        int promedioLlamadaTotal = 0;
        String query = "select * from promedio where pool = ? and "
                + "(select extract(day from (select fecha))) = "
                + "(select extract(day from (select current_timestamp))) "
                + "and (select extract(month from (select fecha))) = "
                + "(select extract(month from (select current_timestamp))) and "
                + "(select extract(year from (select fecha))) = (select extract(year from (select current_timestamp))); ";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setString(1, pool);
            ResultSet rs1 = ps1.executeQuery();
            int i = 0;
            while (rs1.next()) {
                promedioRingeoTotal += rs1.getInt("promedio_ringeo");
                promedioLlamadaTotal += rs1.getInt("promedio_llamada");
                i++;
            }
            if(i>0){
            if((promedioRingeoTotal/i)<=promedioIdeal[0]){
                    resultado.append("<div class='ok' id='ringeo'>");
                    resultado.append("<img src='imagenes/ring.png'> ");
                    resultado.append(promedioRingeoTotal/i);
                    resultado.append(" s");
                    resultado.append("</div>");
            }else{
                resultado.append("<div class='malo' id='ringeo'>");
                resultado.append("<img src='imagenes/ring.png'> ");
                resultado.append(promedioRingeoTotal/i);
                resultado.append("</div>");
            }
            if((promedioLlamadaTotal/i)>=promedioIdeal[1]){
                resultado.append("<div class='ok' id='contesto'>");
                resultado.append("<img src='imagenes/call.png'> ");
                resultado.append(promedioLlamadaTotal/i);
                resultado.append(" s");
                resultado.append("</div>");
            }else{
                resultado.append("<div class='malo' id='contesto'>");
                resultado.append("<img src='imagenes/call.png'> ");
                resultado.append(promedioLlamadaTotal/i);
                resultado.append(" s");
                resultado.append("</div>");
            }
        }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }

        return resultado.toString();
        }
    public static int[] promedios(Connection con,String anexo,int lapso){
        int[] promedios = new int[2];
        String query = "select * from promedio where anexo = ? ";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                if(lapso == 0){
                    promedios[0] = rs1.getInt("promedio_ringeo");
                    promedios[1] = rs1.getInt("promedio_llamada");
                }   
                else if(lapso == 1){
                    promedios[0] = rs1.getInt("promedio_ringeo_semanal");
                    promedios[1] = rs1.getInt("promedio_llamada_semanal");
                }
                else if(lapso == 2){
                    promedios[0] = rs1.getInt("promedio_ringeo_mensual");
                    promedios[1] = rs1.getInt("promedio_llamada_mensual");
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return promedios;
    }
    public static String getEstadistica(Connection con,String anexo,ResourceBundle msgs){
        StringBuilder resultado = new StringBuilder();
        int[] promedioIdeal = getPromedioIdeal(con);
        String query = "select * from promedio where anexo = ? and (select extract(day from (select fecha))) = (select extract(day from (select current_timestamp))) and (select extract(month from (select fecha))) = (select extract(month from (select current_timestamp))) and (select extract(year from (select fecha))) = (select extract(year from (select current_timestamp))); ";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                if(rs1.getInt("promedio_ringeo")<=promedioIdeal[0]){
                    resultado.append("<div class='ok' id='ringeo_ag' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>");
                    resultado.append("<img src='imagenes/ring.png' style=\"float:left;margin-right:10%\"> ");
                    resultado.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    resultado.append(segundosATiempoTheRial(rs1.getInt("promedio_ringeo")));
                    resultado.append("</div>");
                    resultado.append("<div style='font-size: 15px' id='t1' class='toolkit' >");
                    resultado.append(msgs.getString("qos.grafico.titulo.promedio.ringeo"));
                    resultado.append("</div>");
                    resultado.append("</div>");
                }else{
                    resultado.append("<div class='malo' id='ringeo_ag' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>");
                    resultado.append("<img src='imagenes/ring.png' style=\"float:left;margin-right:10%\"> ");
                    resultado.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    resultado.append(segundosATiempoTheRial(rs1.getInt("promedio_ringeo")));
                    resultado.append("</div>");
                    resultado.append("<div style='font-size: 15px' id='t1' class='toolkit' >");
                    resultado.append(msgs.getString("qos.grafico.titulo.promedio.ringeo"));
                    resultado.append("</div>");
                    resultado.append("</div>");
                }
                if(rs1.getInt("promedio_llamada")>=promedioIdeal[1]){
                    resultado.append("<div class='ok' id='contesto_ag' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>");
                    resultado.append("<img src='imagenes/call.png' style=\"float:left;margin-right:10%\"> ");
                    resultado.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    resultado.append(segundosATiempoTheRial(rs1.getInt("promedio_llamada")));
                    resultado.append("</div>");
                    resultado.append("<div style='font-size: 15px' id='t1' class='toolkit' >");
                    resultado.append(msgs.getString("qos.grafico.titulo.promedio.hablado"));
                    resultado.append("</div>");
                    resultado.append("</div>");
                }else{
                    resultado.append("<div class='malo' id='contesto_ag' onmouseover='mostrarToolKit(this)' onmouseout='ocultarToolKit(this)'>");
                    resultado.append("<img src='imagenes/call.png' style=\"float:left;margin-right:10%\"> ");
                    resultado.append("<div class=\"texto\" style=\"margin: 0px; width: 60%;float:left\">");
                    resultado.append(segundosATiempoTheRial(rs1.getInt("promedio_llamada")));
                    resultado.append("</div>");
                    resultado.append("<div style='font-size: 15px' id='t1' class='toolkit' >");
                    resultado.append(msgs.getString("qos.grafico.titulo.promedio.hablado"));
                    resultado.append("</div>");
                    resultado.append("</div>");
                }
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return resultado.toString();
        }
    
    private static String getCampo(Connection con,String piloto) {
        String query = "select ruteo from pilotos where piloto = ?;";
        try {
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setString(1, piloto);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                switch(rs1.getInt("ruteo")){
                    case 0:
                        return "ultimo_uso";
                    case 1:
                        return "posicion";
                    case 2:
                        return "posicion";
                    case 3:
                        return "anexo";
                }
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return "id";
    }

    private static int getRendimiento(String datosSecretaria, String piloto,int recibidas,int perdidas) {
        int porcentaje = 0;
        try{
            int total = recibidas+perdidas; 
            porcentaje = (recibidas*100)/total;
        }
        catch(Exception e){
            return 0;
        }
       return porcentaje;
    }

    private static int getPorcentajeIdeal(Connection con) {
            
        int i = 0;
        try {
            String consulta = "select promedio_rendimiento from promedio_conf";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                i = rs.getInt("promedio_rendimiento");
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return i;
    }
    
    public static int totalAgentes(Connection con,String routePoint){
        int i = 0;
        try {
            String consulta = "select count(anexo) as total from secretaria where piloto_asociado = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1,routePoint);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                i = rs.getInt("total");
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return i;
    }
    
    public static int listarCola(Connection con,String piloto){
        try {
            String consulta = "select cantidad from cola where piloto = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                return rs1.getInt("cantidad");
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public static int listarCola(String piloto) throws SQLException{
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select cantidad from cola where piloto = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                return rs1.getInt("cantidad");
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            con.close();
        }
        return 0;
    }
    
    public static int accionAgente(String anexo){
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            int estadoActual = getEstadoActual(con,anexo);
            if(estadoActual==0){
                estadoActual = 1;
            }
            else if(estadoActual==1){
                estadoActual = 0;
            }
            else if(estadoActual==2){
                estadoActual = 2;
            }
            String consulta = "update secretaria set estado = ? where anexo = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setInt(1, estadoActual);
            ps1.setString(2, anexo);
            ps1.executeUpdate();
            ps1.close();
            return estadoActual;
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
        return -1;
    }
    private static void loguerBD(Connection con,String usuario){
        try {
            String consulta = "UPDATE sesion SET es_logueado = 1 where usuario = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, usuario);
            ps1.executeUpdate();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    private static void desloguerBD(Connection con,String usuario){
        try {
            String consulta = "UPDATE sesion SET es_logueado = 0 where usuario = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, usuario);
            ps1.executeUpdate();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    private static int getEstadoActual(Connection con, String anexo) {
        try {
            String consulta = "select estado from secretaria where anexo = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                return rs1.getInt("estado");
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return -1;
    }
    public static boolean noEstaLogueado(Connection con, String usuario) {
        try {
            String consulta = "select es_logueado from sesion where usuario = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, usuario);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                if(rs1.getInt("es_logueado")==1){
                    return false;
                }
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return true;
    }    
    public static String eliminarAgentesInnesesarios(String listaAgentesDisponibles, String piloto) {
        String[] checks = listaAgentesDisponibles.split("<br>");
        String   checksFiltrados = "";
        boolean sinAgentes = true;
        try {
            List<String> lista = ComboQuery.listaSecretaria2(piloto);
            
            for(String anexo : lista){
                sinAgentes = false;
                for(int i = 0 ; i < checks.length ; i ++){
                    String check = checks[i];
                    if(check.contains(anexo)){
                        checks[i] = "";
                        checksFiltrados += checks[i];
                    }
                    else{
                        checks[i] = "";
                        checksFiltrados += checks[i];
                    }
                    
                }
            }
            if(sinAgentes){
                for(int i = 0 ; i < checks.length ; i ++){
                    checks[i] = "";
                    checksFiltrados += checks[i];
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return checksFiltrados;
    }
    
    public static String generarMenu(Connection con,int id){
        StringBuilder menu = new StringBuilder();
        try{
            List<String> pilotos = ComboQuery.listaPilotosXSupervisor2(con,id);
            if(!pilotos.isEmpty()){
                menu.append("<ul id='arbol'><li><a href='#dashboard' id='mostrarPilotos' ><div class=\"fa fa-plus\"></div>&nbsp;Contact Center</a>");
            }
            else{
                menu.append("<ul id='arbol'><li><a href='#' id='mostrarMensaje' ><div class=\"fa fa-plus\"></div>&nbsp;Contact Center</a>");                
            }
            for(String piloto : pilotos){
                List<String> agentes = ComboQuery.listaSecretariaMasNombre(con, piloto.split(" - ")[0]);
                menu.append("<ul>");
                menu.append("<li>");
                menu.append("<a href='#dashboard' class=\"fa fa-plus\" onclick='mostrarAgentes2("+piloto.split(" - ")[0]+")'>&nbsp;");
                menu.append(piloto);
                menu.append("</a></li>");
                menu.append("<ul>");
                for(String agente : agentes){
                    menu.append("<li><a href='#dashboard' class='agentes"+piloto.split(" - ")[0]+"' onclick=\"mostrarDatosAgente('"+agente.split(" - ")[0]+"')\" style='display:none;'>");
                    menu.append(agente);
                    menu.append("</a></li>");
                }
                menu.append("</ul>");
                menu.append("</ul>");
            }
            menu.append("</ul><script>mostrarOpciones();</script>");
            pilotos = null;
        }
        catch(Exception e){
            e.printStackTrace();
        }
       return menu.toString();
    }
    public static String generarMenu(Connection con){
        StringBuilder menu = new StringBuilder();
        try{
            List<String> pilotos = ComboQuery.listaPilotos3(con);
            menu.append("<ul id='arbol'><li><a href='#dashboard' id='mostrarPilotos' ><div class=\"fa fa-plus\"></div>&nbsp;Contact Center</a>");
            for(String piloto : pilotos){
                List<String> agentes = ComboQuery.listaSecretariaMasNombre(con, piloto.split(" - ")[0]);
                menu.append("<ul>");
                menu.append("<li>");
                menu.append("<a href='#dashboard' class=\"fa fa-plus\" onclick='mostrarAgentes2("+piloto.split(" - ")[0]+")'>&nbsp;");
                menu.append(piloto);
                menu.append("</a></li>");
                menu.append("<ul>");
                for(String agente : agentes){
                    menu.append("<li><a href='#dashboard' class='agentes"+piloto.split(" - ")[0]+"' onclick=\"mostrarDatosAgente('"+agente.split(" - ")[0]+"')\" style='display:none;'>");
                    menu.append(agente);
                    menu.append("</a></li>");
                }
                menu.append("</ul>");
                menu.append("</ul>");
            }
            menu.append("</ul><script>mostrarOpciones();</script>");
            pilotos = null;
        }
        catch(Exception e){
            e.printStackTrace();
        }
       return menu.toString();
    }

    
    public static int duracionTotalllamadas(Connection con,String anexo,int lapso){
        int duracion = 0;
        try {
            String consulta = null;
            if(lapso == 0){
                consulta = "select sum(duracion_llamada) as suma from estadistica where anexo = ? and ringeo >= '"+getFecha(true)+"' and ringeo <='"+getFecha(false)+"'";
            }
            else if(lapso == 1){
                consulta = "select sum(duracion_llamada) as suma from estadistica where anexo = ? and ringeo >= '"+getFechaSemanal(true)+"' and ringeo <='"+getFechaSemanal(false)+"'";
            }
            else if(lapso == 2){
                consulta = "select sum(duracion_llamada) as suma from estadistica where anexo = ? and ringeo >= '"+getFechaMensual(true)+"' and ringeo <='"+getFechaMensual(false)+"'";
            }
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                duracion =  rs1.getInt("suma");
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return duracion;
    }
    
    public static String getTablaEstadisticasPool(Connection con,ResourceBundle msgs,List<String> pilotos,int lapso){
        StringBuilder tabla = new StringBuilder();
        try{
            tabla.append("<table id=\"tabla_exp_excel\">");
//            tabla.append("<table>");
            tabla.append("<tr><th>");
            tabla.append(msgs.getString("qos.piloto"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.contestada"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.perdida"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.tiempo.espera"));
            tabla.append("</th></tr>");
            for(String piloto : pilotos){
                int[] promedios = promedioPool(con,piloto.split(" - ")[0],lapso);
                tabla.append("<tr><td>");
                tabla.append(piloto);
                tabla.append("</td><td>");
                tabla.append(contarTotalTipoDeLlamadas(con, piloto.split(" - ")[0], 1, lapso));
                tabla.append("</td><td>");
                tabla.append(contarTotalTipoDeLlamadas(con, piloto.split(" - ")[0], 0, lapso));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[0]));
                tabla.append("</td></tr>");
            }
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        tabla.append("</table>");
        return tabla.toString();
    }


    public static Map<String,Object[]> tiemposAgente(Connection con,int lapso){
        Map<String,Object[]> tiempos = new HashMap();
        try{
            String consulta = "";
            if(lapso == 0){
                consulta = "select sum(tiempo_activo) as activo,sum(tiempo_inactivo) as inactivo,numero_agente,piloto_asociado from tiempo_agente join secretaria on numero_agente = anexo where fecha >= '"+getFecha(true)+"' and fecha <= '"+getFecha(false)+"' group BY numero_agente,piloto_asociado" ;
            }
            else if(lapso == 1){
                consulta = "select sum(tiempo_activo) as activo,sum(tiempo_inactivo) as inactivo,numero_agente,piloto_asociado from tiempo_agente join secretaria on numero_agente = anexo where fecha >= '"+getFechaSemanal(true)+"' and fecha <= '"+getFechaSemanal(false)+"' group BY numero_agente,piloto_asociado" ;
            }
            else if(lapso == 2){
                consulta = "select sum(tiempo_activo) as activo,sum(tiempo_inactivo) as inactivo,numero_agente,piloto_asociado from tiempo_agente join secretaria on numero_agente = anexo where fecha >= '"+getFechaMensual(true)+"' and fecha <= '"+getFechaMensual(false)+"' group BY numero_agente,piloto_asociado" ;
            }
            PreparedStatement ps = con.prepareStatement(consulta);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                tiempos.put(rs.getString("numero_agente"), new Object[]{rs.getString("piloto_asociado"),rs.getInt("activo"),rs.getInt("inactivo")});
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return tiempos;
    }
    
public static String getTablaEstadisticasAgente(Connection con,ResourceBundle msgs,List<String> secretarias,int lapso){
        StringBuilder tabla = new StringBuilder();
        try{
            tabla.append("<table id=\"tabla_exp_excel\">");
//            tabla.append("<table>");
            tabla.append("<tr><th>");
            tabla.append(msgs.getString("qos.agentes"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.contestada"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.perdida"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.ringeo"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.promedio"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.duracion"));
            tabla.append("</th>");
            tabla.append("</tr>");
            Map<String,Object[]> mapa = tiemposAgente(con,lapso);
            for(String secretaria : secretarias){
                Object[] tiempos = mapa.get(secretaria);
                int[] promedios = promedios(con, secretaria,lapso);
                tabla.append("<tr><td>");
                tabla.append(secretaria);
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, secretaria, 1, lapso));
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, secretaria, 0, lapso));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[0])); 
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[1]));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(duracionTotalllamadas(con, secretaria, lapso)));
                tabla.append("</td>");
                tabla.append("</tr>");
            }
            tabla.append("</table>");
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return tabla.toString();
    }

    

    public static String getTablaEstadisticasAgenteXPiloto(Connection con,ResourceBundle msgs,List<String> secretarias,int lapso){
        StringBuilder tabla = new StringBuilder();
        try{
            tabla.append("<table id=\"tabla_exp_excel\">");
//            tabla.append("<table>");
            tabla.append("<tr><th>");
            tabla.append(msgs.getString("qos.agentes"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.contestada"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.perdida"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.ringeo"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.promedio"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.duracion"));
            tabla.append("</th>");
            tabla.append("</th>");
            tabla.append("</tr>");
            Map<String,Object[]> mapa = tiemposAgente(con,lapso);
            for(String secretaria : secretarias){
                Object[] tiempos = mapa.get(secretaria);
                int[] promedios = promedios(con, secretaria,lapso);
                tabla.append("<tr><td>");
                tabla.append(secretaria);
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, secretaria, 1, lapso));
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, secretaria, 0,lapso));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[0]));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[1]));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(duracionTotalllamadas(con, secretaria, lapso)));
                tabla.append("</td>");
                tabla.append("</tr>");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        tabla.append("</table>");
        return tabla.toString();
    }
    public static void logIn(Connection con,String usuario){
        String anexo = "";
        String piloto = "";
        String consulta = "select anexo,piloto_asociado from sesion join sesion_secretaria ss on sesion.id = id_sesion join secretaria on ss.id_secretaria = secretaria.id where usuario = ?";
        try{
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, usuario);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                anexo = rs1.getString("anexo");
                piloto = rs1.getString("piloto_asociado");
                accionAgente(anexo);
                loguerBD(con, usuario);
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        AgenteSocket agente = new AgenteSocket(anexo,piloto,0);
    }
    public static void logOut(Connection con,String usuario){
        String anexo = "";
        String piloto ="";
        String consulta = "select anexo,piloto_asociado from sesion join sesion_secretaria ss on sesion.id = id_sesion join secretaria on ss.id_secretaria = secretaria.id where usuario = ?";
        try{
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, usuario);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                anexo = rs1.getString("anexo");
                piloto = rs1.getString("piloto_asociado");
                accionAgente(anexo);
                desloguerBD(con, usuario);
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        AgenteSocket agente = new AgenteSocket(anexo,piloto,1);
    }
    public static String segundosATiempoTheRial(int segundos){
        int hours = ((int)Math.floor( segundos / 3600 ));  
        String minutes = (int) Math.floor( (segundos % 3600) / 60 ) + "";
        String seconds = segundos % 60 + "";
        minutes = minutes.length()==1 ? "0" + minutes : minutes;
        seconds = seconds.length()==1 ? "0" + seconds : seconds;
        return hours + ":" + minutes + ":" + seconds;

    }

    public static String obtenerPilotoXAnexo(String anexo) throws SQLException {
        Connection con = null;
        String consulta = "select piloto_asociado from secretaria where anexo = ?";
        try{
            con = SQLConexion.conectar();
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                return rs1.getString("piloto_asociado");
            }
            rs1.close();
            ps1.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }finally{
            con.close();
        }
        return "";
    }
        public static String getFechaMensual(boolean actual){
        Calendar c = new GregorianCalendar();
        if(actual){
            return "01-"+Integer.parseInt(c.get(Calendar.MONTH)+1+"")+"-"+c.get(Calendar.YEAR);
        }else{
            if((c.get(Calendar.MONTH)+1)==12){
                return "01-01-"+(c.get(Calendar.YEAR)+1);
            }
            else{
                return "01-"+Integer.parseInt(c.get(Calendar.MONTH)+2+"")+"-"+c.get(Calendar.YEAR);                    
            }
        }
    }
    public static String getFechaSemanal(boolean actual){
        Calendar c = new GregorianCalendar();
        int dia = c.get(Calendar.DAY_OF_WEEK);
        if(actual){
            switch(dia){
                case Calendar.SUNDAY:   
                    c.add(Calendar.DAY_OF_YEAR, -6);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-6)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.MONDAY:
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.TUESDAY:
                    c.add(Calendar.DAY_OF_YEAR, -1);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-1)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.WEDNESDAY:
                    c.add(Calendar.DAY_OF_YEAR, -2);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-2)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.THURSDAY:
                    c.add(Calendar.DAY_OF_YEAR, -3);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-3)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.FRIDAY:
                    c.add(Calendar.DAY_OF_YEAR, -4);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-4)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.SATURDAY:
                    c.add(Calendar.DAY_OF_YEAR, -5);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)-5)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
            }
        }
        else{
            switch(dia){
                case Calendar.SUNDAY:   
                    return (c.get(Calendar.DATE))+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.MONDAY:
                    c.add(Calendar.DAY_OF_YEAR, 6);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+6)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.TUESDAY:
                    c.add(Calendar.DAY_OF_YEAR, 5);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+5)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.WEDNESDAY:
                    c.add(Calendar.DAY_OF_YEAR, 4);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+4)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.THURSDAY:
                    c.add(Calendar.DAY_OF_YEAR, 3);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+3)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.FRIDAY:
                    c.add(Calendar.DAY_OF_YEAR, 2);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+2)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                case Calendar.SATURDAY:
                    c.add(Calendar.DAY_OF_YEAR, 1);
                    return c.get(Calendar.DATE)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
                    //return (c.get(Calendar.DATE)+1)+"-"+(c.get(Calendar.MONTH)+1)+"-"+c.get(Calendar.YEAR);
            }
        }
        return "";
    }

    public static String getFecha(boolean actual){
        Calendar c = new GregorianCalendar();
        if(actual){
            return (c.get(Calendar.DATE))+"-"+Integer.parseInt(c.get(Calendar.MONTH)+1+"")+"-"+c.get(Calendar.YEAR);
        }
        else{
            c.add(Calendar.DAY_OF_YEAR, 1);
            return c.get(Calendar.DATE)+"-"+Integer.parseInt(c.get(Calendar.MONTH)+1+"")+"-"+c.get(Calendar.YEAR);
        }
    }

    public static String getRankingAgentes(Connection con, int tipo, int lapso) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public static String getRankingAgentesXPool(Connection con, int tipo, int lapso) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    public static String getRankingPool(Connection con,int tipo, int lapso) {
        StringBuilder datos = new StringBuilder();
        try{
            List<String> pilotos = ComboQuery.listaPilotos(con);
            switch(tipo){
                case 0:
                    return obtenerLlamadasPool(con, pilotos, 0, lapso);
                case 1:
                    return obtenerLlamadasPool(con, pilotos, 1, lapso);
                case 2:
                    return obtenerTiempoEspera(con, pilotos, lapso);
                case 3:
                    
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return datos.toString();
    }
    private static Map<String,int[]> obtenertiempoPool(Connection con,List<String> pilotos,int lapso) {
        Map<String,int[]> puntos = new HashMap();
        for(String piloto : pilotos){
            try{
                int[] porcentaje = promedioPool(con, piloto, lapso);
                puntos.put(piloto, porcentaje);
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return puntos;
    }
    private static Map<String,int[]> obtenerActivoPool(Connection con,List<String> pilotos,int lapso) {
        Map<String,int[]> puntos = new HashMap();
        for(String piloto : pilotos){
            try{
                int[] porcentaje = promedioPool(con, piloto, lapso);
                puntos.put(piloto, porcentaje);
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return puntos;
    }
    private static String obtenerLlamadasPool(Connection con,List<String> pilotos,int tipo,int lapso) {
        StringBuilder datos = new StringBuilder();
        for(String piloto : pilotos){
            try{
                datos.append("piloto: "+piloto+" - Llamadas Perdidas:"+obtenerLlamadasPerdidasXPool(con, piloto,tipo, lapso));
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return datos.toString();
    }
    private static Map<String,int[]> obtenerTiempoActivo(Connection con,List<String> pilotos,int lapso) {
        Map<String,int[]> puntos = new HashMap();
        for(String piloto : pilotos){
            try{
                int activo = consultaTiempoActividadPiloto(con, piloto, lapso,0);
                int inactivo = consultaTiempoActividadPiloto(con, piloto, lapso,1);
                int total = activo+inactivo;
                int[] mierda = new int[2];
                if(total == 0){
                    mierda[0] = 0;
                    mierda[1] = 0;
                    puntos.put(piloto, mierda);
                }
                else{
                   mierda[0] = (activo*100)/total;
                   mierda[1] = (inactivo*100)/total;
                   puntos.put(piloto, mierda);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return puntos;
    }
    private static String obtenerTiempoEspera(Connection con,List<String> pilotos,int lapso) {
        StringBuilder datos = new StringBuilder();
        for(String piloto : pilotos){
            try{
                datos.append("piloto: "+piloto+" tiempo espera:"+promedios(con, piloto, lapso)[0]);
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return datos.toString();
    }
 private static int consultaTiempoActividadPiloto(Connection con,String piloto,int lapso,int op){
        PreparedStatement ps = null;
        ResultSet rs = null;
        String consulta = null;
        if(op == 0){
            if(lapso == 0){
                consulta = "select sum(tiempo_activo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFecha(true)+"' and fecha <= '"+getFecha(false)+"'";
            }
            else if(lapso == 1){
                consulta = "select sum(tiempo_activo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFechaSemanal(true)+"' and fecha <= '"+getFechaSemanal(false)+"'";
            }
            else if(lapso == 2){
                consulta = "select sum(tiempo_activo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFechaMensual(true)+"' and fecha <= '"+getFechaMensual(false)+"'";
            }
        }
        else{
            if(lapso == 0){
                consulta = "select sum(tiempo_inactivo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFecha(true)+"' and fecha <= '"+getFecha(false)+"'";
            }
            else if(lapso == 1){
                consulta = "select sum(tiempo_inactivo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFechaSemanal(true)+"' and fecha <= '"+getFechaSemanal(false)+"'";
            }
            else if(lapso == 2){
                consulta = "select sum(tiempo_inactivo) as tiempo from tiempo_agente  where piloto = ? and  fecha > '"+getFechaMensual(true)+"' and fecha <= '"+getFechaMensual(false)+"'";
            }
        }
        try{
            ps = con.prepareStatement(consulta);
            ps.setString(1, piloto);
            rs = ps.executeQuery();
            while(rs.next()){
                return rs.getInt("tiempo");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    private static int obtenerLlamadasPerdidasXPool(Connection con, String piloto,int op, int lapso) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        String consulta = null;
        if(op == 0){
            if(lapso == 0){
                consulta = "select count(*) as total from estadistica where estado =0 and pool = ? and ringeo > '"+getFecha(true)+"' and ringeo <= '"+getFecha(false)+"'";
            }
            else if(lapso == 1){
                consulta = "select count(*) as total from estadistica where estado =0 and pool = ? and ringeo > '"+getFechaSemanal(true)+"' and ringeo <= '"+getFechaSemanal(false)+"'";
            }
            else if(lapso == 2){
                consulta = "select count(*) as total from estadistica where estado =0 and pool = ? and ringeo > '"+getFechaMensual(true)+"' and ringeo <= '"+getFechaMensual(false)+"'";
            }
        }
        else{
            if(lapso == 0){
                consulta = "select count(*) as total from estadistica where estado =1 and pool = ? and ringeo > '"+getFechaMensual(true)+"' and ringeo <= '"+getFecha(false)+"'";
            }
            else if(lapso == 1){
                consulta = "select count(*) as total from estadistica where estado =1 and pool = ? and ringeo > '"+getFechaMensual(true)+"' and ringeo <= '"+getFecha(false)+"'";
            }
            else if(lapso == 2){
                consulta = "select count(*) as total from estadistica where estado =1 and pool = ? and ringeo > '"+getFechaMensual(true)+"' and ringeo <= '"+getFecha(false)+"'";
            }
        }
        try{
            ps = con.prepareStatement(consulta);
            ps.setString(1, piloto);
            rs = ps.executeQuery();
            while(rs.next()){
                return rs.getInt("total");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }
    public static String getTablaEstadisticasAgenteUnico(Connection con,ResourceBundle msgs, String anexo, int lapso){
        StringBuilder tabla = new StringBuilder();
        try{
            tabla.append("<table id=\"tabla_exp_excel\">");
//            tabla.append("<table>");
            tabla.append("<tr><th>");
            tabla.append(msgs.getString("qos.agentes"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.contestada"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.perdida"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.ringeo"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.promedio"));
            tabla.append("</th><th>");
            tabla.append(msgs.getString("qos.llamada.duracion"));
            tabla.append("</th>");
            //tabla.append("<td>");
//            tabla.append(msgs.getString("qos.tiempo.total"));
//            tabla.append("</th><th>");
//            tabla.append(msgs.getString("qos.tiempo.activo"));
//            tabla.append("</th><th>");
//            tabla.append(msgs.getString("qos.tiempo.inactivo"));
            //tabla.append("</td>");
            tabla.append("</tr>");
            Map<String,Object[]> mapa = tiemposAgente(con,lapso);
                Object[] tiempos = mapa.get(anexo);
                int[] promedios = promedios(con, anexo,lapso);
                tabla.append("<tr><td>");
                tabla.append(anexo);
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, anexo, 1, lapso));
                tabla.append("</td><td>");
                tabla.append(contarTipoDeLlamadas(con, anexo, 0, lapso));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[0])); 
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(promedios[1]));
                tabla.append("</td><td>");
                tabla.append(segundosATiempoTheRial(duracionTotalllamadas(con, anexo, lapso)));
                tabla.append("</td>");
//                tabla.append("<td>");
//                int tiempo1 = 0;
//                int tiempo2 = 0;
//                try{
//                    tiempo1 = Integer.parseInt((tiempos[1]==null?"0":tiempos[1]).toString());
//                    tiempo2 = Integer.parseInt((tiempos[2]==null?"0":tiempos[2]).toString());
//                }
//                catch(Exception e){
//                    tiempo1 = 0;
//                    tiempo2 = 0;
//                }
//                tabla.append(segundosATiempoTheRial(tiempo1+tiempo2));
//                tabla.append("</td><td>");
//                
//                tabla.append(segundosATiempoTheRial(tiempo1));
//                tabla.append("</td><td>");
//                tabla.append(segundosATiempoTheRial(tiempo2));
//                tabla.append("</td>");
                tabla.append("</tr>");
            tabla.append("</table>");
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return tabla.toString();
    }
}
