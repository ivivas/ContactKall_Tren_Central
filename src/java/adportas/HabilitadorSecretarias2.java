package adportas;

import DTO.LoginLogout;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.ResourceBundle;

public class HabilitadorSecretarias2 {

    public String agregarSecretaria(String nombre, String anexo, int estado, String valor, String motivoDeshabilitacion) {
        String radio1 = "";
        String radio2 = "";
        String estadoCSS = "";

        if (estado == 1) {
            estadoCSS = "habilitada";

            radio1 = "<input name=\"radio" + valor.trim() + "\" type=\"radio\" value=\"1&" + nombre.trim() + "\" checked/>";
            radio2 = "<input name=\"radio" + valor.trim() + "\" type=\"radio\" value=\"0&" + nombre.trim() + "\"  onclick=\"seleccionOpcionRadio('" + nombre.trim() + "','" + anexo.trim() + "')\" />";
        } else if (estado == 0) {
            estadoCSS = "deshabilitada";

            radio1 = "<input name=\"radio" + valor.trim() + "\" type=\"radio\" value=\"1&" + nombre.trim() + "\"  />";
            radio2 = "<input name=\"radio" + valor.trim() + "\" type=\"radio\" value=\"0&" + nombre.trim() + "\" checked  />";
        }
        String secretaria = "<tr>"
                + "<td><label><input name=\"" + nombre.trim() + "\" type=\"text\" class=\"titulo_" + estadoCSS + "\" id=\"" + nombre.trim() + "\" size=\"40\" value='" + anexo.trim() + " - " + nombre.trim() + "' onClick=\"cambiarEstado(this)\" />"
                + "</label></td>"
                + "<td width=\"43\">" + radio1 + "</td>"
                + "<td><label><input name=\"habilitada\" type=\"text\" class=\"titulo_habilitada\" id=\"habilitada\" size=\"13\" value=\"habilitada\" /></label></td>"
                + "<td width=\"43\">" + radio2
                + "<input type=\"hidden\" value=\"" + motivoDeshabilitacion + "\" name=\"motivo_deshabilitacion-" + nombre.trim() + "\" id=\"motivo_deshabilitacion-" + nombre.trim() + "\" > </td>"
                + "<td><label><input name=\"deshabilitada\" type=\"text\" class=\"titulo_deshabilitada\" id=\"deshabilitada\" size=\"13\" value=\"deshabilitada\" />" + "</label></td>"
                + "</tr>";

        return secretaria;
    }

    public String agregarSecretaria2(String nombre, String anexo, int estado, String valor, String motivoDeshabilitacion, ResourceBundle msgs) {
        String secretaria = "<tr>";
        String clas = "";
        String combo = "<select name=\"estado_" + valor.trim() + "\" onchange=\"cambiaCombo(this,'" + nombre.trim() + "','" + anexo.trim() + "')\">";
        String estadoSec = "";

        if (estado == 0) {
            clas = "deshabilitada";
            combo += "<option value='0' selected=\"selected\" >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_deshabilitada\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.nook") + "\" readonly /></label>";
        } else if (estado == 1) {
            clas = "habilitada";
            combo += "<option value='0' >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' selected=\"selected\" >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_habilitada\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.ok") + "\" readonly /></label>";
        } else if (estado == 3) {
            clas = "campania";
            combo += "<option value='0' >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' selected=\"selected\" >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_campania\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.camp") + "\" readonly /></label>";
        }
        combo += "</select>";
        secretaria += "<td><label><input name=\"" + nombre.trim() + "\" type=\"text\" class=\"titulo_" + clas + "\" id=\"" + nombre.trim() + "\" size=\"40\" value='" + anexo.trim() + " - " + nombre.trim() + "' readonly /></td>"
                + "<td>" + estadoSec + "</td>"
                + "<td>" + combo + "</td>"
                + "<input type=\"hidden\" value=\"" + motivoDeshabilitacion + "\" name=\"motivo_deshabilitacion-" + nombre.trim() + "\" id=\"motivo_deshabilitacion-" + nombre.trim() + "\" >"
                + "<input type=\"hidden\" name=\"info_" + valor.trim() + "\" id=\"" + valor.trim() + "\" value=\"" + nombre.trim() + "\" >";
        secretaria += "</tr>";
        return secretaria;
    }

    public String agregarSecretaria2_1(String nombre, String anexo, int estado, String valor, String motivoDeshabilitacion, ResourceBundle msgs, Connection con, String piloto) {
        String secretaria = "<tr>";
        String clas = "";
        String combo = "<select name=\"estado_" + valor.trim() + "\" onchange=\"cambiaCombo(this,'" + nombre.trim() + "','" + anexo.trim() + "')\">";
        String estadoSec = "";

        if (estado == 0) {
            clas = "deshabilitada";
            combo += "<option value='0' selected=\"selected\" >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_deshabilitada\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.nook") + "\" readonly /></label>";
        } else if (estado == 1) {
            clas = "habilitada";
            combo += "<option value='0' >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' selected=\"selected\" >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_habilitada\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.ok") + "\" readonly /></label>";
        } else if (estado == 3) {
            clas = "campania";
            combo += "<option value='0' >" + msgs.getString("agente.nook") + "</option>";
            combo += "<option value='1' >" + msgs.getString("agente.ok") + "</option>";
            combo += "<option value='3' selected=\"selected\" >" + msgs.getString("agente.camp") + "</option>";
            estadoSec += "<label><input name=\"estado_sec\" type=\"text\" class=\"titulo_campania\" id=\"estado_sec\" size=\"13\" value=\"" + msgs.getString("agente.camp") + "\" readonly /></label>";
        }
        LoginLogout ll = new LoginLogout();
        ll.setAgente(anexo);
        ll.setPiloto(piloto);
        obtenerLoginAgenteTodoElDia(con, ll);
        combo += "</select>";
        secretaria += "<td><label><input name=\"" + nombre.trim() + "\" type=\"text\" class=\"titulo_" + clas + "\" id=\"" + nombre.trim() + "\" size=\"40\" value='" + anexo.trim() + " - " + nombre.trim() + "' readonly /></td>"
                + "<td>" + estadoSec + "</td>"
                + "<td><font color=\"white\">" + motivoDeshabilitacion + "</font></td>"
                + "<td>" + combo + "</td>"
                + "<td><font color=\"white\">" + segundosATiempoTheRial(ll.getLogin()) + "</font></td>"
                + "<td><font color=\"white\">" + segundosATiempoTheRial(ll.getLogout()) + "</font></td>"
                + "<input type=\"hidden\" value=\"" + motivoDeshabilitacion + "\" name=\"motivo_deshabilitacion-" + nombre.trim() + "\" id=\"motivo_deshabilitacion-" + nombre.trim() + "\" >"
                + "<input type=\"hidden\" value=\"" + motivoDeshabilitacion + "\" name=\"motivo_deshabilitacion-" + nombre.trim() + "\" id=\"motivo_deshabilitacion-" + nombre.trim() + "\" >"
                + "<input type=\"hidden\" name=\"info_" + valor.trim() + "\" id=\"" + valor.trim() + "\" value=\"" + nombre.trim() + "\" >";
        secretaria += "</tr>";
        return secretaria;
    }
    public void obtenerHorarioTrabajoAgenteTodoElDia(Connection con, LoginLogout ll) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        Calendar cal;     
        try {
            cal = Calendar.getInstance();
             ll.setHoraHasta(cal.get(Calendar.YEAR) + "-0" + (cal.get(Calendar.MONTH) + 1) + "-" + cal.get(Calendar.DATE) + " 23:59");
            ll.setHoraActual(new Timestamp(cal.getTime().getTime()));
            ll.setTerminoDia(Timestamp.valueOf(cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH) + 1) + "-" + cal.get(Calendar.DATE) + " 23:59:00"));
                ll.setHoraDesde(cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH) + 1) + "-" + cal.get(Calendar.DATE) + " 00:00.000000");
                ll.setInicioDia(Timestamp.valueOf(cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH) + 1) + "-" + cal.get(Calendar.DATE) + " 00:00:00"));
             if (ll.getHoraActual().getTime() < ll.getTerminoDia().getTime()) {
                    ll.setTerminoDia(ll.getHoraActual());
                }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
    }

    public void obtenerLoginAgenteTodoElDia(Connection con, LoginLogout ll) {
        obtenerHorarioTrabajoAgenteTodoElDia(con, ll);
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = con.prepareStatement("select * from historico_estados where anexo = ? and fecha >= ? and fecha <= ? order by fecha asc ");
            pst.setString(1, ll.getAgente());
            pst.setTimestamp(2, ll.getInicioDia());
            pst.setTimestamp(3, ll.getTerminoDia());
//            pst.setTimestamp(3, ll.getTerminoDia());
            rs = pst.executeQuery();
            boolean hayLogin = false;
            while (rs.next()) {
                int estadoAnterior = ll.getUltimo_estado();
               int estadoActual = rs.getInt("estado") ;    
                System.out.println("estado = " + estadoActual);
                
                if (estadoAnterior ==-1 && estadoActual == 0 ) {
                   //ll.setLogin(rs.getTimestamp("fecha").getTime() - ll.getInicioDia().getTime());
                }
                else if(estadoAnterior==-1 && (estadoActual == 1 || estadoActual == 1 ))
                {
                    //login inicial
                    
                }
                else if(estadoAnterior==0 && (estadoActual == 1 || estadoActual == 3 ))
                {
                     ll.setLogout( (rs.getTimestamp("fecha").getTime() - ll.getFechaUltimoEstado().getTime()));
                }
                else if((estadoAnterior==1 || estadoAnterior==3) && estadoActual == 0)
                {
                     ll.setLogin((rs.getTimestamp("fecha").getTime() - ll.getFechaUltimoEstado().getTime()));
                }
                 else if(estadoAnterior==1  && estadoActual == 3)
                {
                     ll.setLogin((rs.getTimestamp("fecha").getTime() - ll.getFechaUltimoEstado().getTime()));
                }
                 else if(estadoAnterior==3  && estadoActual == 1)
                {
                     ll.setLogin((rs.getTimestamp("fecha").getTime() - ll.getFechaUltimoEstado().getTime()));
                }
//                else {
//                    ll.setLogout(rs.getTimestamp("fecha").getTime() - ll.getInicioDia().getTime());
//                }
//                ll.setInicioDia(rs.getTimestamp("fecha"));
           //    ll.setUltimo_estado(rs.getInt("estadoActual"));
           ll.setUltimo_estado(estadoActual);
           ll.setFechaUltimoEstado(rs.getTimestamp("fecha"));
            }
            
            if(ll.getUltimo_estado() != -1)
            {
            if (ll.getUltimo_estado() == 1 || ll.getUltimo_estado() == 3 ) {
              ll.setLogin( (ll.getHoraActual().getTime() - ll.getFechaUltimoEstado().getTime()));
            } else if (ll.getUltimo_estado() == 0) {
             ll.setLogout((ll.getHoraActual().getTime() - ll.getFechaUltimoEstado().getTime()));
            }
        }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
    }

    public String obtenerMotivoDesabilitacionAnexo(Connection con, String anexo) {
        String respuesta = "";
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = con.prepareStatement("select * from historico_estados where anexo = ? and estado = 0 order by fecha desc limit 1");
            pst.setString(1, anexo);
            rs = pst.executeQuery();
            if (rs.next()) {
                respuesta = rs.getString("motivo_de_deshabilitacion");
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception e) {
            }
        }
        return respuesta;
    }

    public void obtenerHorarioTrabajoAgente(Connection con, LoginLogout ll) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        Calendar cal;
        String[] listaDias = {"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"};
        try {
            cal = Calendar.getInstance();
            String dia = listaDias[cal.get(Calendar.DAY_OF_WEEK) - 1];
            ll.setDiaBuscado(dia);
            ll.setHoraActual(new Timestamp(cal.getTime().getTime()));
            pst = con.prepareStatement("select * from dias as d "
                    + "left join horarios as h on h.id = d.id_horario "
                    + "left join pilotos as p on p.id_horarios = h.id "
                    + "where d.nombre_dia = ? and p.piloto = ? ");
            pst.setString(1, dia);
            pst.setString(2, ll.getPiloto());

            rs = pst.executeQuery();
            if (rs.next()) {
                ll.setHoraDesde(rs.getString("hora_desde"));
                ll.setHoraHasta(rs.getString("hora_hasta"));
                Calendar calInicioDia = Calendar.getInstance();
                Calendar calTerminoDia = Calendar.getInstance();
                ll.setInicioDia(Timestamp.valueOf(calInicioDia.get(Calendar.YEAR) + "-" + (calInicioDia.get(Calendar.MONTH) + 1) + "-" + calInicioDia.get(Calendar.DATE) + " " + ll.getHoraDesde() + ":00.000000"));
                ll.setTerminoDia(Timestamp.valueOf(calTerminoDia.get(Calendar.YEAR) + "-" + (calTerminoDia.get(Calendar.MONTH) + 1) + "-" + calTerminoDia.get(Calendar.DATE) + " " + ll.getHoraHasta() + ":59.000000"));
                if (ll.getHoraActual().getTime() < ll.getTerminoDia().getTime()) {
                    ll.setTerminoDia(ll.getHoraActual());
                }
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
    }

   public void obtenerLoginAgente(Connection con, LoginLogout ll) {
        obtenerHorarioTrabajoAgente(con, ll);
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = con.prepareStatement("select * from historico_estados where anexo = ? and fecha >= ? and fecha <= ? order by fecha asc ");
            pst.setString(1, ll.getAgente());
            pst.setTimestamp(2, ll.getInicioDia());
            pst.setTimestamp(3, ll.getTerminoDia());
//            pst.setTimestamp(3, ll.getTerminoDia());
            rs = pst.executeQuery();
            while (rs.next()) {
                if (rs.getInt("estado") == 0) {
                    ll.setLogin(rs.getTimestamp("fecha").getTime() - ll.getInicioDia().getTime());
                } else {
                    ll.setLogout(rs.getTimestamp("fecha").getTime() - ll.getInicioDia().getTime());
                }
                ll.setInicioDia(rs.getTimestamp("fecha"));
                ll.setUltimo_estado(rs.getInt("estado"));
            }
            if (ll.getUltimo_estado() == 1) {
                ll.setLogin(ll.getTerminoDia().getTime() - ll.getInicioDia().getTime());
            } else {
                ll.setLogout(ll.getTerminoDia().getTime() - ll.getInicioDia().getTime());
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
    }

    public static String segundosATiempoTheRial(long segundosL) {
        int segundos = (int) (segundosL / 1000);
        int hours = ((int) Math.floor(segundos / 3600));
        String minutes = (int) Math.floor((segundos % 3600) / 60) + "";
        String seconds = segundos % 60 + "";
        String hora = hours < 10 ? "0" + hours : String.valueOf(hours);
        minutes = minutes.length() == 1 ? "0" + minutes : minutes;
        seconds = seconds.length() == 1 ? "0" + seconds : seconds;
        return hora + ":" + minutes + ":" + seconds;

    }

}
