/*
 * Log.java
 *
 * Creado el 05 de abril de 2007, a las 01:08 PM
 * @author  : Maxbell Caballero Torres
 * @version : 2.0
 *
 */

package query;

import java.io.File;
import java.io.RandomAccessFile;
import java.io.IOException;
import java.util.Date;
import java.text.SimpleDateFormat;

public class Log {
    private static File archivoLog = null;
    private static String archivo = "log.txt";
    private static int TAMANO_MAXIMO_LOG = 10240; //bytes
    private Log() {}
    
    public static void setArchivo(String archivoNombre) {
        archivo = archivoNombre;
    }
    
    public static void setGrabar(String texto, boolean grabarFecha) throws IOException {
        if (grabarFecha) {
            texto = "[" + fecha() + "] " + texto;
        }
        archivoLog = new File(archivo);
        System.out.println(archivoLog.getAbsolutePath());
        RandomAccessFile ras = new RandomAccessFile(archivoLog, "rw");
        if (ras.length() > TAMANO_MAXIMO_LOG) {
            ras.setLength(0);
            ras.writeBytes("\n--------------- Este log fue limpiado el " + fecha() + " ----------------");
            System.out.println("NOTA: Archivo Log ha sido limpiado.");
        }
        ras.seek(ras.length());
        ras.writeBytes("\n\n" + texto);
        ras.close();
    }
    
    public static String getArchivoDirectorio() {
        String archivoDirectorio = System.getProperty("user.dir");
        if (archivoLog!=null) {
            if (archivoLog.getParent()!=null) {
                archivoDirectorio=archivoLog.getParent();
            }
        }
        return archivoDirectorio;
    }
    
    public static String getArchivoNombre() {
        String archivoNombre=archivo;
        if(archivoLog!=null)
            if(archivoLog.getName()!=null) archivoNombre=archivoLog.getName();
        return archivoNombre;
    }
    
    public static String getArchivoRuta() {
        File archivoRutaVolatil = new File(archivo);
        return archivoRutaVolatil.getAbsolutePath();
    }
    
    
    public static void imprimirError(Exception e, boolean grabarFecha) {
        String error = "ERROR: " + e;
        System.out.println(error);
        try {
            setGrabar(error, grabarFecha);
        } catch (Exception eLog) {
            System.out.println("ERROR: El sistema no puede hallar la ruta especificada del archivo " + getArchivoRuta());
        }     
    }
    
    public static void imprimirError(String e, boolean grabarFecha) {
        String error = "ERROR: " + e;
        System.out.println(error);
        try {
            setGrabar(error, grabarFecha);
        } catch (Exception eLog) {
            System.out.println("ERROR: El sistema no puede hallar la ruta especificada del archivo " + getArchivoRuta());
        }     
    }
     
    private static String fecha() {
        SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
        Date date = new Date();
        String fecha = formato.format(date);
        return fecha;
    }
    
    public static void main(String args[]) {
        try {
            System.out.println("archivo ruta -> :" + Log.getArchivoRuta());
            System.out.println("directorio -> :" + Log.getArchivoDirectorio());
            Log.setGrabar("Este es texto agregado al log por defecto en log.txt \ny la ruta es la del la carpeta principal del proyecto", true);
            System.out.println("nombre archivo -> :" + Log.getArchivoNombre());
            Log.setArchivo("nuevoNombreDeArchivo.txt");
            Log.imprimirError("Este es un error", true);
            System.out.println("nombre archivo -> :" + Log.getArchivoNombre());
            System.out.println("archivo ruta -> :" + Log.getArchivoRuta());
            }
        catch (Exception e) {
            System.out.println("Error: El sistema no puede hallar la ruta especificada para el archivo.");
        }
    }
}

