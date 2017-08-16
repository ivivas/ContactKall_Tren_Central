package servlet;

import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.ComboQuery;

public class ListaPilotoToolTip extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        String piloto = request.getParameter("piloto");
        int opcion = Integer.parseInt(request.getParameter("opcion"));
        String salida = "";
        Connection con = null;
        try{
            con = SQLConexion.conectar();
            if(opcion == 0){
                List<String> anexos = ComboQuery.listaSecretariaMasNombre(con,piloto);
                for(String anexo : anexos){
                    salida+=anexo+"<br>";
                }
            }
            else{
                List<String> pilotos = ComboQuery.listaPilotosXSupervisorNombre(con, piloto);
                for(String plt : pilotos){
                    salida+=plt+"<br>";
                }
            }
            out.print(salida);
        }
        catch(Exception e){
           e.printStackTrace();
        }
        finally{
            try{
                con.close();
            }
            catch(Exception e){
                
            }
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
