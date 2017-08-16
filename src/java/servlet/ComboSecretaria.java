/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import query.ComboQuery;

/**
 *
 * @author Jose
 */
public class ComboSecretaria extends HttpServlet {
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            HttpSession session = request.getSession();
            ResourceBundle msgs;
            if(session.getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }
            else{
                msgs = (ResourceBundle) session.getAttribute("msgs");
            }
            response.setCharacterEncoding("utf-8");
            PrintWriter out = response.getWriter();
            List<String> listaSecretaria = ComboQuery.listaSecretaria2(request.getParameter("piloto"));
            String req = request.getParameter("numero")==null?"":request.getParameter("numero");
            String selAll= "";
            if(req.equals("-1")){
                //System.out.println("-1");
                selAll = "selected";
            }
            StringBuilder sB = new StringBuilder();
            
            sB.append("<option value=''>");
            sB.append(msgs.getString("opcion.desh.opt.def"));
            sB.append("</option>");
            sB.append("<option value='-1' ");
            sB.append(selAll);
            sB.append(" >");
            sB.append(msgs.getString("llamadaRegistro.tag.select.all"));
            sB.append("</option>");
            for(String sec : listaSecretaria){
                if(req.equals(sec)){
                    sB.append("<option value='");
                    sB.append(sec);
                    sB.append("' selected>");
                    sB.append(sec);
                    sB.append("</option>");
                }
                else{
                    sB.append("<option value='");
                    sB.append(sec);
                    sB.append("'>");
                    sB.append(sec);
                    sB.append("</option>");
                }
            }
            out.print(sB.toString());
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
