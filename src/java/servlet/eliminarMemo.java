package servlet;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.ConfQuery;
import query.Log;
import query.Reckall;

public class eliminarMemo extends HttpServlet{
    
    private void processRequest(HttpServletRequest req,HttpServletResponse resp) {
        Connection con = null;
        try{
            PrintWriter out = resp.getWriter();
            Configuracion conf = Reckall.conf!=null?Reckall.conf:Reckall.configuracionReckall();
            con = SQLConexion.conectaRecKall(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            int idMemo = Integer.parseInt(req.getParameter("idMemo"));
            String usuario = req.getParameter("usuario");
            ResultSet rsLog = ConfQuery.eliminarMemo(con,idMemo);
            rsLog.next();
            Log.setGrabar("Dato borrado por: "+usuario+"\nContenido mensaje: "+rsLog.getString("mensaje")+"\n", true);
            out.print(rsLog.getInt("segundo"));
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
