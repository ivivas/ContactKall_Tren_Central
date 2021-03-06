/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.AgenteQuery;

/**
 *
 * @author Jose
 */
public class ContenedorPiloto extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            response.setCharacterEncoding("utf-8");
            String sesion = request.getParameter("sesion");
            String idPiloto = request.getParameter("idPiloto");
            //System.out.println("sesion: "+sesion+" idPiloto: "+idPiloto);
            PrintWriter out = response.getWriter();
            out.print(AgenteQuery.obtenerPilotos(sesion,idPiloto));
        }
        catch(Exception e){
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
