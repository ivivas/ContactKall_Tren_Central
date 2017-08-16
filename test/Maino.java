
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Mario
 */
public class Maino {

    public static void main(String[] args) {
        
        String tiempoEspera = "60000";
        System.out.println("tiempoEspera: " + tiempoEspera);
        int espera = Integer.parseInt(tiempoEspera);
        System.out.println("espera: " + espera);
        try {
            Thread.sleep(espera);
        } catch (InterruptedException ex) {
            Logger.getLogger(Maino.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        
        
        Calendar cal;
        String[] listaDias = {"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"};
        cal = Calendar.getInstance();
        String dia = listaDias[cal.get(Calendar.DAY_OF_WEEK) - 1];
        System.out.println("Dia: " + dia + " N: " + (cal.get(Calendar.DAY_OF_WEEK) -1));
    }
}
