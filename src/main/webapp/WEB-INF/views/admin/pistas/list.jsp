<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Pista" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Pistas — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Pistas</h1>
    <p class="subtitle">Administrá las pistas de las historias</p>
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
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/pistas">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" placeholder="Buscar por nombre…" value="<%= q %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/pistas/form">
        <i class="fa-solid fa-lightbulb"></i> Nueva pista
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
          <th>Ubicación</th>
          <th>Personaje</th>
          <th>Crucial</th>
          <th>Importancia</th>
          <th class="actions-col">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <%
          @SuppressWarnings("unchecked")
          List<Pista> lista = (List<Pista>) request.getAttribute("pistas");
          if (lista == null || lista.isEmpty()) {
        %>
        <tr>
          <td colspan="9" style="text-align:center; color:#999;">No hay pistas</td>
        </tr>
        <%
          } else {
            for (Pista p : lista) {
              String truncDesc = p.getDescripcion();
              if (truncDesc != null && truncDesc.length() > 60) {
                truncDesc = truncDesc.substring(0, 60) + "...";
              }
        %>
        <tr>
          <td><%= p.getId() %></td>
          <td><strong><%= p.getNombre() %></strong></td>
          <td><%= truncDesc %></td>
          <td><%= p.getHistoriaTitulo() != null ? p.getHistoriaTitulo() : "Historia #" + p.getHistoriaId() %></td>
          <td><%= p.getUbicacionNombre() != null ? p.getUbicacionNombre() : "-" %></td>
          <td><%= p.getPersonajeNombre() != null ? p.getPersonajeNombre() : "-" %></td>
          <td><%= p.getCrucial() == 1 ? "⭐ Sí" : "⚪ No" %></td>
          <td>
            <% 
              String imp = p.getImportancia();
              if (imp == null || imp.isEmpty()) imp = "-";
              String badge = "";
              if ("alta".equalsIgnoreCase(imp)) badge = "🔴";
              else if ("media".equalsIgnoreCase(imp)) badge = "🟠";
              else if ("baja".equalsIgnoreCase(imp)) badge = "🟢";
            %>
            <%= badge %> <%= imp %>
          </td>
          <td class="actions-col">
            <a class="icon-btn" href="${pageContext.request.contextPath}/admin/pistas/form?id=<%= p.getId() %>" title="Editar">
              <i class="fa-solid fa-pen-to-square"></i>
            </a>
            <form method="post" action="${pageContext.request.contextPath}/admin/pistas/delete" style="display:inline;" 
                  onsubmit="return confirm('¿Eliminar esta pista?');">
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
