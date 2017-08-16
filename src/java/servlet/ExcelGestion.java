package servlet;

import DTO.Configuracion;
import adportas.Fechas;
import adportas.SQLConexion;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;
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
import query.AcdKallGestion;
import query.IvrEncuestaQry;

public class ExcelGestion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=Gestion.xls");        
        ResourceBundle msgs;
        if(request.getSession().getAttribute("msgs")==null){
            Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
            ResourceBundle.clearCache();
            msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
        }
        else{
            msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
        }
        String query = request.getParameter("query");
        boolean err = false;
        short nfila = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

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
            CreateCellHead(row,wb,(short) 3,"Ultima Redireccion");
            CreateCellHead(row,wb,(short) 4,"Numero Final");
            CreateCellHead(row,wb,(short) 5,"Estado Extension");
            CreateCellHead(row,wb,(short) 6,"Estado Ultima redirección");
            CreateCellHead(row,wb,(short) 7,"Estado Número Final");
            CreateCellHead(row,wb,(short) 8,"Tipo");
            CreateCellHead(row,wb,(short) 9,"Fecha");
            CreateCellHead(row,wb,(short) 10,"Inicio");
            CreateCellHead(row,wb,(short) 11,"Duración");
            CreateCellHead(row,wb,(short) 12,"Rings");
            nfila++;
            
            if(!err){
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm:ss");
                Configuracion conf = AcdKallGestion.configuracionGestion();
                try{
                    con = SQLConexion.conectar(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();
                    while(rs.next()){
                        row = sheet.createRow(nfila);
                        
                        int id = rs.getInt("id_llamada");
                        String agente = rs.getString("extension")!= null ? rs.getString("extension").trim() : "";
                        String contr = rs.getString("contraparte") != null ? rs.getString("contraparte").trim() : "";
                        String ultimaRedireccion = rs.getString("ultima_redireccion");
                        String numero_final = rs.getString("numero_final")!=null?rs.getString("numero_final"):"";
                        String estado1 = rs.getString("estado1") != null ? rs.getString("estado1") : "";
                        String estado2 = rs.getString("estado2") != null ? rs.getString("estado2") : "";
                        String estado3 = rs.getString("estado3") != null ? rs.getString("estado3") : "";
                        String tipo = "";
                        if(rs.getString("tipo").trim().equals("anexos")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.ext");
                        }else if(rs.getString("tipo").trim().equals("entrante")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.in");
                        }else if(rs.getString("tipo").trim().equals("saliente")){
                            tipo = msgs.getString("llamadaRegistro.tag.select.out");
                        }
                        Timestamp tiempo_origen = rs.getTimestamp("tiempo_origen");
                        String duracion = rs.getString("duracion");
                        String rings = rs.getString("rings");

                        createCell(row,(short) 0, id+"");
                        createCell(row,(short) 1, agente);
                        createCell(row,(short) 2, contr);
                        createCell(row,(short) 3, ultimaRedireccion);
                        createCell(row,(short) 4, numero_final+"");
                        createCell(row,(short) 5, estado1);
                        createCell(row,(short) 6, estado2);
                        createCell(row,(short) 7, estado3);
                        createCell(row,(short) 8, tipo);
                        createCell(row,(short) 9, Fechas.ddmmaa2time(sdf.format(tiempo_origen)).toString());
                        createCell(row,(short) 10, sdf1.format(tiempo_origen));
                        createCell(row,(short) 11, duracion);
                        createCell(row,(short) 12, rings);
                        
                        
                        nfila++;
                    }
                }
                catch(Exception e){
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
