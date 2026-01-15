<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Personaje" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Personajes — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Personajes</h1>
    <p class="subtitle">Administrá los personajes de las historias</p>
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
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/personajes">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" placeholder="Buscar por nombre…" value="<%= q %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/personajes/form">
        <i class="fa-solid fa-user-plus"></i> Nuevo personaje
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
          <th>Sospechoso</th>
          <th>Culpable</th>
          <th class="actions-col">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <%
          @SuppressWarnings("unchecked")
          List<Personaje> lista = (List<Personaje>) request.getAttribute("personajes");
          if (lista == null || lista.isEmpty()) {
        %>
        <tr>
          <td colspan="7" style="text-align:center; color:#999;">No hay personajes</td>
        </tr>
        <%
          } else {
            for (Personaje p : lista) {
              String truncDesc = p.getDescripcion();
              if (truncDesc != null && truncDesc.length() > 80) {
                truncDesc = truncDesc.substring(0, 80) + "...";
              }
        %>
        <tr>
          <td><%= p.getId() %></td>
          <td><strong><%= p.getNombre() %></strong></td>
          <td><%= truncDesc %></td>
          <td><%= p.getHistoriaTitulo() != null ? p.getHistoriaTitulo() : "Historia #" + p.getHistoriaId() %></td>
          <td><%= p.getSospechoso() == 1 ? "✅ Sí" : "❌ No" %></td>
          <td><%= p.getCulpable() == 1 ? "🔴 Sí" : "⚪ No" %></td>
          <td class="actions-col">
            <a class="icon-btn" href="${pageContext.request.contextPath}/admin/personajes/form?id=<%= p.getId() %>" title="Editar">
              <i class="fa-solid fa-pen-to-square"></i>
            </a>
            <form method="post" action="${pageContext.request.contextPath}/admin/personajes/delete" style="display:inline;" 
                  onsubmit="return confirm('¿Eliminar este personaje?');">
              <input type="hidden" name="id" value="<%= p.getId() %>">
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
