package query;

import adportas.SQLConexion;
import java.io.File;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import org.jfree.chart.*;
import org.jfree.data.general.DefaultPieDataset;

public class Grafico {
    public static int GRAFICO_LLAMADAS = 0;
    public static int GRAFICO_ESTADISTICA = 1;
    public static JFreeChart creaGraficoTorta(String piloto,int tipoLlamada,String fechaDesde, String fechaHasta,int tipoGrafico){
        Collection resultado;
        double suma = 0;
        JFreeChart chart = null;
        String res = null;
        String anexo = null;        
        int total = 0;
        if(tipoGrafico==GRAFICO_LLAMADAS){
            try{
                resultado = consultaEstadisticaLlamadas(tipoLlamada,piloto,fechaDesde, fechaHasta);
                Iterator it = resultado.iterator();
                DefaultPieDataset pieDataset = new DefaultPieDataset();
                int cantidad = 0;
                while(it.hasNext()){
                    res =  (String) it.next();
                    anexo = res.split("-")[0];
                    cantidad = Integer.parseInt(res.split("-")[1]);
                    total = Integer.parseInt(res.split("-")[2]);
                    double porcentaje = ((double)cantidad/total)*100;
                    porcentaje = truncateDecimal(porcentaje,2).doubleValue();
                    String etiqueta = "Anexo: "+anexo+"\nLlam. : "+cantidad+"\n"+porcentaje+" %";
                    suma+=porcentaje;
                    if(suma<=100){
                        pieDataset.setValue(etiqueta,porcentaje);
                    }else{
                       System.out.println("error porcentaje mas de 100*************");
                       break;
                    }
                }
                chart = ChartFactory.createPieChart(null, pieDataset, false, false, false);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        else if(tipoGrafico==GRAFICO_ESTADISTICA){
            try{
                resultado = consultaEstadistica(tipoLlamada,piloto,fechaDesde, fechaHasta);
                Iterator it = resultado.iterator();
                DefaultPieDataset pieDataset = new DefaultPieDataset();
                int cantidad = 0;
                while(it.hasNext()){
                    res =  (String) it.next();
                    anexo = res.split("-")[0];
                    cantidad = Integer.parseInt(res.split("-")[1]);
                    total = Integer.parseInt(res.split("-")[2]);
                    double porcentaje = ((double)cantidad/total)*100;
                    porcentaje = truncateDecimal(porcentaje,2).doubleValue();
                    String etiqueta = "Anexo: "+anexo+"\nSeg.. : "+cantidad+"\nProm. "+porcentaje+" %";
                    suma+=porcentaje;
                    if(suma<=100){
                        pieDataset.setValue(etiqueta,porcentaje);
                    }else{
                       System.out.println("error porcentaje mas de 100*************");
                       break;
                    }
                }
                chart = ChartFactory.createPieChart(null, pieDataset, false, false, false);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return chart;
    }
    private static Collection consultaEstadistica(int tipoLlamada,String piloto,String fechaDesde,String fechaHasta){
        Connection con = null;
        Collection col = new ArrayList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String consulta = null;
        String in = anexoParaIn(piloto);
        if(tipoLlamada==0){
            if(!in.equals("")){
                consulta = "select anexo,promedio_ringeo as promedio,(select sum(promedio_ringeo) as promedio from promedio where anexo in("+in+")) as total from promedio where anexo in("+in+") and fecha > '"+fechaDesde+"' and fecha <= '"+fechaHasta+"' group by anexo,promedio_ringeo";
            }
            else{
                consulta = "select anexo,promedio_ringeo as promedio,(select sum(promedio_ringeo) as promedio from promedio where anexo in('x')) as total from promedio where anexo in('x') and fecha > '"+fechaDesde+"' and fecha <= '"+fechaHasta+"' group by anexo,promedio_ringeo";            
            }
        }
        else{
            if(!in.equals("")){
                consulta = "select anexo,promedio_llamada as promedio,(select sum(promedio_llamada) from promedio where anexo in("+in+")) as total from promedio where anexo in("+in+") and fecha > '"+fechaDesde+"' and fecha <= '"+fechaHasta+"' group by anexo,promedio_llamada";        
            }
            else{
                consulta = "select anexo,promedio_llamada as promedio,(select sum(promedio_llamada) from promedio where anexo in('x')) as total from promedio where anexo in('x') and fecha > '"+fechaDesde+"' and fecha <= '"+fechaHasta+"' group by anexo,promedio_llamada";        
            }
        }
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement(consulta);
            rs = ps.executeQuery();
            while(rs.next()){
                col.add(rs.getString("anexo")+"-"+rs.getInt("promedio")+"-"+rs.getInt("total"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                ps.close();
                rs.close();
                con.close();
            }catch(Exception e){
            }
        }
        return col;
    }
    private static Collection consultaEstadisticaLlamadas(int tipoLlamada,String piloto,String fechaDesde,String fechaHasta){
        Connection con = null;
        Collection col = new ArrayList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String consulta = null;
        String in = anexoParaIn(piloto);
        if(!in.equals("")){
            consulta = "select anexo,count(*) as total,(select count(*) from estadistica where estado = 0 and corto > '"+fechaDesde+"' and corto <= '"+fechaHasta+"' and anexo in("+in+")) as totalreal from estadistica where anexo in("+in+") and estado = ?  and corto > '"+fechaDesde+"' and corto <= '"+fechaHasta+"' group by anexo";
        }
        else{
            consulta = "select anexo,count(*) as total,(select count(*) from estadistica where estado = 0 and corto > '"+fechaDesde+"' and corto <= '"+fechaHasta+"' and anexo in('x')) as totalreal from estadistica where anexo in('x') and estado = ?  and corto > '"+fechaDesde+"' and corto <= '"+fechaHasta+"' group by anexo";        
        }
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement(consulta);
            ps.setInt(1, tipoLlamada);
            rs = ps.executeQuery();
            while(rs.next()){
                col.add(rs.getString("anexo")+"-"+rs.getInt("total")+"-"+rs.getInt("totalreal"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                ps.close();
                rs.close();
                con.close();
            }catch(Exception e){
            }
        }
        return col;
    }

    private static String anexoParaIn(String piloto) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        StringBuilder anexos = new StringBuilder();
        String consulta = "select anexo from secretaria where piloto_asociado = ? ";
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement(consulta);
            ps.setString(1, piloto);
            rs = ps.executeQuery();
            while(rs.next()){
                anexos.append("'");
                anexos.append(rs.getString("anexo"));
                anexos.append("',");
            }
        }
        catch(Exception e){
             e.printStackTrace();
        }
        finally{
            try{
                con.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        try{
        return anexos.substring(0, anexos.length()-1);
        }
        catch(Exception e){
            e.printStackTrace();
            return "";
        }
    }
    private static BigDecimal truncateDecimal(double x, int cantDec){
        if(x>0){
            return new BigDecimal(String.valueOf(x)).setScale(cantDec,BigDecimal.ROUND_FLOOR);
        }else{
            return new BigDecimal(String.valueOf(x)).setScale(cantDec,BigDecimal.ROUND_CEILING);
        }
    }
    public static File reemplazar(File file){
        try{
            if(file.exists()){
            file.delete();
                file.createNewFile();
            }
            else{
                file.createNewFile();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return file;
    }
}
