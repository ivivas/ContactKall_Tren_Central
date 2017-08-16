/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Configuracion;
import adportas.Postgres;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import query.Ivr;

/**
 *
 * @author Ricardo
 */
public class GraficoEstadisticaIVR extends HttpServlet {

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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //response.setContentType("text/html;charset=UTF-8");
        response.setContentType("image/png");
        HttpSession sesion = request.getSession();
        
        String fechaDesde = (String) sesion.getAttribute("fechaDesde") + " 00:00:00";
        String fechaHasta = (String) sesion.getAttribute("fechaHasta") + " 23:59:59";
        //String fechaDesde = request.getParameter("fechaDesde");
        //String fechaHasta = request.getParameter("fechaHasta");
        
        JFreeChart chart = null;
        try {
            chart = creaGrafico(fechaDesde,fechaHasta);
            OutputStream out = response.getOutputStream();
            ChartUtilities.writeChartAsPNG(out, chart, 725, 600);
        }catch(Exception e) {
            System.out.println("Error en GraficoEstadisticaIVR: "+e);
        }
    }
    
    private JFreeChart creaGrafico(String fechaDesde, String fechaHasta){
        JFreeChart chart = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        double suma=0;
        String qry = "select id_accion, boton_accion,  e.tipo_accion, nivel_subrutina,nombre_subrutina, count(*), "
                + " (select count(*) from estadistica e, head_estadistica  h, acciones_subrutina a "
                + " where id_header != 0 and e.fecha > '"+fechaDesde+"' "
                + " and e.fecha <= '"+fechaHasta+"' and h.id = e.id_header and a.id = e.id_accion) "
                + " ,(select descripcion from acciones_subrutina where id = id_accion) "
                + " from estadistica e, head_estadistica  h, acciones_subrutina a where id_header != 0 "
                + " and h.id = e.id_header and a.id = e.id_accion and e.fecha > '"+fechaDesde+"' "
                + " and e.fecha <= '"+fechaHasta+"' "
                + " group by id_accion, boton_accion,  e.tipo_accion ,nivel_subrutina, nombre_subrutina  order by 5,2 ";
        
        //System.out.println("qry");
        try{
            DefaultPieDataset pieDataset = new DefaultPieDataset();
            Configuracion confIVR = Ivr.configuracionIVR();
            con = Postgres.conectar(confIVR.getIpServidor(), confIVR.getBaseDatos(), confIVR.getUsuarioBD(), confIVR.getClaveBD());
            ps = con.prepareStatement(qry);
            rs = ps.executeQuery();
            while(rs.next()){
                double perc = ((double)rs.getInt(6)/rs.getInt(7))*100;
                perc = truncateDecimal(perc,2).doubleValue();
                String etiqueta = rs.getString(8)+"("+rs.getString(2)+")\n Llamadas: "+rs.getInt(6)+" ("+perc+"%)";
                suma += perc;
                if(suma <= 100){
                    pieDataset.setValue(etiqueta,perc);
                }
            }
            chart = ChartFactory.createPieChart("Opciones IVR", pieDataset, true, true, true);
        }catch(Exception e){
            System.out.println("Error en creaGrafico de graficoIVR: "+e);
        }
        return chart;
    }
    
    private static BigDecimal truncateDecimal(double x, int cantDec){
        if(x>0){
            return new BigDecimal(String.valueOf(x)).setScale(cantDec,BigDecimal.ROUND_FLOOR);
        }else{
            return new BigDecimal(String.valueOf(x)).setScale(cantDec,BigDecimal.ROUND_CEILING);
        }
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
