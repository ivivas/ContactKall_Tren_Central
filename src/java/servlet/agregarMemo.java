package servlet;

import DTO.Configuracion;
import adportas.SQLConexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import query.ConfQuery;
import query.Reckall;

public class agregarMemo extends HttpServlet{
    
    private void processRequest(HttpServletRequest req,HttpServletResponse resp) {
        Connection con = null;
        try{
            PrintWriter out = resp.getWriter();
            Configuracion conf = Reckall.conf!=null?Reckall.conf:Reckall.configuracionReckall();
            con = SQLConexion.conectaRecKall(conf.getIpServidor(), conf.getBaseDatos(), conf.getUsuarioBD(), conf.getClaveBD());
            int idGrabacion = Integer.parseInt(req.getParameter("idGrabacion"));
            String mensaje = req.getParameter("mensaje");
            String usuario = req.getParameter("usuario");
            int segundo = Integer.parseInt(req.getParameter("segundo"));
            if(ConfQuery.segundoDisponible(con,segundo,idGrabacion)){
                ConfQuery.agregarMemo(con,idGrabacion, mensaje, usuario, segundo);
                List<Integer> datosMemo = ConfQuery.getMemo(con,idGrabacion);
                StringBuilder sB = new StringBuilder();
                if(datosMemo != null){
                    for(Integer dato : datosMemo){
                        sB.append(dato);
                        sB.append(",");
                    }
                    out.print(sB.substring(0, sB.length()-1));
                }
                else{
                    out.print("");
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
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
