/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package query;

/**
 *
 * @author Jose
 */
public class Paginado {
    public static String paginado(int limit,int offset,int cantidad,String cadena,int total){
        StringBuilder paginado = new StringBuilder();
        if(total>15){
            int totalPaginado = (total/limit)+1;
            if(cantidad==10){
                paginado.append("<<");
            }
            else{
                paginado.append("<a class='flecha' href='campana.jsp?buscar=buscar&cantidad=");
                paginado.append(cantidad-10);
                paginado.append("&limit=");
                paginado.append(limit);
                paginado.append("&offset=");
                paginado.append(offset-1);
                paginado.append("'><<</a>&nbsp;");
            }
            for(int i = 0 ; i< totalPaginado ; i ++){
                if(i>=(cantidad-10) & i<cantidad){
                    if((i+1)==offset){
                        paginado.append(i+1);
                        paginado.append("&nbsp;");
                    }
                    else{
                        paginado.append("<a class='numero' href='campana.jsp?buscar=buscar");
                        paginado.append("&limit=");
                        paginado.append(limit);
                        paginado.append("&offset=");
                        paginado.append(i+1);
                        paginado.append("'>");
                        paginado.append(i+1);
                        paginado.append("</a>&nbsp;");
                    }
                }
            }
            if(cantidad*limit>=total){
                paginado.append(">>");
            }
            else{
                paginado.append("<a class='flecha' href='campana.jsp?buscar=buscar&cantidad=");
                paginado.append((cantidad+10));
                paginado.append("&numero=");
//                paginado.append(numero);
                paginado.append("&piloto=");
//                paginado.append(piloto);
                paginado.append("&contraparte=");
//                paginado.append(contraparte);
                paginado.append("&desde=");
//                paginado.append(fechaDesde);
                paginado.append("&hasta=");
//                paginado.append(fechaHasta);
                paginado.append("&limit=");
                paginado.append(limit);
                paginado.append("&offset=");
                paginado.append(offset+1);
                paginado.append("'>>></a>");
            }
        }
        return paginado.toString();
    }

}
