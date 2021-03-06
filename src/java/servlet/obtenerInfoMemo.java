package servlet;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.ConfQuery;
import query.Reckall;

public class obtenerInfoMemo extends HttpServlet{
    
    private void processRequest(HttpServletRequest req,HttpServletResponse resp) {
        Connection con = null;
        try{
            PrintWriter out = resp.getWriter();
            Configuracion conf = Reckall.conf!=null?Reckall.conf:Reckall.configuracionReckall();
            con = SQLConexion.conectaRecKall(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            int idGrabacion = Integer.parseInt(req.getParameter("idGrabacion"));
            int segundo = Integer.parseInt(req.getParameter("segundo"));
            String datoMemo = ConfQuery.getMemo(con,idGrabacion,segundo);
            out.print(datoMemo);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                con.close();
            }
            catch(Exception e){}
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
