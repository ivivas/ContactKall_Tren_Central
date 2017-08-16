/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package query;

import DTO.Campana;
import DTO.Configuracion;
import adportas.Fechas;
import adportas.SQLConexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;
import javax.naming.NamingException;
import static query.Reckall.hacerOffset;

/**
 *
 * @author Jose
 */
public class IPKall {

    public static Configuracion conf;
    public static String agente_ocupado;

    public static Configuracion configuracionIPKall() {
        Configuracion conf = new Configuracion();
        String query = "select * from configuracion_integracion where clave = 1 ";
        Connection conexion = null;
        try {
            conexion = SQLConexion.conectar();
            PreparedStatement ps = conexion.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                conf.setIpServidor(rs.getString("ip_servidor"));
                conf.setBaseDatos(rs.getString("nombre_bd"));
                conf.setUsuarioBD(rs.getString("user_bd"));
                conf.setClaveBD(rs.getString("clave_bd"));
                conf.setIntegrado(rs.getInt("tiene_integracion") == 1);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                conexion.close();
            } catch (Exception e) {
            }
        }
        return conf;
    }

    public static List<Campana> listaCampanas(Connection con, String cadena, int limit, int offset, boolean tieneLimit) {
        String query = null;
        offset = hacerOffset(limit, offset);
        List<Campana> campanas = new ArrayList();
        try {
            if (tieneLimit) {
                query = "SELECT * FROM campania  where lower(nombre_campania) LIKE lower(?) ORDER BY nombre_campania ASC  LIMIT " + limit + " OFFSET " + offset;
            } else {
                query = "SELECT * FROM campania WHERE estado_campania = 'activa' ORDER BY nombre_campania ASC ";
            }
            PreparedStatement ps = con.prepareStatement(query);
            if (tieneLimit) {
                ps.setString(1, cadena);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Campana campana = new Campana();
                campana.setId(rs.getInt("id_campania"));
                campana.setNombre(rs.getString("nombre_campania"));
                campana.setDescripcion(rs.getString("descripcion_campania"));
                campana.setFechaHoraInicio(Fechas.TimetoString(rs.getTimestamp("inicio_campania")));
                campana.setFechaHoraTermino(Fechas.TimetoString(rs.getTimestamp("fin_campania")));
//                campana.setFechaHoraInicio(rs.getString("inicio_campania"));
//                campana.setFechaHoraTermino(rs.getString("fin_campania"));
                campana.setEstado(rs.getString("estado_campania"));
                campanas.add(campana);
                campana = null;
            }
        } catch (Exception e) {
            if (e instanceof NoFuncoException) {
                e.getMessage();
            }
            e.printStackTrace();
        }
        return campanas;
    }

    public static int totalCampanas(Connection con, String cadena) {
        int total = 0;
        try {
            if (conf == null) {
                throw new NoFuncoException("no se conecto por que los valores de configuracion son los siguientes: host:" + conf.getIpServidor() + ", bd:" + conf.getBaseDatos() + ", user: " + conf.getUsuarioBD() + ", pass: " + conf.getClaveBD());
            }

            String query = "SELECT count(*) as total FROM campania  where lower(nombre_campania) LIKE lower(?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, cadena);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            if (e instanceof NoFuncoException) {
                e.printStackTrace();
            }
            e.printStackTrace();
        }
        return total;
    }

    public static Campana listaCampanasX(Connection con, String id) {
        Campana campana = new Campana();
        try {
            String query = "SELECT * FROM campania  where id_campania = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                campana.setNombre(rs.getString("nombre_campania") != null ? rs.getString("nombre_campania").trim() : "");
                campana.setDescripcion(rs.getString("descripcion_campania") != null ? rs.getString("descripcion_campania").trim() : "");
                campana.setFechaHoraInicio(rs.getTimestamp("inicio_campania") != null ? Fechas.TimetoString(rs.getTimestamp("inicio_campania")) : "");
                campana.setFechaHoraTermino(rs.getTimestamp("fin_campania") != null ? Fechas.TimetoString(rs.getTimestamp("fin_campania")) : "");
//                campana.setFechaHoraInicio(rs.getString("inicio_campania"));
//                campana.setFechaHoraTermino(rs.getString("fin_campania"));
                campana.setEstado(rs.getString("estado_campania") != null ? rs.getString("estado_campania") : "");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return campana;
    }

    public static String generarTablaCamapanas(Connection con, String cadena, int limit, int offset) {
        List<Campana> lista = listaCampanas(con, cadena, limit, offset, true);
        StringBuilder tabla = new StringBuilder();
        for (Campana campana : lista) {
            tabla.append("<tr><td><input type='checkbox' value='");
            tabla.append(campana.getId());
            tabla.append("'></td><td><a href='#' name='");
            tabla.append(campana.getId());
            tabla.append("' id='modificarCampaña'>");
            tabla.append(campana.getNombre());
            tabla.append("</a></td><td>");
            tabla.append(campana.getDescripcion());
            tabla.append("</td><td>");
            tabla.append(campana.getFechaHoraInicio());
            tabla.append("</td><td>");
            tabla.append(campana.getFechaHoraTermino());
            tabla.append("</td><td>");
            tabla.append(campana.getEstado());
            tabla.append("</td></tr>");
        }
        tabla.append("</table>");
        return tabla.toString();
    }

//    public static void main(String[] args) throws ParseException {
//        String fecha = "16-02-2016 00:00:00";
////        Fechas fec = new Fechas();
//        Timestamp fechaFormateada = Fechas.ddmmaa2timePostgres(fecha);
//        System.out.println("fecha: " + fechaFormateada);
//    }
    public static int actualizarDatosCampana(Connection con, int id, String nombre, String descripcion, String inicio, String fin, String estado) {
        int i = 0;
        try {

            String query = "UPDATE campania set nombre_campania = ?,descripcion_campania = ?,inicio_campania=? ,fin_campania=?,estado_campania = ? where id_campania = ?";
//            String query = "UPDATE campania set nombre_campania = ?,descripcion_campania = ?,inicio_campania='" + inicio + "',fin_campania='" + fin + "',estado_campania = ? where id_campania = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setTimestamp(3, Fechas.ddmmaa2timePostgres(inicio));
            ps.setTimestamp(4, Fechas.ddmmaa2timePostgres(fin));
            ps.setString(5, estado);
            ps.setInt(6, id);
            i = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return i;
    }

    public static String comboEstado(String estado, ResourceBundle msj) {
        if (estado.equals("activa")) {
            return "<select id='estado'><option value='activa' selected>" + msj.getString("campana.modificar.combo.activa") + "</option><option value='inactiva'>" + msj.getString("campana.modificar.combo.inactiva") + "</option><option value='completada'>" + msj.getString("campana.modificar.combo.completada") + "</option></select>";
//            return "<select id='estado'><option value='activa' selected>activa</option><option value='inactiva'>inactiva</option><option value='completada'>completada</option></select>";
        } else if (estado.equals("inactiva")) {
            return "<select id='estado'><option value='activa'>" + msj.getString("campana.modificar.combo.activa") + "</option><option value='inactiva' selected>" + msj.getString("campana.modificar.combo.inactiva") + "</option><option value='completada'>" + msj.getString("campana.modificar.combo.completada") + "</option></select>";
//            return "<select id='estado'><option value='activa'>activa</option><option value='inactiva' selected>inactiva</option><option value='completada'>completada</option></select>";
        } else if (estado.equals("completada")) {
            return "<select id='estado'><option value='activa'>" + msj.getString("campana.modificar.combo.activa") + "</option><option value='inactiva'>" + msj.getString("campana.modificar.combo.inactiva") + "</option><option value='completada' selected>" + msj.getString("campana.modificar.combo.completada") + "</option></select>";
//            return "<select id='estado'><option value='activa'>activa</option><option value='inactiva'>inactiva</option><option value='completada' selected>completada</option></select>";
        }
        return "";
    }

    public static int insertarCampaña(String nombre, String desc, String inicio, String fin, String estado) {
        Connection con = null;
        int i = 0;
        try {
            con = SQLConexion.conectaIPKall(conf.getIpServidor(),
                    conf.getBaseDatos(),
                    conf.getUsuarioBD(),
                    conf.getClaveBD());
            //con = SQLConexion.conectaIPKall("localhost", "AcdkallControl_contact", "postgres", "adp2016");
            String query = "INSERT INTO campania (nombre_campania,descripcion_campania,inicio_campania,fin_campania,estado_campania) VALUES (?,?,?,?,?) returning id_campania";
//            String query = "INSERT INTO campania (nombre_campania,descripcion_campania,inicio_campania,fin_campania,estado_campania) VALUES (?,?,'" + inicio + "','" + fin + "',?) returning id_campania";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, nombre);
            ps.setString(2, desc);
            ps.setTimestamp(3, Fechas.ddmmaa2timePostgres(inicio));
            ps.setTimestamp(4, Fechas.ddmmaa2timePostgres(fin));
            ps.setString(5, estado);
            ps.executeQuery();
            ResultSet rs = ps.getResultSet();
            while (rs.next()) {
                i = rs.getInt("id_campania");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return i;
    }

    public static void eliminarCampana(String id) {
        Connection con = null;
        try {
            con = SQLConexion.conectaIPKall(conf.getIpServidor(),
                    conf.getBaseDatos(),
                    conf.getUsuarioBD(),
                    conf.getClaveBD());
            //con = SQLConexion.conectaIPKall("localhost", "AcdkallControl_contact", "postgres", "adp2016");
            eliminarRelacionAgenteCampana(con, id);
            eliminarRelacionClienteCampana(con, id);
            String query = "DELETE FROM campania WHERE id_campania = ? ";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static void eliminarRelacionAgenteCampana(Connection con, String id) {
        try {
            String query = "DELETE FROM agente_campania WHERE id_campania = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void eliminarRelacionAgenteCampanaSupervisor(Connection con, String id, int id_supervisor) {
        try {
            String query = "DELETE FROM agente_campania WHERE id_campania = ? and id_agente in ("
                    + "SELECT id FROM secretaria WHERE piloto_asociado in (select piloto from pilotos where id = ?))";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.setInt(2, id_supervisor);
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void eliminarRelacionAgenteCampanaXAgente(Connection con, String id) {
        try {
            String query = "DELETE FROM agente_campania WHERE id_agente = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void eliminarRelacionClienteCampana(Connection con, String id) {
        try {
            eliminarClienteCampana(con, id);
            String query = "DELETE FROM cliente_campania WHERE id_campania = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void eliminarClienteCampana(Connection con, String id) {
        try {
            String query = "DELETE FROM cliente WHERE id_campania = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String listaAgentesDisponibles(Connection con, int id) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
        StringBuilder agentes = new StringBuilder();
        Connection conControl = SQLConexion.conectar();
        try {
            int ncheckbox = 0;
            int id_campania_actual = id;
            PreparedStatement st = conControl.prepareStatement("SELECT * FROM secretaria ORDER BY nombre ASC ");
//        PreparedStatement st = con.prepareStatement("SELECT * FROM agente ORDER BY nombre_agente ASC ");
            ResultSet rsUsuariosDisponibles = st.executeQuery();
            Statement stg = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsUsuario = stg.executeQuery("SELECT * FROM agente_campania");
            while (rsUsuariosDisponibles.next()) {
                boolean esta_ocupado = false;
                String Usuario_poner = String.valueOf(rsUsuariosDisponibles.getInt("id"));
//                String Usuario_poner = String.valueOf(rsUsuariosDisponibles.getInt("id_agente"));
                rsUsuario.beforeFirst();
                while (rsUsuario.next()) {
                    if (Usuario_poner.equalsIgnoreCase(rsUsuario.getString("id_agente").trim())) {
                        if (rsUsuario.getInt("id_campania") == id_campania_actual) {
                            esta_ocupado = true;
                            break;
                        }
                    } else {
                        esta_ocupado = false;
                    }
                }
                if (esta_ocupado) {
//                if (esta_ocupado && rsUsuario.getInt("id_campania") == id_campania_actual) {
                    agentes.append("<input class=\"clase\" name=\"");
                    agentes.append(rsUsuariosDisponibles.getString("nombre"));
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente") );
                    agentes.append("\" value=\"");
                    agentes.append(Usuario_poner);
                    agentes.append("\" id=\"checko");
                    agentes.append(ncheckbox);
                    agentes.append("\" type=\"checkbox\" checked>");
                    agentes.append(rsUsuariosDisponibles.getString("anexo") != null ? rsUsuariosDisponibles.getString("anexo").trim() : "");
//                    agentes.append(" - ");
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? " - " + rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente"));
                    agentes.append("<br>");
                    ncheckbox++;
                } else //                    if (esta_ocupado == false) 
                {
                    agentes.append("<input class=\"clase\" name=\"");
                    agentes.append(rsUsuariosDisponibles.getString("nombre"));
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente") );
                    agentes.append("\" value=\"");
                    agentes.append(Usuario_poner);
                    agentes.append("\" id=\"checko");
                    agentes.append(ncheckbox);
                    agentes.append("\" type=\"checkbox\">");
                    agentes.append(rsUsuariosDisponibles.getString("anexo") != null ? rsUsuariosDisponibles.getString("anexo").trim() : "");
//                    agentes.append(" - ");
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? " - " + rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente"));
                    agentes.append("<br>");
                    ncheckbox++;
                }
            }
            rsUsuario.close();
            rsUsuariosDisponibles.close();
            stg.close();
        } catch (Exception e) {
            if (e instanceof NoFuncoException) {
                System.out.println("excepcion noFuncoException");
            } else {
                e.printStackTrace();
            }
        } finally {
            try {
                if (conControl != null) {
                    conControl.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
        return agentes.toString();
    }

//    public static String panelClientes(){}
    public static String listaAgentesDisponiblesSupervisor(Connection con, int id, int id_supervisor) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException, NamingException {
        StringBuilder agentes = new StringBuilder();
        Connection conControl = SQLConexion.conectar();
        try {
            int ncheckbox = 0;
            int id_campania_actual = id;
            PreparedStatement st = conControl.prepareStatement("SELECT * FROM secretaria WHERE piloto_asociado in ("
                    + "select piloto from pilotos where id = " + id_supervisor + ") ORDER BY nombre ASC");
//            PreparedStatement st = conControl.prepareStatement("SELECT * FROM secretaria ORDER BY nombre ASC ");
//        PreparedStatement st = con.prepareStatement("SELECT * FROM agente ORDER BY nombre_agente ASC ");
            ResultSet rsUsuariosDisponibles = st.executeQuery();
            Statement stg = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsUsuario = stg.executeQuery("SELECT * FROM agente_campania");
            while (rsUsuariosDisponibles.next()) {
                boolean esta_ocupado = false;
                String Usuario_poner = String.valueOf(rsUsuariosDisponibles.getInt("id"));
//                String Usuario_poner = String.valueOf(rsUsuariosDisponibles.getInt("id_agente"));
                rsUsuario.beforeFirst();
                while (rsUsuario.next()) {
                    if (Usuario_poner.equalsIgnoreCase(rsUsuario.getString("id_agente").trim())) {
                        if (rsUsuario.getInt("id_campania") == id_campania_actual) {
                            esta_ocupado = true;
                            break;
                        }
                    } else {
                        esta_ocupado = false;
                    }
                }
                if (esta_ocupado) {
//                if (esta_ocupado && rsUsuario.getInt("id_campania") == id_campania_actual) {
                    agentes.append("<input class=\"clase\" name=\"");
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente") );
                    agentes.append("\" value=\"");
                    agentes.append(Usuario_poner);
                    agentes.append("\" id=\"checko");
                    agentes.append(ncheckbox);
                    agentes.append("\" type=\"checkbox\" checked>");
                    agentes.append(rsUsuariosDisponibles.getString("anexo") != null ? rsUsuariosDisponibles.getString("anexo").trim() : "");
//                    agentes.append(" - ");
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? " - " + rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente"));
                    agentes.append("<br>");
                    ncheckbox++;
                } else //                    if (esta_ocupado == false) 
                {
                    agentes.append("<input class=\"clase\" name=\"");
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente") );
                    agentes.append("\" value=\"");
                    agentes.append(Usuario_poner);
                    agentes.append("\" id=\"checko");
                    agentes.append(ncheckbox);
                    agentes.append("\" type=\"checkbox\">");
                    agentes.append(rsUsuariosDisponibles.getString("anexo") != null ? rsUsuariosDisponibles.getString("anexo").trim() : "");
//                    agentes.append();
                    agentes.append(rsUsuariosDisponibles.getString("nombre") != null ? " - " + rsUsuariosDisponibles.getString("nombre").trim() : "");
//                agentes.append(rsUsuariosDisponibles.getString("nombre_agente"));
                    agentes.append("<br>");
                    ncheckbox++;
                }
            }
            rsUsuario.close();
            rsUsuariosDisponibles.close();
            stg.close();
        } catch (Exception e) {
            if (e instanceof NoFuncoException) {
                System.out.println("excepcion noFuncoException");
            } else {
                e.printStackTrace();
            }
        } finally {
            try {
                if (conControl != null) {
                    conControl.close();
                }
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
        return agentes.toString();
    }

    public static String validarAgentesOcupadosEnOtrasCampañas(String agente, String inicio, String termino) {
        String respuesta = "";
        String[] algo = agente.split("-");
//        if (agente != null) {
        for (String id_agente : algo) {
            Connection conexion = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            try {
                conexion = SQLConexion.conectaIPKall(conf.getIpServidor(),
                        conf.getBaseDatos(),
                        conf.getUsuarioBD(),
                        conf.getClaveBD());
                //conexion = SQLConexion.conectaIPKall("localhost", "AcdkallControl_contact", "postgres", "adp2016");
                pst = conexion.prepareStatement("select * from campania where id_campania in ("
                        + "select id_campania from agente_campania where id_agente = ?)");
                pst.setInt(1, Integer.parseInt(id_agente));
                rs = pst.executeQuery();
                boolean flagAgente = true;
                while (rs.next() && flagAgente) {
                    Timestamp inicioBD = rs.getTimestamp("inicio_campania");
                    Timestamp terminoBD = rs.getTimestamp("fin_campania");
                    Timestamp inicioNuevaCampania = Fechas.ddmmaa2timePostgres(inicio);
                    Timestamp terminoNuevaCampania = Fechas.ddmmaa2timePostgres(termino);
                    if (inicioNuevaCampania.getTime() >= inicioBD.getTime() && inicioNuevaCampania.getTime() <= terminoBD.getTime()
                            || terminoNuevaCampania.getTime() >= inicioBD.getTime() && terminoNuevaCampania.getTime() <= terminoBD.getTime()) {
                        flagAgente = false;
//                        respuesta += id_agente + "\n";
                        respuesta += "Agente:" + buscaAnexoNombreSecretariaXID(conexion, id_agente) + " Campa&ntilde;a:" + (rs.getString("nombre_campania") != null ? rs.getString("nombre_campania").trim() : "") + "<br>";
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (pst != null) {
                    try {
                        pst.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (conexion != null) {
                    try {
                        conexion.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

        }
//        }
        if (respuesta.equals("")) {
            respuesta = "ok";
        }
        return respuesta;
    }

    public static String validarAgentesOcupadosEnOtrasCampañasModificar(String agente, String inicio, String termino, String id_campana) {
        String respuesta = "";
        String[] algo = agente.split("-");
//        if (agente != null) {
        for (String id_agente : algo) {
            Connection conexion = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            try {
                conexion = SQLConexion.conectaIPKall(conf.getIpServidor(),
                        conf.getBaseDatos(),
                        conf.getUsuarioBD(),
                        conf.getClaveBD());
                pst = conexion.prepareStatement("select * from campania where id_campania in ("
                        + "select id_campania from agente_campania where id_agente = ?) and id_campania != ?");
                pst.setInt(1, Integer.parseInt(id_agente));
                pst.setInt(2, Integer.parseInt(id_campana));
                rs = pst.executeQuery();
                boolean flagAgente = true;
                while (rs.next() && flagAgente) {
                    Timestamp inicioBD = rs.getTimestamp("inicio_campania");
                    Timestamp terminoBD = rs.getTimestamp("fin_campania");
                    Timestamp inicioNuevaCampania = Fechas.ddmmaa2timePostgres(inicio);
                    Timestamp terminoNuevaCampania = Fechas.ddmmaa2timePostgres(termino);
                    if (inicioNuevaCampania.getTime() >= inicioBD.getTime() && inicioNuevaCampania.getTime() <= terminoBD.getTime()
                            || terminoNuevaCampania.getTime() >= inicioBD.getTime() && terminoNuevaCampania.getTime() <= terminoBD.getTime()) {
                        flagAgente = false;
//                        respuesta += id_agente + "\n";
                        respuesta += "Agente:" + buscaAnexoNombreSecretariaXID(conexion, id_agente) + " Campa&ntilde;a:" + (rs.getString("nombre_campania") != null ? rs.getString("nombre_campania").trim() : "") + "<br>";
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (pst != null) {
                    try {
                        pst.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (conexion != null) {
                    try {
                        conexion.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

        }
//        }
        if (respuesta.equals("")) {
            respuesta = "ok";
        }
        return respuesta;
    }

    public static void insertarColaboradores(String agentes, String clientes, int campana) {
        Connection conexion = null;
        try {
            conexion = SQLConexion.conectaIPKall(conf.getIpServidor(),
                    conf.getBaseDatos(),
                    conf.getUsuarioBD(),
                    conf.getClaveBD());
            //conexion = SQLConexion.conectaIPKall("localhost", "AcdkallControl_contact", "postgres", "adp2016");
            String[] idsAgentes = agentes.split("-");
            String[] infoClientes = clientes.split("--");
            if (!agentes.equals("")) {
                insertarRelacionCampanaAgente(conexion, idsAgentes, campana);
            }
            if (!clientes.equals("")) {
                insertarRelacionCampanaCliente(conexion, insertarClientes(conexion, infoClientes, campana), campana);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conexion.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static void insertarRelacionCampanaAgente(Connection con, Object[] idsAgentes, int campana) {
        try {
            String query = "INSERT INTO agente_campania (id_agente,id_campania) VALUES (?,?)";
            for (int j = 0; j < idsAgentes.length; j++) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(idsAgentes[j].toString()));
                ps.setInt(2, campana);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static List insertarClientes(Connection con, String[] infoClientes, int campana) {
        List idsClientes = new ArrayList();
        try {
            String query = "INSERT INTO cliente (nombre_cliente,apellido_cliente,telefono_cliente,criterio_cliente,fecha,telefono_cliente2,rut_cliente,id_campania,fk_id_horario) VALUES (?,?,?,'no conectado',now(),?,?,?,?) returning id_cliente";
            int id_horario = idHorarioDef(con);
            for (int i = 0; i < infoClientes.length; i++) {
                try {
                    String[] infoClinte = infoClientes[i].split(";");
                    PreparedStatement ps = con.prepareStatement(query);
                    ps.setString(1, infoClinte[0]);
                    ps.setString(2, infoClinte[1]);
                    ps.setString(3, infoClinte[3]);
                    ps.setString(4, infoClinte[4]);
                    ps.setString(5, infoClinte[2]);
                    ps.setInt(6, campana);
                    ps.setInt(7, id_horario);
                    ps.executeQuery();
                    ResultSet rs = ps.getResultSet();
                    while (rs.next()) {
                        idsClientes.add(rs.getInt("id_cliente"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return idsClientes;
    }

    private static int idHorarioDef(Connection con) {
        int id = 0;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement("select id_horario from horario_agente where is_default = 1");
//            ps = con.prepareStatement("select id_horario from horario where is_default = 1");
            rs = ps.executeQuery();
            if (rs.next()) {
                id = rs.getInt("id_horario");
            } else {
                ps = con.prepareStatement("select id_horario from horario_agente order by 1 limit 1 ");
//                ps = con.prepareStatement("select id_horario from horario order by 1 limit 1 ");
                rs = ps.executeQuery();
                if (rs.next()) {
                    id = rs.getInt("id_horario");
                }
            }
        } catch (Exception e) {
            System.out.println("Error en idHorarioDef: " + e);
        } finally {
            try {
                ps.close();
                rs.close();
            } catch (Exception e) {
            }
        }
        return id;
    }

    private static void insertarRelacionCampanaCliente(Connection con, List idsClientes, int campana) {
        try {
            String query = "INSERT INTO cliente_campania (id_cliente,id_campania) VALUES (?,?)";
            for (int j = 0; j < idsClientes.size(); j++) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(idsClientes.get(j).toString()));
                ps.setInt(2, campana);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String datosAgentes(Connection con, int campana) {
        StringBuilder agentes = new StringBuilder();
        String query = "select agente.id as id_agente ,agente.nombre as nombre_agente,agente.anexo as anexo from secretaria as agente join agente_campania ac on agente.id = ac.id_agente join campania c on ac.id_campania = c.id_campania and c.id_campania = ?";
//        String query = "select agente.id_agente,nombre_agente,anexo from agente join agente_campania ac on agente.id_agente = ac.id_agente join campania c on ac.id_campania = c.id_campania and c.id_campania = ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, campana);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                agentes.append("<input name=\"");
                agentes.append(rs.getString("nombre_agente"));
                agentes.append("\" value=\"");
                agentes.append(rs.getString("id_agente"));
                agentes.append("\" type=\"checkbox\" checked>");
                agentes.append(rs.getString("anexo"));
                agentes.append(" - ");
                agentes.append(rs.getString("nombre_agente"));
                agentes.append("<br>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return agentes.toString();
    }

    public static String datosClientes(Connection con, int campana) {
        StringBuilder clientes = new StringBuilder();
        String consulta = "select * from cliente where id_campania = ? and criterio_cliente != 'conectado' and criterio_cliente != 'rechazado'";
        try {
            PreparedStatement ps = con.prepareStatement(consulta);
            ps.setInt(1, campana);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {//nombre;apellido;rut;num1;num2
//                clientes.append("<div class='cursor' id='");
//                String name = rs.getString("nombre_cliente") != null ? rs.getString("nombre_cliente").trim() : "";
//                clientes.append(name);
//                clientes.append(";");
//                String lstName = rs.getString("apellido_cliente") != null ? rs.getString("apellido_cliente").trim() : "";
//                clientes.append(lstName);
//                clientes.append(";");
//                String rut = rs.getString("rut_cliente") != null ? rs.getString("rut_cliente").trim() : "";
//                clientes.append(rut);
//                clientes.append(";");
//                clientes.append(rs.getString("telefono_cliente"));
//                clientes.append(";");
//                clientes.append(rs.getString("telefono_cliente2"));
//                clientes.append("' onclick='quitar(this)'>");
//                //clientes.append(rs.getString("nombre_cliente"));
//                String dato = rs.getString("nombre_cliente") != null ? rs.getString("nombre_cliente").trim() : rs.getString("telefono_cliente");
//                clientes.append(dato);
//                clientes.append("</div>");

                clientes.append("<input name=\"");
                clientes.append(rs.getString("nombre_cliente") != null ? rs.getString("nombre_cliente").trim() : "");
                clientes.append("\" id=\"");
                String name = rs.getString("nombre_cliente") != null ? rs.getString("nombre_cliente").trim() : "";
                clientes.append(name);
                clientes.append(";");
                String lstName = rs.getString("apellido_cliente") != null ? rs.getString("apellido_cliente").trim() : "";
                clientes.append(lstName);
                clientes.append(";");
                String rut = rs.getString("rut_cliente") != null ? rs.getString("rut_cliente").trim() : "";
                clientes.append(rut);
                clientes.append(";");
                clientes.append(rs.getString("telefono_cliente"));
                clientes.append(";");
                
                clientes.append(rs.getString("telefono_cliente2"));
                
                clientes.append("\" value=\"");
                clientes.append(rs.getString("id_cliente"));
                clientes.append("\" type=\"checkbox\" checked>");
                clientes.append(rs.getString("telefono_cliente") != null ? rs.getString("telefono_cliente").trim() : "");
//                clientes.append(" - ");
clientes.append(rs.getString("fecha_ultimo_contacto") != null ? " - " + formatearFechaAFormatoChileno(new Date(rs.getTimestamp("fecha_ultimo_contacto").getTime())) : "");
                clientes.append(rs.getString("nombre_cliente") != null ? " - " + rs.getString("nombre_cliente").trim() : "");
                clientes.append("<br>");

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clientes.toString();
    }
public static String formatearFechaAFormatoChileno(Date date)
{
    String respuesta = "";
    
    SimpleDateFormat dt1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    respuesta = dt1.format(date);
System.out.println(respuesta);
    return respuesta;
}
    public static void validarRelacionesExistentes(Connection con, String agentes, String clientes, int campana, String session, int id_supervisor) {
        try {
            List relacionesAgente = obtenerRelacion(con, campana, "agente");
            List relacionesClientes = obtenerRelacion(con, campana, "cliente");
            comprobarCambiosParaActualizarAgentes(con, agentes, relacionesAgente, campana, session, id_supervisor);
            comprobarCambiosParaActualizarClientes(con, clientes, relacionesClientes, campana);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List obtenerRelacion(Connection con, int campana, String entidad) {
        List lista = new ArrayList();
        String query = "select id_" + entidad + " from " + entidad + "_campania where id_campania = ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, campana);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(rs.getInt("id_" + entidad));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    private static void comprobarCambiosParaActualizarAgentes(Connection con, String agentesNuevos, List agentesActuales, int campana, String sesionActual, int id_supervisor) {
        List agentesAAgregar = new ArrayList();
        String[] agentes = agentesNuevos.split("-");
        boolean noInserto = true;
        if (agentesActuales.isEmpty()) {
            insertarRelacionCampanaAgente(con, agentes, campana);
            agentesNuevos = "";
            noInserto = false;
        } else {
            if (sesionActual.equalsIgnoreCase("supervisor")) {
                eliminarRelacionAgenteCampanaSupervisor(con, campana + "", id_supervisor);
            } else {
                eliminarRelacionAgenteCampana(con, campana + "");
            }
            if (!agentesNuevos.equals("")) {
                String[] agentesX = agentesNuevos.split("-");
                agentesAAgregar.addAll(Arrays.asList(agentesX));
            }
        }
        if (noInserto) {
            insertarRelacionCampanaAgente(con, agentesAAgregar.toArray(), campana);
        }
    }

    private static void comprobarCambiosParaActualizarClientes(Connection con, String clientesNuevos, List clientesActuales, int campana) {
        List clientesAAgregar = new ArrayList();
        String[] clientes = clientesNuevos.split("--");
        boolean noInserto = true;
        if (clientesActuales.isEmpty() & !clientesNuevos.equals("")) {
            insertarRelacionCampanaCliente(con, insertarClientes(con, clientes, campana), campana);
            clientesNuevos = "";
            noInserto = false;
        } else {
            eliminarClienteCampana(con, campana + "");
            eliminarRelacionClienteCampana(con, campana + "");
            if (!clientesNuevos.equals("")) {
                String[] agentesX = clientesNuevos.split("-");
                clientesAAgregar.addAll(Arrays.asList(agentesX)); //}
            }
        }
        if (noInserto) {
            eliminarClienteCampana(con, campana + "");
            eliminarRelacionClienteCampana(con, campana + "");
            insertarClientes(con, clientes, campana);
            insertarRelacionCampanaAgente(con, clientesAAgregar.toArray(), campana);
        }
    }

    public static boolean noEstaEnIpKall(Connection con, String anexo) {
        String query = "select count(*) as esta from secretaria where anexo = ?";
//        String query = "select count(*) as esta from agente where anexo = ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, anexo);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (rs.getInt("esta") == 0) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static String buscaAnexoNombreSecretariaXID(Connection con, String id_anexo) {
        String respuesta = "";
        String query = "select * from secretaria where id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(id_anexo));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                respuesta = rs.getString("anexo") != null ? rs.getString("anexo").trim() : "";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }

    public static void insertarAgente(Connection con, String anexo, String nombreCompleto, String sep) {
        String[] nombre = nombreCompleto.split(" ");
        try {
            String query = "INSERT INTO secretaria (nombre,estado_agente,anexo,sep,usuario,clave,fecha_creacion_agente) VALUES (?,0,?,?,'admin','admin',now())";
//            String query = "INSERT INTO agente (nombre_agente,apellido_agente,estado_agente,anexo,sep,usuario,clave,fecha_creacion_agente) VALUES (?,?,0,?,?,'admin','admin',now())";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, nombre[0] + " " + nombre[1]);
            ps.setString(3, anexo);
            ps.setString(4, sep);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String campanasModuloSupervisor(Connection con) {
        StringBuilder sB = new StringBuilder();
        List<Campana> lista = listaCampanas(con, null, 0, 0, false);
        for (Campana campana : lista) {
            sB.append("<input type='radio' name='campana' value='");
            sB.append(campana.getId());
            sB.append("'>");
            sB.append(campana.getNombre());
            sB.append("<br>");
        }
        return sB.toString();
    }
}
