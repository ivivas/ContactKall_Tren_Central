package adportas;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Paginado3{
    String botonAnteriorPay;
    String botonAnterior;
    String botonSiguiente;
    String botonSiguientePay;
    String variablesGet;
    int maximoTamanoBarra;
    int registrosMostrar;
    int registrosTotalPaginado;
    int requestPagina;
    int numeroPaginas;
    int registrosTotales;

    public Paginado3(){
        this.botonAnteriorPay = "&Iota;&lt;";
        this.botonAnterior = "&lt;&lt;";
        this.botonSiguiente = "&gt;&gt;";
        this.botonSiguientePay = "&gt;&Iota;";
        this.variablesGet = "";
        this.maximoTamanoBarra = 3;
        this.registrosMostrar = 0;
        this.registrosTotalPaginado = 0;
        this.requestPagina = 1;
        this.numeroPaginas = 1;
        this.registrosTotales = 0;
    }

    public Paginado3(PreparedStatement pst, int registrosMostrar, int pg) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException{
        this.botonAnteriorPay = "&Iota;&lt;";
        this.botonAnterior = "&lt;&lt;";
        this.botonSiguiente = "&gt;&gt;";
        this.botonSiguientePay = "&gt;&Iota;";
        this.variablesGet = "";
        this.maximoTamanoBarra = 3;
        this.registrosMostrar = 0;
        this.registrosTotalPaginado = 0;
        this.requestPagina = 1;
        this.numeroPaginas = 1;
        this.registrosTotales = 0;
        this.registrosMostrar = registrosMostrar;
        this.requestPagina = pg;
        ResultSet salidaRegistrosTotalPaginado = pst.executeQuery();
        if (salidaRegistrosTotalPaginado.next())
          this.registrosTotalPaginado = Integer.parseInt(salidaRegistrosTotalPaginado.getString("registrosTotalPaginado"));
        salidaRegistrosTotalPaginado.close();
        this.numeroPaginas = (int)Math.ceil(this.registrosTotalPaginado / this.registrosMostrar);
    }

  public int getRegistrosTotalPaginado()
  {
    return this.registrosTotalPaginado;
  }

  public int getNumeroPaginas()
  {
    return this.numeroPaginas;
  }

  public ResultSet getResultSet(PreparedStatement pst)
    throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException
  {
    ResultSet salida = null;
    salida = pst.executeQuery();
    return salida;
  }

  public String getBarraPaginado(String paginaReferencia, String variablesGet, String botonAnteriorPay, String botonAnterior, String botonSiguiente, String botonSiguientePay)
  {
    this.botonAnteriorPay = botonAnteriorPay;
    this.botonAnterior = botonAnterior;
    this.botonSiguiente = botonSiguiente;
    this.botonSiguientePay = botonSiguientePay;
    return getBarraPaginado(paginaReferencia, variablesGet);
  }

  public String getBarraPaginado(String paginaReferencia, String variablesGet){
    String barra = "<div class=\"estiloDivPaginado\">";
    if ((this.requestPagina >= 1) && (this.requestPagina <= this.numeroPaginas) && (this.numeroPaginas > 1)){
        int numeroSeccion = (int)Math.ceil(this.requestPagina / this.maximoTamanoBarra);
        int inicioSeccion = numeroSeccion * this.maximoTamanoBarra - (this.maximoTamanoBarra - 1);
        int finSeccion = inicioSeccion + this.maximoTamanoBarra - 1;
        if (finSeccion > this.numeroPaginas)
            finSeccion = this.numeroPaginas;
        int anteriorMaximoIrA = inicioSeccion - this.maximoTamanoBarra;
        int siguienteMaximoIrA = inicioSeccion + this.maximoTamanoBarra;
        if (anteriorMaximoIrA >= 1)
            barra = barra + "<a class=\"botonPay\" href=\"" + paginaReferencia + "?pg=" + anteriorMaximoIrA + variablesGet + "\" title=\"Anteriores " + this.maximoTamanoBarra + " paginas\">" + this.botonAnteriorPay + "</a> ";
        if (this.requestPagina > 1)
            barra = barra + "<a class=\"boton\" href=\"" + paginaReferencia + "?pg=" + (this.requestPagina - 1) + variablesGet + "\" title=\"Anterior\">" + this.botonAnterior + "</a> ";
        for (int i = inicioSeccion; i <= finSeccion; i++) {
            barra = barra + (this.requestPagina == i ? i + " " : new StringBuilder().append("<a href=\"").append(paginaReferencia).append("?pg=").append(i).append(variablesGet).append("\">").append(i).append("</a> ").toString());
        }
        if (this.requestPagina < this.numeroPaginas)
            barra = barra + "<a class=\"boton\" href=\"" + paginaReferencia + "?pg=" + (this.requestPagina + 1) + variablesGet + "\" title=\"Siguiente\">" + this.botonSiguiente + "</a> ";
        if (siguienteMaximoIrA <= this.numeroPaginas)
            barra = barra + "<a class=\"botonPay\" href=\"" + paginaReferencia + "?pg=" + siguienteMaximoIrA + variablesGet + "\" title=\"Siguientes " + this.maximoTamanoBarra + " paginas\" >" + this.botonSiguientePay + "</a>";
    }
    barra = barra + "</div>";
    return barra;
  }
  
    public String getBarraPaginado2(String paginaReferencia, String variablesGet){
    String barra = "<div class=\"estiloDivPaginado\">";
    int pag = numeroPaginas;
    if((registrosTotalPaginado % registrosMostrar)>0){
        pag ++;
    }
    if ((this.requestPagina >= 1) && (this.requestPagina <= pag) && (pag> 1)){
        int numeroSeccion = (int)Math.ceil(this.requestPagina / this.maximoTamanoBarra);
        if((this.requestPagina % this.maximoTamanoBarra)>0){
            numeroSeccion++;
        }
        int inicioSeccion = numeroSeccion * this.maximoTamanoBarra - (this.maximoTamanoBarra - 1);
        int finSeccion = inicioSeccion + this.maximoTamanoBarra - 1;
        if (finSeccion > pag)
            finSeccion = pag;
        int anteriorMaximoIrA = inicioSeccion - this.maximoTamanoBarra;
        int siguienteMaximoIrA = inicioSeccion + this.maximoTamanoBarra;
        if (anteriorMaximoIrA >= 1)
            barra = barra + "<a class=\"botonPay\" href=\"" + paginaReferencia + "?pg=" + anteriorMaximoIrA + variablesGet + "\" title=\"Anteriores " + this.maximoTamanoBarra + " paginas\">" + this.botonAnteriorPay + "</a> ";
        if (this.requestPagina > 1)
            barra = barra + "<a class=\"boton\" href=\"" + paginaReferencia + "?pg=" + (this.requestPagina - 1) + variablesGet + "\" title=\"Anterior\">" + this.botonAnterior + "</a> ";
        for (int i = inicioSeccion; i <= finSeccion; i++) {
            barra = barra + (this.requestPagina == i ? i + " " : new StringBuilder().append("<a href=\"").append(paginaReferencia).append("?pg=").append(i).append(variablesGet).append("\">").append(i).append("</a> ").toString());
        }
        if (this.requestPagina < pag)
            barra = barra + "<a class=\"boton\" href=\"" + paginaReferencia + "?pg=" + (this.requestPagina + 1) + variablesGet + "\" title=\"Siguiente\">" + this.botonSiguiente + "</a> ";
        if (siguienteMaximoIrA <= pag)
            barra = barra + "<a class=\"botonPay\" href=\"" + paginaReferencia + "?pg=" + siguienteMaximoIrA + variablesGet + "\" title=\"Siguientes " + this.maximoTamanoBarra + " paginas\" >" + this.botonSiguientePay + "</a>";
    }
    barra = barra + "</div>";
    return barra;
  }
  

  public String getPaginadoJavascript(String nombreFuncion)
  {
    String barra = "<div class=\"estiloDivPaginado\">";
    if ((this.requestPagina >= 1) && (this.requestPagina <= this.numeroPaginas) && (this.numeroPaginas > 1))
    {
      int numeroSeccion = (int)Math.ceil(this.requestPagina / this.maximoTamanoBarra);
      int inicioSeccion = numeroSeccion * this.maximoTamanoBarra - (this.maximoTamanoBarra - 1);
      int finSeccion = inicioSeccion + this.maximoTamanoBarra - 1;
      if (finSeccion > this.numeroPaginas)
        finSeccion = this.numeroPaginas;
      int anteriorMaximoIrA = inicioSeccion - this.maximoTamanoBarra;
      int siguienteMaximoIrA = inicioSeccion + this.maximoTamanoBarra;
      if (anteriorMaximoIrA >= 1)
        barra = barra + "<a class=\"botonPay\" href=\"javascript:" + nombreFuncion + "(" + anteriorMaximoIrA + ");\" title=\"Anteriores " + this.maximoTamanoBarra + " paginas\">" + this.botonAnteriorPay + "<a>";
      if (this.requestPagina > 1)
        barra = barra + "<a class=\"boton\" href=\"javascript:" + nombreFuncion + "(" + (this.requestPagina - 1) + ");\" title=\"Anterior\">" + this.botonAnterior + "<a>";
      for (int i = inicioSeccion; i <= finSeccion; i++) {
        barra = barra + (this.requestPagina == i ? i + " " : new StringBuilder().append("<a href=\"javascript:").append(nombreFuncion).append("(").append(i).append(");\">").append(i).append("</a> ").toString());
      }
      if (this.requestPagina < this.numeroPaginas)
        barra = barra + "<a class=\"boton\" href=\"javascript:" + nombreFuncion + "(" + (this.requestPagina + 1) + ");\" title=\"Siguiente\">" + this.botonSiguiente + "</a> ";
      if (siguienteMaximoIrA <= this.numeroPaginas)
        barra = barra + "<a class=\"botonPay\" href=\"javascript:" + nombreFuncion + "(" + siguienteMaximoIrA + ");\" title=\"Siguientes " + this.maximoTamanoBarra + " paginas\" >" + this.botonSiguientePay + "</a>";
    }
    barra = barra + "</div>";
    return barra;
  }

  public String getEstiloEjemplo()
  {
    String estilo = "";
    estilo = estilo + ".estiloDivPaginado{font-family: Verdana;}<br>";
    estilo = estilo + ".estiloDivPaginado .boton,.botonPay{<br>";
    estilo = estilo + "    border:1px solid #000000;<br>";
    estilo = estilo + "    color:#000000;<br>";
    estilo = estilo + "    text-align:center;<br>";
    estilo = estilo + "    padding:0px 5px 0px 5px;<br>";
    estilo = estilo + "    margin:0px 3px 0px 3px;<br>";
    estilo = estilo + "    display:inline;<br>";
    estilo = estilo + "}<br>";
    estilo = estilo + ".estiloDivPaginado a.boton:link{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.boton:visited{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.boton:active{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.boton:hover{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.botonPay:link{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.botonPay:visited{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.botonPay:active{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a.botonPay:hover{text-decoration:none; color:#000000;}<br>";
    estilo = estilo + ".estiloDivPaginado a:link {text-decoration:none;color:#999966;}<br>";
    estilo = estilo + ".estiloDivPaginado a:visited {text-decoration:none;color:#999966;}<br>";
    estilo = estilo + ".estiloDivPaginado a:active {text-decoration:none;color:#999966;}<br>";
    estilo = estilo + ".estiloDivPaginado a:hover {text-decoration:underline;color:#999999;}<br>";
    return estilo;
  }

  public void setMaximoTamanoBarra(int maximoTamanoBarra)
  {
    this.maximoTamanoBarra = maximoTamanoBarra;
  }
}