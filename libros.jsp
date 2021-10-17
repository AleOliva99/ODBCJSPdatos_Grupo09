<%@page contentType="text/html" pageEncoding="iso-8859-1" import="java.sql.*,net.ucanaccess.jdbc.*" %>
 <html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Actualizar, Eliminar, Crear registros.</title>
  </head>
 <body>
  <H1>MANTENIMIENTO DE LIBROS</H1>
  <a type=url style="margin-left: 10px;" href="listado-csv.jsp" download="listadoLibros.csv">Descargar Listado CSV</a>
  <form action="matto.jsp" method="post" name="Actualizar">
    <table>
    <tr>
      <td>ISBN<input id="id_isbn" type="text" name="isbn" value="" size="40"/>
      </td>
    </tr>
    <tr>
      <td>T�tulo<input id="id_titulo" type="text" name="titulo" value="" size="50"/></td>
    </tr>
    <tr>
      <td class="etiqueta">Autor 
        <input onkeyup="mensajeCreate()" id="id_autor" name="autor" size="50" type="text" value="" /></td>
    </tr>
    <tr>
      <td class="etiqueta">Editorial 
        <%
        ServletContext context2 = request.getServletContext();
        Connection conexion2 = getConnection();
    
        if (!conexion2.isClosed())
        {
          Statement stEditorial = conexion2.createStatement();
          ResultSet rsEditorial = stEditorial.executeQuery("select * from editorial" );
        %>
        <select onkeyup="mensajeCreate()" id="id_editorial" name="editorial">
          <% while (rsEditorial.next()) { %>
            <option value="<% out.println(rsEditorial.getString("id")); %>"><% out.println(rsEditorial.getString("nombre")); %></option>
          <% } %>
        </select>
      </td>
    </tr>
    <% } %>
    <tr>
    <td class="etiqueta">Anio de Publicacion  
              <input onkeyup="mensajeCreate()" id="id_anioPublic" name="anioPublic" size="30" type="text" value="" /></td>
    </tr>
    <tr><td> Action <input id="id_Actualizar" type="radio" name="Action" value="Actualizar" /> Actualizar
      <input type="radio" name="Action" value="Eliminar" /> Eliminar
      <input type="radio" name="Action" value="Crear" checked /> Crear
        </td>
      <td><input type="SUBMIT" value="ACEPTAR" />
      </td>
    </tr>
    </form>
    </tr>
    </table>
  </form>
  <br><br>
  
  <form action="libros.jsp" name="formbusca" method="GET">
    <table>
      <tbody>
        <tr><td class="etiqueta">ISBN: 
          <td>
            <input onkeyup="funtionHabilitar()" type="text" id="idISBN" name="isbn_form_2" placeholder="ISBN del Libro:">
          </td>
        </td></tr>

        <tr><td class="etiqueta">Titulo: 
          <td>
            <input onkeyup="funtionHabilitar()" type="text" id="idTitulo" name="titulo_form_2" placeholder="Titulo del Libro:">
          </td>
        </td></tr>
		
		<tr><td class="etiqueta">Autor: 
          <td>
            <input onkeyup="funtionHabilitar()" type="text" id="idAutor" name="autor2_form_2" placeholder="Autor del Libro:">
          </td>
        </td></tr>

    </tbody>
    </table>

    <input type="submit" id="ActionBuscar" value="Buscar" disabled>
    <input type="reset" value="Restaurar">
  </form>
  
  <h2 style="text-align:center;"><span style="color:red;">Lista de Libros</span></h2>
  
<br><br>

  <%
    ServletContext context = request.getServletContext();
    Connection conexion = getConnection();


    if (!conexion.isClosed())
    {
      String buscarISBN= request.getParameter("isbn_form_2");
      String buscarTitulo= request.getParameter("titulo_form_2");
      String buscarAutor= request.getParameter("autor2_form_2");
      if(buscarTitulo==null || buscarISBN==null||buscarAutor==null){

      Statement st = conexion.createStatement();
      ResultSet rs = st.executeQuery("select * from libros inner join editorial on libros.id_editorial = editorial.id" );
      
      out.println("<table id='tabla_id' border=\"1\"><tr><th>Num.</th><th>ISBN</th>"+"<th onclick='ordenarTabla(2);'>"+"<a href=\'#!\'>"+"Titulo"+"</a> </th>"+"<th>Autor</th>"+"<th>Editorial</th>"+"<th>Año Public</th>"+"<th>Acciones</th></tr>");
      int i=1;
      while (rs.next())
      {
        String isbn = rs.getString("isbn");
        String titulo = rs.getString("titulo");
        String autor = rs.getString("autor");
        String editorial = rs.getString("nombre");
        String id = rs.getString("id");
        String anioPublic = rs.getString("anioPublic");
        %>
  <tr>
    <td><% out.println(i); %></td>
    <td id='isbn_id<% out.println(i); %>'><% out.println(isbn); %></td>
    <td id='titulo_id<%out.println(i);%>'><% out.println(titulo); %></td>
    <td id='autor_id<%out.println(i);%>'><% out.println(autor); %></td>
    <td id='editorial_id<%out.println(i);%>'><% out.println(editorial); %></td>
    <td id='anioPublic_id<%out.println(i);%>'><% out.println(anioPublic); %></td>
    <td>
      <a href='#' id='<%out.println(i);%>' name='<% out.println(id); %>' onclick='actualizar(this, <% out.println(id); %>);'>Actualizar</a> | <% out.println("<a id="+"delete"+" href='matto.jsp?isbn="+isbn+"&titulo="+titulo+"&autor="+autor+"&nombre="+editorial+"&anioPublic="+anioPublic+"+&Action=Eliminar'>"+"Eliminar"+"</a>"); 
      %>
    </td>
  </tr>
  <%
        i++;
      }
      out.println("</table> <br><br>");
      } else {
        Statement st2 = conexion.createStatement();
        
        ResultSet rs=st2.executeQuery("select * from libros inner join editorial on libros.id_editorial = editorial.id where isbn LIKE"+"'"+buscarISBN+"'" +"OR titulo LIKE"+"'"+buscarTitulo+"'"+"OR autor LIKE "+"'"+buscarAutor+"'" );
        out.println("<table id='tabla_id' border=\"1\"><tr><th>Num.</th><th>ISBN</th>"+"<th onclick='ordenarTabla(2);'>"+"<a href=\'#!\'>"+"Titulo"+"</a> </th>"+"<th>Autor</th>"+"<th>Editorial</th>"+"<th>Año Public</th>"+"<th>Acciones</th></tr>");
      int i=1;
      while (rs.next())
      {
        String isbn = rs.getString("isbn");
        String titulo = rs.getString("titulo");
        String autor = rs.getString("autor");
        String editorial = rs.getString("nombre");
        String id = rs.getString("id");
        String anioPublic = rs.getString("anioPublic");
%>
  <tr>
    <td><% out.println(i); %></td>
    <td id='isbn_id<% out.println(i); %>'><% out.println(isbn); %></td>
    <td id='titulo_id<%out.println(i);%>'><% out.println(titulo); %></td>
    <td id='autor_id<%out.println(i);%>'><% out.println(autor); %></td>
    <td id='editorial_id<%out.println(i);%>'><% out.println(editorial); %></td>
    <td id='anioPublic_id<%out.println(i);%>'><% out.println(anioPublic); %></td>
    <td>
      <a href='#' id='<%out.println(i);%>' name='<% out.println(id); %>' onclick='actualizar(this, <% out.println(id); %>);'>Actualizar</a> | <% out.println("<a id="+"delete"+" href='matto.jsp?isbn="+isbn+"&titulo="+titulo+"&autor="+autor+"&nombre="+editorial+"&anioPublic="+anioPublic+"+&Action=Eliminar'>"+"Eliminar"+"</a>"); 
      %>
    </td>
  </tr>
  <%
        i++;
      }
      out.println("</table> <br><br>");
      out.println("<a href="+"libros.jsp"+"> < Volver </a>");
      }
      conexion.close();
    }
  %>

  <%!
    public Connection getConnection() throws SQLException {
      String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
      String userName="libros",password="books";
      String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;
          Connection conn = null;
      try{
              Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
      conn = DriverManager.getConnection(fullConnectionString,userName,password);
      }
      catch (Exception e) {
      System.out.println("Error: " + e);
      }
      return conn;
    }
  %>


  <script>//Script Habilitar/Deshabilitar botón Buscar
    function funtionHabilitar() {
          console.log("change");
          const campo1 = document.getElementById("idISBN");
          const campo2 = document.getElementById("idTitulo");
          const campo3 = document.getElementById("idAutor");
          const boton = document.getElementById("ActionBuscar");
          console.log(boton)
          
          if (campo1.value.trim() !== ""&&campo2.value.trim() !== "") {
            console.log("Se muestra")
            boton.removeAttribute('disabled')
          }
          else if (campo1.value.trim() !== ""&&campo3.value.trim() !== "") {
            console.log("Se muestra")
            boton.removeAttribute('disabled')
          } else {
            boton.setAttribute('disabled', "true");
          }
        }
  </script>
  <script>//Script para Habilitar/Deshabilitar el boton Aceptar
      function mensajeCreate() 
      {
        console.log("create");
        const campo1 = document.getElementById("id_isbn");
        const campo2 = document.getElementById("id_titulo");
        const campo3 = document.getElementById("id_autor");
        const campo4 = document.getElementById("id_editorial");
        const campo5 = document.getElementById("id_anioPublic");
        const boton = document.getElementById("id_aceptar");
        console.log(boton)

        if (campo1.value.trim() !== "" && campo2.value.trim() !== "" && campo3.value.trim() !== "" && campo4.value.trim() !== "" && campo5.value.trim() !== "") 
        {
          console.log("Se muestra")
          boton.removeAttribute('disabled')
        }
        else {
          boton.setAttribute('disabled', "true");
        }
      }
    </script>
	
	<script type="text/javascript">//Funcion Actualizar
  function actualizar(elemento, tam)
  {
    document.getElementById("id_isbn").value=document.getElementById("isbn_id"+elemento.id).innerHTML;
    document.getElementById("id_titulo").value=document.getElementById("titulo_id"+elemento.id).innerHTML;
    document.getElementById("id_Actualizar").checked=true;
  }
  </script>
  
  <script>
  function ordenarTabla(c) 
  {
    var tabla, rows, emparejado, i, j, k, emparejar, dir, conteo = 0;
    emparejado = true; 
    dir = "asc";
	tabla = document.getElementById('tabla_id');
    while (emparejado) {
      emparejado = false;
      rows = tabla.rows;
      for (i = 1; i < (rows.length - 1); i++) {
      emparejar = false;
      j = rows[i].getElementsByTagName("TD")[c];
      k = rows[i + 1].getElementsByTagName("TD")[c];
      if (dir == "asc") {
         if (j.innerHTML.toLowerCase() > k.innerHTML.toLowerCase()) {
            emparejar = true;
          break;
          }
        } else if (dir == "desc") {
          if (j.innerHTML.toLowerCase() < k.innerHTML.toLowerCase()) {
            emparejar = true;
          break;
        }
      }
    }
    if (emparejar) {
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      emparejado = true;
      conteo ++;
    } else {
      if (conteo == 0 && dir == "asc") {
        dir = "desc";
        emparejado = true;
      }
    }
  }
}
</script>
  </body>
