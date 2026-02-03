<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="entities.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Logros — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Logros</h1>
    <p class="subtitle">Administrá los logros del juego</p>
  </header>

  <!-- flash -->
  <%
    @SuppressWarnings("unchecked")
    List<Logro> logros = (List<Logro>) request.getAttribute("logros");
    String search = (String) request.getAttribute("search");
    
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    if (search == null) search = "";
  %>

  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/logros">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="search" placeholder="Buscar por nombre…" value="<%= search %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/logros/form">
        <i class="fa-solid fa-trophy"></i> Nuevo logro
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-grid-2"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Clave</th>
          <th>Nombre</th>
          <th>Descripción</th>
          <th>Icono</th>
          <th>Puntos</th>
          <th>Activo</th>
          <th class="actions-col">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (logros == null || logros.isEmpty()) {
        %>
        <tr>
          <td colspan="8" style="text-align:center; color:#999;">No hay logros</td>
        </tr>
        <%
          } else {
            for (Logro l : logros) {
              boolean activo = l.getActivo() == 1;
              String truncDesc = l.getDescripcion();
              if (truncDesc != null && truncDesc.length() > 60) {
                truncDesc = truncDesc.substring(0, 60) + "...";
              }
        %>
        <tr>
          <td><%= l.getId() %></td>
          <td><code style="background:rgba(59,130,246,0.1);color:#60a5fa;padding:4px 8px;border-radius:4px;font-size:12px;border:1px solid rgba(59,130,246,0.2);"><%= l.getClave() %></code></td>
          <td><strong><%= l.getNombre() %></strong></td>
          <td><%= truncDesc != null ? truncDesc : "-" %></td>
          <td><i class="<%= l.getIcono() %>" style="font-size: 18px; color: #f59e0b;"></i></td>
          <td><%= l.getPuntos() %> pts</td>
          <td><%= activo ? "✅ Sí" : "❌ No" %></td>
          <td class="actions-col">
            <a class="icon-btn" href="${pageContext.request.contextPath}/admin/logros/form?id=<%= l.getId() %>" title="Editar">
              <i class="fa-solid fa-pen-to-square"></i>
            </a>
            <form method="post" action="${pageContext.request.contextPath}/admin/logros/delete" style="display:inline;" 
                  onsubmit="return confirm('¿Eliminar este logro?');">
              <input type="hidden" name="id" value="<%= l.getId() %>">
              <button type="submit" class="icon-btn danger" title="Eliminar">
                <i class="fa-solid fa-trash-can"></i>
              </button>
            </form>
          </td>
        </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>
  </div>

</div>
</body>
</html>
