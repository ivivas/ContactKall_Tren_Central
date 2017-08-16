/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import query.IvrEncuestaQry;

/**
 *
 * @author Ricardo Fuentes
 */
@WebServlet(name = "GraficoEncuesta", urlPatterns = {"/GraficoEncuesta"})
public class GraficoEncuesta extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    static { /* too late ! */
      System.setProperty("java.awt.headless", "true");
      System.out.println(java.awt.GraphicsEnvironment.isHeadless());
      /* ---> prints false */
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("image/png");
        HttpSession sesion = request.getSession();
        
        ResourceBundle msgs;
        if(sesion.getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }
        else{
            msgs = (ResourceBundle) sesion.getAttribute("msgs");
        }
        
        String desde = (String) sesion.getAttribute("desde");
        String hasta = (String) sesion.getAttribute("hasta");
        String anexo = (String) sesion.getAttribute("anexo");
        String piloto = (String) sesion.getAttribute("piloto");
        String pregunta = (String) sesion.getAttribute("pregunta");
        DefaultCategoryDataset datos = new DefaultCategoryDataset();
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
                con1 = SQLConexion.conectar();
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

                    for(int n : lista){
                        PreparedStatement ps1 = con.prepareStatement(qry);
                        ps1.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                        ps1.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                        //ps1.setString(3,anexo);
                        ps1.setInt(3, n);
                        ResultSet rs1 = ps1.executeQuery();
                        Map<Integer,Integer> mapaResp = new HashMap();
                        while(rs1.next()){
                            mapaResp.put(rs1.getInt("respuesta_encuesta"), rs1.getInt("cantidad"));
                        }
                        mapa_preguntas.put(n, mapaResp);
                    }

                    for(int n : lista){
                        //este devuelve los totales de respuestas de la pregunta x
                        Map<Integer,Integer> mapa = mapa_preguntas.get(n);
                        for(int i = min; i<= max ; i++){
                            if(mapa.containsKey(i)){
                                datos.addValue(mapa.get(i), msgs.getString("encusta.tbl2.preg")+": "+n, i+"");
                                //System.out.println("pregunta: "+n+" valor: "+mapa.get(i)+" nota: "+i);
                            }else{
                                datos.addValue(0, msgs.getString("encusta.tbl2.preg")+": "+n, i+"");
                                //System.out.println("pregunta: "+n+" valor: 0 nota: "+i);
                            }
                        }
                    }
                }else{
                    PreparedStatement ps1 = con.prepareStatement(qry);
                    ps1.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                    ps1.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                    ps1.setInt(3, Integer.parseInt(pregunta.trim()));
                    ResultSet rs1 = ps1.executeQuery();
                    Map<Integer,Integer> mapaResp = new HashMap();
                    while(rs1.next()){
                        mapaResp.put(rs1.getInt("respuesta_encuesta"), rs1.getInt("cantidad"));
                    }
                    for(int i = min; i<= max ; i++){
                        if(mapaResp.containsKey(i)){
                            datos.addValue(mapaResp.get(i), msgs.getString("encusta.tbl2.preg")+": "+pregunta, i+"");
                        }else{
                            datos.addValue(0, msgs.getString("encusta.tbl2.preg")+": "+pregunta, i+"");
                        }
                    }
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
        
        JFreeChart chart = ChartFactory.createLineChart(msgs.getString("tag.encuesta.grafico.title"),
                msgs.getString("tag.encuesta.grafico.nota"),
                msgs.getString("tag.encuesta.grafico.cant"),
                datos,PlotOrientation.VERTICAL,true, true, false);
        //chart = new JFreeChart();
        OutputStream out = response.getOutputStream();
        ChartUtilities.writeChartAsPNG(out, chart, 700, 250);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
