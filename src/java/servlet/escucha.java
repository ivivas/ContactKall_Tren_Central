package servlet;

import adportas.audio.JSpeexDec;
import adportas.audio.Cripto;
import it.sauronsoftware.jave.AudioAttributes;
import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.EncodingAttributes;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import query.Reckall;

public class escucha
  extends HttpServlet
{
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    String wav = request.getParameter("wav");
    String referer = request.getHeader("referer");
    File target = null;
    try
    {
      String comienzoReferer = referer.split("/reproductor2.jsp")[0];
      
      String protocolo = request.getProtocol().contains("HTTPS") ? "https" : "http";
      String comprobador = protocolo + "://" + request.getLocalAddr() + ":" + request.getLocalPort() + request.getContextPath();
      String comprobadorSP = protocolo + "://" + request.getLocalAddr() + request.getContextPath();
      String comprobadorFlash = protocolo + "://" + request.getLocalAddr() + ":" + request.getLocalPort() + request.getContextPath() + "/js/jQuery_jPlayer/Jplayer.swf";
      String comprobadorSPFlash = protocolo + "://" + request.getLocalAddr() + request.getContextPath() + "/js/jQuery_jPlayer/Jplayer.swf";
      
      String comprobador2 = "";
      String comprobadorSP2 = "";
      String comprobador2Flash = "";
      String comprobadorSP2Flash = "";
      try
      {
        if (request.getLocalName() != null)
        {
          comprobador2 = protocolo + "://" + request.getLocalName() + ":" + request.getLocalPort() + request.getContextPath();
          comprobadorSP2 = protocolo + "://" + request.getLocalName() + request.getContextPath();
          comprobador2Flash = protocolo + "://" + request.getLocalName() + ":" + request.getLocalPort() + request.getContextPath() + "/js/jQuery_jPlayer/Jplayer.swf";
          comprobadorSP2Flash = protocolo + "://" + request.getLocalName() + request.getContextPath() + "/js/jQuery_jPlayer/Jplayer.swf";
        }
      }
      catch (Exception localException1) {}
      response.setContentType("audio/x-wav");
      


      OutputStream o = null;
      InputStream is = null;
      try
      {
        HttpSession sesion = request.getSession();
        String sesionActual = sesion.getAttribute("tipo") != null ? sesion.getAttribute("tipo").toString() : "";
        Cripto cripto = new Cripto();
//        String claveRuta = "rutaArchivo" + sesion.getId();
//        String claveNombre = "nombreArchivo" + sesion.getId();
        //String sesionRutaArchivo = request.getParameter("rutaArchivo").replace(sesion.getId(), "");
        //String sesionNombreArchivo = request.getParameter("archivo").replace(sesion.getId(), "");
        if ((sesionActual.compareTo("adm_general") == 0) || (sesionActual.compareTo("supervisor") == 0))
        {
          String rutaArchivo = request.getParameter("rutaArchivo");
          
          String nombreArchivo = request.getParameter("archivo");
          
          Calendar cal = Calendar.getInstance();
          String fecha = cal.get(1) + "-" + cal.get(2) + "-" + cal.get(5) + " " + cal.get(11) + ":" + cal.get(12);
          
          int random = (int)Math.round(Math.random() * 1000000.0D);
          System.out.println("random = " + random);
          
          String rutaPC = getServletContext().getRealPath("");
         //rutaPC = "/data/apache-tomcat-8.0.3/webapps/RecKallPortal";
          String[] args = new String[2];
          //args[0] = (rutaPC);
          args[0] = Reckall.conf.getRutaGrabacion()+"/"+nombreArchivo;
          
          //args[0] = args[0].replace("\\", "/");
          args[0] = args[0].trim();
          File source = new File(args[0]);
          String ruta = "";
          String nombreArchivoAMostrar = nombreArchivo;
          if (wav == null)
          {
              System.out.println("wav es null");
            if (nombreArchivo.contains("ogg"))
            {
                System.out.println("es ogg");
              target = File.createTempFile(sesion.getId(), ".mp3");
              target = transformarOggAMp3(source, target);
              nombreArchivoAMostrar = nombreArchivo.replace("ogg", "mp3");
              response.setContentType("audio/x-mp3");
            }
            else
            {
                System.out.println("no es oogg");
              target = File.createTempFile(sesion.getId(), ".mp3");
              System.out.println("el id es : " + sesion.getId());
              AudioAttributes audio = new AudioAttributes();
              audio.setCodec("libmp3lame");
              audio.setBitRate(new Integer(128000));
              audio.setChannels(new Integer(2));
              audio.setSamplingRate(new Integer(44100));
              EncodingAttributes attrs = new EncodingAttributes();
              attrs.setFormat("mp3");
              attrs.setAudioAttributes(audio);
              Encoder encoder = new Encoder();
              response.setContentType("audio/x-mp3");
              nombreArchivoAMostrar = nombreArchivo.replace("wav", "mp3");
              try
              {
                encoder.encode(source, target, attrs);
              }
              catch (Exception localException2) {}
            }
          }
          else if (nombreArchivo.contains("ogg"))
          {
              System.out.println("???--------------");
            target = File.createTempFile(sesion.getId(), ".wav");
            target = transformarOggAWav(source, target);
            nombreArchivoAMostrar = nombreArchivo.replace("ogg", "wav");
            response.setContentType("audio/x-wav");
          }
          else
          {
              System.out.println("no se que xuxa");
            target = new File(args[0]);
          }
          response.setHeader("Accept-Ranges", "bytes");
          response.setHeader("Content-Disposition", "attachment;filename=" + nombreArchivoAMostrar);
            System.out.println("este es el archivo a reproducir: "+nombreArchivoAMostrar);
          DataInputStream dis = new DataInputStream(new FileInputStream(target));
          response.setHeader("Content-Length", String.valueOf(target.length()));
          System.out.println("target length = " + target.length());
          is = dis;
          
          o = response.getOutputStream();
          


          byte[] buf = new byte[32768];
          int nRead = 0;
          while ((nRead = is.read(buf)) != -1) {
              try{
            o.write(buf, 0, nRead);
              }
              catch(Exception e){}
          }
          o.flush();
          is.close();
          
          o.close();
          if ((wav == null) && (target != null)) {
            target.delete();
          }
        }
      }
      catch (Exception ex)
      {
          System.out.println("la wea cago aqui");
        o.flush();
        
        is.close();
        
        o.close();
        
        ex.printStackTrace();
      }
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
  }
  
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    processRequest(request, response);
  }
  
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    processRequest(request, response);
  }
  
  public String getServletInfo()
  {
    return "Short description";
  }
  
  public static File transformarOggAMp3(File source, File target)
    throws IOException
  {
    JSpeexDec jspeex = new JSpeexDec();
    File outputFile = File.createTempFile("temp", null);
    System.out.println("ruta absoluta del temporal " + outputFile.getAbsolutePath());
    
    jspeex.decode(source, outputFile);
    
    AudioAttributes audio = new AudioAttributes();
    audio.setCodec("libmp3lame");
    audio.setBitRate(new Integer(128000));
    audio.setChannels(new Integer(1));
    audio.setSamplingRate(new Integer(8000));
    EncodingAttributes attrs = new EncodingAttributes();
    attrs.setFormat("mp3");
    attrs.setAudioAttributes(audio);
    Encoder encoder = new Encoder();
    try
    {
      encoder.encode(outputFile, target, attrs);
      outputFile.delete();
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
    return target;
  }
  
  public static File transformarOggAWav(File source, File target)
    throws IOException
  {
      System.out.println("este es el source: "+source+" - "+target);
    JSpeexDec jspeex = new JSpeexDec();
    
    System.out.println("ruta absoluta del temporal " + target.getAbsolutePath());
    
    jspeex.decode(source, target);
    
    return target;
  }
  
  public static void main(String[] args)
    throws IOException
  {
    JSpeexDec jspeex = new JSpeexDec();
    File outputFile = File.createTempFile("temp", null);
    System.out.println("ruta absoluta del temporal " + outputFile.getAbsolutePath());
    File source = new File("C:\\ccc.ogg");
    jspeex.decode(source, outputFile);
    File target = new File("T:\\creado.mp3");
    
    AudioAttributes audio = new AudioAttributes();
    audio.setCodec("libmp3lame");
    audio.setBitRate(new Integer(128000));
    audio.setChannels(new Integer(2));
    audio.setSamplingRate(new Integer(44100));
    EncodingAttributes attrs = new EncodingAttributes();
    attrs.setFormat("mp3");
    attrs.setAudioAttributes(audio);
    Encoder encoder = new Encoder();
    try
    {
      encoder.encode(outputFile, target, attrs);
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
  }
}
