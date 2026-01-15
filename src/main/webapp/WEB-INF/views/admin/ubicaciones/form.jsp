<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="entities.Ubicacion, entities.Historia, java.util.List" %>
<%
  Ubicacion u = (Ubicacion) request.getAttribute("ubicacion");
  @SuppressWarnings("unchecked")
  List<Historia> historias = (List<Historia>) request.getAttribute("historias");
  String error = (String) request.getAttribute("error");
  boolean esEdicion = (u != null && u.getId() > 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title><%= esEdicion ? "Editar" : "Nueva" %> Ubicación — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style/admin-usuarios-form.css">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="page">

  <header>
    <h1><%= esEdicion ? "Editar Ubicación" : "Nueva Ubicación" %></h1>
    <% if (esEdicion) { %>
      <p class="subtitle">ID <%= u.getId() %></p>
    <% } %>
  </header>

  <% if (error != null) { %>
    <div class="flash error"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/admin/ubicaciones/save" class="form-card">
    <% if (esEdicion) { %>
      <input type="hidden" name="id" value="<%= u.getId() %>">
    <% } %>

    <div class="form-group">
      <label for="nombre">Nombre <span class="required">*</span></label>
      <input type="text" id="nombre" name="nombre" 
             value="<%= u != null && u.getNombre() != null ? u.getNombre() : "" %>" 
             required maxlength="100">
    </div>

    <div class="form-group">
      <label for="descripcion">Descripción <span class="required">*</span></label>
      <textarea id="descripcion" name="descripcion" rows="3" required><%= u != null && u.getDescripcion() != null ? u.getDescripcion() : "" %></textarea>
    </div>

    <div class="form-group">
      <label for="historia_id">Historia <span class="required">*</span></label>
      <select id="historia_id" name="historia_id" required>
        <option value="">Seleccionar historia...</option>
        <%
          if (historias != null) {
            for (Historia h : historias) {
              boolean selected = (u != null && u.getHistoriaId() == h.getId());
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
      <label for="imagen">Ruta de imagen</label>
      <input type="text" id="imagen" name="imagen" 
             value="<%= u != null && u.getImagen() != null ? u.getImagen() : "" %>" 
             placeholder="/images/ubicacion.jpg" maxlength="200">
      <small>Ruta opcional de la imagen de la ubicación</small>
    </div>

    <div class="form-group checkbox-group">
      <label>
        <input type="checkbox" name="accesible" <%= (u != null && u.getAccesible() == 1) ? "checked" : "" %>>
        <span>Es accesible</span>
      </label>
      <small>Marcar si los jugadores pueden acceder a esta ubicación</small>
    </div>

    <div class="actions">
      <button type="submit" class="btn btn-primary">
        <i class="fa-solid fa-floppy-disk"></i> Guardar
      </button>
      <a href="${pageContext.request.contextPath}/admin/ubicaciones" class="btn btn-secondary">
        <i class="fa-solid fa-xmark"></i> Cancelar
      </a>
    </div>
  </form>

</div>
</body>
</html>
