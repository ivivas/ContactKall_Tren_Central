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

/**
 *
 * @author Jose
 */
public class QosGrafico extends HttpServlet {

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        ResourceBundle msgs = null;
        try {
            if(request.getSession().getAttribute("msgs")==null){
                Locale lEs= new Locale.Builder().setLanguageTag("es").setRegion("CL").build();
                ResourceBundle.clearCache();
                msgs = ResourceBundle.getBundle("bundle.fichero", lEs);
            }
            else{
                msgs = (ResourceBundle) request.getSession().getAttribute("msgs");
            }            
            int seleccion = Integer.parseInt(request.getParameter("seleccion"));
            String anexo = request.getParameter("anexo");
            int lapso = Integer.parseInt(request.getParameter("lapso"));
            String rutaCarpetaImagenes = "";
            if (lapso == 0) {
                rutaCarpetaImagenes = "imagenes/diario/";
            } else if (lapso == 1) {
                rutaCarpetaImagenes = "imagenes/semanal/";
            } else if (lapso == 2) {
                rutaCarpetaImagenes = "imagenes/mensual/";
            }
            String piloto = request.getParameter("piloto");
            PrintWriter out = response.getWriter();
            switch (seleccion) {
                case 0:

                    out.print("<div id='uno' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.perdida")+"<img src='" + rutaCarpetaImagenes + "llamadaPerdidaPool.jpg' width='265' height='130' title='Llamadas Perdidas' alt='Llamadas Perdidas'></div>");
                    out.print("<div id='dos' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.contestada")+"<img src='" + rutaCarpetaImagenes + "llamadaContestadaPool.jpg' width='265' height='130' title='Llamadas contestadas' alt='Llamadas contestadas'></div>");
                    out.print("<div id='tres' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.ringeo")+"<img src='" + rutaCarpetaImagenes + "promedioRingeoPool.jpg' width='265' height='130' title='Promedio tiempo espera' alt='Promedio tiempo espera'></div>");
                    out.print("<div id='cuatro' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.hablado")+"<img src='" + rutaCarpetaImagenes + "promedioLlamadaPool.jpg' width='265' height='130' title='Promedio tiempo hablado' alt='Proemdio tiempo hablado'></div>");
                    out.print("<div id='cinco' class='grfcol' >"+msgs.getString("qos.grafico.titulo.total.llamada")+"<img src='" + rutaCarpetaImagenes + "llamadaGralPool.jpg' width='265' height='130' title='Total Llamadas' alt='Total Llamadas'></div>");
                    //out.print("<div id='seis' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.activo")+"<img src='" + rutaCarpetaImagenes + "tiempoActivoPool.jpg' width='265' height='130' title='Tiempo activo' alt='Tiempo activo'></div>");
                    //out.print("<div id='siete' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.inactivo")+"<img src='" + rutaCarpetaImagenes + "tiempoInactivoPool.jpg' width='265' height='130' title='Tiempo inactivo' alt='Tiempo inactivo'></div>");
                    //out.print("<div id='ocho' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.total")+"<img src='" + rutaCarpetaImagenes + "tiempoPool.jpg' width='265' height='130' title='Tiempo total' alt='Tiempo total'></div>");

                    break;
                case 1:

                    out.print("<div id='uno' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.perdida")+"<img src='" + rutaCarpetaImagenes + "llamadaPerdida" + piloto + ".jpg' width='265' height='130' title='Llamadas Perdidas' alt='Llamadas Perdidas'></div>");
                    out.print("<div id='dos' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.contestada")+"<img src='" + rutaCarpetaImagenes + "llamadaContestada" + piloto + ".jpg' width='265' height='130' title='Llamadas contestadas' alt='Llamadas contestadas'></div>");
                    out.print("<div id='tres' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.ringeo")+"<img src='" + rutaCarpetaImagenes + "promedioRingeo" + piloto + ".jpg' width='265' height='130' title='Promedio tiempo espera' alt='Promedio Ringueo'></div>");
                    out.print("<div id='cuatro' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.hablado")+"<img src='" + rutaCarpetaImagenes + "promedioLlamada" + piloto + ".jpg' width='265' height='130' title='Promedio tiempo hablado' alt='Promedio tiempo hablado'></div>");
                    out.print("<div id='cinco' class='grfcol' >"+msgs.getString("qos.grafico.titulo.total.llamada")+"<img src='" + rutaCarpetaImagenes + "promedioGralLlamada" + piloto + ".jpg' width='265' height='130' title='Total llamadas' alt='Total llamadas'></div>");
                    //out.print("<div id='seis' class='grfcol' >pendiente<img src='" + rutaCarpetaImagenes + "promedioGralEstadistica" + piloto + ".jpg' width='265' height='130' title='' alt=''></div>");
                    //out.print("<div id='siete' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.activo")+"<img src='" + rutaCarpetaImagenes + "tiempoActivo" + piloto + ".jpg' width='265' height='130' title='Tiempo activo' alt='Tiempo activo'></div>");
                    //out.print("<div id='ocho' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.inactivo")+"<img src='" + rutaCarpetaImagenes + "tiempoInactivo" + piloto + ".jpg' width='265' height='130' title='Tiempo Inactivo' alt='Tiempo Inactivo'></div>");

                    break;
                case 2:

                    out.print("<div id='uno' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.perdida")+"<img src='" + rutaCarpetaImagenes + "llamadasPerdidas.jpg' width='265' height='130' title='Llamadas Perdidas' alt='Llamadas Perdidas'></div>");
                    out.print("<div id='dos' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.contestada")+"<img src='" + rutaCarpetaImagenes + "llamadaContestadas.jpg' width='265' height='130' title='Llamadas Contestadas' alt='Llamadas Contestadas'></div>");
                    out.print("<div id='tres' class='grfcol' >"+msgs.getString("qos.grafico.titulo.total.llamada")+"<img src='" + rutaCarpetaImagenes + "promedioGralLlamada.jpg' width='265' height='130' title='Todas las Llamadas' alt='Todas las Llamadas'></div>");
                    out.print("<div id='cuatro' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.ringeo")+"<img src='" + rutaCarpetaImagenes + "promedioRingeo.jpg' width='265' height='130' title='Promedio tiempo espera' alt='Promedio tiempo espera'></div>");
                    out.print("<div id='cinco' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.hablado")+"<img src='" + rutaCarpetaImagenes + "promedioLlamada.jpg' width='265' height='130' title='Promedio hablado' alt='Promedio hablado'></div>");
                    //out.print("<div id='seis' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.login")+"<img src='" + rutaCarpetaImagenes + "tiempoTotal.jpg' width='265' height='130' title='Tiempo total' alt='Tiempo total'></div>");
                    //out.print("<div id='siete' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.desabilitado")+"<img src='" + rutaCarpetaImagenes + "tiempoInactivo.jpg' width='265' height='130' title='Tiempo inactivo' alt='Tiempo inactivo'></div>");
                    //out.print("<div id='ocho' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.habilitado")+"<img src='" + rutaCarpetaImagenes + "tiempoActivo.jpg' width='265' height='130' title='Tiempo activo' alt='Tiempo activo'></div>");

                    break;
                case 3:

                    out.print("<div id='uno' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.perdida")+"<img src='" + rutaCarpetaImagenes + "llamadasPerdidas"+anexo+".jpg' width='265' height='130' title='Llamadas Perdidas' alt='Llamadas Perdidas'></div>");
                    out.print("<div id='dos' class='grfcol' >"+msgs.getString("qos.grafico.titulo.llamada.contestada")+"<img src='" + rutaCarpetaImagenes + "llamadaContestadas"+anexo+".jpg' width='265' height='130' title='Llamadas Contestadas' alt='Llamadas Contestadas'></div>");
                    out.print("<div id='tres' class='grfcol' >"+msgs.getString("qos.grafico.titulo.total.llamada")+"<img src='" + rutaCarpetaImagenes + "promedioGralLlamada"+anexo+".jpg' width='265' height='130' title='Todas las Llamadas' alt='Todas las Llamadas'></div>");
                    out.print("<div id='cuatro' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.ringeo")+"<img src='" + rutaCarpetaImagenes + "promedioRingeo"+anexo+".jpg' width='265' height='130' title='Promedio tiempo espera' alt='Promedio tiempo espera'></div>");
                    out.print("<div id='cinco' class='grfcol' >"+msgs.getString("qos.grafico.titulo.promedio.hablado")+"<img src='" + rutaCarpetaImagenes + "promedioLlamada"+anexo+".jpg' width='265' height='130' title='Promedio hablado' alt='Promedio hablado'></div>");
                    //out.print("<div id='seis' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.login")+"<img src='" + rutaCarpetaImagenes + "tiempoTotal"+anexo+".jpg' width='265' height='130' title='Tiempo total' alt='Tiempo total'></div>");
                    //out.print("<div id='siete' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.desabilitado")+"<img src='" + rutaCarpetaImagenes + "tiempoInactivo"+anexo+".jpg' width='265' height='130' title='Tiempo inactivo' alt='Tiempo inactivo'></div>");
                    //out.print("<div id='ocho' class='grfcol' >"+msgs.getString("qos.grafico.titulo.tiempo.habilitado")+"<img src='" + rutaCarpetaImagenes + "tiempoActivo"+anexo+".jpg' width='265' height='130' title='Tiempo activo' alt='Tiempo activo'></div>");

                    break;
            }
        } catch (Exception e) {
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
