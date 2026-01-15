<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Ubicacion" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Ubicaciones — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Ubicaciones</h1>
    <p class="subtitle">Administrá las ubicaciones de las historias</p>
  </header>

  <%
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    String q = (String) request.getAttribute("q");
    if (q == null) q = request.getParameter("q");
    if (q == null) q = "";
  %>

  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/ubicaciones">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" placeholder="Buscar por nombre…" value="<%= q %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/ubicaciones/form">
        <i class="fa-solid fa-location-dot"></i> Nueva ubicación
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
          <th>Nombre</th>
          <th>Descripción</th>
          <th>Historia</th>
          <th>Accesible</th>
          <th>Imagen</th>
          <th class="actions-col">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <%
          @SuppressWarnings("unchecked")
          List<Ubicacion> lista = (List<Ubicacion>) request.getAttribute("ubicaciones");
          if (lista == null || lista.isEmpty()) {
        %>
        <tr>
          <td colspan="7" style="text-align:center; color:#999;">No hay ubicaciones</td>
        </tr>
        <%
          } else {
            for (Ubicacion u : lista) {
              String truncDesc = u.getDescripcion();
              if (truncDesc != null && truncDesc.length() > 80) {
                truncDesc = truncDesc.substring(0, 80) + "...";
              }
        %>
        <tr>
          <td><%= u.getId() %></td>
          <td><strong><%= u.getNombre() %></strong></td>
          <td><%= truncDesc %></td>
          <td><%= u.getHistoriaTitulo() != null ? u.getHistoriaTitulo() : "Historia #" + u.getHistoriaId() %></td>
          <td><%= u.getAccesible() == 1 ? "✅ Sí" : "🔒 No" %></td>
          <td><%= u.getImagen() != null && !u.getImagen().isEmpty() ? "🖼️" : "-" %></td>
          <td class="actions-col">
            <a class="icon-btn" href="${pageContext.request.contextPath}/admin/ubicaciones/form?id=<%= u.getId() %>" title="Editar">
              <i class="fa-solid fa-pen-to-square"></i>
            </a>
            <form method="post" action="${pageContext.request.contextPath}/admin/ubicaciones/delete" style="display:inline;" 
                  onsubmit="return confirm('¿Eliminar esta ubicación?');">
              <input type="hidden" name="id" value="<%= u.getId() %>">
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
