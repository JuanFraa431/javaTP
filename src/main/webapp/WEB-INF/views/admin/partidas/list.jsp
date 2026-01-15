<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,entities.Partida,java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Partidas — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Partidas</h1>
    <p class="subtitle">Monitoreo de partidas jugadas (solo lectura)</p>
  </header>

  <%
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    String q = (String) request.getAttribute("q");
    if (q == null) q = request.getParameter("q");
    if (q == null) q = "";
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
  %>

  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/partidas">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" placeholder="Buscar por usuario, estado…" value="<%= q %>">
      </form>
    </div>
    <div class="right">
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
          <th>Usuario</th>
          <th>Historia</th>
          <th>Estado</th>
          <th>Inicio</th>
          <th>Fin</th>
          <th>Pistas</th>
          <th>Puntuación</th>
          <th>Caso Resuelto</th>
          <th>Solución</th>
        </tr>
      </thead>
      <tbody>
        <%
          @SuppressWarnings("unchecked")
          List<Partida> lista = (List<Partida>) request.getAttribute("partidas");
          if (lista == null || lista.isEmpty()) {
        %>
        <tr>
          <td colspan="10" style="text-align:center; color:#999;">No hay partidas</td>
        </tr>
        <%
          } else {
            for (Partida p : lista) {
              String fechaInicio = p.getFechaInicio() != null ? sdf.format(p.getFechaInicio()) : "-";
              String fechaFin = p.getFechaFin() != null ? sdf.format(p.getFechaFin()) : "-";
              String estadoBadge = "";
              if ("EN_PROGRESO".equals(p.getEstado())) estadoBadge = "🔵";
              else if ("FINALIZADA".equals(p.getEstado())) estadoBadge = "✅";
              else if ("ABANDONADA".equals(p.getEstado())) estadoBadge = "❌";
              
              String truncSol = p.getSolucionPropuesta();
              if (truncSol != null && truncSol.length() > 40) {
                truncSol = truncSol.substring(0, 40) + "...";
              } else if (truncSol == null || truncSol.isEmpty()) {
                truncSol = "-";
              }
        %>
        <tr>
          <td><%= p.getId() %></td>
          <td><strong>Usuario #<%= p.getUsuarioId() %></strong></td>
          <td>Historia #<%= p.getHistoriaId() %></td>
          <td><%= estadoBadge %> <%= p.getEstado() %></td>
          <td><%= fechaInicio %></td>
          <td><%= fechaFin %></td>
          <td><%= p.getPistasEncontradas() %></td>
          <td><strong><%= p.getPuntuacion() %></strong> pts</td>
          <td><%= p.getCasoResuelto() == 1 ? "✅ Sí" : "❌ No" %></td>
          <td><%= truncSol %></td>
        </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>
  </div>

  <div style="margin-top: 20px; padding: 15px; background: #f5f5f5; border-radius: 8px;">
    <p style="margin: 0; color: #666; font-size: 14px;">
      <i class="fa-solid fa-info-circle"></i> 
      <strong>Nota:</strong> Las partidas son de solo lectura. No se pueden crear ni editar manualmente desde el panel de administración.
    </p>
  </div>

</div>
</body>
</html>
