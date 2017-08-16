/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import query.AgenteQuery;

/**
 *
 * @author Jose
 */
public class ContenedorAgente extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            response.setContentType("text/html");
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            boolean multiple = Boolean.valueOf(request.getParameter("multiple"));
            HttpSession session = request.getSession();
            ResourceBundle msgs = null;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }else{
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }
            
            if(multiple){
                out.print(AgenteQuery.obtenerAgentesXPiloto(request.getParameter("piloto"),msgs));
            }else{
                out.print(AgenteQuery.obtenerAgentes(request.getParameter("anexo"),msgs));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}
