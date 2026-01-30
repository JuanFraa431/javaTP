<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="entities.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Documentos — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-list.css">
  <link href="https://fonts.googleapis.com/css2?family=Creepster&family=Nunito:wght@400;700;800&family=Overpass:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1>Documentos</h1>
    <p class="subtitle">Administrá documentos, códigos y pistas del juego</p>
  </header>

  <!-- flash -->
  <%
    @SuppressWarnings("unchecked")
    List<Documento> documentos = (List<Documento>) request.getAttribute("documentos");
    @SuppressWarnings("unchecked")
    List<Historia> historias = (List<Historia>) request.getAttribute("historias");
    @SuppressWarnings("unchecked")
    Map<Integer, String> historiasMap = (Map<Integer, String>) request.getAttribute("historiasMap");
    String search = (String) request.getAttribute("search");
    String historiaSelected = (String) request.getAttribute("historiaSelected");
    
    String ok = (String) session.getAttribute("flash_ok");
    String err = (String) session.getAttribute("flash_error");
    if (ok != null) { %><div class="flash ok"><i class="fa-solid fa-circle-check"></i> <%= ok %></div><% session.removeAttribute("flash_ok"); }
    if (err != null){ %><div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= err %></div><% session.removeAttribute("flash_error"); }
    if (search == null) search = "";
  %>

  <!-- acciones -->
  <div class="actions">
    <div class="left">
      <form class="search" method="get" action="${pageContext.request.contextPath}/admin/documentos">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="search" placeholder="Buscar por nombre o clave..." value="<%= search %>">
      </form>
      
      <form class="filter-form" method="get" action="${pageContext.request.contextPath}/admin/documentos">
        <label for="historia">Historia:</label>
        <select id="historia" name="historia" onchange="this.form.submit()">
          <option value="">Todas</option>
          <% for (Historia h : historias) { %>
            <option value="<%= h.getId() %>" <%= historiaSelected != null && historiaSelected.equals(String.valueOf(h.getId())) ? "selected" : "" %>>
              <%= h.getTitulo() %>
            </option>
          <% } %>
        </select>
      </form>
    </div>
    <div class="right">
      <a class="btn" href="${pageContext.request.contextPath}/admin/documentos/form">
        <i class="fa-solid fa-plus"></i> Nuevo documento
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-grid-2"></i> Dashboard
      </a>
    </div>
  </div>

  <!-- tabla -->
  <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Historia</th>
            <th>Clave</th>
            <th>Nombre</th>
            <th style="text-align: center;">Icono</th>
            <th style="text-align: center;">Código</th>
            <th style="text-align: center;">Pista</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <% if (documentos == null || documentos.isEmpty()) { %>
            <tr>
              <td colspan="8" style="text-align: center; padding: 40px; color: #666;">
                <i class="fa-solid fa-inbox" style="font-size: 48px; opacity: 0.3; display: block; margin-bottom: 16px;"></i>
                No hay documentos registrados
              </td>
            </tr>
          <% } else {
               for (Documento d : documentos) {
                 String historiaTitulo = historiasMap.get(d.getHistoriaId());
                 boolean tieneCodigo = d.getCodigoCorrecto() != null && !d.getCodigoCorrecto().isEmpty();
                 boolean tienePista = d.getPistaNombre() != null && !d.getPistaNombre().isEmpty();
          %>
            <td><strong>#<%= d.getId() %></strong></td>
            <td><%= historiaTitulo != null ? historiaTitulo : "Historia #" + d.getHistoriaId() %></td>
            <td><code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;font-size:13px;"><%= d.getClave() %></code></td>
            <td><strong><%= d.getNombre() %></strong></td>
            <td style="text-align: center;">
              <i class="<%= d.getIcono() %>" style="font-size: 20px; color: #3b82f6;"></i>
            </td>
            <td style="text-align: center;">
              <% if (tieneCodigo) { %>
                <span class="badge" style="background: #10b981; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                  <i class="fa-solid fa-key"></i> <%= d.getCodigoCorrecto() %>
                </span>
              <% } else { %>
                <span style="color: #999;">—</span>
              <% } %>
            </td>
            <td style="text-align: center;">
              <% if (tienePista) { %>
                <span class="badge" style="background: #3b82f6; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                  <i class="fa-solid fa-lightbulb"></i> <%= d.getPistaNombre() %>
                </span>
              <% } else { %>
                <span style="color: #999;">—</span>
              <% } %>
            </td>
            <td class="actions">
              <a class="icon-btn" href="${pageContext.request.contextPath}/admin/documentos/form?id=<%= d.getId() %>" title="Editar">
                <i class="fa-solid fa-edit"></i>
              </a>
              <form method="post" action="${pageContext.request.contextPath}/admin/documentos/delete" style="display:inline;" 
                    onsubmit="return confirm('¿Confirmar eliminación del documento <%= d.getNombre() %>?');">
                <input type="hidden" name="id" value="<%= d.getId() %>">
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
