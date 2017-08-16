package query;

import DTO.Combo;
import DTO.Opcion;
import adportas.SQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

public class ComboQuery{
  
    private Connection con = null;
    private String query = null;
    static StringBuilder menu = new StringBuilder();
    
    public ComboQuery(Connection con) {
        this.con = con;
    }

    public ComboQuery() {

    }

    public ResourceBundle getIdioma(String idioma){
        ResourceBundle texto = null;
        if(idioma.equalsIgnoreCase("es")){
            Locale locale = new Locale.Builder().setLanguageTag("es").setRegion("cl").build();
            ResourceBundle.clearCache();
            texto = ResourceBundle.getBundle("bundle.fichero", locale); 
        }else if(idioma.equalsIgnoreCase("pt")){
            Locale locale = new Locale.Builder().setLanguageTag("pt").setRegion("br").build();
            ResourceBundle.clearCache();
            texto = ResourceBundle.getBundle("bundle.fichero", locale);
        } 
        return  texto;
    }
    
    public Combo getComboXNombre(String nombreCombo){
        Combo combo = null;

        this.query = "select o.*,c.id as id_combo,c.nombre as nombre_combo from opciones_combo as o, combos as c where c.nombre = ? and c.id = o.id_combo";
        try {
            combo = new Combo();
            PreparedStatement ps = this.con.prepareStatement(this.query);
            ps.setString(1, nombreCombo);
            ResultSet rs = ps.executeQuery();

            ArrayList listaOpciones = new ArrayList();

            int contador = 0;
            while (rs.next()) {
                if (contador == 0){
                    if (rs.getString("nombre_combo") != null) {
                        combo.setNombre(rs.getString("nombre_combo").trim());
                    }
                    int id = rs.getInt("id_combo");
                    combo.setId(id);
                    contador++;
                }
                Opcion dto = new Opcion();
                dto.setId(rs.getInt("id"));
                if (rs.getString("valor") != null){
                    dto.setValor(rs.getString("valor").trim());
                }else {
                    dto.setValor("");
                }
                if (rs.getString("texto") != null){
                    dto.setTexto(rs.getString("texto").trim());
                }else {
                    dto.setTexto("");
                }
                //System.out.println("dto.getTexto()" + dto.getTexto());
                listaOpciones.add(dto);
            }
            rs.close();
            ps.close();
            combo.setListaOpciones(listaOpciones);
        }catch (Exception ex){
            System.out.println(ex);
        }
        return combo;
    }
  
    public static List getComboRuteo(){
        List lista = new ArrayList();
        lista.add("0");
        lista.add("1");
        lista.add("2");
        lista.add("3");
        return lista;
    }

    public static String getRuteoEnPalabras(int id,ResourceBundle texto){
        String letras = null;
        switch(id){
            case 0:
                letras =  texto.getString("virtual.idle");
                break;
            case 1:
                letras = texto.getString("virtual.topdown");
                break;
            case 2:
                letras = texto.getString("virtual.circular");
                break;
            case 3:
                letras =  texto.getString("virtual.broadcast");
                break;
        }
        return letras;
    }

    public int modificarEspera(String largo){
        int i = 0;
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "update configuraciones configuraciones set valor = ? where dato = 'intervaloDeEsperaParaQueSuenenLosTelefonos'";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, largo+"000");
            i = ps1.executeUpdate();
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
        return  i;
    }
    
    public static String comboPiloto(Connection con,String req,String usuario, String perfil) throws SQLException{
        StringBuilder comboPiloto = new StringBuilder();
        comboPiloto.append("<option value=''>Seleccione...</option>");
        if(perfil.equals("adm_general")){
            for(String piloto : listaPilotos(con)){
                if(req.endsWith(piloto)){
                    comboPiloto.append("<option value='");
                    comboPiloto.append(piloto);
                    comboPiloto.append("' selected>");
                    comboPiloto.append(piloto);
                    comboPiloto.append("</option>");
                }else{
                    comboPiloto.append("<option value='");
                    comboPiloto.append(piloto);
                    comboPiloto.append("'>");
                    comboPiloto.append(piloto);
                    comboPiloto.append("</option>");
                }
            }
        }else{
            String piloto = listaPiloto(con,usuario);
            comboPiloto.append("<option value='");
            comboPiloto.append(piloto);
            comboPiloto.append("' selected>");
            comboPiloto.append(piloto);
            comboPiloto.append("</option>");
        }
        return comboPiloto.toString();
    }
    
    public static List<String> listaPilotos(Connection con) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto,descripcion from pilotos order by piloto";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    public static String listaPiloto(Connection con,String usuario) throws SQLException{
        String piloto="";
        int idp = SesionQuery.idPilotoSesion(usuario);
        try {
            String consulta = "select piloto,descripcion from pilotos where id = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setInt(1, idp);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                piloto = rs.getString("piloto");
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  piloto;
    }
    
    
    public static List<String> listaPilotos2(Connection con, String sesion, String idPiloto) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "";
            if(sesion.equals("supervisor")){
                consulta = "select piloto,descripcion from pilotos where id = "+idPiloto;
            }else{
                consulta = "select piloto,descripcion from pilotos order by 1";
            }
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto")+"%"+rs.getString("descripcion"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    
    public static List<String> listaPilotos2(Connection con) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto,descripcion from pilotos order by 1";
            
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto")+"%"+rs.getString("descripcion"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    
    public static List<String> listaPilotos3(Connection con) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto,descripcion from pilotos order by piloto";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto")+" - "+rs.getString("descripcion"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    public static List<String> listaPilotos3(Connection con, int idPiloto) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto,descripcion from pilotos where id = ? ";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setInt(1,idPiloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto")+" - "+rs.getString("descripcion"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    
    public static List<String> listaSecretaria(String piloto,String campo) throws SQLException{
        List secretaria = new ArrayList();
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            StringBuilder consulta = new StringBuilder();
            consulta.append("select anexo,sep,nombre,estado,estado_uso from secretaria where piloto_asociado = ? order by ");
            consulta.append(campo);
            consulta.append(" desc");
            PreparedStatement ps1 = con.prepareStatement(consulta.toString());
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo")+"%"+rs.getString("nombre")+"%"+rs.getInt("estado")+"%"+rs.getInt("estado_uso")+"%"+rs.getString("sep"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }finally{
            con.close();
        }
        return  secretaria;
    }
    
    public static List<String> listaSecretaria(Connection con,String piloto,String campo) throws SQLException{
        List secretaria = new ArrayList();
        try {
            StringBuilder consulta = new StringBuilder();
            consulta.append("select anexo,sep,nombre,estado,estado_uso from secretaria where piloto_asociado = ? order by ");
            consulta.append(campo);
            consulta.append(" desc");
            PreparedStatement ps1 = con.prepareStatement(consulta.toString());
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo")+"%"+rs.getString("nombre")+"%"+rs.getInt("estado")+"%"+rs.getInt("estado_uso")+"%"+rs.getString("sep"));
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  secretaria;
    }
    
    public static String listaSecretariaUnica(Connection con,String anexo) throws SQLException{
        try {
            StringBuilder consulta = new StringBuilder();
            consulta.append("select anexo,sep,nombre,estado,estado_uso from secretaria where anexo = ?");
            PreparedStatement ps1 = con.prepareStatement(consulta.toString());
            ps1.setString(1, anexo);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                return rs.getString("anexo")+"%"+rs.getString("nombre")+"%"+rs.getInt("estado")+"%"+rs.getInt("estado_uso")+"%"+rs.getString("sep");
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  "";
    }
    
    public static List<String> listaSecretaria(Connection con,String piloto) throws SQLException{
        List secretaria = new ArrayList();
        try {
            String consulta = "select anexo from secretaria where piloto_asociado = ? ";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  secretaria;
    }
    
    public static List<String> listaSecretariaACD() throws SQLException{
        List secretaria = new ArrayList();
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select anexo,nombre,sep from secretaria";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo")+"%"+rs.getString("nombre")+"%"+rs.getString("sep"));
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            con.close();
        }
            return  secretaria;
  }
    public static List<String> listaSecretariaACD2(Connection con) throws SQLException{
        List secretaria = new ArrayList();
        try {
            String consulta = "select anexo from secretaria";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo"));
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }

            return  secretaria;
  }
    public static List<String> listaSecretaria2(String piloto) throws SQLException{
        List secretaria = new ArrayList();
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            StringBuilder consulta = new StringBuilder();
            consulta.append("select anexo,nombre,estado,estado_uso from secretaria where piloto_asociado = ? order by anexo");
            PreparedStatement ps1 = con.prepareStatement(consulta.toString());
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo"));
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            con.close();
        }
            return  secretaria;
  }
    public static List<String> listaSecretariaNombre() throws SQLException{
        List secretaria = new ArrayList();
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            StringBuilder consulta = new StringBuilder();
            consulta.append("select nombre from secretaria ");
            PreparedStatement ps1 = con.prepareStatement(consulta.toString());
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("nombre"));
            }
            ps1.close();
        }
        catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            con.close();
        }
            return  secretaria;
  }
    public int modificarBienvenida(String tiene){
        int i = 0;
        String valor = "";
        if(tiene.equals("on")){
            valor = "1";
        }else{
            valor = "0";
        }
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "update configuraciones configuraciones set valor = ?  where dato = 'tieneMusicaBienvenidaDirectoAlPiloto'";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, valor);
            i = ps1.executeUpdate();
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
            return  i;
    }
    
    public String getTieneMusica(ResourceBundle texto){
       Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select * from configuraciones where dato = 'tieneMusicaBienvenidaDirectoAlPiloto'";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs1 = ps1.executeQuery();
            int i = 0;
            while (rs1.next()) {
                if(rs1.getString("valor").equals("1")){
                    return "checked";
                }
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
            return  "";
    }
    
    public String[] getEspera(ResourceBundle texto){
        String[] datos = new String[2];
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            String consulta = "select * from configuraciones where dato = 'intervaloDeEsperaParaQueSuenenLosTelefonos'";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs1 = ps1.executeQuery();
            int i = 0;
            while (rs1.next()) {
                    datos[i] = rs1.getString("valor").replace("000","")+"&"+ texto.getString("intervalo.uno");
            }
            rs1.close();
            ps1.close();
        }
        catch (Exception ex1) {
            ex1.printStackTrace();
        }
        finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
            return  datos;
    }
    
    public static String comboTipoCtiPort(String sel){
        if(sel.equals("musicaEspera")){
            return "<option value='musicaEspera' selected>M&uacute;sica espera</option><option value='fuerahora'>Fuera de hora</option><option value='bienvenida'>Bienvenida</option>";
        }
        else if(sel.equals("fueraHora")){
            return "<option value='musicaEspera'>M&uacute;sica espera</option><option value='fuerahora' selected>Fuera de hora</option><option value='bienvenida'>Bienvenida</option>";      
        }
        else{
            return "<option value='musicaEspera'>M&uacute;sica espera</option><option value='fuerahora'>Fuera de hora</option><option value='bienvenida' selected>Bienvenida</option>";
        }
  }
    
    public static String pilotosYaControldados(){
        StringBuilder resultado = new StringBuilder();
        String query ="select distinct(id_piloto) from pilotos_monitores;";
        Connection con = null;
        try {
            con = SQLConexion.conectar();
            PreparedStatement ps1 = con.prepareStatement(query);
            ResultSet rs1 = ps1.executeQuery();
            int i = 0;
            while (rs1.next()) {
                resultado.append("'");
                resultado.append(rs1.getString("id_piloto"));
                resultado.append("',");
            }
            rs1.close();
            ps1.close();
        } catch (Exception ex1) {
           ex1.printStackTrace();
        }
        finally{
            try {
                con.close();
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
        }
        try{
            return resultado.substring(0,resultado.length()-1);
        }
        catch(Exception e){
            return "";
        }
    }
    public static String getAnexoSupervisor(Connection con,String supervisor){
        try {
            boolean esSupervisor = true;
            String consulta = "select anexo,sep from secretaria c join sesion_secretaria d on c.id = d.id_secretaria join sesion on d.id_sesion = sesion.id where sesion.usuario = ? and d.tipo = 0";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, supervisor);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                esSupervisor = false;
              return rs1.getString("anexo")+"-"+rs1.getString("sep");
            }
            if(esSupervisor){
                consulta = "select extension,devicename from monitores c join sesion_secretaria d on c.id = d.id_secretaria join sesion on d.id_sesion = sesion.id where sesion.usuario = ? and d.tipo = 1";
                ps1 = con.prepareStatement(consulta);
                ps1.setString(1, supervisor);
                rs1 = ps1.executeQuery();
                if(rs1.next()) {
                return rs1.getString("extension")+"-"+rs1.getString("devicename");
            }
            rs1.close();
            ps1.close();
            }
        }
        catch (Exception ex1) {
            ex1.printStackTrace();
        }
        return "";
    }
    public static String menu(){
        if(menu.length()==0){
            menu.append("<a href='habilitador.jsp' class='btnMenu btnhabilitado'>%menu_btn_hdext%</a>");
            menu.append("<a href='disponibilidad.jsp'class='btnMenu btncola'>%menu_btn_cola%</a>");
            menu.append("<a href='grabaciones.jsp'  class='btnMenu btncola'>%menu_btn_grabaciones%</a>");
            menu.append("<a href='configuracion.jsp' class=\"btnMenu btnconfi\">%menu_btn_conf%</a>");
            menu.append("<a href='piloto.jsp' ><img src='imagenes/agente.png'></a>");
            menu.append("<a href='agentes.jsp' ><img src='imagenes/agente.png'></a>");
        }
        return menu.toString();
    }
    public static String estadoAgente(Connection con,String anexo){
        StringBuilder enlace = new StringBuilder();
        try {
            String consulta = "select estado from secretaria where anexo = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, anexo);
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) {
                int estado = rs1.getInt("estado");
                if(estado == 1){
                    enlace.append("<div id='estadox'>Habilitado</div><a href='#' onclick=\"hd('agente')\">");
                    enlace.append("H/D");
                }
                else{
                    enlace.append("<div id='estadox'>Desabilitado</div><a href='#' onclick=\"hd('agente')\">");
                    enlace.append("H/D");
                }
                enlace.append("</a>");
                
            }
            rs1.close();
            ps1.close();
        }
        catch (Exception ex1) {
            ex1.printStackTrace();
        }
        return enlace.toString();
    }
    public static String listaAnexosPool(Connection con,String piloto){
        StringBuilder in = new StringBuilder();
        try {
            String consulta = "select anexo from secretaria where piloto_asociado = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                in.append("'");
                in.append(rs.getString("anexo"));
                in.append("',");
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        try{
        return  in.substring(0,in.length()-1);
        }
        catch(Exception e){
            return "";
        }
    }
        public static List<Object> listaSecretariaArray(Connection con, String piloto) {
            List<Object> lista = new ArrayList();
        try {
            String consulta = "select anexo from secretaria where piloto_asociado = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                lista.add(rs.getString("anexo"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return lista;
    }
        public static List<String> listaPilotosXSupervisor(Connection con) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto from pilotos p join pilotos_monitores pm on p.id = pm.id_piloto join monitores m on pm.id_monitor = m.id;";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    public static List<String> listaPilotosXSupervisor(Connection con,String extensionMonitor) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "select piloto from pilotos p join pilotos_monitores pm on p.id = pm.id_piloto join monitores m on pm.id_monitor = m.id where m.extension = ?;";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, extensionMonitor);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
    public static List<String> listaPilotosXSupervisor2(Connection con,int id) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "Select distinct(piloto_asociado) FROM secretaria s, pilotos p where p.piloto = s.piloto_asociado and p.id = ? order by 1";
//            String consulta = "select piloto from pilotos p join pilotos_monitores pm on p.id = pm.id_piloto join monitores m on pm.id_monitor = m.id where m.extension = ?;";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto_asociado"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
        public static List<String> listaPilotosXSupervisorNombre(Connection con,String extensionMonitor) throws SQLException{
        List pilotos = new ArrayList();
        try {
            String consulta = "Select distinct(piloto_asociado),p.descripcion FROM secretaria s, pilotos p where p.piloto = s.piloto_asociado and p.id = ?";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, extensionMonitor);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                pilotos.add(rs.getString("piloto")+" - "+rs.getString("descripcion"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        return  pilotos;
    }
        
    public static List<String> listaSecretariaMasNombre(Connection con,String piloto) throws SQLException{
        List secretaria = new ArrayList();
        try {
            String consulta = "select anexo,nombre from secretaria where piloto_asociado = ? ";
            PreparedStatement ps1 = con.prepareStatement(consulta);
            ps1.setString(1, piloto);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()){
                secretaria.add(rs.getString("anexo")+" - "+rs.getString("nombre"));
            }
            ps1.close();
        }catch (Exception ex1) {
           ex1.printStackTrace();
        }
        
        return secretaria;
    }
    
    public String getTieneTitulos(ResourceBundle texto){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sel = "";
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select * from configuraciones where dato = 'tieneTitulos'");
            rs= ps.executeQuery();
            while(rs.next()){
                if(rs.getString("valor").equals("1")){
                    sel = "checked";
                }
            }
        }catch(Exception e){
            System.out.println("Error en getTieneTitulos: "+e);
        }finally{
            try{
                con.close();
                ps.close();
               rs.close(); 
            }catch(Exception e){}
        }
        return sel;
    }
    
    public int modificarTitulos(String tiene){
        Connection con = null;
        PreparedStatement ps = null;
        int i= 0;
        String valor;
        String qry;
        try{
            if(tiene.equals("on")){
                valor = "1";
            }else{
                valor="0";
            }
            con = SQLConexion.conectar();
            if(contTit()>0){
                qry = "update configuraciones set valor = ?  where dato = 'tieneTitulos'";
            }else{
                qry = "insert into configuraciones(dato, valor) values('tieneTitulos', ? )";
            }
            ps = con.prepareStatement(qry);
            ps.setString(1, valor);
            i = ps.executeUpdate();
        }catch(Exception e){
            System.out.println("Error en modificarTitulos: "+e);
        } finally{
            try{
                con.close();
                ps.close();
            } catch(Exception e){}
        }
        return i;
    }
    
    private int contTit(){
        Connection con =  null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int cont = 0;
        try{
            con = SQLConexion.conectar();
            ps = con.prepareStatement("select count(*) from configuraciones where dato = 'tieneTitulos'");
            rs = ps.executeQuery();
            while(rs.next()){
                cont = rs.getInt(1);
            }
        }catch(Exception e){
            System.out.println("Error en contTit: "+e);
        }finally{
            try{
                con.close();
                ps.close();
                rs.close();
            }catch(Exception e){}
        }
        return cont;
    }
}
