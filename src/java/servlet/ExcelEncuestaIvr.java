/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import query.IvrEncuestaQry;

/**
 *
 * @author Ricardo Fuentes
 */
@WebServlet(name = "ExcelEncuestaIvr", urlPatterns = {"/ExcelEncuestaIvr"})
public class ExcelEncuestaIvr extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=Encuesta.xlsx");
        //PrintWriter out = response.getWriter();
        
        String desde = request.getParameter("desde") != null ? request.getParameter("desde").trim() : "";
        String hasta = request.getParameter("hasta") != null ? request.getParameter("hasta").trim() : "";
        String anexo = request.getParameter("anexo") != null ? request.getParameter("anexo").trim() : "";
        String piloto = request.getParameter("piloto") != null ? request.getParameter("piloto").trim() : "";
        Date d_desde= null;
        Date d_hasta = null;
        boolean err = false;
        short nfila = 0;
        String anexosBusqueda = "";
        
        System.out.println("desde: "+desde+" hasta: "+hasta+" anexo: "+anexo);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        
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
                    //System.out.println(rs1.getString("anexo").trim());
                }
            }catch(Exception e){
                System.out.println("Error buscando secretarias: "+e);
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
        
        try{
            sdf.parse(desde);
            d_desde = sdf2.parse(desde+" 00:00:00");
        }catch(Exception e){
            err = true;
        }
        try{
            sdf.parse(hasta);
            d_hasta = sdf2.parse(hasta+" 23:59:59");
        }catch(Exception e){}
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String qry_tbl = "select h.id_head, h.callid_head, h.num_agente, h.num_contraparte, e.pregunta_encuesta, e.respuesta_encuesta , "
                    + " to_char(h.fecha_registro_head,'YYYY-MM-DD HH24:MI') as fecha , h.fecha_registro_head from head_encuesta h , encuesta e "
                    + " where h.callid_head = e.callid_encuesta and h.num_contraparte = e.contraparte_encuesta and fecha_registro_head >= ? "
                    + " and fecha_registro_head <= ? "
                    //+ " and num_agente like ? "
                    + " and num_agente in ("+anexosBusqueda+")"
                    + " order by fecha_registro_head ";

        try {
            Workbook wb = new XSSFWorkbook();
            Sheet sheet = wb.createSheet();

            sheet.setColumnWidth(0, 5000);
            sheet.setColumnWidth(1, 5000);
            sheet.setColumnWidth(2, 5000);
            sheet.setColumnWidth(3, 5000);
            sheet.setColumnWidth(4, 5000);
            sheet.setColumnWidth(5, 5000);

            Row row = sheet.createRow(nfila);
            CreateCellHead(row,wb,(short) 0,"Id Llamada");
            CreateCellHead(row,wb,(short) 1,"Anexo Agente");
            CreateCellHead(row,wb,(short) 2,"Contraparte");
            CreateCellHead(row,wb,(short) 3,"Numero Pregunta");
            CreateCellHead(row,wb,(short) 4,"Respuesta");
            CreateCellHead(row,wb,(short) 5,"Fecha");
            nfila++;
            
            if(!err){
                Configuracion conf = IvrEncuestaQry.getConfiguracion();
                try{
                    //con = SQLConexion.conectaIVREncuesta(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
                    con = SQLConexion.conectaIVREncuesta("localhost", "ivr_encuesta", "postgres", "adp2016");
                    ps = con.prepareStatement(qry_tbl);
                    ps.setTimestamp(1, new java.sql.Timestamp(d_desde.getTime()));
                    ps.setTimestamp(2, new java.sql.Timestamp(d_hasta.getTime()));
                    //ps.setString(3, anexo+"%");
                    System.out.println("qry: "+ps.toString());
                    rs = ps.executeQuery();
                    while(rs.next()){
                        row = sheet.createRow(nfila);
                        
                        int id = rs.getInt("id_head");
                        String agente = rs.getString("num_agente")!= null ? rs.getString("num_agente").trim() : "";
                        String contr = rs.getString("num_contraparte") != null ? rs.getString("num_contraparte").trim() : "";
                        int pregunta = rs.getInt("pregunta_encuesta");
                        int respuesta = rs.getInt("respuesta_encuesta");
                        String fecha = rs.getString("fecha") != null ? rs.getString("fecha") : "";
                        createCell(row,(short) 0, id+"");
                        createCell(row,(short) 1, agente);
                        createCell(row,(short) 2, contr);
                        createCell(row,(short) 3, pregunta+"");
                        createCell(row,(short) 4, respuesta+"");
                        createCell(row,(short) 5, fecha);
                        nfila++;
                    }
                    
                }catch(Exception e){
                    System.out.println("Error consultado a bd en ExcelEncuestaIvr: "+e);
                }finally{
                    con.close();
                    ps.close();
                    rs.close();
                }
            }
            ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
            wb.write(outByteStream);
            byte [] outArray = outByteStream.toByteArray();
            response.setContentLength(outArray.length);
            OutputStream outStream = response.getOutputStream();
            outStream.write(outArray);
            outStream.flush();
            
        }catch(Exception e){
            System.out.println("Error en ExcelEncuestaIvr: "+e);
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
    
    private static void CreateCellHead(Row row, Workbook wb, Short col, String val){
        Font font = wb.createFont();
        font.setBoldweight(Font.BOLDWEIGHT_BOLD);
        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        Cell cell = row.createCell(col);
        cell.setCellValue(val);
        cell.setCellStyle(style);
    }
    
    private static void createCell(Row row, Short col, String val){
        Cell cell = row.createCell(col);
        cell.setCellValue(val);   
    }
}
