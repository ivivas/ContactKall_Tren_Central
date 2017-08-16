/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package BO;

import DTO.Configuracion;
import DTO.EncuestaPreguntasDTO;
import adportas.SQLConexion;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import query.IvrEncuestaQry;

/**
 *
 * @author Jose
 */
public class GraficoBarraEncuesta {
    public static Map<Integer,Object> crearGraficoBarraEncuenta(String desde,String hasta,String anexo,String piloto,String pregunta){
            Map<Integer,Object> mapa = new HashMap();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        Date d_desde=null;
        Date d_hasta=null;
        int min = 0;
        int max = 0;
        boolean err = false;
        String anexosBusqueda="";
        
        try{
            sdf.parse(desde);
            d_desde = sdf2.parse(desde+" 00:00:00");
        }catch(Exception e){
            err = true;
        }
        try{
            sdf.parse(hasta);
            d_hasta = sdf2.parse(hasta+" 23:59:59");
        }catch(Exception e){
            err = true;
        }
        if(anexo.equals("-1")){
            Connection con1 = null;
            PreparedStatement ps1 = null;
            ResultSet rs1 = null;
            try{
                con1 = SQLConexion.conectaIVREncuesta("localhost", "AcdkallControl_contact", "postgres", "adp2016");
                ps1 = con1.prepareStatement("select anexo from secretaria where piloto_asociado = ? ");
                ps1.setString(1, piloto);
                rs1 = ps1.executeQuery();
                int cont = 0;
                while(rs1.next()){
                    if(cont>0){
                        anexosBusqueda+=",";
                    }
                    cont++;
                    anexosBusqueda+="'"+rs1.getString("anexo").trim()+"'";
                }
            }catch(Exception e){
                //System.out.println("Error buscando secretarias: "+e);
            }finally{
                try{
                    con1.close();
                    ps1.close();
                    rs1.close();
                }catch(Exception e){}
            }
        }else if(!anexo.equals("")){
            anexosBusqueda="'"+anexo+"'";
        }
        
        if(!err && !piloto.equals("")){
            IvrEncuestaQry ivr = new IvrEncuestaQry();
            min = ivr.getMinEncuesta();
            max = ivr.getMaxEncuesta();
            Configuracion conf = IvrEncuestaQry.getConfiguracion();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            ArrayList<Integer> lista = new ArrayList();
            Map<Integer,Map> mapa_preguntas = new HashMap();
            String qry = "select count(*) cantidad, respuesta_encuesta from head_encuesta h , encuesta e where h.callid_head = e.callid_encuesta "
                    + " and h.num_contraparte = e.contraparte_encuesta and fecha_registro_head >= ? and fecha_registro_head <= ? "
                    + " and pregunta_encuesta = ? "
                    //+ " and num_agente = ? "
                    + " and num_agente in ("+anexosBusqueda+") "
                    + " group by respuesta_encuesta order by respuesta_encuesta ";
            try{
                con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
     //           con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
                //System.out.println("pregunta: "+pregunta);
                if(pregunta.equals("-1")){
                    ps = con.prepareStatement("select distinct(pregunta_encuesta) from encuesta");
                    rs = ps.executeQuery();
                    while(rs.next()){
                        lista.add(rs.getInt(1));
                    }
                    Collections.sort(lista);
                    Map<Integer,Integer> mapa2 = null;
                    for(int n : lista){
                        PreparedStatement ps1 = con.prepareStatement(qry);
                        ps1.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                        ps1.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                        //ps1.setString(3,anexo);
                        ps1.setInt(3, n);
                        ResultSet rs1 = ps1.executeQuery();
                        mapa2 = new HashMap();
                        while(rs1.next()){
                            
                            mapa2.put(rs1.getInt("respuesta_encuesta"), rs1.getInt("cantidad"));
                        }
                        mapa.put(n, mapa2);
                    }
                    
                    /*
                    for(int n : lista){
                        //este devuelve los totales de respuestas de la pregunta x
                        Map<Integer,Integer> mapa = mapa_preguntas.get(n);
                        for(int i = min; i<= max ; i++){
                            if(mapa.containsKey(i)){
                                //datos.addValue(mapa.get(i), msgs.getString("encusta.tbl2.preg")+": "+n, i+"");
                                //System.out.println("pregunta: "+n+" valor: "+mapa.get(i)+" nota: "+i);
                            }else{
                                //datos.addValue(0, msgs.getString("encusta.tbl2.preg")+": "+n, i+"");
                                //System.out.println("pregunta: "+n+" valor: 0 nota: "+i);
                            }
                        }
                    }*/
                }else{
                    PreparedStatement ps1 = con.prepareStatement(qry);
                    ps1.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                    ps1.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                    ps1.setInt(3, Integer.parseInt(pregunta.trim()));
                    ResultSet rs1 = ps1.executeQuery();
                    while(rs1.next()){
                        mapa.put(rs1.getInt("respuesta_encuesta"), rs1.getInt("cantidad"));
                    }
                    /*
                    for(int i = min; i<= max ; i++){
                        if(mapaResp.containsKey(i)){
                            //datos.addValue(mapaResp.get(i), msgs.getString("encusta.tbl2.preg")+": "+pregunta, i+"");
                        }else{
                            //datos.addValue(0, msgs.getString("encusta.tbl2.preg")+": "+pregunta, i+"");
                        }
                    }
                            */
                }
            }catch(Exception e){
                System.out.println("Error en GraficoEncuesta: "+e);
            }finally{
                try{
                    con.close();
                    ps.close();
                    rs.close();
                }catch(Exception e){}
            }
        }
        
      return mapa;
    }
    
    public static void main(String[] args) {
        
        IvrEncuestaQry ivr = new IvrEncuestaQry();
        String lblGrafico = "";
        String plantillaGraficoAcumulado = "";
        String dataGrafico = "";
        String plantillaGrafico = "";
        boolean esMultiple = false;
        Map<Integer,Object> mapa = GraficoBarraEncuesta.crearGraficoBarraEncuenta("01-09-2016", "30-09-2016", "-1", "8510", "-1");
            for(Object llavaIdEnc : mapa.keySet()){
                lblGrafico = ivr.getMinEncuesta()+","+ivr.getMaxEncuesta();
                if(mapa.get(llavaIdEnc) instanceof Integer){
                    dataGrafico +=  llavaIdEnc+",";
                    dataGrafico = dataGrafico.substring(0,dataGrafico.length()-1);
                    plantillaGrafico = plantillaGrafico.replace("%valores_grafico%", dataGrafico);
                    //valorGrafico += llavaIdEnc+","
                }   
                else if(mapa.get(llavaIdEnc) instanceof Map){
                    esMultiple = true;
                    lblGrafico = ivr.getMinEncuesta()+","+ivr.getMaxEncuesta() +",3,4";
                    for(Object llavaIdEnc2 : mapa.keySet()){
                        Map mapax = (Map) mapa.get(llavaIdEnc2);
                        for(Object dato : mapax.keySet()){
                            dataGrafico += (Map)mapax.get(dato)+",";
                            dataGrafico = dataGrafico.substring(0,dataGrafico.length()-1);
                            plantillaGrafico = plantillaGrafico.replace("%valores_grafico%", dataGrafico);
                        }
                        plantillaGraficoAcumulado += plantillaGrafico + ",";
                    }
                    
                }
            }
    }
    public static String[] getColores(){
        String[] arrayColores = new String[4];
        arrayColores[0] = "red";
        arrayColores[1] = "green";
        arrayColores[2] = "yellow";
        arrayColores[3] = "blue";
        
        return arrayColores;
        
    }
}
