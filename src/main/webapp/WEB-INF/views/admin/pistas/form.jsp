<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Pista, entities.Historia, java.util.List, java.util.Map" %>
<%
  Pista p = (Pista) request.getAttribute("pista");
  @SuppressWarnings("unchecked")
  List<Historia> historias = (List<Historia>) request.getAttribute("historias");
  @SuppressWarnings("unchecked")
  List<Map<String, Object>> ubicaciones = (List<Map<String, Object>>) request.getAttribute("ubicaciones");
  @SuppressWarnings("unchecked")
  List<Map<String, Object>> personajes = (List<Map<String, Object>>) request.getAttribute("personajes");
  String error = (String) request.getAttribute("error");
  boolean esEdicion = (p != null && p.getId() > 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title><%= esEdicion ? "Editar" : "Nueva" %> Pista — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1><%= esEdicion ? "Editar Pista" : "Nueva Pista" %></h1>
    <% if (esEdicion) { %>
      <p class="subtitle">ID <%= p.getId() %></p>
    <% } %>
  </header>

  <% if (error != null) { %>
    <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/admin/pistas/save" class="form-card">
    <% if (esEdicion) { %>
      <input type="hidden" name="id" value="<%= p.getId() %>">
    <% } %>

    <div class="form-group">
      <label for="nombre">Nombre <span class="required">*</span></label>
      <input type="text" id="nombre" name="nombre" 
             value="<%= p != null && p.getNombre() != null ? p.getNombre() : "" %>" 
             required maxlength="100">
    </div>

    <div class="form-group">
      <label for="descripcion">Descripción <span class="required">*</span></label>
      <textarea id="descripcion" name="descripcion" rows="3" required><%= p != null && p.getDescripcion() != null ? p.getDescripcion() : "" %></textarea>
    </div>

    <div class="form-group">
      <label for="contenido">Contenido</label>
      <textarea id="contenido" name="contenido" rows="4"><%= p != null && p.getContenido() != null ? p.getContenido() : "" %></textarea>
      <small>Contenido detallado de la pista (opcional)</small>
    </div>

    <div class="form-group">
      <label for="historia_id">Historia <span class="required">*</span></label>
      <select id="historia_id" name="historia_id" required>
        <option value="">Seleccionar historia...</option>
        <%
          if (historias != null) {
            for (Historia h : historias) {
              boolean selected = (p != null && p.getHistoriaId() == h.getId());
        %>
          <option value="<%= h.getId() %>" <%= selected ? "selected" : "" %>>
            <%= h.getTitulo() %>
          </option>
        <%
            }
          }
        %>
      </select>
    </div>

    <div class="form-group">
      <label for="ubicacion_id">Ubicación</label>
      <select id="ubicacion_id" name="ubicacion_id">
        <option value="">Ninguna</option>
        <%
          if (ubicaciones != null) {
            for (Map<String, Object> u : ubicaciones) {
              int uid = (Integer) u.get("id");
              String unombre = (String) u.get("nombre");
              boolean selected = (p != null && p.getUbicacionId() == uid);
        %>
          <option value="<%= uid %>" <%= selected ? "selected" : "" %>>
            <%= unombre %>
          </option>
        <%
            }
          }
        %>
      </select>
      <small>Ubicación donde se encuentra la pista (opcional)</small>
    </div>

    <div class="form-group">
      <label for="personaje_id">Personaje</label>
      <select id="personaje_id" name="personaje_id">
        <option value="">Ninguno</option>
        <%
          if (personajes != null) {
            for (Map<String, Object> per : personajes) {
              int pid = (Integer) per.get("id");
              String pnombre = (String) per.get("nombre");
              boolean selected = (p != null && p.getPersonajeId() == pid);
        %>
          <option value="<%= pid %>" <%= selected ? "selected" : "" %>>
            <%= pnombre %>
          </option>
        <%
            }
          }
        %>
      </select>
      <small>Personaje relacionado con la pista (opcional)</small>
    </div>

    <div class="form-group">
      <label for="importancia">Importancia</label>
      <select id="importancia" name="importancia">
        <option value="">No especificada</option>
        <option value="baja" <%= (p != null && "baja".equalsIgnoreCase(p.getImportancia())) ? "selected" : "" %>>Baja</option>
        <option value="media" <%= (p != null && "media".equalsIgnoreCase(p.getImportancia())) ? "selected" : "" %>>Media</option>
        <option value="alta" <%= (p != null && "alta".equalsIgnoreCase(p.getImportancia())) ? "selected" : "" %>>Alta</option>
      </select>
    </div>

    <div class="form-group checkbox-group">
      <label>
        <input type="checkbox" name="crucial" <%= (p != null && p.getCrucial() == 1) ? "checked" : "" %>>
        <span>Es pista crucial</span>
      </label>
      <small>Marcar si es una pista imprescindible para resolver el caso</small>
    </div>

    <div class="actions">
      <button type="submit" class="btn btn-primary">
        <i class="fa-solid fa-floppy-disk"></i> Guardar
      </button>
      <a href="${pageContext.request.contextPath}/admin/pistas" class="btn btn-secondary">
        <i class="fa-solid fa-xmark"></i> Cancelar
      </a>
    </div>
  </form>

</div>
</body>
</html>
