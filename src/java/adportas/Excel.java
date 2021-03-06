package adportas;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Excel
{
  public static List<String> JSP(ResultSet rs)
    throws SQLException
  {
    List excel = new ArrayList();
    ResultSetMetaData rsmd = rs.getMetaData();

    excel.add("<html><body><table><thead><tr>");

    int numeroColumnas = rsmd.getColumnCount();
    for (int i = 1; i <= numeroColumnas; i++) {
      excel.add("<th>" + rsmd.getColumnName(i) + "</th>");
    }
    excel.add("</tr></thead><tbody>");

    while (rs.next()) {
      excel.add("<tr>");
      for (int i = 1; i <= numeroColumnas; i++) {
        excel.add(rs.getString(i) != null ? "<td>" + rs.getString(i).trim() + "/<td>" : "<td></td>");
      }
      excel.add("</tr>");
    }
    rs.close();
    excel.add("</tbody></table></body></html>");
    return excel;
  }
}