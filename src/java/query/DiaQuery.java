package query;

import DTO.Dia;
import DTO.Horario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class DiaQuery
{
  private Connection con = null;
  private String query = null;

  public DiaQuery(Connection con) {
    this.con = con;
  }

  public List getTodosLosHorarios()
  {
    ArrayList lista = new ArrayList();

    Horario horario = null;
    this.query = "select h.id as id_horario,h.nombre_horario from horarios as h where 1=1 ";
    try
    {
      PreparedStatement ps = this.con.prepareStatement(this.query);

      ResultSet rs = ps.executeQuery();

      while (rs.next()) {
        horario = new Horario();
        if (rs.getString("nombre_horario") != null)
        {
          horario.setNombre(rs.getString("nombre_horario").trim());

          int id = rs.getInt("id_horario");
          horario.setId(id);
        }

        lista.add(horario);
      }

      rs.close();
      ps.close();
    }
    catch (Exception ex)
    {
      System.out.println(ex);
    }
    return lista;
  }

  public Horario getHorarioXNumeroPiloto(String piloto) {
    HashMap list = null;
    HashMap listaExcepcionalmenteNoHabil = null;
    Horario horario = null;
    this.query = "select h.id as id_horario,h.nombre_horario, d.*  from pilotos as p, dias as d,horarios as h where p.piloto = ? and p.id_horarios = h.id and d.id_horario = h.id";
    try {
      horario = new Horario();
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setString(1, piloto);
      ResultSet rs = ps.executeQuery();
      list = new HashMap();
      listaExcepcionalmenteNoHabil = new HashMap();

      int contador = 0;
      while (rs.next()) {
        if (contador == 0) {
          if (rs.getString("nombre_horario") != null) {
            horario.setNombre(rs.getString("nombre_horario").trim());
          }
          int id = rs.getInt("id_horario");
          horario.setId(id);
          contador++;
        }
        Dia dto = new Dia();

        dto.setId(rs.getInt("id"));

        if (rs.getString("nombre_dia") != null)
          dto.setNombreDia(rs.getString("nombre_dia").trim());
        else {
          dto.setNombreDia("");
        }

        if (rs.getString("hora_desde") != null)
          dto.setHoraMinima(rs.getString("hora_desde").trim());
        else {
          dto.setHoraMinima("");
        }

        if (rs.getString("hora_hasta") != null)
          dto.setHoraMaxima(rs.getString("hora_hasta").trim());
        else {
          dto.setHoraMaxima("");
        }

        int respuesta = rs.getInt("is_habil");

        if (respuesta == 1) {
          dto.setHabil(true);
        }
        else {
          dto.setHabil(false);
        }

        int respuestaExNoHabil = rs.getInt("is_excepcionalmente_no_habil");

        if (respuestaExNoHabil == 1) {
          dto.setExcepcionalmenteNoHabil(true);

          if (rs.getString("fecha_excepcionalmente_no_habil") != null) {
            dto.setFechaExcepcionalMenteNoHabil(rs.getString("fecha_excepcionalmente_no_habil").trim());
          }

          listaExcepcionalmenteNoHabil.put(dto.getFechaExcepcionalMenteNoHabil(), dto);
        }
        else {
          dto.setExcepcionalmenteNoHabil(false);
          list.put(dto.getNombreDia(), dto);
        }

      }

      rs.close();
      ps.close();

      horario.setListaDiasExcepcionalmenteNoHabiles(listaExcepcionalmenteNoHabil);
      horario.setListaDiasSemana(list);
    }
    catch (Exception ex)
    {
      System.out.println(ex);
    }
    return horario;
  }

  public Horario getHorarioXIdPiloto(int idPiloto) {
    HashMap list = null;
    HashMap listaExcepcionalmenteNoHabil = null;
    Horario horario = null;
    this.query = "select h.id as id_horario,h.nombre_horario,h.is_predeterminado, d.*  from pilotos as p, dias as d,horarios as h where p.id = ? and p.id_horarios = h.id and d.id_horario = h.id";
    try {
      horario = new Horario();
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, idPiloto);
      ResultSet rs = ps.executeQuery();
      list = new HashMap();
      listaExcepcionalmenteNoHabil = new HashMap();

      int contador = 0;
      while (rs.next()) {
        if (contador == 0) {
          if (rs.getString("nombre_horario") != null) {
            horario.setNombre(rs.getString("nombre_horario").trim());
            boolean isPredeterminado = rs.getString("is_predeterminado").equalsIgnoreCase("1");
            horario.setPredeterminado(isPredeterminado);
          }
          int id = rs.getInt("id_horario");
          horario.setId(id);
          contador++;
        }
        Dia dto = new Dia();

        dto.setId(rs.getInt("id"));

        if (rs.getString("nombre_dia") != null)
          dto.setNombreDia(rs.getString("nombre_dia").trim());
        else {
          dto.setNombreDia("");
        }

        if (rs.getString("hora_desde") != null)
          dto.setHoraMinima(rs.getString("hora_desde").trim());
        else {
          dto.setHoraMinima("");
        }

        if (rs.getString("hora_hasta") != null)
          dto.setHoraMaxima(rs.getString("hora_hasta").trim());
        else {
          dto.setHoraMaxima("");
        }

        int respuesta = rs.getInt("is_habil");

        if (respuesta == 1) {
          dto.setHabil(true);
        }
        else {
          dto.setHabil(false);
        }

        int respuestaExNoHabil = rs.getInt("is_excepcionalmente_no_habil");

        if (respuestaExNoHabil == 1) {
          dto.setExcepcionalmenteNoHabil(true);

          if (rs.getString("fecha_excepcionalmente_no_habil") != null) {
            dto.setFechaExcepcionalMenteNoHabil(rs.getString("fecha_excepcionalmente_no_habil").trim());
          }

          listaExcepcionalmenteNoHabil.put(dto.getFechaExcepcionalMenteNoHabil(), dto);
        }
        else {
          dto.setExcepcionalmenteNoHabil(false);
          list.put(dto.getNombreDia(), dto);
        }

      }

      rs.close();
      ps.close();

      horario.setListaDiasExcepcionalmenteNoHabiles(listaExcepcionalmenteNoHabil);
      horario.setListaDiasSemana(list);
    }
    catch (Exception ex)
    {
      System.out.println(ex);
    }
    return horario;
  }
  public Horario getHorarioXIdHorario(int idHorario) {
    HashMap list = null;
    HashMap listaExcepcionalmenteNoHabil = null;
    List listaExcepcionalmenteNoHabilList = null;
    Horario horario = null;
    this.query = "select h.id as id_horario,h.nombre_horario,h.is_predeterminado, d.*  from  dias as d,horarios as h where h.id = ?  and d.id_horario = h.id";
    try {
      horario = new Horario();
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, idHorario);
      ResultSet rs = ps.executeQuery();
      list = new HashMap();
      listaExcepcionalmenteNoHabil = new HashMap();
      listaExcepcionalmenteNoHabilList = new ArrayList();

      int contador = 0;
      while (rs.next()) {
        if (contador == 0) {
          if (rs.getString("nombre_horario") != null) {
            horario.setNombre(rs.getString("nombre_horario").trim());
            boolean isPredeterminado = rs.getString("is_predeterminado").equalsIgnoreCase("1");
            horario.setPredeterminado(isPredeterminado);
          }
          int id = rs.getInt("id_horario");
          horario.setId(id);

          contador++;
        }
        Dia dto = new Dia();

        dto.setId(rs.getInt("id"));

        if (rs.getString("nombre_dia") != null)
          dto.setNombreDia(rs.getString("nombre_dia").trim());
        else {
          dto.setNombreDia("");
        }

        if (rs.getString("hora_desde") != null)
          dto.setHoraMinima(rs.getString("hora_desde").trim());
        else {
          dto.setHoraMinima("");
        }

        if (rs.getString("hora_hasta") != null)
          dto.setHoraMaxima(rs.getString("hora_hasta").trim());
        else {
          dto.setHoraMaxima("");
        }

        int respuesta = rs.getInt("is_habil");

        if (respuesta == 1) {
          dto.setHabil(true);
        }
        else {
          dto.setHabil(false);
        }

        int respuestaExNoHabil = rs.getInt("is_excepcionalmente_no_habil");

        if (respuestaExNoHabil == 1) {
          dto.setExcepcionalmenteNoHabil(true);

          if (rs.getString("fecha_excepcionalmente_no_habil") != null) {
            dto.setFechaExcepcionalMenteNoHabil(rs.getString("fecha_excepcionalmente_no_habil").trim());
          }

          listaExcepcionalmenteNoHabil.put(dto.getFechaExcepcionalMenteNoHabil(), dto);
          listaExcepcionalmenteNoHabilList.add(dto);
        }
        else
        {
          dto.setExcepcionalmenteNoHabil(false);
          list.put(dto.getNombreDia(), dto);
        }

      }

      rs.close();
      ps.close();

      horario.setListaDiasExcepcionalmenteNoHabiles(listaExcepcionalmenteNoHabil);
      horario.setListaDiasExcepcionalmenteNoHabilesList(listaExcepcionalmenteNoHabilList);
      horario.setListaDiasSemana(list);
    }
    catch (Exception ex)
    {
      System.out.println(ex);
    }
    return horario;
  }

  public int getIdHorarioPredeterminado()
  {
    int id = 0;
    this.query = "select h.id as id_horario from horarios as h where h.is_predeterminado = 1";
    try
    {
      PreparedStatement ps = this.con.prepareStatement(this.query);

      ResultSet rs = ps.executeQuery();

      while (rs.next())
      {
        Object idObj = Integer.valueOf(rs.getInt("id_horario"));
        id = idObj != null ? ((Integer)idObj).intValue() : 0;
      }

      rs.close();
      ps.close();
    }
    catch (Exception ex)
    {
      System.out.println(ex);
    }
    return id;
  }

  private boolean comprobacionDia(Dia dia) {
    boolean respuesta = false;
    respuesta = !dia.getNombreDia().trim().equalsIgnoreCase("");
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    Date f1 = null;
    Date f2 = null;
    String h1 = dia.getHoraMinima();
    String h2 = dia.getHoraMaxima();
    String h1_temp;
    String h2_temp;
    try {
      f1 = sdf.parse(h1);
      f2 = sdf.parse(h2);
      h1_temp = sdf.format(f1);
      h2_temp = sdf.format(f2);
      //respuesta = true;
      respuesta = (h1_temp.equalsIgnoreCase(h1) && h2_temp.equalsIgnoreCase(h2));
    } catch (Exception ex) {
      respuesta = false;
    }
    return respuesta;
  }

  public boolean comprobacionDiaEnLista(List listaDias)
  {
    boolean respuesta = true;

    for (int i = 0; i < listaDias.size(); i++)
    {
      Dia aux = (Dia)listaDias.get(i);
      if (comprobacionDia(aux))
        continue;
      respuesta = false;
    }

    return respuesta;
  }
  public boolean modificarDia(Dia dia) {
    boolean respuesta = false;
    if (comprobacionDia(dia))
      try {
        int isHabil = dia.isHabil() == true ? 1 : 0;

        this.query = "update dias set hora_desde = ? , hora_hasta = ? ,is_habil = ? where id = ? ";
        PreparedStatement ps = this.con.prepareStatement(this.query);
        ps.setString(1, dia.getHoraMinima());
        ps.setString(2, dia.getHoraMaxima());
        ps.setInt(3, isHabil);
        ps.setInt(4, dia.getId());
        ps.executeUpdate();
        ps.close();
        respuesta = true;
      }
      catch (Exception ex) {
      }
    return respuesta;
  }

  public boolean modificarHorario(Horario horario)
  {
    boolean respuesta = false;
    boolean eliminarPredeterminadoAnterior = false;
    int isPredeterminado = horario.isPredeterminado() == true ? 1 : 0;
    int idHorarioPredeterminado = getIdHorarioPredeterminado();
    if ((!horario.isPredeterminado()) && (idHorarioPredeterminado == horario.getId()))
    {
      isPredeterminado = 1;
    }

    if ((horario.isPredeterminado() == true) && (idHorarioPredeterminado != horario.getId()))
    {
      eliminarPredeterminadoAnterior = true;
    }

    try
    {
      this.query = "update horarios set nombre_horario = ?, is_predeterminado=? where id = ? ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setString(1, horario.getNombre());
      ps.setInt(2, isPredeterminado);
      ps.setInt(3, horario.getId());
      ps.executeUpdate();
      if (eliminarPredeterminadoAnterior)
      {
        dejarSinHorarioPredeterminado(idHorarioPredeterminado);
      }

      ps.close();
      respuesta = true;
    }
    catch (Exception ex) {
    }
    return respuesta;
  }

  public void nuevoDia(Dia dia, int idHorario)
  {
    try {
      int isHabil = dia.isHabil() == true ? 1 : 0;
      int isExcepcionalmenteNoHabil = dia.isExcepcionalmenteNoHabil() == true ? 1 : 0;
      this.query = "insert into dias (hora_desde , hora_hasta  ,is_habil,nombre_dia,is_excepcionalmente_no_habil,fecha_excepcionalmente_no_habil,id_horario) values(?,?,?,?,?,?,?) ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setString(1, dia.getHoraMinima());
      ps.setString(2, dia.getHoraMaxima());
      ps.setInt(3, isHabil);
      ps.setString(4, dia.getNombreDia());
      ps.setInt(5, isExcepcionalmenteNoHabil);
      ps.setString(6, dia.getFechaExcepcionalMenteNoHabil());
      ps.setInt(7, idHorario);
      ps.executeUpdate();
      ps.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public void cambiarHorarioAlPiloto(int idPiloto, int idHorario)
  {
    try {
      this.query = "update pilotos set id_horarios = ? where id = ? ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, idHorario);
      ps.setInt(2, idPiloto);

      ps.executeUpdate();
      ps.close();
    }
    catch (Exception ex)
    {
    }
  }

  public boolean eliminarHorario(Horario horario)
  {
    boolean respuesta = false;
    eliminarDiasXIdHorario(horario.getId());
    try
    {
      this.query = "delete from horarios where id = ? ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, horario.getId());
      ps.executeUpdate();

      respuesta = true;
      ps.close();
    }
    catch (Exception ex) {
        ex.printStackTrace();
    }
    return respuesta;
  }

  public boolean eliminarDiasXIdHorario(int idHorario)
  {
    boolean respuesta = false;
    try
    {
      this.query = "delete dias where id_horario = ? ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, idHorario);
      ps.executeUpdate();

      respuesta = true;
      ps.close();
    }
    catch (Exception ex) {
    }
    return respuesta;
  }

  public boolean eliminarDiaXId(int id)
  {
    boolean respuesta = false;
    try
    {
      this.query = "delete from dias where id = ? ";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, id);
      ps.executeUpdate();

      respuesta = true;
      ps.close();
    }
    catch (Exception ex) {
        
    }
    return respuesta;
  }

  public int obtenerIdMasAltoDeUnaTabla(String nombreTabla)
  {
    int id = 0;
    this.query = ("select max(id) as id from " + nombreTabla + " ");
    try
    {
      PreparedStatement ps = this.con.prepareStatement(this.query);

      ResultSet rs = ps.executeQuery();

      while (rs.next())
      {
        Object idObj = Integer.valueOf(rs.getInt("id"));
        id = idObj != null ? ((Integer)idObj).intValue() : 0;
      }

      rs.close();
      ps.close();
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
    return id;
  }

  public boolean comprobarSiExisteNombreHorario(String nombre)
  {
    boolean respuesta = false;
    this.query = "select nombre_horario  from horarios where nombre_horario= ?";
    try
    {
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setString(1, nombre);
      ResultSet rs = ps.executeQuery();

      while (rs.next())
      {
        Object obj = rs.getString("nombre_horario");
        if (obj == null)
        {
          respuesta = false;
        }
        else
        {
          respuesta = true;
        }

      }

      rs.close();
      ps.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    return respuesta;
  }
  public boolean insertarHorario(Horario horario, List listaDias) {
    boolean respuesta = false;
    if (comprobacionDiaEnLista(listaDias))
    {
      try
      {
        int idHorarioPredeterminado = getIdHorarioPredeterminado();
        int isPredeterminado = horario.isPredeterminado() == true ? 1 : 0;
        int idHorario = obtenerIdMasAltoDeUnaTabla("horarios") + 1;
        this.query = "insert into horarios (id,nombre_horario,is_predeterminado) values(?,?,?) ";
        PreparedStatement ps = this.con.prepareStatement(this.query);
        ps.setInt(1, idHorario);

        ps.setString(2, horario.getNombre());
        ps.setInt(3, isPredeterminado);

        ps.executeUpdate();

        for (int i = 0; i < listaDias.size(); i++)
        {
          Dia aux = (Dia)listaDias.get(i);
          nuevoDia(aux, idHorario);
        }
        ps.close();
        respuesta = true;
        if (horario.isPredeterminado() == true)
          dejarSinHorarioPredeterminado(idHorarioPredeterminado);
      }
      catch (Exception ex)
      {
        ex.printStackTrace();
      }
    }
    else
    {
      respuesta = false;
    }
    return respuesta;
  }

  public void dejarSinHorarioPredeterminado(int idHorarioPredeterminado)
  {
    try
    {
      this.query = "update horarios set is_predeterminado = 0 where is_predeterminado = 1 and id = ?";
      PreparedStatement ps = this.con.prepareStatement(this.query);
      ps.setInt(1, idHorarioPredeterminado);

      ps.executeUpdate();
      ps.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public List obtenerTodosLosNumerosDeRoutePoint()
  {
    List respuesta = new ArrayList();
    this.query = "select piloto  from pilotos where 1=1";
    try
    {
      PreparedStatement ps = this.con.prepareStatement(this.query);

      ResultSet rs = ps.executeQuery();

      while (rs.next())
      {
        Object obj = rs.getString("piloto").trim();
        if (obj != null)
        {
          respuesta.add(obj);
        }

      }

      rs.close();
      ps.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    return respuesta;
  }

  private boolean comprobarFecha(String fecha)
  {
    boolean respuesta = true;
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    Date f1 = null;

    String h1 = fecha;
    try
    {
      f1 = sdf.parse(h1);

      respuesta = true;
    } catch (Exception ex) {
      respuesta = false;
    }
    return respuesta;
  }

  public boolean insertarFechaExcepcionalmenteNoHabil(int idHorario, String fecha) {
    boolean respuesta = false;

    if (comprobarFecha(fecha))
    {
      try
      {
        this.query = "insert into dias (is_excepcionalmente_no_habil,fecha_excepcionalmente_no_habil,id_horario) values(1,?,?);";
        PreparedStatement ps = this.con.prepareStatement(this.query);
        ps.setString(1, fecha);
        ps.setInt(2, idHorario);
        ps.executeUpdate();

        respuesta = true;
        ps.close();
      }
      catch (Exception ex) {
        ex.printStackTrace();
      }
    }
    else {
      respuesta = false;
    }
    return respuesta;
  }
}