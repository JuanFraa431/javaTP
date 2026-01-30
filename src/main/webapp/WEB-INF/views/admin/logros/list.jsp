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
    <h1><i class="fa-solid fa-trophy" style="color: #fbbf24;"></i> Logros</h1>
    <p class="subtitle">Administrá los achievements desbloqueables y sistema de puntos</p>
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

  <!-- acciones -->
  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/logros">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="search" placeholder="Buscar por nombre o clave..." value="<%= search %>">
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/logros/form">
        <i class="fa-solid fa-plus"></i> Nuevo logro
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-grid-2"></i> Dashboard
      </a>
    </div>
  </div>

  <!-- tabla -->
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th style="width: 60px;">ID</th>
          <th style="width: 180px;">Clave</th>
          <th>Logro</th>
          <th style="text-align: center; width: 100px;">Puntos</th>
          <th style="text-align: center; width: 120px;">Estado</th>
          <th style="width: 120px;">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <% if (logros == null || logros.isEmpty()) { %>
          <tr>
            <td colspan="6" style="text-align: center; padding: 40px; color: #666;">
              <i class="fa-solid fa-trophy" style="font-size: 48px; opacity: 0.3; display: block; margin-bottom: 16px;"></i>
              <strong>No hay logros registrados</strong>
              <br><small style="color: #999; margin-top: 8px; display: block;">Creá el primer achievement del juego</small>
            </td>
          </tr>
        <% } else {
             for (Logro l : logros) {
               boolean activo = l.getActivo() == 1;
        %>
          <tr <%= !activo ? "style='opacity: 0.6;'" : "" %>>
            <td><strong style="color: #666;">#<%= l.getId() %></strong></td>
            <td><code style="background:#f3f4f6;padding:4px 8px;border-radius:3px;font-size:12px;font-weight:600;color:#4b5563;"><%= l.getClave() %></code></td>
            <td>
              <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(251, 191, 36, 0.2);">
                  <i class="<%= l.getIcono() %>" style="font-size: 20px; color: #d97706;"></i>
                </div>
                <div>
                  <strong style="font-size: 14px; color: #1f2937;"><%= l.getNombre() %></strong>
                  <% if (l.getDescripcion() != null && !l.getDescripcion().isEmpty()) { %>
                    <br><small style="color:#6b7280; font-size: 12px; line-height: 1.4; display: block; margin-top: 2px;"><%= l.getDescripcion() %></small>
                  <% } %>
                </div>
              </div>
            </td>
            <td style="text-align: center;">
              <span class="badge" style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); color: white; padding: 6px 12px; border-radius: 6px; font-size: 14px; font-weight: 700; box-shadow: 0 2px 4px rgba(59, 130, 246, 0.3);">
                <i class="fa-solid fa-coins" style="font-size: 11px; margin-right: 4px;"></i><%= l.getPuntos() %> pts
              </span>
            </td>
            <td style="text-align: center;">
              <% if (activo) { %>
                <span class="badge" style="background: #10b981; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                  <i class="fa-solid fa-check-circle"></i> Activo
                </span>
              <% } else { %>
                <span class="badge" style="background: #dc2626; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                  <i class="fa-solid fa-times-circle"></i> Inactivo
                </span>
              <% } %>
            </td>
            <td class="actions">
              <a class="icon-btn" href="${pageContext.request.contextPath}/admin/logros/form?id=<%= l.getId() %>" title="Editar">
                <i class="fa-solid fa-edit"></i>
              </a>
              <form method="post" action="${pageContext.request.contextPath}/admin/logros/delete" style="display:inline;" 
                    onsubmit="return confirm('¿Confirmar eliminación del logro <%= l.getNombre() %>?');">
                <input type="hidden" name="id" value="<%= l.getId() %>">
                <button type="submit" class="icon-btn danger" title="Eliminar">
                  <i class="fa-solid fa-trash"></i>
                </button>
              </form>
            </td>
          </tr>
        <% } } %>
      </tbody>
    </table>
  </div>

</div>
</body>
</html>
