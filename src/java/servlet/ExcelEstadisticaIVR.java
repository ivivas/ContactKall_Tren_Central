/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import DTO.Configuracion;
import adportas.Postgres;
import adportas.SQLConexion;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
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
import query.Ivr;
import query.IvrEncuestaQry;

/**
 *
 * @author Ricardo
 */
@WebServlet(name = "ExcelEstadisticaIVR", urlPatterns = {"/ExcelEstadisticaIVR"})
public class ExcelEstadisticaIVR extends HttpServlet {

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
        response.setHeader("Content-Disposition", "attachment; filename=IVR.xlsx");
        //PrintWriter out = response.getWriter();
        String desde = request.getParameter("desde") != null ? request.getParameter("desde").trim()   : "";
        String hasta = request.getParameter("hasta") != null ? request.getParameter("hasta").trim()  : "";
        short nfila = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String qry_tbl = "select e.id,h. num_llama, e.boton_accion,ai.nombre, nombre_subrutina, "
                + " ac.descripcion, h.global_call_id, to_char(e.fecha, 'YYYY-MM-DD HH24:MI') as fecha "
                + " from estadistica e, head_estadistica  h , acciones_subrutina ac, acciones_ivr ai "
                + " where id_header != 0 and h.id = e.id_header and ac.id = e.id_accion "
                + " and ai.id = e.tipo_accion and e.fecha > '"+desde+" 00:00:00' "
                + " and e.fecha <= '"+hasta+" 23:59:59' ";
        
        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet();

        sheet.setColumnWidth(0, 5000);
        sheet.setColumnWidth(1, 5000);
        sheet.setColumnWidth(2, 5000);
        sheet.setColumnWidth(3, 5000);
        sheet.setColumnWidth(4, 5000);
        sheet.setColumnWidth(5, 5000);
        sheet.setColumnWidth(6, 5000);
        sheet.setColumnWidth(7, 5000);

        Row row = sheet.createRow(nfila);

        CreateCellHead(row,wb,(short) 0,"Id Registro");
        CreateCellHead(row,wb,(short) 1,"Numero Cliente");
        CreateCellHead(row,wb,(short) 2,"Boton Accion");
        CreateCellHead(row,wb,(short) 3,"Accion");
        CreateCellHead(row,wb,(short) 4,"Menu");
        CreateCellHead(row,wb,(short) 5,"Descripcion Accion");
        CreateCellHead(row,wb,(short) 6,"Call ID");
        CreateCellHead(row,wb,(short) 7,"Fecha Registro");
        nfila++;
        try {
            Configuracion confIVR = Ivr.configuracionIVR();
            con = Postgres.conectar(confIVR.getIpServidor(), confIVR.getBaseDatos(), confIVR.getUsuarioBD(), confIVR.getClaveBD());
            ps = con.prepareStatement(qry_tbl);
            rs = ps.executeQuery();
            while(rs.next()){
                row = sheet.createRow(nfila);
                
                int id = rs.getInt("id");
                String numCl = rs.getString("num_llama") != null ? rs.getString("num_llama").trim() : "";
                String btn = rs.getString("boton_accion") != null ? rs.getString("boton_accion").trim() : "";
                String accion = rs.getString("nombre") != null ? rs.getString("nombre").trim() : "";
                String menu = rs.getString("nombre_subrutina") != null ? rs.getString("nombre_subrutina").trim(): "";
                String descAcc = rs.getString("descripcion") != null ? rs.getString("descripcion").trim() : "";
                String gcid = rs.getString("global_call_id") != null ? rs.getString("global_call_id").trim() : "";
                String fecha = rs.getString("fecha") != null ? rs.getString("fecha").trim() : "";
                createCell(row,(short) 0, id+"");
                createCell(row,(short) 1, numCl);
                createCell(row,(short) 2, btn);
                createCell(row,(short) 3, accion+"");
                createCell(row,(short) 4, menu+"");
                createCell(row,(short) 5, descAcc);
                createCell(row,(short) 6, gcid);
                createCell(row,(short) 7, fecha);
                nfila++;
            }
        }catch(Exception e){
            System.out.println("Error en ExcelEstadisticaIVR: "+e+" "+e.getStackTrace()[0].getLineNumber());
            System.out.println("qry: "+qry_tbl);
        }
        finally{
            
        }
        ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
        wb.write(outByteStream);
        byte [] outArray = outByteStream.toByteArray();
        response.setContentLength(outArray.length);
        OutputStream outStream = response.getOutputStream();
        outStream.write(outArray);
        outStream.flush();
    }
    
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
